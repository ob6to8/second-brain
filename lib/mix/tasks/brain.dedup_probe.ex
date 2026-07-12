defmodule Mix.Tasks.Brain.DedupProbe do
  @shortdoc "Score intake dedup recall: the lexical backend vs the natural-phrasing gold set"

  @moduledoc """
  Measure how well the bundle's mechanical search layer finds the concept a new
  item should merge into, scored against the gold set in
  `meta/evals/dedup-probe.md`.

      mix brain.dedup_probe              # plain lexical recall
      mix brain.dedup_probe --expanded   # synonym-expanded recall (query + variants)

  Zero-dependency, fully offline, deterministic — makes no LLM calls. Prints a
  per-row table over the `target` rows, the aggregate recall, the reported-not-
  scored `negative`/`quarantine` rows, and the delta from the committed
  `## Baseline`. Non-gating: recall is an editorial trend metric (like the
  route-tags cross-check), so the task always exits 0 — read the trend, don't
  block on it.

  See the [dedup-recall-probe plan](/meta/plans/dedup-recall-probe.md) and
  `SecondBrain.DedupProbe`.
  """

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    {opts, _rest, _invalid} = OptionParser.parse(args, strict: [expanded: :boolean])
    Mix.shell().info(SecondBrain.DedupProbe.report(File.cwd!(), opts))
  end
end
