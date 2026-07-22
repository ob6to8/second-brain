defmodule Mix.Tasks.Brain.Url do
  @shortdoc "Print the working URL for a bundle path (live Pages page, or branch blob until merged)"

  @moduledoc """
  Map a bundle path to a URL that **actually resolves right now**, so a link in a
  response is never dead.

      mix brain.url meta/doctrine/fit-each-layer-to-its-purpose.md
      mix brain.url /meta/policy/response-resource-links.md
      mix brain.url --pages meta/policy/response-resource-links.md   # force canonical Pages URL

  The mechanical form of the response-resource-links policy. Pages deploys **only
  from the default branch** (`pages.yml`), so a document created or modified on an
  unmerged branch has no live page yet — its Pages URL would 404 (new) or show
  stale content (modified) until the branch merges. This task resolves that
  automatically:

    * **Rendered and unchanged vs `origin/main`** → the live Pages URL
      (`ElixirMind.SiteConfig.live_url/1`) — canonical and current.
    * **New or modified on this branch, or under a non-rendered directory**
      (`deprecated/`, `.claude/`, `lib/`, `test/`, …) → the GitHub **blob URL** at
      the ref whose tree holds the current content (this branch, else `main`) —
      `ElixirMind.SiteConfig.blob_url/2`.

  `--pages` forces the canonical Pages URL regardless of branch state (use when
  citing something you know will be merged). When `origin/main` is unavailable
  (bare checkout with no remote) the task can't judge liveness and falls back to
  the blob URL at the current branch.
  """

  use Mix.Task

  alias ElixirMind.SiteConfig

  @impl Mix.Task
  def run(argv) do
    {opts, args} = OptionParser.parse!(argv, strict: [pages: :boolean])

    case args do
      [path | _] when is_binary(path) -> emit(path, opts)
      _ -> usage()
    end
  end

  defp emit(path, opts) do
    result = if opts[:pages], do: SiteConfig.live_url(path), else: resolve(path)
    print(result, path)
  end

  # Pick the URL that resolves AND shows the content being referred to.
  defp resolve(path) do
    rel = path |> to_string() |> String.trim_leading("/")

    cond do
      rel == "" -> {:error, :empty}
      live_and_current?(rel) -> SiteConfig.live_url(rel)
      true -> SiteConfig.blob_url(rel, content_ref(rel))
    end
  end

  # Live on the deployed site and identical to what's deployed: on origin/main and
  # not modified in the working tree.
  defp live_and_current?(rel), do: on_main?(rel) and not differs_from_main?(rel)

  # The ref whose tree holds the current content: main when it's there and
  # unchanged, otherwise the branch we're on.
  defp content_ref(rel) do
    if on_main?(rel) and not differs_from_main?(rel), do: "main", else: current_branch()
  end

  defp on_main?(rel), do: git(["cat-file", "-e", "origin/main:" <> rel]) == :ok

  defp differs_from_main?(rel), do: git(["diff", "--quiet", "origin/main", "--", rel]) != :ok

  defp current_branch do
    case System.cmd("git", ["rev-parse", "--abbrev-ref", "HEAD"], stderr_to_stdout: true) do
      {out, 0} -> String.trim(out)
      _ -> "main"
    end
  end

  defp git(args) do
    case System.cmd("git", args, stderr_to_stdout: true) do
      {_, 0} -> :ok
      _ -> :error
    end
  rescue
    ErlangError -> :error
  end

  defp print({:ok, url}, _path), do: Mix.shell().info(url)

  defp print({:error, :not_rendered}, path) do
    Mix.shell().error(
      "#{path}: not rendered to the site (excluded directory) — drop --pages to get its repo blob URL."
    )
  end

  defp print({:error, :no_repo}, path) do
    Mix.shell().error(
      "#{path}: repo_url is unconfigured (config/config.exs) — cannot build a blob URL."
    )
  end

  defp print({:error, :empty}, _path), do: usage()

  defp usage do
    Mix.shell().error("usage: mix brain.url [--pages] <bundle-path>")
    exit({:shutdown, 1})
  end
end
