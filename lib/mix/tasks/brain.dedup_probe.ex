defmodule Mix.Tasks.Brain.DedupProbe do
  @shortdoc "Score intake dedup recall: the lexical backend vs the natural-phrasing gold set"

  @moduledoc """
  Measure how well the bundle's mechanical search layer finds the concept a new
  item should merge into, scored against the gold set in
  `meta/evals/dedup-probe.md`.

      mix brain.dedup_probe                    # plain lexical recall
      mix brain.dedup_probe --expanded         # synonym-expanded recall (query + variants)
      mix brain.dedup_probe --update-baseline  # rewrite the committed ## Baseline, then report

  Zero-dependency, fully offline, deterministic — makes no LLM calls. Prints a
  per-row table over the `target` rows, the aggregate recall, the reported-not-
  scored `negative`/`quarantine` rows, and the delta from the committed
  `## Baseline`. Non-gating: recall is an editorial trend metric (like the
  route-tags cross-check), so the task always exits 0 — read the trend, don't
  block on it.

  `--update-baseline` regenerates the gold doc's `## Baseline` table from a fresh
  run (the baseline is generated, not hand-kept); the `/intake` skill runs it so
  the recall figure and its git-history trend stay current with zero manual
  upkeep.

  See the [dedup-recall-probe plan](/meta/plans/dedup-recall-probe.md) and
  `ElixirMind.DedupProbe`.
  """

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    {opts, _rest, _invalid} =
      OptionParser.parse(args, strict: [expanded: :boolean, update_baseline: :boolean])

    if opts[:update_baseline] do
      path = ElixirMind.DedupProbe.update_baseline(File.cwd!())
      Mix.shell().info("Refreshed baseline in #{Path.relative_to_cwd(path)}.\n")
    end

    Mix.shell().info(ElixirMind.DedupProbe.report(File.cwd!(), Keyword.take(opts, [:expanded])))
  end
end
