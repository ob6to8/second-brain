defmodule SecondBrain.Registry do
  @moduledoc """
  The stable-identity layer for the knowledge bundle.

  Every bundle concept carries an opaque, immutable `id` in its frontmatter
  (format `sb:` + 6 lowercase hex chars). The per-file `id` is the **canonical**
  data; `meta/registry.md` is a *compiled* id → path view (like `CLAUDE.md`),
  regenerated via `mix brain.registry`. References between concepts — e.g.
  `verified_by` — point at stable ids, so moving or renaming a file never
  breaks an edge: only the registry view changes.

  Scope: knowledge-bundle concepts only. Governance (`meta/`), skills
  (`.claude/`), tooling (`lib/`, `test/`), the archive (`deprecated/`), and
  reserved/root files (`index.md`, `log.md`, `README.md`, `CLAUDE.md`) are
  outside the registry.
  """

  alias SecondBrain.Frontmatter

  @id_format ~r/^sb:[0-9a-f]{6}$/
  @excluded_dirs ~w(.git .github .githooks .claude _build deps tmp lib test meta deprecated inbox)
  @excluded_files ~w(index.md log.md README.md CLAUDE.md)

  defmodule Entry do
    @moduledoc false
    @enforce_keys [:id, :concept_id, :path]
    defstruct [
      :id,
      :concept_id,
      :path,
      :type,
      :title,
      :verified,
      :resource,
      :sense,
      verified_by: []
    ]
  end

  @doc "Regex a valid stable id must match."
  def id_format, do: @id_format

  @doc "Mint a fresh stable id, guaranteed not to collide with `taken` (a MapSet)."
  def mint(taken \\ MapSet.new()) do
    id = "sb:" <> (:crypto.strong_rand_bytes(3) |> Base.encode16(case: :lower))
    if MapSet.member?(taken, id), do: mint(taken), else: id
  end

  @doc """
  Scan the bundle and return `{entries, errors}`. Entries are concepts that
  parsed cleanly (with or without an id); errors are human-readable strings
  for unparseable files and duplicate ids.
  """
  @spec scan(String.t()) :: {[Entry.t()], [String.t()]}
  def scan(root \\ File.cwd!()) do
    {entries, errors} =
      root
      |> concept_paths()
      |> Enum.map(&load_entry(&1, root))
      |> Enum.split_with(&match?(%Entry{}, &1))

    {entries, errors ++ duplicate_id_errors(entries)}
  end

  @doc "Return a map of id => Entry. Raises if the bundle has scan errors."
  @spec index!(String.t()) :: %{String.t() => Entry.t()}
  def index!(root \\ File.cwd!()) do
    case scan(root) do
      {entries, []} ->
        entries |> Enum.reject(&is_nil(&1.id)) |> Map.new(&{&1.id, &1})

      {_, errors} ->
        raise ArgumentError, "bundle has registry errors:\n" <> Enum.join(errors, "\n")
    end
  end

  @doc "All `.md` concept files in the bundle (relative paths), sorted."
  def concept_paths(root \\ File.cwd!()) do
    root
    |> Path.join("**/*.md")
    |> Path.wildcard()
    |> Enum.map(&Path.relative_to(&1, root))
    |> Enum.reject(&excluded?/1)
    |> Enum.sort()
  end

  defp excluded?(rel_path) do
    [top | _] = Path.split(rel_path)
    top in @excluded_dirs or Path.basename(rel_path) in @excluded_files
  end

  defp load_entry(rel_path, root) do
    case root |> Path.join(rel_path) |> File.read!() |> Frontmatter.parse() do
      {:ok, %{frontmatter: fm}} ->
        %Entry{
          id: fm["id"],
          concept_id: String.trim_trailing(rel_path, ".md"),
          path: rel_path,
          type: fm["type"],
          title: fm["title"],
          verified: fm["verified"],
          resource: fm["resource"],
          sense: fm["sense"],
          verified_by: List.wrap(fm["verified_by"])
        }

      {:error, reason} ->
        "#{rel_path}: unparseable frontmatter (#{inspect(reason)})"
    end
  end

  defp duplicate_id_errors(entries) do
    entries
    |> Enum.reject(&is_nil(&1.id))
    |> Enum.group_by(& &1.id)
    |> Enum.filter(fn {_id, group} -> length(group) > 1 end)
    |> Enum.map(fn {id, group} ->
      "duplicate id #{id}: " <> Enum.map_join(group, ", ", & &1.path)
    end)
  end

  # --- compiled registry view ----------------------------------------------

  @registry_output "meta/registry.md"

  @doc "Path of the compiled registry view, relative to repo root."
  def output_path, do: @registry_output

  @doc "Render the compiled id → path registry view."
  def render(root \\ File.cwd!()) do
    entries =
      root
      |> index!()
      |> Map.values()
      |> Enum.sort_by(& &1.concept_id)

    rows =
      Enum.map_join(entries, "\n", fn e ->
        "| `#{e.id}` | [#{e.concept_id}](/#{e.path}) | #{e.type} | #{e.verified} |"
      end)

    """
    <!--
      GENERATED FILE — do not edit by hand.
      Source of truth: the `id:` frontmatter of each bundle concept.
      Regenerate:      mix brain.registry
      Verify (CI):     mix brain.registry --check
    -->

    # Registry — stable id → concept

    Compiled view of the bundle's stable-identity layer. Ids are opaque and
    immutable; paths may change. Reference concepts by id (e.g. in `verified_by`).

    | id | concept | type | verified |
    |----|---------|------|----------|
    #{rows}
    """
  end

  @doc "Render and write the registry view. Returns the output path."
  def write(root \\ File.cwd!()) do
    path = Path.join(root, @registry_output)
    File.write!(path, render(root))
    path
  end

  @doc "Check the on-disk registry view matches a fresh render."
  def check(root \\ File.cwd!()) do
    path = Path.join(root, @registry_output)
    actual = if File.exists?(path), do: File.read!(path), else: ""
    if render(root) == actual, do: :ok, else: {:stale, @registry_output}
  end
end
