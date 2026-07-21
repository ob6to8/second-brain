---
id: em:7ecfb6
type: concept
title: LLM-as-judge
description: Using a language model's judgment in place of human annotation for evaluation tasks, validated by measured agreement with human raters — e.g. SAFE matching crowdworkers 72% of the time and winning 76% of disagreements at >20× lower cost.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, evals, llm, annotation, methodology]
sense: common
timestamp: 2026-07-21
attribution:
  when: 2026-07-11T20:14:11+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "extracted in the glossary run over the eight epistemic prior-art docs"
---

# LLM-as-judge

In practice the task is rating, labeling, or verifying outputs, and the
substitution earns trust only when its agreement with humans is *measured*
rather than assumed. The decompose-then-verify factuality results are the canonical
validation: SAFE matches crowdworkers 72% of the time and wins 76% of
adjudicated disagreements at more than 20× lower cost. The same pattern
underlies per-edge belief-graph judgments: local, cacheable model verdicts
composed by mechanical aggregation. A structural caveat: judge *ensembles*
drawn from the same few model lineages share blind spots ("great models think
alike"), so best practice runs 3–5 judges across distinct model families —
which makes each genuinely new pretraining lineage (e.g.
[Inkling](/beliefs/glossary/inkling.md)) an oversight resource, not just a
contestant.

*Seen in:* [decompose-then-verify factuality reference](/knowledge/SWE/evals/decompose-then-verify-factuality.md), [belief-decomposition plan](/meta/plans/belief-decomposition-analysis-mode.md), [2026-07-20 evals and observation-records thread](/meta/threads/2026-07-20-evals-harness-ledger-and-observation-records.md), [2026-07-16 evals-landscape spike thread](/meta/threads/2026-07-16-inkling-evals-landscape-spike.md) (judge diversity against correlated error; fine-tuned judges as the evals industry's product)
