defmodule SecondBrain.Links do
  @moduledoc """
  Advisory docs-freshness checks: internal-link resolution and index coverage.

  Two warning families (never errors — `mix brain.verify` prints them but
  stays green; per OKF conformance broken links are tolerated, and index
  coverage is ultimately editorial):

    1. **Link resolution** — every internal markdown link (`](/abs/path)` or
       `](relative/path)`) in a live doc resolves to a file on disk.
    2. **Index coverage** — every directory holding `.md` docs has an
       `index.md`, and every non-reserved doc (and immediate subdirectory)
       is mentioned in it.

  Deliberately exempt, because their content is frozen or placeholder:

    * `meta/threads/` bodies (frozen verbatim by the capture policy — a broken
      link quoted there is history, not drift);
    * `## Thread excerpts — route-tagged log` sections anywhere (they quote
      frozen thread regions verbatim);
    * link targets containing `…` (ellipsis placeholders in examples) and
      external targets (`scheme://`, `mailto:`, pure `#anchor`s);
    * code spans and fenced code blocks (literal text, not rendered links);
    * reserved files (`index.md`, `log.md`, `README.md`, `CLAUDE.md`) from the
      must-be-listed requirement.

  Unlike `Registry.scan/1` this walks the governance namespaces too (`meta/`,
  `inbox/`) — index drift lives exactly where the id gates don't look.
  """

  @excluded_dirs ~w(.git .github .githooks .claude _build deps tmp lib test deprecated)
  @reserved_files ~w(index.md log.md README.md CLAUDE.md)
  @frozen_dirs ~w(meta/threads)
  @excerpt_heading "## Thread excerpts — route-tagged log"

  @doc "Run both warning families over the tree rooted at `root`."
  @spec check(String.t()) :: [String.t()]
  def check(root \\ File.cwd!()) do
    paths = doc_paths(root)
    link_warnings(paths, root) ++ index_warnings(paths, root)
  end

  @doc "All `.md` docs in scope (relative paths), sorted."
  def doc_paths(root) do
    root
    |> Path.join("**/*.md")
    |> Path.wildcard()
    |> Enum.map(&Path.relative_to(&1, root))
    |> Enum.reject(fn p -> hd(Path.split(p)) in @excluded_dirs end)
    |> Enum.sort()
  end

  # --- link resolution -------------------------------------------------------

  defp link_warnings(paths, root) do
    paths
    |> Enum.reject(&frozen?/1)
    |> Enum.flat_map(fn path ->
      root
      |> Path.join(path)
      |> File.read!()
      |> strip_excerpt_log()
      |> internal_targets()
      |> Enum.reject(&resolves?(&1, path, root))
      |> Enum.map(&"#{path}: link `#{&1}` does not resolve")
    end)
  end

  defp frozen?(path),
    do: Enum.any?(@frozen_dirs, &String.starts_with?(path, &1 <> "/"))

  # Drop every excerpt-log section: from its heading to the next `## ` or EOF.
  defp strip_excerpt_log(body) do
    body
    |> String.split("\n")
    |> Enum.reduce({[], :keep}, fn line, {acc, state} ->
      cond do
        String.trim(line) == @excerpt_heading -> {acc, :skip}
        state == :skip and String.starts_with?(line, "## ") -> {[line | acc], :keep}
        state == :skip -> {acc, :skip}
        true -> {[line | acc], :keep}
      end
    end)
    |> elem(0)
    |> Enum.reverse()
    |> Enum.join("\n")
  end

  defp internal_targets(body) do
    body = body |> String.replace(~r/```.*?```/s, "") |> String.replace(~r/`[^`\n]*`/, "")

    ~r/\]\(([^)\s]+)\)/
    |> Regex.scan(body)
    |> Enum.map(fn [_, target] -> target end)
    |> Enum.reject(fn t ->
      String.contains?(t, "://") or String.starts_with?(t, "mailto:") or
        String.starts_with?(t, "#") or String.contains?(t, "…")
    end)
  end

  defp resolves?(target, from_path, root) do
    target = target |> String.split("#") |> hd()

    rel =
      case target do
        "/" <> rest ->
          rest

        _ ->
          Path.join(Path.dirname(from_path), target) |> Path.expand("/") |> String.slice(1..-1//1)
      end

    File.exists?(Path.join(root, rel))
  end

  # --- index coverage --------------------------------------------------------

  defp index_warnings(paths, root) do
    by_dir = Enum.group_by(paths, &Path.dirname/1)

    Enum.flat_map(Enum.sort(by_dir), fn {dir, files} ->
      basenames = Enum.map(files, &Path.basename/1)

      if "index.md" in basenames do
        index_rel = join_dir(dir, "index.md")
        content = File.read!(Path.join(root, index_rel))

        unlisted_files(index_rel, content, basenames) ++
          unlisted_dirs(index_rel, content, dir, by_dir)
      else
        ["#{dir}: holds docs but has no index.md"]
      end
    end)
  end

  defp unlisted_files(index_rel, content, basenames) do
    basenames
    |> Enum.reject(&(&1 in @reserved_files))
    |> Enum.reject(&String.contains?(content, &1))
    |> Enum.map(&"#{index_rel}: #{&1} is filed here but not listed")
  end

  defp unlisted_dirs(index_rel, content, dir, by_dir) do
    by_dir
    |> Map.keys()
    |> Enum.filter(&(&1 != dir and Path.dirname(&1) == dir))
    |> Enum.map(&Path.basename/1)
    |> Enum.reject(&String.contains?(content, &1))
    |> Enum.map(&"#{index_rel}: subdirectory #{&1}/ is not listed")
  end

  defp join_dir(".", file), do: file
  defp join_dir(dir, file), do: dir <> "/" <> file
end
