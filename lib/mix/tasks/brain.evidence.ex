defmodule Mix.Tasks.Brain.Evidence do
  @shortdoc "Derive the verification narrative for a concept from its verified_by edges"

  @moduledoc """
  Render the evidence chain for a concept, derived live from frontmatter — the
  bundle commits only the `verified_by` edges; the prose is generated on demand.

      mix brain.evidence sb:4c9e1f
      mix brain.evidence SWE/version-control/git/some-concept
  """

  use Mix.Task

  alias SecondBrain.Registry

  @impl Mix.Task
  def run([ref]) do
    index = Registry.index!()

    entry =
      index[ref] || Enum.find(Map.values(index), &(&1.concept_id == ref)) ||
        Mix.raise("no concept found for #{inspect(ref)} (by id or concept path)")

    Mix.shell().info(render(entry, index))
  end

  def run(_), do: Mix.raise("usage: mix brain.evidence <sb:id | concept/path>")

  defp render(entry, index) do
    header = """
    # #{entry.title || entry.concept_id}
    id: #{entry.id}   type: #{entry.type}   verified: #{entry.verified}
    """

    case entry.verified_by do
      [] ->
        header <> "\nNo verified_by edges. " <> grounding_note(entry)

      refs ->
        sources =
          Enum.map_join(refs, "\n", fn ref ->
            case index[ref] do
              nil -> "  - #{ref} (UNRESOLVED)"
              src -> "  - #{ref} — #{src.title}\n    #{src.path}\n    resource: #{src.resource}"
            end
          end)

        header <> "\nSupported by:\n" <> sources
    end
  end

  # A concept that stores a link is a capture — trusted evidence, never itself a
  # verifiable statement (see meta/policy/verification-grounding.md). A resource
  # grounds nothing; only `verified_by` edges do.
  defp grounding_note(%{resource: nil}), do: "Not grounded."

  defp grounding_note(%{resource: res}),
    do: "Capture — stores resource: #{res} (trusted evidence, not a verifiable statement)."
end
