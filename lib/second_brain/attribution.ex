defmodule SecondBrain.Attribution do
  @moduledoc """
  The attribution layer: machine checks and helpers for the `attribution`
  frontmatter map — the record of the **ingestion event** on every bundle
  concept and governance doc (see `meta/policy/resource-attribution.md` and the
  attribution plan).

      attribution:
        when: 2026-07-13T14:02:00Z
        channel: auto-intake
        agent: "Claude Code agent, /research daily Routine"
        why: "featured in the 2026-07-13 digest under agents/orchestration"
        from: [/meta/threads/2026-07-13-example.md]   # governance docs only

  Rules (surfaced through `SecondBrain.Verifier`):

    * **Shape** — `attribution` is a map; `when` parses as ISO 8601 (date or
      datetime); `channel` is from the controlled vocabulary; `agent` is a
      non-empty string; `why` is a non-empty string except under
      `channel: backfill`, where a reconstructed event may honestly lack one.
    * **`from` placement** — `from` belongs to governance docs only; on a
      bundle concept it is an error.
    * **`from` resolution** — every ref resolves: `sb:` ids to a bundle
      concept, bundle-absolute paths to an existing file.
    * **Exemption placement** — exempt files (thread docs, `inbox/` digests,
      `index.md` listings, generated artifacts) must NOT carry `attribution`.
    * **Presence** — once the backfill lands (`presence_enforced?/0` flips to
      `true`), every bundle concept and every governance doc carries
      `attribution`. `from`-presence on ratification-flow docs is advisory
      (a warning) while `/create-pull-request` stamping beds in.

  The event sub-keys are immutable once written; governance `from` is
  append-only. Immutability is a contract obligation on agents (the verifier
  sees one snapshot, not a diff) — git review is the safety net.
  """

  @channels ~w(intake auto-intake glossary agent-authored backfill)

  # Governance docs whose `from` is expected (warned when missing): things
  # that are always extracted from *somewhere*.
  @from_expected_types ~w(plan analysis elaboration issue)

  # Flipped on when the corpus backfill landed (build step 4 of the
  # attribution plan): every bundle concept and governance doc must carry
  # the field.
  @presence_enforced true

  def channels, do: @channels
  def presence_enforced?, do: @presence_enforced

  # --- governance namespace walk --------------------------------------------

  @doc """
  All governance-side `.md` paths (relative), partitioned into
  `%{governance: [...], exempt: [...]}`. Governance docs live under `meta/`;
  exempt files are thread docs, `inbox/` digests, `index.md` listings, and
  generated artifacts (`meta/registry.md`, `meta/preamble.md`,
  `meta/flows/lineage.md`).
  """
  def governance_paths(root \\ File.cwd!()) do
    ["meta/**/*.md", "inbox/**/*.md"]
    |> Enum.flat_map(fn glob ->
      root |> Path.join(glob) |> Path.wildcard() |> Enum.map(&Path.relative_to(&1, root))
    end)
    |> Enum.sort()
    |> Enum.split_with(&(not exempt?(&1)))
    |> then(fn {gov, exempt} -> %{governance: gov, exempt: exempt} end)
  end

  defp exempt?(rel_path) do
    Path.basename(rel_path) == "index.md" or
      String.starts_with?(rel_path, "meta/threads/") or
      String.starts_with?(rel_path, "inbox/") or
      rel_path in ~w(meta/registry.md meta/preamble.md meta/flows/lineage.md)
  end

  # --- errors ----------------------------------------------------------------

  @doc """
  All attribution errors for the governance namespace, given the bundle's
  id index (for `from` ref resolution). Pass `presence: true` to also require
  `attribution` on every governance doc (the post-backfill regime).
  """
  def governance_errors(root, by_id, opts \\ []) do
    presence = Keyword.get(opts, :presence, presence_enforced?())
    %{governance: governance, exempt: exempt} = governance_paths(root)

    exempt_errors =
      exempt
      |> Enum.filter(&has_attribution?(root, &1))
      |> Enum.map(fn path ->
        "#{path}: exempt file carries `attribution` — thread docs, inbox digests, " <>
          "index listings, and generated artifacts are outside the attribution scope"
      end)

    governance_errors =
      Enum.flat_map(governance, fn path ->
        case frontmatter(root, path) do
          {:ok, fm} ->
            case fm["attribution"] do
              nil ->
                if presence,
                  do: ["#{path}: missing `attribution` — every governance doc records its ingestion event"],
                  else: []

              attribution ->
                shape_errors(attribution, path, :governance, by_id, root)
            end

          :error ->
            []
        end
      end)

    exempt_errors ++ governance_errors
  end

  @doc """
  Attribution errors for one bundle concept (a `Registry.Entry`). Pass
  `presence: true` to require the field (the post-backfill regime).
  """
  def bundle_errors(entry, by_id, root, opts \\ []) do
    presence = Keyword.get(opts, :presence, presence_enforced?())

    case entry.attribution do
      nil ->
        if presence,
          do: ["#{entry.path}: missing `attribution` — every bundle concept records its ingestion event"],
          else: []

      attribution ->
        shape_errors(attribution, entry.path, :bundle, by_id, root)
    end
  end

  @doc """
  Advisory warnings (never fail the gate): ratification-flow governance docs
  (#{Enum.join(@from_expected_types, "/")}) whose `attribution` lacks a `from`
  back-link to the thread or doc they were extracted from.
  """
  def warnings(root \\ File.cwd!()) do
    %{governance: governance} = governance_paths(root)

    Enum.flat_map(governance, fn path ->
      with {:ok, fm} <- frontmatter(root, path),
           true <- fm["type"] in @from_expected_types,
           %{} = attribution <- fm["attribution"],
           [] <- List.wrap(attribution["from"]) do
        ["#{path}: `attribution` lacks `from` — link the thread or doc this #{fm["type"]} was extracted from"]
      else
        _ -> []
      end
    end)
  end

  # --- query ------------------------------------------------------------------

  @doc """
  List every attributed doc as a row map (`path`/`id`/`when`/`channel`/
  `agent`/`why`/`from`), newest first. Options:

    * `:channel` — keep only rows with this channel (e.g. `"auto-intake"`,
      the operator's post-auto-intake editorial queue).
    * `:since` — an ISO 8601 date string; keep only rows ingested on or
      after it.
  """
  def list(root \\ File.cwd!(), opts \\ []) do
    {entries, _errors} = SecondBrain.Registry.scan(root)
    %{governance: governance} = governance_paths(root)

    bundle_rows =
      Enum.flat_map(entries, fn e ->
        case e.attribution do
          %{} = a -> [row(e.path, e.id, a)]
          _ -> []
        end
      end)

    governance_rows =
      Enum.flat_map(governance, fn path ->
        case frontmatter(root, path) do
          {:ok, %{"attribution" => %{} = a}} -> [row(path, nil, a)]
          _ -> []
        end
      end)

    (bundle_rows ++ governance_rows)
    |> filter_channel(opts[:channel])
    |> filter_since(opts[:since])
    |> Enum.sort_by(& &1.when, :desc)
  end

  defp row(path, id, attribution) do
    %{
      path: path,
      id: id,
      when: to_string(attribution["when"] || ""),
      channel: attribution["channel"],
      agent: attribution["agent"],
      why: attribution["why"],
      from: List.wrap(attribution["from"])
    }
  end

  defp filter_channel(rows, nil), do: rows
  defp filter_channel(rows, channel), do: Enum.filter(rows, &(&1.channel == channel))

  defp filter_since(rows, nil), do: rows

  defp filter_since(rows, since),
    do: Enum.filter(rows, &(String.slice(&1.when, 0, 10) >= since))

  # --- shape ------------------------------------------------------------------

  defp shape_errors(attribution, path, _kind, _by_id, _root) when not is_map(attribution) do
    [
      "#{path}: `attribution` is not a map — expected an indented block with " <>
        "`when`/`channel`/`agent`/`why` sub-keys"
    ]
  end

  defp shape_errors(attribution, path, kind, by_id, root) do
    when_errors(attribution["when"], path) ++
      channel_errors(attribution["channel"], path) ++
      agent_errors(attribution["agent"], path) ++
      why_errors(attribution["why"], attribution["channel"], path) ++
      from_errors(attribution["from"], path, kind, by_id, root)
  end

  defp when_errors(nil, path), do: ["#{path}: attribution missing `when` (ISO 8601 ingestion instant)"]

  defp when_errors(value, path) do
    value = to_string(value)

    parses? =
      match?({:ok, _}, Date.from_iso8601(value)) or
        match?({:ok, _, _}, DateTime.from_iso8601(value)) or
        match?({:ok, _}, NaiveDateTime.from_iso8601(value))

    if parses?, do: [], else: ["#{path}: attribution `when` #{inspect(value)} is not ISO 8601"]
  end

  defp channel_errors(channel, _path) when channel in @channels, do: []

  defp channel_errors(channel, path) do
    [
      "#{path}: attribution channel #{inspect(channel)} is not in the controlled " <>
        "vocabulary (#{Enum.join(@channels, ", ")})"
    ]
  end

  defp agent_errors(agent, path) do
    if is_binary(agent) and String.trim(agent) != "",
      do: [],
      else: ["#{path}: attribution missing `agent` (the acting pathway, e.g. \"operator via /intake\")"]
  end

  # A reconstructed event may honestly lack a why; anything else must say
  # why it was worth filing.
  defp why_errors(why, channel, path) do
    cond do
      is_binary(why) and String.trim(why) != "" -> []
      channel == "backfill" -> []
      true -> ["#{path}: attribution missing `why` (one sentence; only `channel: backfill` may omit it)"]
    end
  end

  defp from_errors(nil, _path, _kind, _by_id, _root), do: []

  defp from_errors(_from, path, :bundle, _by_id, _root) do
    ["#{path}: attribution `from` on a bundle concept — the back-link belongs to governance docs only"]
  end

  defp from_errors(from, path, :governance, by_id, root) do
    from
    |> List.wrap()
    |> Enum.reject(&resolves?(&1, by_id, root))
    |> Enum.map(&"#{path}: attribution from #{inspect(&1)} does not resolve")
  end

  defp resolves?("sb:" <> _ = id, by_id, _root), do: Map.has_key?(by_id, id)
  defp resolves?("/" <> rel, _by_id, root), do: File.exists?(Path.join(root, rel))
  defp resolves?(_other, _by_id, _root), do: false

  # --- helpers ----------------------------------------------------------------

  defp has_attribution?(root, rel_path) do
    case frontmatter(root, rel_path) do
      {:ok, fm} -> Map.has_key?(fm, "attribution")
      :error -> false
    end
  end

  defp frontmatter(root, rel_path) do
    case root |> Path.join(rel_path) |> File.read!() |> SecondBrain.Frontmatter.parse() do
      {:ok, %{frontmatter: fm}} -> {:ok, fm}
      {:error, _} -> :error
    end
  end
end
