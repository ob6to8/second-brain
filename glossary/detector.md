---
id: sb:0da4a3
type: concept
title: detector
description: A mechanical check that converts a rule violation or drift from a silent state into an announced signal (a failing gate or a printed warning), thereby creating the repair signal that probabilistic enforcement lacks.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, enforcement, tooling, ci]
timestamp: 2026-07-12
---

# detector

A mechanical check that converts a rule violation or drift from a silent state into an announced signal, thereby creating the *repair signal* that [probabilistic enforcement](/glossary/probabilistic-enforcement.md) lacks — a violation with a detector gets fixed once; a violation without one compounds. Detectors come in two strengths: **gates** (the signal is a failure — CI blocks the merge) and [warn passes](/glossary/warn-pass.md) (the signal is advisory — printed, never blocking). The recurring design move in this brain is shrinking the set of surfaces that rely on discipline by giving each [drift class](/glossary/drift-class.md) a detector; what remains detector-less (README prose accuracy, semantic duplication) is known and named rather than assumed covered.

*Seen in:* [docs-surface evaluation and the wiki question](/meta/analysis/docs-surface-evaluation-and-wiki-question.md), [the gate suite tutorial](/meta/tutorials/the-gate-suite-and-where-it-runs.md), [2026-07-12 docs-audit thread](/meta/threads/2026-07-12-docs-audit-wiki-verdict-and-freshness-warnings.md)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="sb:0da4a3">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-12-docs-audit-wiki-verdict-and-freshness-warnings (2026-07-12)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:0da4a3`]**  (co-feeds: `sb:e8c1a9 sb:e08db0 sb:1c53dc meta/analysis/comparison-with-the-2026-second-brain-field.md`)

**Your question — what field-comparison, and what prevents the drift:**

It's `/meta/analysis/comparison-with-the-2026-second-brain-field.md`, filed 2026-07-10 when you asked how this repo stacks up against the second-brain landscape (Obsidian/PARA systems, Karpathy-pattern Claude Code vaults, PKM products). Its central finding was that the whole field runs on *advisory* integrity — an LLM promising to follow CLAUDE.md prose — while this bundle converts rules into *structural* CI checks. It then modeled why advisory systems die past ~500 concepts, and two of its root causes are the prediction I was citing: **probabilistic enforcement** (rules living in prose have a roughly constant per-operation violation rate, and with no detector there's no repair signal, so errors compound) and **invisible degradation** (nothing distinguishes a healthy corpus from a rotting one until it visibly fails). Stage 3 of its failure chain — cross-reference drift — is exactly what the audit found in miniature: the enforced surfaces (contract, registry, route-tag logs) had *zero* drift, while every staleness hit sat on a surface no verifier watches — the README, two index entries, one example link.

**What can be done** is the same move the repo has made repeatedly: shrink the set of surfaces that rely on discipline by giving each one a detector. That's what the new warn pass does for the two drift classes the audit caught by hand — a stale link or an unlisted file now announces itself in every `mix brain.verify` run and in CI logs, instead of waiting for someone to notice. After this change, the remaining detector-less surfaces are, deliberately: README *prose accuracy* (no mechanical oracle exists; the mitigation was making it a thin pointer into enforced surfaces rather than a parallel description that can rot), frozen thread quotes (history, not drift, by design), and the one big semantic gap both analyses converge on — **intake dedup recall**, which no syntactic check can cover. That's the still-`proposed` dedup-recall-probe plan, and it remains the highest-leverage unshipped work in the repo.
