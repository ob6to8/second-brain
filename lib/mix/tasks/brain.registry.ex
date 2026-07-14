defmodule Mix.Tasks.Brain.Registry do
  @shortdoc "Compile meta/registry.md (stable id → concept) from bundle frontmatter"

  @moduledoc """
  Compile the registry view from the canonical per-file `id:` frontmatter.

      mix brain.registry          # render and write meta/registry.md
      mix brain.registry --check  # verify the view is current (non-zero exit if stale)
  """

  use Mix.Task

  alias ElixirMind.Registry

  @impl Mix.Task
  def run(args) do
    {opts, _, _} = OptionParser.parse(args, strict: [check: :boolean])

    if opts[:check] do
      case Registry.check() do
        :ok ->
          Mix.shell().info("#{Registry.output_path()} is up to date.")

        {:stale, path} ->
          Mix.shell().error("#{path} is STALE — regenerate with `mix brain.registry`.")
          exit({:shutdown, 1})
      end
    else
      path = Registry.write()
      Mix.shell().info("Compiled #{path} from bundle concept ids.")
    end
  end
end
