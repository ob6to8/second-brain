defmodule Mix.Tasks.Brain.DevHistory do
  @shortdoc "Derive meta/dev-history.md (per-PR progress) from the merge graph"

  @moduledoc """
  Compile the dev-history view from the default branch's first-parent git
  history — one section per merged PR, bulleted with the branch's commit
  subjects. There is no hand-kept source: the commit graph is the data.

      mix brain.dev_history          # derive and write meta/dev-history.md
      mix brain.dev_history --check  # verify the view is consistent (lag-tolerant;
                                     # non-zero exit if hand-edited or diverged)

  On a shallow clone the derivation would silently truncate, so `--check`
  passes with a note and a plain run refuses to write.
  """

  use Mix.Task

  alias SecondBrain.DevHistory

  @impl Mix.Task
  def run(args) do
    {opts, _, _} = OptionParser.parse(args, strict: [check: :boolean])

    cond do
      DevHistory.shallow?() and opts[:check] ->
        Mix.shell().info("shallow clone — dev-history check skipped (full history unavailable).")

      DevHistory.shallow?() ->
        Mix.shell().error("shallow clone — refusing to derive a truncated dev history.")
        exit({:shutdown, 1})

      opts[:check] ->
        case DevHistory.check() do
          :ok ->
            Mix.shell().info("#{DevHistory.output_path()} is consistent with the merge graph.")

          {:stale, path} ->
            Mix.shell().error(
              "#{path} DIVERGES from the merge graph — regenerate with `mix brain.dev_history`."
            )

            exit({:shutdown, 1})

          {:error, reason} ->
            Mix.shell().error("dev-history derivation failed: #{inspect(reason)}")
            exit({:shutdown, 1})
        end

      true ->
        case DevHistory.write() do
          {:ok, path} ->
            Mix.shell().info("Derived #{path} from the default branch's merge graph.")

          {:error, reason} ->
            Mix.shell().error("dev-history derivation failed: #{inspect(reason)}")
            exit({:shutdown, 1})
        end
    end
  end
end
