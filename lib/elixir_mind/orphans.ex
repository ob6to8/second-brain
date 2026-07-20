defmodule ElixirMind.Orphans do
  @moduledoc """
  Find docs with **no inbound internal link** — filed but never referenced from
  another doc's prose.

  An *inbound link* is an internal markdown link in some other doc that resolves
  to the candidate (extraction and normalization are reused from
  `ElixirMind.Links`, so this can't drift from the link-resolution check).

  Two scoping decisions make the default output meaningful rather than noisy:

    * **`index.md` links don't count** by default. Every filed doc is listed in
      its directory's `index.md`, so counting those listings as inbound links
      would mask every real orphan. Pass `include_index: true` to count them.
    * **Anchored-by-design namespaces are not candidates** by default:
      `meta/threads/` (anchored by `pr:`) and `inbox/` (dated digests) are
      unreferenced on purpose, not orphaned. Pass `all: true` to include them.

  A doc that links *out* but has nothing linking *in* is still an orphan — only
  inbound edges matter here.
  """

  alias ElixirMind.Links

  @reserved ~w(index.md log.md README.md CLAUDE.md)
  @anchored_dirs ~w(meta/threads inbox)

  @doc """
  Repo-relative paths (sorted) of candidate docs with no inbound link.

  Options:

    * `:include_index` (default `false`) — count links inside `index.md`
      listings as inbound edges.
    * `:all` (default `false`) — keep anchored-by-design namespaces
      (`meta/threads/`, `inbox/`) as orphan candidates.
  """
  @spec find(String.t(), keyword()) :: [String.t()]
  def find(root \\ File.cwd!(), opts \\ []) do
    include_index = Keyword.get(opts, :include_index, false)
    all = Keyword.get(opts, :all, false)

    docs = Links.doc_paths(root)

    linked =
      docs
      |> reject_index_sources(include_index)
      |> Enum.flat_map(fn from ->
        root
        |> Path.join(from)
        |> File.read!()
        |> Links.internal_targets()
        |> Enum.map(&Links.resolve_target(&1, from))
      end)
      |> MapSet.new()

    docs
    |> Enum.reject(&(Path.basename(&1) in @reserved))
    |> reject_anchored(all)
    |> Enum.reject(&MapSet.member?(linked, &1))
    |> Enum.sort()
  end

  defp reject_index_sources(paths, true), do: paths

  defp reject_index_sources(paths, false),
    do: Enum.reject(paths, &(Path.basename(&1) == "index.md"))

  defp reject_anchored(paths, true), do: paths

  defp reject_anchored(paths, false) do
    Enum.reject(paths, fn p ->
      Enum.any?(@anchored_dirs, &String.starts_with?(p, &1 <> "/"))
    end)
  end
end
