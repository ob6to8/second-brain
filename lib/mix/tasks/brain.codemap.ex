defmodule Mix.Tasks.Brain.Codemap do
  @shortdoc "Compile meta/code-map.md (module/function/type intent) from lib/ docstrings"

  @moduledoc """
  Compile the code map from the `@moduledoc`/`@doc`/`@typedoc` in each `lib/`
  module — the code glossary of the tooling that sits alongside the bundle.

      mix brain.codemap          # render and write meta/code-map.md
      mix brain.codemap --check  # verify the map is current (non-zero exit if stale)

  Docstrings are the source of truth; this file is generated, on the same
  `--check`-gated discipline as `mix brain.contract` and `mix brain.registry`.
  Never hand-edit `meta/code-map.md` — edit the module's docstrings and regenerate.
  """

  use Mix.Task

  alias ElixirMind.CodeMap

  @impl Mix.Task
  def run(args) do
    {opts, _, _} = OptionParser.parse(args, strict: [check: :boolean])

    if opts[:check] do
      case CodeMap.check() do
        :ok ->
          Mix.shell().info("#{CodeMap.output_path()} is up to date.")

        {:stale, path} ->
          Mix.shell().error("#{path} is STALE — regenerate with `mix brain.codemap`.")
          exit({:shutdown, 1})
      end
    else
      path = CodeMap.write()
      Mix.shell().info("Compiled #{path} from lib/ docstrings.")
    end
  end
end
