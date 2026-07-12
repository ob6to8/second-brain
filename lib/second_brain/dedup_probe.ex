defmodule SecondBrain.DedupProbe do
  @moduledoc """
  The intake dedup-recall probe: score the bundle's mechanical search layer
  against a gold set of natural-phrasing dedup queries.

  Intake dedup — finding the existing concept a new item should merge into — is
  the entry gate of the corpus-maintenance failure chain, and it is the one gate
  CI can't otherwise cover. Today it leans on lossy lexical search plus an
  LLM-in-context subsidy that expires as the corpus outgrows agent context. This
  probe measures the *mechanical* layer in isolation, so the loss is re-measured
  as the corpus grows (see the
  [dedup-recall-probe plan](/meta/plans/dedup-recall-probe.md)).

  Deliberately zero-dependency, fully offline, deterministic — it must run in CI
  and any sandbox, so it makes **no LLM calls** at probe time.

  ## The gold set

  `meta/evals/dedup-probe.md` — a prose-bearing doc whose `## Gold set` table this
  module parses. Each row is a `query`, its `acceptable ids` (one or more `sb:`
  ids), a `band`, `;`-separated `variants`, and an adjudication `note`.

    * **`target`** — a scored row: the query should surface at least one acceptable
      id from the mechanical backend.
    * **`negative`** — a non-duplicate pair (shares vocabulary, must not merge).
      Not scored in v1 (lexical search has no duplicate judgment to test); seeded
      so the later embedding/judge tiers inherit them.
    * **`quarantine`** — gold answer undefined until supersession exists
      (time-relativity). Parsed, reported, never scored.

  ## The backend under test

  Case-insensitive substring match over each bundle concept's title, description,
  tags, and body. A row **hits** if any of its acceptable ids is in the query's
  match set. Scoring is surfaced-or-not, not ranked — intake has no ranked backend
  yet — and the report also carries each query's match-set size (the noise /
  cluster-saturation signal). In `--expanded` mode a target row hits if the query
  **or any recorded variant** hits, approximating synonym-expanded intake dedup
  deterministically; the plain-vs-expanded gap measures how much recall the tier-1
  `/intake` synonym-expansion change is expected to recover, offline.

  Tolerant consumer per OKF conformance: unparseable concepts are skipped, never
  fatal; a missing gold doc raises (the probe has nothing to measure).
  """

  alias SecondBrain.{Frontmatter, Registry}

  @gold_doc "meta/evals/dedup-probe.md"
  @bands ~w(target negative quarantine)

  defmodule Row do
    @moduledoc "One parsed gold-set row."
    @enforce_keys [:query, :acceptable_ids, :band]
    defstruct [:query, :acceptable_ids, :band, :note, variants: []]
  end

  @doc "Path of the gold-set doc, relative to repo root."
  def gold_path, do: @gold_doc

  @doc """
  Run the probe. Options: `expanded: true` scores in synonym-expanded mode.
  Returns a report map: `%{expanded:, results:, aggregate:, baseline:}` where
  `results` is one entry per gold row (in doc order) and `aggregate` covers the
  `target` rows only.
  """
  @spec run(String.t(), keyword) :: map
  def run(root \\ File.cwd!(), opts \\ []) do
    expanded = Keyword.get(opts, :expanded, false)
    rows = parse_gold!(root)
    index = search_index(root)

    results = Enum.map(rows, &score_row(&1, index, expanded))
    targets = Enum.filter(results, &(&1.band == "target"))
    hits = Enum.count(targets, & &1.hit)

    %{
      expanded: expanded,
      results: results,
      aggregate: %{hits: hits, targets: length(targets)},
      baseline: parse_baseline(root)
    }
  end

  @doc "Run the probe and render its report as text."
  @spec report(String.t(), keyword) :: String.t()
  def report(root \\ File.cwd!(), opts \\ []), do: render(run(root, opts))

  @doc """
  Rewrite the gold doc's `## Baseline` table from a fresh plain + expanded run,
  preserving all surrounding prose. The committed baseline is a *generated*
  figure — refreshed by this command (typically at intake time), never hand-kept
  — so the recall trend lives in the doc's git history. Returns the gold path.
  """
  @spec update_baseline(String.t()) :: String.t()
  def update_baseline(root \\ File.cwd!()) do
    plain = run(root, expanded: false).aggregate
    expanded = run(root, expanded: true).aggregate

    path = Path.join(root, @gold_doc)
    File.write!(path, replace_baseline_rows(File.read!(path), plain, expanded))
    path
  end

  # --- scoring --------------------------------------------------------------

  defp score_row(%Row{} = row, index, expanded) do
    primary = match_ids(row.query, index)

    phrasings = if expanded, do: [row.query | row.variants], else: [row.query]

    {hit, via} =
      Enum.reduce_while(phrasings, {false, nil}, fn phrase, _acc ->
        ids = if phrase == row.query, do: primary, else: match_ids(phrase, index)

        if Enum.any?(row.acceptable_ids, &(&1 in ids)),
          do: {:halt, {true, phrase}},
          else: {:cont, {false, nil}}
      end)

    %{
      query: row.query,
      band: row.band,
      acceptable_ids: row.acceptable_ids,
      note: row.note,
      match_set_size: length(primary),
      hit: hit,
      # the phrasing that produced the hit, when it wasn't the bare query
      via: if(via && via != row.query, do: via)
    }
  end

  # Ids whose searchable blob contains the phrase (case-insensitive substring).
  defp match_ids(phrase, index) do
    needle = phrase |> String.trim() |> String.downcase()

    if needle == "" do
      []
    else
      for {id, blob} <- index, String.contains?(blob, needle), do: id
    end
  end

  # --- the searchable index -------------------------------------------------

  @doc """
  Map of `id => searchable blob` for every bundle concept carrying an `sb:` id.
  The blob is the lowercased concatenation of title, description, tags, and body
  — the text the mechanical backend matches against.
  """
  @spec search_index(String.t()) :: %{String.t() => String.t()}
  def search_index(root \\ File.cwd!()) do
    root
    |> Registry.concept_paths()
    |> Enum.flat_map(fn rel ->
      case root |> Path.join(rel) |> File.read!() |> Frontmatter.parse() do
        {:ok, %{frontmatter: %{"id" => id} = fm, body: body}} when is_binary(id) ->
          blob =
            [fm["title"], fm["description"], tags_text(fm["tags"]), body]
            |> Enum.reject(&is_nil/1)
            |> Enum.join(" ")
            |> String.downcase()

          [{id, blob}]

        _ ->
          []
      end
    end)
    |> Map.new()
  end

  defp tags_text(tags) when is_list(tags), do: Enum.join(tags, " ")
  defp tags_text(tags) when is_binary(tags), do: tags
  defp tags_text(_), do: ""

  # --- gold-doc parsing -----------------------------------------------------

  @doc "Parse the `## Gold set` table into `Row` structs (doc order)."
  @spec parse_gold!(String.t()) :: [Row.t()]
  def parse_gold!(root) do
    path = Path.join(root, @gold_doc)

    unless File.exists?(path) do
      raise ArgumentError, "dedup-probe gold doc not found: #{@gold_doc}"
    end

    %{body: body} = path |> File.read!() |> Frontmatter.parse!()

    body
    |> table_rows("## Gold set")
    |> Enum.flat_map(&parse_row/1)
  end

  defp parse_row([query, ids, band, variants, note]) do
    band = String.downcase(band)

    if band in @bands do
      [
        %Row{
          query: query,
          acceptable_ids: split_ids(ids),
          band: band,
          variants: split_variants(variants),
          note: note
        }
      ]
    else
      []
    end
  end

  defp parse_row(_), do: []

  defp split_ids(cell) do
    ~r/sb:[0-9a-f]{6}/
    |> Regex.scan(cell)
    |> List.flatten()
  end

  defp split_variants(cell) do
    cell
    |> String.split(";")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 in ["", "-", "—"]))
  end

  # --- baseline parsing -----------------------------------------------------

  @doc """
  The committed `## Baseline` figures as `%{"plain" => {hits, targets}, ...}`,
  or `nil` if no baseline table is present.
  """
  @spec parse_baseline(String.t()) :: %{String.t() => {integer, integer}} | nil
  def parse_baseline(root) do
    path = Path.join(root, @gold_doc)

    with true <- File.exists?(path),
         %{body: body} <- path |> File.read!() |> Frontmatter.parse!(),
         [_ | _] = rows <- table_rows(body, "## Baseline") do
      rows
      |> Enum.flat_map(fn
        [mode, hits, targets] ->
          with {h, ""} <- Integer.parse(String.trim(hits)),
               {t, ""} <- Integer.parse(String.trim(targets)) do
            [{String.downcase(String.trim(mode)), {h, t}}]
          else
            _ -> []
          end

        _ ->
          []
      end)
      |> Map.new()
      |> case do
        map when map_size(map) > 0 -> map
        _ -> nil
      end
    else
      _ -> nil
    end
  end

  # Swap the data rows of the `mode | hits | targets` table under `## Baseline`
  # for freshly-measured ones, leaving every other line (prose, header,
  # separator) untouched. A small line-wise state machine, so surrounding prose
  # is preserved and the operation is idempotent.
  defp replace_baseline_rows(content, plain, expanded) do
    new_rows = [
      "| plain | #{plain.hits} | #{plain.targets} |",
      "| expanded | #{expanded.hits} | #{expanded.targets} |"
    ]

    {out, state} =
      content
      |> String.split("\n")
      |> Enum.reduce({[], :before}, fn line, {out, state} ->
        t = String.trim(line)

        case state do
          :before ->
            {out ++ [line], if(t == "## Baseline", do: :seek_header, else: :before)}

          :seek_header ->
            {out ++ [line], if(baseline_header?(t), do: :seek_sep, else: :seek_header)}

          # the line right after the header is the `|---|` separator: keep it,
          # then inject the fresh rows ahead of the (now stale) old rows
          :seek_sep ->
            {out ++ [line] ++ new_rows, :drop_old_rows}

          :drop_old_rows ->
            if String.starts_with?(t, "|"),
              do: {out, :drop_old_rows},
              else: {out ++ [line], :done}

          :done ->
            {out ++ [line], :done}
        end
      end)

    if state == :before do
      raise ArgumentError, "no ## Baseline table found in #{@gold_doc}"
    end

    Enum.join(out, "\n")
  end

  defp baseline_header?(t) do
    String.starts_with?(t, "|") and String.contains?(t, "mode") and
      String.contains?(t, "targets")
  end

  # --- markdown table extraction --------------------------------------------

  # Cells of every data row of the first markdown table under `heading`
  # (header and `---` separator rows dropped).
  defp table_rows(body, heading) do
    body
    |> String.split("\n")
    |> Enum.drop_while(&(String.trim(&1) != heading))
    |> Enum.drop(1)
    |> Enum.take_while(&(not String.starts_with?(String.trim(&1), "## ")))
    |> Enum.filter(&String.starts_with?(String.trim(&1), "|"))
    |> Enum.map(&split_cells/1)
    |> Enum.reject(&header_or_separator?/1)
  end

  defp split_cells(line) do
    line
    |> String.trim()
    |> String.trim_leading("|")
    |> String.trim_trailing("|")
    |> String.split("|")
    |> Enum.map(&String.trim/1)
  end

  defp header_or_separator?([first | _] = cells) do
    first in ["query", "mode"] or Enum.all?(cells, &separator_cell?/1)
  end

  defp header_or_separator?(_), do: true

  defp separator_cell?(cell), do: Regex.match?(~r/^:?-+:?$/, cell)

  # --- rendering ------------------------------------------------------------

  defp render(%{expanded: expanded, results: results, aggregate: agg, baseline: baseline}) do
    mode = if expanded, do: "expanded", else: "plain"
    targets = Enum.filter(results, &(&1.band == "target"))
    negatives = Enum.filter(results, &(&1.band == "negative"))
    quarantine = Enum.filter(results, &(&1.band == "quarantine"))

    """
    # Dedup recall probe — #{mode} mode

    Backend: case-insensitive lexical (substring) match over each concept's title,
    description, tags, and body. A target row hits if any acceptable id is in the
    match set#{if expanded, do: " (query or any recorded variant)", else: ""}.

    #{targets_section(targets, expanded)}
    #{aggregate_line(mode, agg, baseline)}

    #{band_section("Negatives", negatives, "non-duplicate pairs, not scored in v1")}
    #{band_section("Quarantine", quarantine, "gold answer undefined until supersession exists, never scored")}
    #{baseline_section(mode, agg, baseline)}
    """
  end

  defp targets_section(targets, expanded) do
    header =
      if expanded,
        do: "| query | hit | matched id | match-set | via |",
        else: "| query | hit | matched id | match-set |"

    sep =
      if expanded,
        do: "|-------|-----|-----------|-----------|-----|",
        else: "|-------|-----|-----------|-----------|"

    rows =
      Enum.map_join(targets, "\n", fn r ->
        matched = matched_id(r)
        mark = if r.hit, do: "✓", else: "✗"

        base = "| #{r.query} | #{mark} | #{matched} | #{r.match_set_size} |"
        if expanded, do: base <> " #{r.via || "—"} |", else: base
      end)

    "## Targets (#{length(targets)})\n\n#{header}\n#{sep}\n#{rows}"
  end

  defp matched_id(%{hit: false}), do: "—"

  defp matched_id(%{hit: true, acceptable_ids: ids}),
    do: Enum.join(ids, " ")

  defp aggregate_line(mode, %{hits: h, targets: t}, baseline) do
    pct = percent(h, t)
    delta = delta_str(mode, h, baseline)
    "**Recall (#{mode}): #{h}/#{t} = #{pct}%**#{delta}"
  end

  defp band_section(_title, [], _blurb), do: ""

  defp band_section(title, rows, blurb) do
    lines =
      Enum.map_join(rows, "\n", fn r ->
        "- `#{r.query}` → #{Enum.join(r.acceptable_ids, ", ")} — #{r.note}"
      end)

    "## #{title} (#{length(rows)}) — reported, not scored\n\n_#{blurb}._\n\n#{lines}\n"
  end

  defp baseline_section(mode, %{hits: h, targets: t}, baseline) do
    committed =
      case baseline do
        nil ->
          "_(none recorded yet)_"

        map ->
          map
          |> Enum.sort_by(fn {m, _} -> m end)
          |> Enum.map_join(", ", fn {m, {bh, bt}} -> "#{m} #{bh}/#{bt}" end)
      end

    delta = delta_str(mode, h, baseline) |> String.trim()

    delta =
      if delta == "",
        do: "no committed baseline for this mode",
        else: String.trim_leading(delta, "— ")

    "## Baseline\n\nCommitted: #{committed}.\nThis run (#{mode}): #{h}/#{t} — #{delta}.\n"
  end

  defp delta_str(mode, hits, baseline) do
    case baseline && Map.get(baseline, mode) do
      {bh, _bt} ->
        d = hits - bh

        cond do
          d > 0 -> " — +#{d} vs baseline"
          d < 0 -> " — #{d} vs baseline"
          true -> " — no change vs baseline"
        end

      _ ->
        ""
    end
  end

  defp percent(_h, 0), do: 0
  defp percent(h, t), do: round(h * 100 / t)
end
