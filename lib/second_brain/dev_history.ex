defmodule SecondBrain.DevHistory do
  @moduledoc """
  The derived dev-history view: per-PR features and progress, compiled from
  the default branch's **first-parent git history** into
  `meta/dev-history.md`.

  There is no hand-kept log (see the reserved-filenames policy and the
  retire-hand-kept-logs plan): the true-merge commit graph *is* the
  provenance layer, and this module renders a readable overview of it on the
  same generated-artifact discipline as `CLAUDE.md`, `meta/registry.md`, and
  `meta/flows/lineage.md`. `git log --first-parent` yields one commit per PR;
  each entry's bullets are the merged branch's commit subjects (already
  atomic and deliberately messaged per the merge-strategy policy).

  Three eras of history are handled:

    * **true merges** — `Merge pull request #N …`; bullets from the branch
      commits (`merge^1..merge^2`), title from the merge subject or body.
    * **the pre-policy squash era** — `Title (#N)` commits directly on main;
      bullets from the squash body's `* ` lines.
    * **the pre-PR era** — direct commits predating the PR workflow, listed
      as a closing section of dated subjects.

  The checked-in file inherently lags by the PR that ships it (a PR cannot
  contain its own merge commit), so `check/1` is **lag-tolerant**: a fresh
  derivation may have newer sections the file lacks, but everything the file
  does contain must match. The Pages build regenerates the doc at deploy
  time, so the live site's copy is always fully current.
  """

  @output "meta/dev-history.md"
  @ref_candidates ~w(origin/main main)

  # ASCII unit/record separators — safe field delimiters for git formats.
  @us "\x1f"
  @rs "\x1e"

  defmodule Entry do
    @moduledoc false
    @enforce_keys [:date, :title]
    defstruct [:pr, :date, :title, bullets: []]
  end

  @doc "Path of the generated dev-history view, relative to repo root."
  def output_path, do: @output

  @doc "True when the repository is a shallow clone (derivation would truncate)."
  def shallow?(root \\ File.cwd!()) do
    case git(root, ["rev-parse", "--is-shallow-repository"]) do
      {:ok, out} -> String.trim(out) == "true"
      _ -> false
    end
  end

  @doc """
  Resolve the ref the history is derived from: the first of `origin/main` /
  `main` that exists. Returns `{:ok, ref}` or `{:error, :no_default_branch}`.
  """
  def default_ref(root \\ File.cwd!()) do
    @ref_candidates
    |> Enum.find(fn ref ->
      match?({:ok, _}, git(root, ["rev-parse", "--verify", "--quiet", ref <> "^{commit}"]))
    end)
    |> case do
      nil -> {:error, :no_default_branch}
      ref -> {:ok, ref}
    end
  end

  @doc """
  Derive the entry list (newest first) from the first-parent history of the
  default branch. Returns `{:ok, entries}` or `{:error, reason}`.
  """
  @spec entries(String.t()) :: {:ok, [Entry.t()]} | {:error, term()}
  def entries(root \\ File.cwd!()) do
    with {:ok, ref} <- default_ref(root),
         {:ok, out} <-
           git(root, [
             "log",
             "--first-parent",
             "--date=short",
             "--format=%H#{@us}%ad#{@us}%s#{@us}%b#{@rs}",
             ref
           ]) do
      entries =
        out
        |> String.split(@rs, trim: true)
        |> Enum.map(&String.trim_leading(&1, "\n"))
        |> Enum.reject(&(&1 == ""))
        |> Enum.map(&build_entry(&1, root))

      {:ok, entries}
    end
  end

  defp build_entry(record, root) do
    [sha, date, subject, body] =
      case String.split(record, @us, parts: 4) do
        [sha, date, subject, body] -> [sha, date, subject, body]
        [sha, date, subject] -> [sha, date, subject, ""]
      end

    case classify(subject) do
      {:merge_from, pr, branch} ->
        title = first_line(body) || humanize_branch(branch) || subject
        %Entry{pr: pr, date: date, title: title, bullets: branch_bullets(root, sha)}

      {:merge_titled, pr, title} ->
        %Entry{pr: pr, date: date, title: title, bullets: branch_bullets(root, sha)}

      {:squash, pr, title} ->
        %Entry{pr: pr, date: date, title: title, bullets: squash_bullets(body)}

      :direct ->
        %Entry{pr: nil, date: date, title: subject}
    end
  end

  @doc """
  Classify a first-parent commit subject into its era:
  `{:merge_from, pr, branch}` / `{:merge_titled, pr, title}` (true merges),
  `{:squash, pr, title}` (pre-policy squash commits), or `:direct`.
  """
  def classify(subject) do
    cond do
      m = Regex.run(~r/^Merge (?:pull request|PR) #(\d+) from (\S+)\s*$/, subject) ->
        {:merge_from, String.to_integer(Enum.at(m, 1)), Enum.at(m, 2)}

      m = Regex.run(~r/^Merge (?:pull request|PR) #(\d+):\s*(.+)$/, subject) ->
        {:merge_titled, String.to_integer(Enum.at(m, 1)), String.trim(Enum.at(m, 2))}

      m = Regex.run(~r/^Merge (?:pull request|PR) #(\d+)\b/, subject) ->
        {:merge_from, String.to_integer(Enum.at(m, 1)), nil}

      m = Regex.run(~r/^(.+) \(#(\d+)\)$/, subject) ->
        {:squash, String.to_integer(Enum.at(m, 2)), String.trim(Enum.at(m, 1))}

      true ->
        :direct
    end
  end

  @doc """
  A readable fallback title from a head-branch name when the merge body is
  empty: strip the owner and `claude/` prefixes and the trailing session id,
  and space out the slug (`ob6to8/claude/foo-bar-ab12cd` → `foo bar`).
  """
  def humanize_branch(nil), do: nil

  def humanize_branch(branch) do
    branch
    |> String.split("/")
    |> List.last()
    |> String.replace(~r/-[a-z0-9]{6}$/, "")
    |> String.replace("-", " ")
    |> case do
      "" -> nil
      slug -> slug
    end
  end

  @doc """
  Bullets from a squash-commit body: the first line of each `* `-led block
  (GitHub's default squash body lists the branch's commit subjects that way).
  """
  def squash_bullets(body) do
    body
    |> String.split("\n")
    |> Enum.flat_map(fn line ->
      case Regex.run(~r/^\* (.+)$/, line) do
        [_, subject] -> [String.trim(subject)]
        nil -> []
      end
    end)
  end

  # The merged branch's commit subjects, oldest first — reachable forever
  # through the true merge (see the merge-strategy policy).
  defp branch_bullets(root, merge_sha) do
    case git(root, [
           "log",
           "--no-merges",
           "--reverse",
           "--format=%s",
           "#{merge_sha}^1..#{merge_sha}^2"
         ]) do
      {:ok, out} -> out |> String.split("\n", trim: true) |> Enum.map(&String.trim/1)
      _ -> []
    end
  end

  defp first_line(body) do
    body
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.find(&(&1 != ""))
    |> decode_entities()
  end

  # PR titles copied into merge bodies occasionally carry HTML entities.
  defp decode_entities(nil), do: nil

  defp decode_entities(text) do
    text
    |> String.replace("&amp;", "&")
    |> String.replace("&lt;", "<")
    |> String.replace("&gt;", ">")
    |> String.replace("&quot;", "\"")
    |> String.replace("&#39;", "'")
  end

  # --- render ----------------------------------------------------------------

  @doc "Derive and render the full generated document."
  def render(root \\ File.cwd!()) do
    with {:ok, entries} <- entries(root) do
      {:ok, render_entries(entries, SecondBrain.SiteConfig.repo_url())}
    end
  end

  @doc "Render a document from an entry list (pure; newest first)."
  def render_entries(entries, repo_url) do
    {pr_entries, direct} = Enum.split_with(entries, &(&1.pr != nil))

    """
    <!--
      GENERATED FILE — do not edit by hand.
      Source of truth: the default branch's first-parent git history (one merge per PR).
      Regenerate:      mix brain.dev_history
      Verify (CI):     mix brain.dev_history --check (lag-tolerant: newer merges may be absent)
    -->

    # Dev history — per-PR features and progress

    One section per pull request merged into the default branch, newest first —
    derived entirely from the true-merge commit graph (the provenance layer per the
    [merge-strategy policy](/meta/policy/merge-strategy.md)), never hand-written.
    Each PR's bullets are the merged branch's commit subjects, in the order they
    were made. The checked-in copy lags by the PR that ships it; the copy on the
    deployed site is regenerated at deploy time and is always current.

    #{Enum.map_join(pr_entries, "\n", &pr_section(&1, repo_url))}#{direct_section(direct)}
    """
  end

  defp pr_section(%Entry{} = e, repo_url) do
    bullets =
      case e.bullets do
        [] -> "- *(no branch commits recorded)*\n"
        bullets -> Enum.map_join(bullets, "\n", &("- " <> &1)) <> "\n"
      end

    "## #{pr_label(e.pr, repo_url)} — #{e.title} *(#{e.date})*\n\n" <> bullets
  end

  defp pr_label(pr, nil), do: "PR ##{pr}"
  defp pr_label(pr, repo_url), do: "[PR ##{pr}](#{repo_url}/pull/#{pr})"

  defp direct_section([]), do: ""

  defp direct_section(direct) do
    rows = Enum.map_join(direct, "\n", fn e -> "- #{e.date} — #{e.title}" end)

    "\n## Pre-PR era — direct commits\n\n" <>
      "Commits made straight to the default branch before the PR workflow was\n" <>
      "adopted (the brain's precursor era), listed by commit subject.\n\n" <> rows <> "\n"
  end

  # --- write / check ---------------------------------------------------------

  @doc "Derive, render, and write the view. Returns `{:ok, path}` or `{:error, reason}`."
  def write(root \\ File.cwd!()) do
    with {:ok, rendered} <- render(root) do
      path = Path.join(root, @output)
      File.write!(path, rendered)
      {:ok, @output}
    end
  end

  @doc """
  Check the on-disk view against a fresh derivation. Lag-tolerant: the fresh
  render may carry newer PR sections the file lacks (the file cannot contain
  the merge that ships it), but the shared preamble and every section the
  file does contain must match. Returns `:ok`, `{:stale, path}`, or
  `{:error, reason}`.
  """
  def check(root \\ File.cwd!()) do
    with {:ok, fresh} <- render(root) do
      path = Path.join(root, @output)
      disk = if File.exists?(path), do: File.read!(path), else: ""

      if fresh == disk or lagging_but_consistent?(fresh, disk),
        do: :ok,
        else: {:stale, @output}
    end
  end

  @doc "True when `disk` is `fresh` minus some newest sections (pure)."
  def lagging_but_consistent?(fresh, disk) do
    disk_sections = from_first_section(disk)

    disk_sections != "" and
      preamble(fresh) == preamble(disk) and
      String.ends_with?(fresh, disk_sections)
  end

  defp from_first_section(doc) do
    case :binary.match(doc, "\n## ") do
      {pos, _} -> binary_part(doc, pos, byte_size(doc) - pos)
      :nomatch -> ""
    end
  end

  defp preamble(doc) do
    case :binary.match(doc, "\n## ") do
      {pos, _} -> binary_part(doc, 0, pos)
      :nomatch -> doc
    end
  end

  # --- git --------------------------------------------------------------------

  defp git(root, args) do
    case System.cmd("git", args, cd: root, stderr_to_stdout: true) do
      {out, 0} -> {:ok, out}
      {out, code} -> {:error, {:git, code, String.trim(out)}}
    end
  end
end
