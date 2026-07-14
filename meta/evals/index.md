# evals

Eval gold sets and their baselines — the **repeatable instruments** that measure the
brain's corpus-maintenance behavior against constructed ground truth, filed so a
measurement can be re-run as the corpus grows rather than done once by hand. A
separate genre from [`analysis`](/meta/analysis/index.md) (a *point-in-time* judgment
on a question): an eval is a fixture the tooling re-scores on every run.

Each gold set is a prose-bearing markdown doc whose table a `mix brain.*` task parses;
governance namespace (no `em:` id, like plans and threads).

## Contents

- [Dedup recall probe](/meta/evals/dedup-probe.md) — the id-keyed gold set of
  natural-phrasing dedup queries scored by
  [`mix brain.dedup_probe`](/lib/mix/tasks/brain.dedup_probe.ex): can the mechanical
  search layer find the concept a new item should merge into? Seeded from the vector-DB
  recall analysis's 14 probes; carries `target`/`negative`/`quarantine` bands, synonym
  variants for `--expanded` mode, and a committed baseline.
