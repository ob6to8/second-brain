defmodule Mix.Tasks.Brain.RouteTags do
  @shortdoc "Verify route tags and the per-concept excerpt logs they materialize"

  @moduledoc """
  Verify the route-tagging layer (see `SecondBrain.RouteTags` and
  `meta/policy/route-tagging.md`): `<routes ref="...">` tag wellformedness, ref
  resolution, that every tagged concept sink carries its dated block, that each
  block matches its re-derivation from the current tags, and — at warn level —
  that every concept-routed routing-ledger row is covered by a tag.

      mix brain.route_tags              # verify; exits non-zero on any failure
      mix brain.route_tags --materialize  # (re)generate the log sections from tags, then verify

  Warnings never fail the task; only `:fail` results do.
  """

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    {opts, _rest, _invalid} = OptionParser.parse(args, strict: [materialize: :boolean])

    if opts[:materialize] do
      case SecondBrain.RouteTags.materialize() do
        [] ->
          Mix.shell().info("Route tags: no fed sinks; nothing to materialize.")

        paths ->
          Mix.shell().info(
            "Route tags: materialized log section(s) in:\n  " <> Enum.join(paths, "\n  ")
          )
      end
    end

    results = SecondBrain.RouteTags.run_checks()
    Enum.each(results, &report/1)

    if Enum.any?(results, fn {_, status, _} -> status == :fail end) do
      Mix.shell().error("\nRoute-tag verification FAILED.")
      exit({:shutdown, 1})
    else
      Mix.shell().info("\nRoute tags verify: tags, refs, sink logs, and fidelity all check out.")
    end
  end

  defp report({name, status, detail}) do
    marker =
      case status do
        :ok -> "ok  "
        :warn -> "warn"
        :fail -> "FAIL"
      end

    line = "  [#{marker}] #{name}: #{detail}"

    case status do
      :fail -> Mix.shell().error(line)
      _ -> Mix.shell().info(line)
    end
  end
end
