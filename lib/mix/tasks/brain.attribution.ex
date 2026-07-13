defmodule Mix.Tasks.Brain.Attribution do
  @shortdoc "Query the attribution layer; --backfill reconstructs missing events from git"

  @moduledoc """
  The attribution layer's command surface (see `SecondBrain.Attribution` and
  `meta/policy/resource-attribution.md`).

      mix brain.attribution --backfill

  One-shot reconstruction of `attribution` for docs that predate the policy
  (see `SecondBrain.Attribution.Backfill` for the derivation rules). Files
  already carrying the field are skipped; review the diff before committing.
  """

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    case args do
      ["--backfill"] ->
        {written, skipped} = SecondBrain.Attribution.Backfill.run()

        Mix.shell().info(
          "Backfilled attribution into #{length(written)} doc(s); " <>
            "#{length(skipped)} already carried it and were left untouched."
        )

      _ ->
        Mix.shell().error("usage: mix brain.attribution --backfill")
        exit({:shutdown, 1})
    end
  end
end
