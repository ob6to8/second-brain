defmodule Mix.Tasks.Brain.Contract do
  @shortdoc "Compile CLAUDE.md from meta/preamble.md + meta/policy/*.md"

  @moduledoc """
  Compile the operating contract (`CLAUDE.md`) from its source documents.

      mix brain.contract          # render and write CLAUDE.md
      mix brain.contract --check  # verify CLAUDE.md is up to date (non-zero exit if stale)

  `CLAUDE.md` is a generated artifact — never hand-edit it. Edit the source policy
  documents under `meta/policy/` (or `meta/preamble.md`) and re-run this task.
  """

  use Mix.Task

  alias ElixirMind.Contract

  @impl Mix.Task
  def run(args) do
    {opts, _, _} = OptionParser.parse(args, strict: [check: :boolean])

    if opts[:check] do
      check()
    else
      write()
    end
  end

  defp write do
    path = Contract.write()
    Mix.shell().info("Compiled #{path} from #{ElixirMind.Policy.dir()}/*.md")
  end

  defp check do
    case Contract.check() do
      :ok ->
        Mix.shell().info("#{Contract.output_path()} is up to date.")

      {:stale, summary} ->
        Mix.shell().error("""
        #{Contract.output_path()} is STALE — regenerate with `mix brain.contract`.

        #{summary}
        """)

        exit({:shutdown, 1})
    end
  end
end
