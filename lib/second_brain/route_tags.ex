defmodule SecondBrain.RouteTags do
  @moduledoc """
  Verify route tags and the excerpt logs they materialize (the route-tagging
  convention; see `meta/policy/route-tagging.md`).

  A finalized thread body (under `meta/threads/`) carries `<routes ref="...">`
  regions — per-paragraph, multi-ref, keyed on canonical ids. A **`sb:` id** is
  an aggregating sink: the concept it names carries the region in an append-only,
  per-thread, date-stamped excerpt log (`## Thread excerpts — route-tagged log`).
  A **path** ref (anything with a `/`) is a non-aggregating back-link and
  accretes no log.

  The log is a write-once materialization of the tags, so its freshness is
  structural only if something re-derives it: this module re-derives each sink's
  per-thread block from the current tags and reports divergence, converting the
  guarantee from procedural (remember to append, remember to propagate a tag
  correction) to structural. Tag *coverage* — whether every paragraph that feeds
  a matter was tagged — has no mechanical oracle and stays editorial; a
  routing-ledger cross-check lifts it to row granularity and reports (never
  fails) at warn level.

  Checks, in order:

  - **tag wellformedness** — regions are line-anchored and outside fenced code,
    balanced, never nested, never crossing a `## User`/`## Assistant` turn
    boundary, and carry a non-empty ref set.
  - **ref resolution** — every ref resolves: `sb:` ids to a bundle concept (via
    the stable-id registry), path refs to files in the repository.
  - **sink logs** — every concept sink referenced by a tagged thread carries a
    dated block for that thread in its route-tagged log section.
  - **log fidelity** — each block matches its re-derivation from the current
    tags (count line, region order, full ref-sets, whole-region content with
    ATX headers demoted to bold); blocks naming threads that no longer tag the
    sink are orphans and fail.
  - **ledger cross-check** (warn) — each tagged thread's routing-ledger rows
    that route to a concept sink are covered by at least one tag; threads with
    routing rows but no tags at all are reported once.

  `materialize/1` writes each sink's log section from the current tags, so the
  log is generated, not hand-kept; `run_checks/1` is then the structural
  backstop that fails if the two ever diverge.
  """

  alias SecondBrain.Registry

  @threads_dir "meta/threads"

  @log_section_re ~r/^## Thread excerpts.*route-tagged log/
  @log_heading "## Thread excerpts — route-tagged log"
  @open_re ~r/^<routes ref="([^"]*)">\s*$/
  @close_re ~r/^<\/routes>\s*$/
  @turn_re ~r/^## (User|Assistant)\b/
  @date_re ~r/^\d{4}-\d{2}-\d{2}/

  @type status :: :ok | :fail | :warn
  @type result :: {String.t(), status, String.t()}

  @doc """
  Run all checks against the bundle at `root`. Returns results in check order; a
  check that cannot fully run because an earlier one failed is still reported, on
  whatever it could see.
  """
  @spec run_checks(String.t()) :: [result]
  def run_checks(root \\ File.cwd!()) do
    threads = scan_threads(root)
    concepts = bundle_concepts(root)
    id_index = Map.new(concepts, &{&1.id, &1.path})
    sinks = scan_sinks(root, concepts)

    [
      check_wellformedness(threads),
      check_ref_resolution(threads, id_index, root),
      check_sink_logs(threads, sinks),
      check_log_fidelity(threads, sinks),
      check_ledger_coverage(threads, root, id_index)
    ]
  end

  # Concepts carrying a stable id, from the identity registry. Registry scan
  # errors (unparseable frontmatter, duplicate ids) are surfaced by
  # `mix brain.verify`; here we resolve refs against whatever parsed cleanly.
  defp bundle_concepts(root) do
    {entries, _errors} = Registry.scan(root)
    Enum.reject(entries, &is_nil(&1.id))
  end

  # ---------------------------------------------------------------------
  # Thread scanning: tags
  # ---------------------------------------------------------------------

  @doc "All finalized threads under `meta/threads/` (excluding `index.md`), parsed."
  def scan_threads(root) do
    dir = Path.join(root, @threads_dir)

    Path.wildcard(Path.join(dir, "*.md"))
    |> Enum.reject(&(Path.basename(&1) == "index.md"))
    |> Enum.sort()
    |> Enum.map(fn path ->
      slug = Path.basename(path, ".md")
      {regions, problems} = parse_regions(File.read!(path))

      %{
        slug: slug,
        path: path,
        date: thread_date(slug),
        regions: regions,
        problems: problems
      }
    end)
  end

  defp thread_date(slug) do
    case Regex.run(@date_re, slug) do
      [date] -> date
      nil -> nil
    end
  end

  @doc """
  Parse `<routes ref="...">` regions out of a markdown body.

  Tags count only when line-anchored and outside fenced code, so prose and
  code-block mentions of the syntax are not tags. Returns `{regions, problems}`;
  each region is `%{refs: [...], line: n, content: [...]}` with content the raw
  lines between the tags.
  """
  def parse_regions(markdown) do
    lines = String.split(markdown, "\n")

    state = %{fence: false, open: nil, regions: [], problems: []}

    state =
      lines
      |> Enum.with_index(1)
      |> Enum.reduce(state, &parse_line/2)

    state =
      case state.open do
        nil ->
          state

        {refs, line, _} ->
          problem(
            state,
            "unclosed <routes> opened at line #{line} (refs: #{Enum.join(refs, " ")})"
          )
      end

    {Enum.reverse(state.regions), Enum.reverse(state.problems)}
  end

  defp parse_line({line, n}, state) do
    cond do
      String.starts_with?(String.trim_leading(line), "```") ->
        %{state | fence: not state.fence}

      state.fence ->
        state

      match = Regex.run(@open_re, line) ->
        [_, ref_string] = match
        refs = String.split(ref_string)

        state =
          if refs == [],
            do: problem(state, "empty ref set at line #{n}"),
            else: state

        case state.open do
          nil ->
            %{state | open: {refs, n, []}}

          {_, opened, _} ->
            problem(state, "nested <routes> at line #{n} (already open since line #{opened})")
        end

      Regex.match?(@close_re, line) ->
        case state.open do
          nil ->
            problem(state, "unmatched </routes> at line #{n}")

          {refs, opened, content} ->
            region = %{refs: refs, line: opened, content: Enum.reverse(content)}
            %{state | open: nil, regions: [region | state.regions]}
        end

      Regex.match?(@turn_re, line) ->
        case state.open do
          nil ->
            state

          {refs, opened, _} ->
            state
            |> problem(
              "region opened at line #{opened} (refs: #{Enum.join(refs, " ")}) crosses a turn boundary at line #{n}"
            )
            |> Map.put(:open, nil)
        end

      state.open != nil ->
        {refs, opened, content} = state.open
        %{state | open: {refs, opened, [line | content]}}

      true ->
        state
    end
  end

  defp problem(state, text), do: %{state | problems: [text | state.problems]}

  # ---------------------------------------------------------------------
  # Ref classification and resolution
  # ---------------------------------------------------------------------

  @doc """
  Classify a ref. A `sb:` id is an aggregating concept sink; anything else is
  treated as a path back-link (it must resolve to a file, and it accretes no
  log). There are deliberately only two kinds in this bundle — belief ids do not
  exist here.
  """
  def classify_ref("sb:" <> _ = ref), do: {:doc, ref}
  def classify_ref(ref), do: {:path, ref}

  @doc "Concept sinks (aggregating refs) of a region, in ref order."
  def doc_refs(refs), do: Enum.filter(refs, &match?({:doc, _}, classify_ref(&1)))

  defp resolve_ref({:doc, id}, id_index, _root), do: Map.has_key?(id_index, id)

  defp resolve_ref({:path, p}, _id_index, root),
    do: File.exists?(Path.join(root, String.trim_leading(p, "/")))

  # ---------------------------------------------------------------------
  # Sink scanning: materialized logs
  # ---------------------------------------------------------------------

  @doc """
  All concept documents carrying a route-tagged log section, mapped
  `sb_id => %{path: rel, blocks: %{thread_slug => block_lines}}`.
  """
  def scan_sinks(root, concepts) do
    concepts
    |> Enum.flat_map(fn %{id: id, path: rel} ->
      case root |> Path.join(rel) |> File.read!() |> parse_log_section() do
        nil -> []
        blocks -> [{id, %{path: rel, blocks: blocks}}]
      end
    end)
    |> Map.new()
  end

  @doc """
  Extract the route-tagged log section's per-thread blocks from a document.
  Returns `nil` when the document carries no log section, else a map of
  `thread_slug => block_lines` (from the `###` header to the section's end).
  """
  def parse_log_section(markdown) do
    lines = String.split(markdown, "\n")

    case Enum.split_while(lines, &(!Regex.match?(@log_section_re, &1))) do
      {_, []} ->
        nil

      {_, [_header | rest]} ->
        rest
        |> Enum.take_while(&(!String.starts_with?(&1, "## ")))
        |> split_blocks()
    end
  end

  defp split_blocks(lines) do
    lines
    |> Enum.chunk_while(
      [],
      fn line, acc ->
        if String.starts_with?(line, "### ") and acc != [],
          do: {:cont, Enum.reverse(acc), [line]},
          else: {:cont, [line | acc]}
      end,
      fn acc -> {:cont, Enum.reverse(acc), []} end
    )
    |> Enum.filter(fn block -> match?(["### " <> _ | _], block) end)
    |> Map.new(fn ["### " <> header | _] = block ->
      slug = header |> String.split(" (") |> hd()
      {slug, block}
    end)
  end

  # ---------------------------------------------------------------------
  # Derivation: what a sink's block must contain, given the current tags
  # ---------------------------------------------------------------------

  @doc """
  Re-derive sink `sink`'s dated block for a thread from its tagged regions: the
  `###` header, the count line, and each region lifted whole (ATX headers
  demoted to bold) under its full ref-set, in document order.
  """
  def derive_block(sink, thread, regions) do
    entries =
      Enum.map(regions, fn region ->
        co_feeds = region.refs -- [sink]

        header =
          case co_feeds do
            [] -> "**[`#{sink}`]**"
            _ -> "**[`#{sink}`]**  (co-feeds: `#{Enum.join(co_feeds, " ")}`)"
          end

        header <>
          "\n\n" <> (region.content |> demote_headers() |> trim_blank_edges() |> Enum.join("\n"))
      end)

    """
    ### #{thread.slug} (#{thread.date})

    #{length(regions)} tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

    #{Enum.join(entries, "\n\n---\n\n")}
    """
  end

  @doc "Demote ATX headers to bold, outside fenced code."
  def demote_headers(lines) do
    {out, _fence} =
      Enum.map_reduce(lines, false, fn line, fence ->
        cond do
          String.starts_with?(String.trim_leading(line), "```") -> {line, not fence}
          fence -> {line, fence}
          match = Regex.run(~r/^#{"#"}{1,6} (.+)$/, line) -> {"**#{Enum.at(match, 1)}**", fence}
          true -> {line, fence}
        end
      end)

    out
  end

  defp trim_blank_edges(lines) do
    lines
    |> Enum.drop_while(&(String.trim(&1) == ""))
    |> Enum.reverse()
    |> Enum.drop_while(&(String.trim(&1) == ""))
    |> Enum.reverse()
  end

  defp normalize(text) when is_binary(text), do: normalize(String.split(text, "\n"))

  defp normalize(lines) do
    lines
    |> Enum.map(&String.trim_trailing/1)
    |> trim_blank_edges()
    |> Enum.join("\n")
  end

  # ---------------------------------------------------------------------
  # Checks
  # ---------------------------------------------------------------------

  defp tagged(threads), do: Enum.filter(threads, &(&1.regions != []))

  defp check_wellformedness(threads) do
    problems = for t <- threads, p <- t.problems, do: "#{t.slug}: #{p}"

    tagged = tagged(threads)
    regions = tagged |> Enum.map(&length(&1.regions)) |> Enum.sum()

    if problems == [] do
      {"tag wellformedness", :ok,
       "#{regions} region(s) across #{length(tagged)} tagged thread(s), balanced, none crossing a turn boundary"}
    else
      {"tag wellformedness", :fail, Enum.join(problems, "\n        ")}
    end
  end

  defp check_ref_resolution(threads, id_index, root) do
    refs = for t <- tagged(threads), r <- t.regions, ref <- r.refs, uniq: true, do: ref

    unresolved = Enum.reject(refs, &resolve_ref(classify_ref(&1), id_index, root))

    kinds = Enum.frequencies_by(refs, &elem(classify_ref(&1), 0))

    if unresolved == [] do
      {"ref resolution", :ok,
       "#{length(refs)} distinct ref(s) all resolve (#{kinds[:doc] || 0} concept sink(s), #{kinds[:path] || 0} path back-link(s))"}
    else
      {"ref resolution", :fail, "unresolved ref(s): #{Enum.join(unresolved, ", ")}"}
    end
  end

  # Every (tagged thread, concept sink) pair demands a dated block in the sink.
  defp feeding_pairs(threads) do
    for t <- tagged(threads),
        sink <- t.regions |> Enum.flat_map(&doc_refs(&1.refs)) |> Enum.uniq(),
        do: {t, sink}
  end

  defp check_sink_logs(threads, sinks) do
    missing =
      for {t, sink} <- feeding_pairs(threads),
          get_in(sinks, [sink, :blocks, t.slug]) == nil,
          do:
            "#{sink}: no dated block for #{t.slug}#{if sinks[sink], do: "", else: " (no route-tagged log section)"}"

    pairs = feeding_pairs(threads)

    if missing == [] do
      {"sink logs", :ok, "#{length(pairs)} thread-to-sink append(s) all present"}
    else
      {"sink logs", :fail, Enum.join(missing, "\n        ")}
    end
  end

  defp check_log_fidelity(threads, sinks) do
    by_slug = Map.new(threads, &{&1.slug, &1})

    divergent =
      for {t, sink} <- feeding_pairs(threads),
          block = get_in(sinks, [sink, :blocks, t.slug]),
          block != nil,
          regions = Enum.filter(t.regions, &(sink in doc_refs(&1.refs))),
          normalize(block) != normalize(derive_block(sink, t, regions)),
          do: "#{sink}: block for #{t.slug} diverges from its re-derivation from the tags"

    orphans =
      for {sink, %{blocks: blocks}} <- sinks,
          {slug, _} <- blocks,
          t = by_slug[slug],
          t == nil or not Enum.any?(t.regions, &(sink in doc_refs(&1.refs))),
          do:
            "#{sink}: block for #{slug} but #{if t, do: "the thread no longer tags this sink", else: "no such thread"}"

    problems = divergent ++ orphans

    checked =
      feeding_pairs(threads)
      |> Enum.count(fn {t, sink} -> get_in(sinks, [sink, :blocks, t.slug]) != nil end)

    if problems == [] do
      {"log fidelity", :ok,
       "#{checked} materialized block(s) match their re-derivation from the tags"}
    else
      {"log fidelity", :fail, Enum.join(problems, "\n        ")}
    end
  end

  defp check_ledger_coverage(threads, root, id_index) do
    warnings =
      threads
      |> Enum.filter(&(&1.date != nil))
      |> Enum.flat_map(fn t ->
        routed = ledger_doc_sinks(t, root, id_index)
        tagged_sinks = t.regions |> Enum.flat_map(&doc_refs(&1.refs)) |> Enum.uniq()

        cond do
          routed == [] ->
            []

          t.regions == [] ->
            [
              "#{t.slug}: routing ledger routes to #{length(routed)} concept(s) but the body carries no route tags"
            ]

          true ->
            case routed -- tagged_sinks do
              [] ->
                []

              uncovered ->
                [
                  "#{t.slug}: ledger row(s) routed to #{Enum.join(uncovered, ", ")} but no region tags them"
                ]
            end
        end
      end)

    if warnings == [] do
      {"ledger cross-check", :ok, "every concept-routed ledger row is covered by a tag"}
    else
      {"ledger cross-check", :warn, Enum.join(warnings, "\n        ")}
    end
  end

  @doc """
  Concept sinks a thread's routing ledger routes to, as `sb:` ids: markdown
  links in the `Routed to` column that resolve to a bundle concept (via its
  stable id). Bundle-absolute links (`/SWE/…`) and thread-relative links both
  resolve; links to non-concepts (`unrouted`, `index.md`, tooling) drop out
  because they carry no id.
  """
  def ledger_doc_sinks(thread, root, id_index) do
    path_index = Map.new(id_index, fn {id, path} -> {path, id} end)

    thread.path
    |> File.read!()
    |> String.split("\n")
    |> Enum.filter(&String.starts_with?(&1, "|"))
    |> Enum.flat_map(fn row ->
      case String.split(row, "|") do
        [_, _topic, _state, routed_to | _] ->
          Regex.scan(~r/\[[^\]]*\]\(([^)]+)\)/, routed_to, capture: :all_but_first)

        _ ->
          []
      end
    end)
    |> Enum.map(fn [target] -> resolve_link(target, thread.path, root) end)
    |> Enum.map(&path_index[&1])
    |> Enum.reject(&is_nil/1)
    |> Enum.uniq()
  end

  # Resolve a ledger link target to a bundle-relative path. Bundle-absolute
  # targets begin with `/`; everything else is relative to the thread file.
  defp resolve_link("/" <> rest, _thread_path, _root), do: strip_anchor(rest)

  defp resolve_link(target, thread_path, root) do
    thread_path
    |> Path.dirname()
    |> Path.join(strip_anchor(target))
    |> Path.expand()
    |> Path.relative_to(Path.expand(root))
  end

  defp strip_anchor(target), do: target |> String.split("#") |> hd()

  # ---------------------------------------------------------------------
  # Materialization: write each sink's log section from the current tags
  # ---------------------------------------------------------------------

  @doc """
  Regenerate every fed sink's route-tagged log section from the current tags,
  writing the files in place. Returns the list of concept paths (relative to
  `root`) that were rewritten. Run this after (re)placing tags so the log is
  generated rather than hand-kept; `run_checks/1` then guards it structurally.
  """
  @spec materialize(String.t()) :: [String.t()]
  def materialize(root \\ File.cwd!()) do
    threads = scan_threads(root)
    concepts = bundle_concepts(root)
    id_index = Map.new(concepts, &{&1.id, &1.path})

    threads
    |> feeding_pairs()
    |> Enum.group_by(fn {_t, sink} -> sink end, fn {t, _sink} -> t end)
    |> Enum.flat_map(fn {sink, ts} ->
      case id_index[sink] do
        nil ->
          []

        rel ->
          write_log_section(root, rel, sink, Enum.sort_by(ts, & &1.slug))
          [rel]
      end
    end)
    |> Enum.sort()
  end

  defp write_log_section(root, rel, sink, threads) do
    path = Path.join(root, rel)
    content = File.read!(path)

    blocks =
      Enum.map(threads, fn t ->
        regions = Enum.filter(t.regions, &(sink in doc_refs(&1.refs)))
        String.trim_trailing(derive_block(sink, t, regions))
      end)

    section =
      @log_heading <>
        "\n\n" <>
        "Append-only, per-thread, date-stamped excerpts, generated from the " <>
        "`<routes ref=\"#{sink}\">` regions of the threads that fed this matter and " <>
        "re-derivable via `mix brain.route_tags` — never hand-edit.\n\n" <>
        Enum.join(blocks, "\n\n")

    File.write!(path, replace_section(content, section))
  end

  # Replace an existing log section (heading through the next h1/h2 or EOF) with
  # the freshly rendered one, or append it to the body when none exists.
  defp replace_section(content, section) do
    lines = String.split(content, "\n")

    case Enum.find_index(lines, &Regex.match?(@log_section_re, &1)) do
      nil ->
        String.trim_trailing(content) <> "\n\n" <> section <> "\n"

      start ->
        {before, from} = Enum.split(lines, start)
        rest = tl(from)

        tail =
          case Enum.find_index(rest, &Regex.match?(~r/^#{"#"}{1,2} /, &1)) do
            nil -> []
            i -> Enum.drop(rest, i)
          end

        (Enum.join(before, "\n") |> String.trim_trailing()) <>
          "\n\n" <> section <> if(tail == [], do: "\n", else: "\n\n" <> Enum.join(tail, "\n"))
    end
  end
end
