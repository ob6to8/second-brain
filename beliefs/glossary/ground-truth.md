---
id: em:628db5
type: concept
title: ground truth
description: The known-correct answers an evaluation scores a system against — reference facts established independently of the system under test and treated as truth by the scoring.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, evals, ground-truth]
sense: common
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T23:23:55+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-20 evals-harness-ledger thread"
---

# ground truth

Usually it must be *collected* — human labeling is the expensive bottleneck of most benchmarks — but when the evaluator owns the domain (as this bundle owns its corpus) it becomes *constructible*: synthesize the material, inject known defects, and the right answers exist by fiat. A [gold set](/beliefs/glossary/gold-set.md) is its packaged form, and for editorial judgments the labels are policy-relative rather than factual, which is why they need [adjudication](/beliefs/glossary/adjudication.md) notes.

*Seen in:* [2026-07-20 evals and observation-records thread](/meta/threads/2026-07-20-evals-harness-ledger-and-observation-records.md), [eval-suitability analysis](/meta/analysis/eval-suitability-of-the-corpus-maintenance-failure-space.md)
