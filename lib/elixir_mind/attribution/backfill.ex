defmodule ElixirMind.Attribution.Backfill do
  @moduledoc """
  One-shot reconstruction of `attribution` for docs that predate the
  resource-attribution policy (`mix brain.attribution --backfill`).

  Derivation rules — facts recovered from history, never invented:

    * `when` — the file's first-add instant from `git log --follow
      --diff-filter=A` (the ingestion commit).
    * Bundle concepts tagged `auto-intake` — their true channel is known:
      `channel: auto-intake`, `why` derived from the digest date in
      `provenance`, and the retired tag removed (its job moves to
      `attribution.channel`).
    * Glossary term files — their pathway is structural:
      `channel: glossary` (every term file is accreted by `/add-to-glossary`
      from scanned sources; the *Seen in:* line carries the citations).
    * Everything else — `channel: backfill` with the reconstruction named in
      `agent` and `why` omitted (the reason is unrecoverable; the backfill
      rule allows its absence rather than a guessed sentence).
    * Governance `from` — recovered from the explicit sources that already
      exist: an elaboration's `thread:` field (migrated, the field removed)
      and a flow doc's `lineage:` block (analysis/plan/thread paths; the
      block itself is retired separately by lineage derivation).

  Files already carrying `attribution` are left untouched — the event is
  write-once, and hand-written blocks beat reconstruction.
  """

  alias ElixirMind.{Attribution, Frontmatter, Lineage, Registry}

  @doc """
  Backfill the whole corpus under `root`. Returns `{written, skipped}` —
  paths rewritten and paths that already carried attribution. Runs two
  idempotent passes: reconstruct missing `attribution` blocks, then derive
  missing governance `from` back-links (the thread of the PR that introduced
  the doc, resolved through the thread docs' `pr:` anchors).
  """
  def run(root \\ File.cwd!()) do
    bundle = Registry.concept_paths(root)
    %{governance: governance} = Attribution.governance_paths(root)

    {written, skipped} =
      Enum.reduce(bundle ++ governance, {[], []}, fn path, {written, skipped} ->
        case backfill_file(root, path, path in bundle) do
          :written -> {[path | written], skipped}
          :skipped -> {written, [path | skipped]}
        end
      end)

    stamped = from_pass(root, governance)

    {Enum.reverse(written) ++ stamped, Enum.reverse(skipped)}
  end

  # --- from derivation (pass 2) ----------------------------------------------
  #
  # The thread a governance doc was *extracted from* is recoverable exactly:
  # the doc's first-add commit reached main through one PR merge, and thread
  # docs record their PR as `pr:`. Flow docs are excluded — their `from` comes
  # from the richer `lineage:` block in pass 1. Docs whose first-add commit
  # sits directly on a first-parent line (pre-PR era, or this very session)
  # are skipped rather than guessed.
  defp from_pass(root, governance) do
    threads = thread_by_pr(root)
    mainline = first_parent_set(root)

    governance
    |> Enum.reject(&String.starts_with?(&1, "meta/flows/"))
    |> Enum.filter(fn path ->
      case root |> Path.join(path) |> File.read!() |> Frontmatter.parse() do
        {:ok, %{frontmatter: %{"attribution" => %{} = a}}} -> is_nil(a["from"])
        _ -> false
      end
    end)
    |> Enum.flat_map(fn path ->
      with commit when is_binary(commit) <- first_add_commit(root, path),
           false <- MapSet.member?(mainline, commit),
           {:ok, pr} <- introducing_pr(root, commit),
           thread when is_binary(thread) <- threads[pr] do
        append_from(root, path, "/" <> thread)
        [path]
      else
        _ -> []
      end
    end)
  end

  defp thread_by_pr(root) do
    root
    |> Path.join("meta/threads/*.md")
    |> Path.wildcard()
    |> Enum.map(&Path.relative_to(&1, root))
    |> Enum.reject(&(Path.basename(&1) == "index.md"))
    |> Enum.flat_map(fn path ->
      case root |> Path.join(path) |> File.read!() |> Frontmatter.parse() do
        {:ok, %{frontmatter: %{"pr" => pr}}} when is_integer(pr) -> [{pr, path}]
        _ -> []
      end
    end)
    |> Map.new()
  end

  defp first_parent_set(root) do
    {out, 0} = System.cmd("git", ["rev-list", "--first-parent", "HEAD"], cd: root)
    out |> String.split("\n", trim: true) |> MapSet.new()
  end

  defp first_add_commit(root, rel_path) do
    candidates = [rel_path | List.wrap(pre_reorg_path(rel_path))]

    Enum.find_value(candidates, fn path ->
      {out, 0} =
        System.cmd(
          "git",
          ["log", "--follow", "--diff-filter=A", "--format=%H", "--", path],
          cd: root
        )

      out |> String.split("\n", trim: true) |> List.last()
    end)
  end

  # The first PR-merge on the ancestry path from the commit to HEAD, verified
  # to actually contain the commit on its branch side.
  defp introducing_pr(root, commit) do
    {out, 0} =
      System.cmd(
        "git",
        ["log", "--merges", "--ancestry-path", "--reverse", "--format=%H %s", "#{commit}..HEAD"],
        cd: root
      )

    out
    |> String.split("\n", trim: true)
    |> Enum.find_value(:error, fn line ->
      with [merge_sha, subject] <- String.split(line, " ", parts: 2),
           [_, pr] <- Regex.run(~r/Merge pull request #(\d+)/, subject),
           {_, 0} <-
             System.cmd("git", ["merge-base", "--is-ancestor", commit, "#{merge_sha}^2"], cd: root) do
        {:ok, String.to_integer(pr)}
      else
        _ -> nil
      end
    end)
  end

  defp append_from(root, rel_path, thread_ref) do
    path = Path.join(root, rel_path)
    content = File.read!(path)

    updated =
      Regex.replace(
        ~r/^(attribution:\n(?:  [^\n]+\n)+)/m,
        content,
        "\\1  from: [#{thread_ref}]\n",
        global: false
      )

    if updated == content, do: raise("could not append from to #{rel_path}")
    File.write!(path, updated)
  end

  defp backfill_file(root, rel_path, bundle?) do
    content = root |> Path.join(rel_path) |> File.read!()
    {:ok, %{frontmatter: fm}} = Frontmatter.parse(content)

    if Map.has_key?(fm, "attribution") do
      :skipped
    else
      attribution = derive(root, rel_path, fm, content, bundle?)

      content
      |> strip_migrated_lines(fm)
      |> insert_attribution(attribution)
      |> then(&File.write!(Path.join(root, rel_path), &1))

      :written
    end
  end

  # --- derivation ------------------------------------------------------------

  defp derive(root, rel_path, fm, content, bundle?) do
    base = [{"when", first_add_instant(root, rel_path)}]

    cond do
      bundle? and auto_intake_tagged?(fm) ->
        base ++
          [
            {"channel", "auto-intake"},
            {"agent", "\"Claude Code agent, /research auto-intake\""},
            {"why", "\"#{auto_intake_why(fm)}\""}
          ]

      bundle? and String.starts_with?(rel_path, "beliefs/glossary/") ->
        base ++
          [
            {"channel", "glossary"},
            {"agent", "\"Claude Code agent, /add-to-glossary\""},
            {"why", "\"term surfaced by the captured sources cited in Seen in (backfilled)\""}
          ]

      true ->
        base ++
          [
            {"channel", "backfill"},
            {"agent", "\"reconstructed by mix brain.attribution --backfill, 2026-07-13\""}
          ] ++ from_entry(rel_path, fm, content)
    end
  end

  # The 2026-07-12 root reorganization (81e67e5) moved the bundle under
  # knowledge/ and beliefs/ on a side branch, and `git log --follow` does not
  # track those renames across the merge topology — so when the current path
  # has no first-add commit, retry under the pre-reorg path, then fall back to
  # the earliest commit touching either path.
  defp first_add_instant(root, rel_path) do
    candidates = [rel_path | List.wrap(pre_reorg_path(rel_path))]

    Enum.find_value(candidates, fn path -> git_instant(root, path, filter: "A") end) ||
      Enum.find_value(candidates, fn path -> git_instant(root, path, filter: nil) end) ||
      raise "no first-add commit found for #{rel_path}"
  end

  defp pre_reorg_path("knowledge/" <> rest), do: rest
  defp pre_reorg_path("beliefs/glossary/" <> rest), do: "glossary/" <> rest
  defp pre_reorg_path("beliefs/glossary.md"), do: "glossary.md"
  defp pre_reorg_path("beliefs/future-beliefs.md"), do: "meta/future-beliefs.md"
  defp pre_reorg_path(_), do: nil

  defp git_instant(root, path, filter: filter) do
    args =
      ["log", "--follow"] ++
        if(filter, do: ["--diff-filter=#{filter}"], else: []) ++
        ["--format=%aI", "--", path]

    {out, 0} = System.cmd("git", args, cd: root)
    out |> String.split("\n", trim: true) |> List.last()
  end

  defp auto_intake_tagged?(fm), do: "auto-intake" in List.wrap(fm["tags"])

  # The digest date is recoverable from the provenance line the auto-intake
  # step wrote (e.g. "auto-intaken from /research inbox 2026-07-12").
  defp auto_intake_why(fm) do
    case Regex.run(~r/(\d{4}-\d{2}-\d{2})/, to_string(fm["provenance"])) do
      [_, date] -> "featured in the #{date} /research digest (backfilled)"
      nil -> "featured in a /research digest (backfilled)"
    end
  end

  # Governance `from`: an elaboration's thread back-link, or a flow doc's
  # lineage sources (analysis/plan/thread paths — the PR hop lives on the
  # thread docs' `pr:`, not in `from`).
  defp from_entry(rel_path, fm, content) do
    refs =
      cond do
        String.starts_with?(rel_path, "meta/elaborations/") ->
          List.wrap(fm["thread"])

        String.starts_with?(rel_path, "meta/flows/") ->
          lineage = Lineage.parse_lineage_block(content)

          Enum.flat_map([:analysis, :plan, :thread], &Map.get(lineage, &1, []))

        true ->
          []
      end

    case refs do
      [] -> []
      refs -> [{"from", "[" <> Enum.join(refs, ", ") <> "]"}]
    end
  end

  # --- rewriting ---------------------------------------------------------------

  # The elaboration `thread:` field is migrated into `attribution.from`;
  # the retired `auto-intake` tag is dropped from `tags`.
  defp strip_migrated_lines(content, fm) do
    content
    |> then(fn c ->
      if is_binary(fm["thread"]),
        do: String.replace(c, ~r/^thread:[^\n]*\n/m, "", global: false),
        else: c
    end)
    |> then(fn c ->
      if auto_intake_tagged?(fm) do
        String.replace(c, ~r/^tags:[^\n]*$/m, fn line ->
          line
          |> String.replace(~r/,\s*auto-intake/, "")
          |> String.replace(~r/auto-intake,\s*/, "")
        end)
      else
        c
      end
    end)
  end

  defp insert_attribution(content, pairs) do
    block = "attribution:\n" <> Enum.map_join(pairs, "\n", fn {k, v} -> "  #{k}: #{v}" end)

    [head, rest] = String.split(content, "\n---\n", parts: 2)
    head <> "\n" <> block <> "\n---\n" <> rest
  end
end
