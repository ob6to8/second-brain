---
type: reference
title: "Dedup recall probe — gold set of natural-phrasing dedup queries"
description: The id-keyed gold set that mix brain.dedup_probe scores the bundle's lexical search layer against — natural-phrasing queries an intake agent would type when it doesn't remember a concept's exact wording, each mapped to the acceptable concept id(s) it should surface, with bands, synonym-expansion variants, and adjudication notes.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-12 — seeded from the 14 probes of the vector-DB recall analysis, re-adjudicated to sb: ids per the dedup-recall-probe plan"
tags: [meta, eval, dedup, recall, probe, intake, gold-set, search]
timestamp: 2026-07-12
attribution:
  when: 2026-07-12T09:50:13+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-12-dedup-recall-probe-and-synonym-intake.md]
---

# Dedup recall probe — gold set

This is the versioned gold set behind
[`mix brain.dedup_probe`](/lib/mix/tasks/brain.dedup_probe.ex) — the offline,
deterministic recall eval built by the
[dedup-recall-probe plan](/meta/plans/dedup-recall-probe.md). For the whole loop end
to end — and, in particular, **how to audit and re-evaluate it** — see the
[dedup recall probe flow doc](/meta/flows/dedup-recall-probe.md). It measures the one
intake gate CI can't otherwise cover: **can the mechanical search layer find the
concept a new item should merge into**, when the query is phrased the way a human —
or a future intake agent no longer holding the whole tree in context — would phrase
it from memory.

The rows are the 14 probes from the
[vector-DB recall analysis](/meta/analysis/vector-db-recall-for-the-scaling-bundle.md),
re-adjudicated to stable `sb:` ids. That analysis ran the probe **once, by hand**,
and found grep already misses ~6 of 14 natural-phrasing queries at 39 concepts — a
**semantic** miss (vocabulary mismatch), not a typo. This doc turns that one-shot
measurement into a repeatable instrument, so the miss rate is re-measured as the
corpus grows and becomes the quantified trigger for tier-2 embedding dedup.

## How the probe reads this doc

`SecondBrain.DedupProbe` parses the **`## Gold set`** table below. Each row:

| Column | Holds |
|--------|-------|
| **query** | the natural phrasing an agent would type — the thing under test |
| **acceptable ids** | one or more `sb:` ids; the row **hits** if the lexical backend surfaces *any* of them (query-relativity: several concepts can legitimately answer one phrasing) |
| **band** | the row's role — `target` (scored), `negative` (a non-duplicate pair, not scored in v1), `quarantine` (gold answer undefined until supersession exists; parsed, reported, never scored) |
| **variants** | `;`-separated synonym-expanded phrasings an intake agent would generate; `--expanded` mode hits if the query **or any variant** hits. Use `—` for none |
| **note** | the adjudication reasoning — why this id, why this band |

**Backend under test (v1):** case-insensitive substring match over each bundle
concept's title + description + tags + body. Scoring is surfaced-or-not, not ranked
(intake has no ranked backend yet); the report also prints each query's match-set
size — the noise / cluster-saturation signal. Ids survive renames; a concept
**merge** should flag the affected row here for human re-adjudication rather than
being mechanically rewritten.

## Gold set

