defmodule Mix.Tasks.Brain.Verify do
  @shortdoc "Verify the bundle: conformance, stable ids, and verified_by evidence edges"

  @moduledoc """
  Run the machine checks over the knowledge bundle (see `SecondBrain.Verifier`):
  OKF conformance, stable-id presence/uniqueness/format, `verified_by` edge
  resolution, and grounding of every `verified: true`.

  On a green bundle, also prints advisory docs-freshness warnings (see
  `SecondBrain.Links`): internal links that don't resolve and index-coverage
  gaps. Warnings never fail the task — broken links are tolerated per OKF
  conformance, and index coverage is ultimately editorial.

      mix brain.verify
  """

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    case SecondBrain.Verifier.run() do
      :ok ->
        Mix.shell().info("Bundle verifies: ids, edges, and grounding all check out.")
        report_freshness_warnings()

      {:error, errors} ->
        Mix.shell().error("Bundle verification FAILED:\n\n" <> Enum.join(errors, "\n"))
        exit({:shutdown, 1})
    end
  end

  defp report_freshness_warnings do
    case SecondBrain.Links.check() do
      [] ->
        :ok

      warnings ->
        Mix.shell().info("\nDocs-freshness warnings (advisory — never fail this gate):")
        Enum.each(warnings, &Mix.shell().info("  [warn] " <> &1))
    end
  end
end
