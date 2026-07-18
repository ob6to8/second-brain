---
type: plan
title: "Auto-intake escape-rate sampling: measure the quality of what /research files"
description: Build mix brain.escape_rate — a zero-dependency, offline eval that measures the defect-escape rate of /research auto-intake by treating the operator's post-intake editorial edits (recovered from git history, keyed on channel:auto-intake) as the ground-truth oracle, reporting reviewed-escape-rate alongside an explicit unreviewed-coverage fraction so silence is never counted as success.
status: proposed
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-17 — the parked follow-up strand of the tier-3/4 interface-and-trust analysis"
tags: [meta, plan, evals, escape-rate, auto-intake, trust, verification, tooling]
timestamp: 2026-07-17
attribution:
  when: 2026-07-17T18:50:00Z
  channel: agent-authored
  agent: "Claude Code session, tier-3/4 trust analysis follow-up"
  why: "operator asked to file the parked follow-up: instrument /research auto-intake escape-rate sampling, the trust experiment the gate suite is built to support"
  from: [/meta/threads/2026-07-17-escape-rate-plan-and-genserver-agent-minds.md]
---

# Auto-intake escape-rate sampling: measure the quality of what `/research` files

## Motivation

The [tier-3/4 interface-and-trust analysis](/meta/analysis/tier-3-4-interface-and-trust-determination.md)
established that reaching supervised autonomy is a **measured** property — a low,
stable, *sampled* [escape rate](/beliefs/glossary/escape-rate.md) against an
independent [test oracle](/beliefs/glossary/test-oracle.md) that stays flat as
supervision is withdrawn — never a declared milestone. The brain already has the
oracle-independence and detectability halves of that story built in (a deterministic
[gate suite](/beliefs/glossary/gate-suite.md), full provenance). What it lacks is the
**measurement itself**: nothing computes how often `/research`
[auto-intake](/beliefs/glossary/auto-intake.md) files something a competent operator
would not have filed as-is. Without that number, "the loop looks autonomous" cannot
become "the loop is demonstrably trusted." This plan builds the missing instrument.

It is the **precision-side complement** to the
[dedup recall probe](/meta/plans/dedup-recall-probe.md): that eval measures the entry
gate's *recall* (does dedup find the existing doc?); this one measures the *quality of
what got filed* — the semantic escapes the deterministic gates structurally cannot see.

## What counts as an escape

The deterministic gates already reject **structural** escapes (unparseable
frontmatter, id/edge integrity, broken invariants). The escape rate targets the
**semantic** residue an auto-intake can produce while passing every gate:

1. **Misfiled** — filed under the wrong taxonomy node.
2. **Should-have-merged** — a near-duplicate created as a new doc instead of
   updating in place (the precision complement to the dedup probe's recall).
3. **Dump-not-distill** — raw content parked rather than distilled.
4. **Wrong type** — mis-picked from the controlled vocabulary.
5. **Off-taxonomy / low-value** — an item that should not have been filed at all
   (the bounded-to-known-tree rule violated, or simply not worth a document).
6. **Bad distillation** — factual drift or hallucinated summary vs. the `resource`.

## The oracle already exists — and its cost is near zero

The key design insight: the independent oracle is **already in the workflow**.
`channel: auto-intake` explicitly hands each filed doc to "the operator's post-intake
editorial pass" (auto-intake policy). So the operator's **edits, moves, retypes, and
deletions** of an auto-intaken doc — recovered from git history, keyed on the
`channel: auto-intake` [attribution](/beliefs/glossary/attribution.md) and the intake
commit — *are* the ground-truth escape signal. The measurement piggybacks on work the
operator already does; no new labeling burden. That is the cheapest possible oracle
and the reason this eval is tractable at all.

**Silence is not success.** An operator-untouched doc is **unreviewed**, not
**accepted** — counting it as correct would reproduce the exact tier-3 trap the
analysis names (unmeasured trust). The metric therefore reports two numbers, never one:

- **reviewed-escape-rate** = escaped / reviewed (docs the operator actually touched
  or a sampled reviewer scored), and
- **coverage** = reviewed / total auto-intaken — the unreviewed fraction stated
  explicitly, so a low-coverage measurement reads as weak evidence, not a clean bill.

This mirrors the analysis's "sampling rate never zero" and the harness rule that
silence must not look like the happy path.

## Artifact shape

- A `meta/evals/escape-rate.md` doc (the [`meta/evals/`](/meta/evals/index.md) genre
  already exists) holding the escape taxonomy above, the disposition model, and a
  generated `## Baseline` (committed like the dedup probe's; the trend lives in git
  history).
- `ElixirMind.EscapeRate` + `mix brain.escape_rate` — zero-dep, offline, sibling of
  [`mix brain.dedup_probe`](/lib/mix/tasks/brain.dedup_probe.ex): enumerate the
  `channel: auto-intake` docs from attribution, walk each one's git history for a
  post-intake **disposition** (`accepted` · `edited` · `moved` · `retyped` ·
  `deleted`), classify escapes where the diff shape allows, compute
  reviewed-escape-rate + coverage, and support `--update-baseline`. Pinned by an
  ExUnit test.
- A **non-gating CI report step**, exactly like the dedup probe — a report first, a
  gate only once a baseline is trusted (see open questions).

## Build order

1. **Escape taxonomy + disposition model** — write `meta/evals/escape-rate.md`; define
   the git-derived signal (first operator touch on a `channel: auto-intake` doc within
   a window) and the severity line separating an escape from mere polish.
2. **`mix brain.escape_rate`** — the parser, git-history disposition walker, scorer
   (reviewed-escape-rate + coverage), `--update-baseline`, tests, and the CI report
   step. First baseline recorded.

## Deferred

- **Sampled independent-model review of the unreviewed fraction.** A different-model
  reviewer scores a sample of operator-untouched auto-intaken docs against their
  `resource`, moving coverage from operator-only toward full — the model-assisted
  oracle that catches escapes the operator never got to. Deferred because the
  operator-as-oracle signal is free and should be measured first.
- **Escape classification rollup** — which class dominates — to direct fixes back into
  `/research` and `/intake` (e.g. a spike in should-have-merged escapes is a dedup-gate
  signal, not an intake-prose one).
- **A warn gate and `/priorities` wiring** — surface the rate once a baseline exists
  and is trusted; never gate on an untrusted number.

## Open questions (for ratification)

- **Edit window** — how long after the intake commit does an operator edit count as an
  escape signal versus unrelated later refinement? (First operator touch, or N days?)
- **Refinement vs. escape** — light copyedits are not escapes; moves, retypes, merges,
  and deletions are. Where exactly is the severity line, and can git-diff heuristics
  draw it or does it need manual classification?
- **Should-have-merged home** — measure the duplicate-creation class here, or extend
  the dedup probe with a precision mode? (They share the same failure.)
- **Report-only vs. gating** — stay a pure report indefinitely (like the dedup probe),
  or graduate to a warn gate once trusted? Proposal: report-only first.

## Doctrine

Serves *measured trust before scaled autonomy* — the direction the tier-3/4 analysis
argues. This eval is the concrete trust experiment the gate suite is already built to
support: it is what would let the operator withdraw a unit of supervision from
auto-intake and *see* whether the escape rate stays flat.
