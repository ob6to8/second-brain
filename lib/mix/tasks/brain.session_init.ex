defmodule Mix.Tasks.Brain.SessionInit do
  @shortdoc "Print the session-init digest: open issues, todos, plans, dangling strands, top-3 priorities"

  @moduledoc """
  Render the open-work digest a fresh session should start from.

      mix brain.session_init

  Scans `meta/issues/` (status `open`), `meta/todos/` (status `open`),
  `meta/plans/` (status `proposed` / `accepted` / `in-progress`), and the
  `## Routing` ledgers under `meta/threads/` (rows in state `open`/`paused`,
  or with a dangling question), then prints a markdown digest ending in a heuristic top-3
  priority ranking. The SessionStart hook echoes this output into the
  session's context so every thread opens against the same picture of the
  brain's open work.
  """

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    Mix.shell().info(ElixirMind.SessionInit.report())
  end
end
