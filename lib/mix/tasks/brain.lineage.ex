defmodule Mix.Tasks.Brain.Lineage do
  @shortdoc "Materialize flow-doc lineage blockquotes + the derived flowchart index"

  @moduledoc """
  Derive the flow-lineage views from each `meta/flows/*.md` `lineage:` frontmatter
  block: a per-doc blockquote (between `lineage:start`/`lineage:end` markers) and
  the cross-flow flowchart index at `meta/flows/lineage.md`.

      mix brain.lineage                # materialize blockquotes + write the index
      mix brain.lineage --materialize  # same (explicit)
      mix brain.lineage --check        # verify the views are current (non-zero exit if stale)
  """

  use Mix.Task

  alias ElixirMind.Lineage

  @impl Mix.Task
  def run(args) do
    {opts, _, _} = OptionParser.parse(args, strict: [check: :boolean, materialize: :boolean])

    if opts[:check] do
      case Lineage.check() do
        :ok ->
          Mix.shell().info("Flow lineage views are up to date.")

        {:stale, paths} ->
          Mix.shell().error(
            "Flow lineage views are STALE — regenerate with `mix brain.lineage`:\n  " <>
              Enum.join(paths, "\n  ")
          )

          exit({:shutdown, 1})
      end
    else
      case Lineage.write() do
        [] -> Mix.shell().info("Flow lineage views already current — nothing to write.")
        paths -> Mix.shell().info("Wrote flow lineage views:\n  " <> Enum.join(paths, "\n  "))
      end
    end
  end
end
