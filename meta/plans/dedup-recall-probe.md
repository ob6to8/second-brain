---
type: plan
title: "Dedup recall probe: a gold set of natural-phrasing queries and a mix task that measures intake dedup recall"
description: Build mix brain.dedup_probe — a zero-dependency, offline, deterministic eval that scores the bundle's lexical search layer against an id-keyed gold set of natural-phrasing dedup queries — as the quantified trigger for tier-2 embedding dedup and the substrate for all later corpus-maintenance evals.
status: done
provenance: "Claude Code session (Claude Fable), 2026-07-10 — commissioned by the operator following the eval-suitability analysis; executes recommendation 1 of the vector-DB recall analysis"
tags: [meta, plan, evals, dedup, recall, probe, intake, tooling]
timestamp: 2026-07-12
attribution:
  when: 2026-07-10T19:11:24+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-10-field-comparison-evals-and-cb-overlay-execution-path.md]
---

# Dedup recall probe: gold set + `mix brain.dedup_probe`

## Status & provenance

**Done** (2026-07-12). All build-order steps 1–6 shipped on branch
`claude/dedup-recall-probe-qyvt7w`.

**The instrument (steps 1–4, 6):**

- `meta/evals/` genre + [`meta/evals/dedup-probe.md`](/meta/evals/dedup-probe.md) —
  the gold set, seeded from the vector-DB analysis's 14 probes, re-keyed to `em:`
  ids, with `target`/`negative`/`quarantine` bands and synonym-expansion variants.
- [`ElixirMind.DedupProbe`](/lib/elixir_mind/dedup_probe.ex) +
  [`mix brain.dedup_probe`](/lib/mix/tasks/brain.dedup_probe.ex) — parser, lexical
  backend, scorer, plain + `--expanded` modes, baseline delta, and
  `--update-baseline` (the baseline is generated, not hand-kept); pinned by
  [`test/elixir_mind/dedup_probe_test.exs`](/test/elixir_mind/dedup_probe_test.exs).
- First `## Baseline`: **plain 3/10, expanded 10/10** — the offline measurement of
  the recall the tier-1 synonym-expansion change recovers. Non-gating CI report step.

**The tier-1 fix + harvest (step 5):**

- [`/intake`](/.claude/skills/intake/SKILL.md) step 3 now requires **synonym-expanded
  dedup search** (3–5 alternate phrasings), and a new step 8 **automatically harvests
  a gold row** from the operator's own phrasing and refreshes the baseline via
  `--update-baseline`, escalating only on a plain-recall regression. Mirrored in the
  [intake flow doc](/meta/flows/intake.md) per the no-drift rule.

**Open questions — resolved by the operator (2026-07-12):**

- **Q1 (ratify `meta/evals/`):** yes — the genre stands.
- **Q2 (gold-harvest default):** **automatic on every intake**, agent-run, using the
  operator's *actual* phrasing (skip silently when there's none). The operator does
  nothing; "opt-out" is moot because there is no operator step to opt out of.
- **Q3 (baseline cadence):** the baseline is a **generated** figure refreshed by
  `mix brain.dedup_probe --update-baseline` during intake; the trend lives in the gold
  doc's **git history** (consistent with the no-hand-kept-logs rule). The operator
  never edits it or runs anything on a schedule; the agent surfaces recall **only when
  it regresses** — the sole operator decision (whether to fire tier-2 embedding dedup).

