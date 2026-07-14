defmodule Mix.Tasks.Brain.Id do
  @shortdoc "Mint stable ids (sb:xxxxxx) for bundle concepts that lack one"

  @moduledoc """
  Insert a freshly minted `id: sb:xxxxxx` as the first frontmatter line of every
  bundle concept that does not already carry one. Existing ids are never touched —
  ids are immutable for the life of a concept.

      mix brain.id
  """

  use Mix.Task

  alias ElixirMind.Registry

  @impl Mix.Task
  def run(_args) do
    root = File.cwd!()
    {entries, _errors} = Registry.scan(root)
    taken = entries |> Enum.map(& &1.id) |> Enum.reject(&is_nil/1) |> MapSet.new()

    {_taken, minted} =
      entries
      |> Enum.filter(&is_nil(&1.id))
      |> Enum.reduce({taken, []}, fn entry, {taken, minted} ->
        id = Registry.mint(taken)
        add_id!(Path.join(root, entry.path), id)
        {MapSet.put(taken, id), [{entry.path, id} | minted]}
      end)

    case minted do
      [] ->
        Mix.shell().info("All bundle concepts already carry a stable id.")

      minted ->
        Enum.each(minted, fn {path, id} -> Mix.shell().info("#{id}  #{path}") end)
        Mix.shell().info("Minted #{length(minted)} id(s). Now run `mix brain.registry`.")
    end
  end

  defp add_id!(path, id) do
    # Tolerate CRLF the same way the frontmatter parser does — insert the id
    # with the file's own line ending so nothing else changes.
    case File.read!(path) do
      "---\r\n" <> rest -> File.write!(path, "---\r\nid: #{id}\r\n" <> rest)
      "---\n" <> rest -> File.write!(path, "---\nid: #{id}\n" <> rest)
      _ -> Mix.raise("#{path}: cannot mint id — file has no frontmatter block")
    end
  end
end
