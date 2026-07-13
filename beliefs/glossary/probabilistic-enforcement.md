---
id: sb:e8c1a9
type: concept
title: probabilistic enforcement
description: An integrity model in which rules live as prose an agent promises to follow, so each operation has a roughly constant chance of violating them — meaning violations scale with operation count and, absent a detector, compound silently.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, enforcement, failure-modes, governance]
sense: common
timestamp: 2026-07-12
attribution:
  when: 2026-07-12T09:43:37+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# probabilistic enforcement

An integrity model in which the rules live as prose (a `CLAUDE.md` convention, a style guide) and are followed only as reliably as the agent or human executing them — giving every operation a roughly constant probability of violation. Because operation count scales with the corpus while the per-operation rate stays flat, total violations grow with scale, and without a [detector](/beliefs/glossary/detector.md) there is no repair signal, so errors compound into [invisible degradation](/beliefs/glossary/invisible-degradation.md). The contrast is *structural* enforcement — converting the rule into a machine check (a CI gate, a compiled artifact with `--check`) whose violation is an announced failure rather than a silent state. The 2026 second-brain field survey found probabilistic ("advisory") enforcement to be the near-universal norm, and names it root cause (a) of the 500+ concept failure chain.

*Seen in:* [comparison with the 2026 second-brain field](/meta/analysis/comparison-with-the-2026-second-brain-field.md), [docs-surface evaluation and the wiki question](/meta/analysis/docs-surface-evaluation-and-wiki-question.md), [2026-07-12 docs-audit thread](/meta/threads/2026-07-12-docs-audit-wiki-verdict-and-freshness-warnings.md)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="sb:e8c1a9">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-12-docs-audit-wiki-verdict-and-freshness-warnings (2026-07-12)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:e8c1a9`]**  (co-feeds: `sb:e08db0 sb:1c53dc sb:0da4a3 meta/analysis/comparison-with-the-2026-second-brain-field.md`)

**Your question — what field-comparison, and what prevents the drift:**

It's `/meta/analysis/comparison-with-the-2026-second-brain-field.md`, filed 2026-07-10 when you asked how this repo stacks up against the second-brain landscape (Obsidian/PARA systems, Karpathy-pattern Claude Code vaults, PKM products). Its central finding was that the whole field runs on *advisory* integrity — an LLM promising to follow CLAUDE.md prose — while this bundle converts rules into *structural* CI checks. It then modeled why advisory systems die past ~500 concepts, and two of its root causes are the prediction I was citing: **probabilistic enforcement** (rules living in prose have a roughly constant per-operation violation rate, and with no detector there's no repair signal, so errors compound) and **invisible degradation** (nothing distinguishes a healthy corpus from a rotting one until it visibly fails). Stage 3 of its failure chain — cross-reference drift — is exactly what the audit found in miniature: the enforced surfaces (contract, registry, route-tag logs) had *zero* drift, while every staleness hit sat on a surface no verifier watches — the README, two index entries, one example link.

**What can be done** is the same move the repo has made repeatedly: shrink the set of surfaces that rely on discipline by giving each one a detector. That's what the new warn pass does for the two drift classes the audit caught by hand — a stale link or an unlisted file now announces itself in every `mix brain.verify` run and in CI logs, instead of waiting for someone to notice. After this change, the remaining detector-less surfaces are, deliberately: README *prose accuracy* (no mechanical oracle exists; the mitigation was making it a thin pointer into enforced surfaces rather than a parallel description that can rot), frozen thread quotes (history, not drift, by design), and the one big semantic gap both analyses converge on — **intake dedup recall**, which no syntactic check can cover. That's the still-`proposed` dedup-recall-probe plan, and it remains the highest-leverage unshipped work in the repo.