| query | acceptable ids | band | variants | note |
|-------|----------------|------|----------|------|
| context pollution | sb:784985 | target | context poisoning; logical context poisoning; poisoned context | The hypothesized miss: the concept titles the failure "poisoning", never "pollution", so plain search returns unrelated files. Recovered by the "poisoning" variant. |
| lost in the middle | sb:77d68a | target | context rot; long-context degradation; positional degradation | Canonical synonym gap: "lost in the middle" and "context rot" share zero tokens. The variant "context rot" (the concept's own term) recovers it. |
| long context degradation | sb:77d68a | target | context rot; degrades over long context | Same target, a second natural phrasing; the "context rot" variant recovers it. |
| stale branch | sb:4c9e1f | target | auto-advance; local branch behind; branch didn't move on fetch | Concept is titled "…don't auto-advance on fetch"; the word "stale" never appears. The "auto-advance" variant recovers it. |
| branch not updating | sb:4c9e1f | target | auto-advance; fetch doesn't move the branch | Same target, a second phrasing; recovered by "auto-advance". |
| codebase graph | sb:b89ea1 | target | code knowledge graph; knowledge graph of the code | GitNexus says "code knowledge graph"; the transposed "codebase graph" misses. The exact-order variant recovers it. |
| inference margin | sb:07610c | target | inference gross margin; gross margin | The concept uses "inference gross margins"; the bare "inference margin" phrase lands only in the (excluded) index. The full-phrase variant recovers it. |
| MQA | sb:266c5e | target | multi-query attention | Acronym present verbatim in the KV-cache concept — a straightforward control hit. |
| reranking | sb:41be22 | target | re-ranking; rerank | Present verbatim in the RAG-pruning concept — a control hit. |
| context poisoning | sb:784985 | target | logical context poisoning | The concept's exact wording — a control hit, deliberately paired with the row-1 "pollution" miss to isolate vocabulary as the failure. |
| kv cache | sb:266c5e sb:1cac23 | negative | — | A non-duplicate pair: kv-cache-compression-history (survey of eviction/quantization) vs vericache-lossless-kv-cache (one lossless technique). They share heavy vocabulary but must **not** be judged duplicates. Seeded for the later duplicate-judgment tiers; not scored in v1. |
| context rot | sb:77d68a sb:c0961a | negative | — | Another non-duplicate pair: the context-rot capture vs effective-context-engineering-for-agents, which merely discusses the phenomenon. Overlapping vocabulary, distinct concepts. Not scored in v1. |
| lossless kv cache | sb:1cac23 | quarantine | — | Gold answer is time-relative: once supersession is modeled, a newer lossless-KV concept could supersede VeriCache and become the correct dedup target. Undefined until then (see the [epistemic overlay plan](/meta/plans/epistemic-overlay.md)); parsed and reported, never scored. |

## Baseline

**Generated, not hand-kept.** This table is rewritten by
`mix brain.dedup_probe --update-baseline` (which `/intake` runs), so the committed
figure stays current with zero manual upkeep and the recall **trend lives in this
doc's git history** — read it with `git log -p -- meta/evals/dedup-probe.md`.
`mix brain.dedup_probe` prints the current run's delta from these figures; the CI
report step is non-gating (recall is an editorial trend metric, like the route-tags
cross-check — warn and trend, don't fail).

| mode | hits | targets |
|------|------|---------|
| plain | 3 | 10 |
| expanded | 10 | 10 |

The gap — **plain 3/10 vs expanded 10/10** — is the offline, repeatable measurement
of how much recall the tier-1 `/intake` synonym-expansion change is expected to
recover: 7 of the 10 targets miss under plain lexical search but are recovered once
the agent generates the recorded variant phrasings. When the **plain** figure
degrades as concepts are added, that is the quantified trigger for tier-2 embedding
dedup — not a guessed size threshold.

## Upkeep — fully automated, no operator action

The gold set and its baseline are **agent-maintained at intake time**; the operator
never edits this doc or runs anything on a schedule. Every `/intake` run:

1. **Harvests a gold row** — if the intake carried a natural phrasing (the operator's
   own words for the material), the agent appends one `target` row here, keyed to the
   filed/merged concept's `sb:` id, using that **actual** phrasing (never a synthetic
   paraphrase, which would be systematically too easy). A bare-URL paste with no
   natural phrasing is skipped silently — the set only grows from real query language.
2. **Refreshes the baseline** — the agent runs `mix brain.dedup_probe --update-baseline`
   and commits the regenerated table alongside the concept.
3. **Escalates on regression** — if that run's **plain** recall has dropped below the
   prior baseline, the agent surfaces it to the operator. A sustained drop is the one
   decision that *is* the operator's: the trigger to adopt tier-2 embedding dedup (see
   the [plan](/meta/plans/dedup-recall-probe.md)). Absent a drop, nothing is surfaced.

Concept **merges** are the one case needing human eyes: a merge can change which id a
row should point at, so the agent flags affected rows for re-adjudication here rather
than rewriting them mechanically (ids are stable across renames, so renames need
nothing).

## Adjudication history

- **2026-07-12** — seeded from the vector-DB recall analysis's 14 probes,
  re-adjudicated to `sb:` ids. The analysis's combined "found" row
  (`MQA` / `reranking` / `context poisoning`) was split into three explicit control
  rows; two `negative` non-duplicate pairs and one `quarantine` row were added so the
  later embedding/judge tiers inherit them. First `## Baseline` recorded from a live
  `mix brain.dedup_probe` run.