Originally commissioned by the operator on 2026-07-10, immediately after the
[eval-suitability analysis](/meta/analysis/eval-suitability-of-the-corpus-maintenance-failure-space.md)
identified this as the smallest eval guarding the known unguarded gate. It executes
recommendation 1 of the
[vector-DB recall analysis](/meta/analysis/vector-db-recall-for-the-scaling-bundle.md)
("ship the synonym-expansion dedup change to `/intake` + a recall-probe eval now —
both zero-dependency") and encodes the gold-set properties the eval-suitability
analysis derived from the seven sources of ground-truth fuzziness.

## Problem

Intake dedup — finding the existing concept a new item should merge into — is the
entry gate of the 500+ failure chain
([field-comparison analysis](/meta/analysis/comparison-with-the-2026-second-brain-field.md),
stage 2), and it is guarded today by lossy lexical search plus an LLM-in-context
subsidy that expires as the corpus outgrows agent context. The vector-DB analysis
*measured* the loss: ~6 of 14 natural-phrasing queries missed their existing target
at 39 concepts. But that probe was run by hand, once. Nothing re-measures it as the
corpus grows, so the quantified trigger it proposed ("when recall drops, *that* is
the signal for tier-2 embedding dedup") has no instrument. This plan builds the
instrument.

## Decisions

1. **Name and shape: `mix brain.dedup_probe`,** beside the other `brain.*` tasks.
   Zero dependencies, fully offline, deterministic — the probe must run in CI and
   any sandbox, so it measures the *mechanical* search layer only. No LLM calls at
   probe time (agent-in-the-loop measurement is deferred; see scope boundaries).
2. **The gold set is a markdown document, not a data file:**
   `meta/evals/dedup-probe.md` — a prose-bearing, versioned doc in the governance
   namespace (no `em:` id, like plans and threads), whose table the task parses.
   Markdown-as-substrate matches the rest of the bundle, and the eval-suitability
   analysis requires the gold set to carry adjudication notes and its own
   provenance — a bare data file can't.
   **This creates a new `meta/evals/` directory; accepting this plan ratifies it.**
3. **Rows are id-keyed with acceptable-id *sets*.** Each row:
   `| query | acceptable ids | band | note |` where *acceptable ids* is one or more
   `em:` ids (query-relativity: several concepts can legitimately answer one
   phrasing), *band* labels the row's role (see 4), and *note* records the
   adjudication reasoning. Ids survive renames; concept **merges** flag the row for
   human re-adjudication rather than mechanical rewriting.
4. **Bands encode the fuzzy edges instead of pretending they're not there:**
   - `target` — a straightforward should-surface row (the 14 seed probes).
   - `negative` — a labeled type-aware negative: a pair that shares content but
     must *not* be judged duplicate (e.g. a `reference` capture vs the `concept`
     distilled from it). v1 scoring ignores these (lexical search has no duplicate
     judgment to test); they are seeded now so the later embedding/judge tiers
     inherit them.
   - `quarantine` — cases whose gold answer is undefined until supersession exists
     (time-relativity; see the [epistemic overlay plan](/meta/plans/epistemic-overlay.md)).
     Parsed, reported, never scored.
5. **Scoring v1 is surfaced-or-not, not ranked.** The backend under test is what
   intake actually has: case-insensitive lexical match over concept titles,
   descriptions, tags, and bodies. A row **hits** if any acceptable id's file
   appears in the match set; the report also shows match-set size per query (the
   noise/cluster-saturation signal the vector-DB analysis identified). Aggregate =
   hit fraction over `target` rows. Ranked recall@k is deferred until a ranked
   backend exists — inventing a ranking just to score it would measure nothing real.
6. **An `--expanded` mode approximates synonym-expanded dedup deterministically.**
   Rows may carry recorded variant phrasings (the expansions an intake agent would
   generate). In `--expanded` mode a row hits if *any* variant hits. The gap between
   plain and expanded scores measures, offline and repeatably, how much of the
   recall loss the tier-1 `/intake` synonym-expansion change recovers — without an
   LLM at probe time.
7. **Harvest gold pairs at intake, don't synthesize them.** Synthetic paraphrases
   share their generator's vocabulary and are systematically too easy
   (eval-suitability analysis, fuzz source 7). The true query distribution is the
   operator's own phrasing at the moment of intake — so the `/intake` skill gains a
   final optional step: append a gold row using the operator's *actual submitted
   phrasing* as the query and the filed/merged concept's id as the target. The
   intake moment is the gold-harvest moment; the set then grows with the corpus at
   zero synthetic cost.
8. **CI runs the probe and warns; it does not gate.** Recall is an editorial
   trend metric, not a boolean invariant — precedent: the route-tags ledger
   cross-check warns, never fails. The report prints per-row results, the aggregate,
   and the delta from the last committed baseline (a `## Baseline` section in the
   gold doc, updated deliberately). A hard floor gate is deferred until a baseline
   history exists to set one honestly.
9. **The probe is the tier-2 trigger.** Per the vector-DB analysis: when the
   plain-mode aggregate degrades as concepts are added — not at a guessed size
   threshold — that is the quantified signal to adopt intake-time embedding dedup
   (cached vectors, brute-force cosine, still no vector DB).

## Artifact shape

- `meta/evals/index.md` — the new directory's index (genre: eval gold sets and
  their baselines; distinct from `analysis` — an eval is a *repeatable instrument*,
  an analysis is a *point-in-time judgment*).
- `meta/evals/dedup-probe.md` — purpose prose; the gold table (seeded with the 14
  probes from the vector-DB analysis, re-keyed to `em:` ids); a `## Baseline`
  section; adjudication history notes.
- `lib/mix/tasks/brain.dedup_probe.ex` — thin task wrapper, matching the existing
  pattern.
- `lib/elixir_mind/dedup_probe.ex` — parse gold doc, run backend, score, render
  report; pure core so the scenario test can pin it.
- `test/elixir_mind/dedup_probe_test.exs` — fixture gold doc + fixture corpus;
  asserts parsing, hit/miss logic, band handling (negatives ignored, quarantine
  reported-not-scored), `--expanded` semantics, and baseline-delta rendering.
- One line in `.github/workflows/ci.yml` (non-gating report step) and a
  `/intake` skill edit adding the gold-harvest step (with its mirror in the
  [intake flow doc](/meta/flows/intake.md), per the no-drift rule).

## Build order

1. `meta/evals/` + gold doc seeded from the vector-DB analysis's 14 probes
   (re-adjudicated: acceptable-id sets, bands, notes).
2. Parser + scorer + task + tests. Plain mode first.
3. Record the first `## Baseline` from a live run; add the CI report step.
4. `--expanded` mode + record expansion variants for the seed rows.
5. The tier-1 `/intake` synonym-expansion dedup change (from the vector-DB
   analysis) + the gold-harvest step, landing together with their flow-doc mirror.
6. Run the probe before/after step 5 and record both baselines — the first real
   measurement the harness produces.

## Scope boundaries (deliberate exclusions)

- **No LLM at probe time.** The offline invariant (`deps: []`, runs in any sandbox)
  outranks fidelity to live agent behavior. Agent-in-the-loop dedup measurement is
  a scenario-test-style extension, deferred.
- **No embeddings in this plan.** Tier 2 (cached embedding dedup) has its own
  trigger — this probe's degradation — and should get its own plan when fired.
- **No ranked recall@k until a ranked backend exists.**
- **No CI gate in v1.** Warn and trend first; gate when a baseline history makes a
  floor honest.
- **The other evals** from the eval-suitability analysis (fan-out completeness,
  filing consistency, capacity curves, longitudinal corpus-health) are out of
  scope; this probe's gold-set format and task skeleton are deliberately the
  substrate they will reuse.

## Open questions — resolved

All three were answered by the operator on 2026-07-12 (see the Status section for the
decisions and their rationale); kept here for the record.

1. **Ratify `meta/evals/` as a genre** → **yes.**
2. **Gold-harvest default** → **automatic on every intake**, agent-run, on the
   operator's actual phrasing (skip when there's none). No operator step.
3. **Baseline cadence** → **generated** via `--update-baseline` at intake; trend in
   git history; the agent escalates only on regression. No manual upkeep.
