---
id: em:fa29f5
type: concept
title: reward model
description: A model trained to score outputs by quality or preference, standing in for human judgment as the reward signal in reinforcement learning pipelines (RLHF and successors) and, increasingly, in automated evaluation.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, reward-model, rl, rlhf, evals, training]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T14:20:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-16 Inkling evals-landscape spike thread"
---

# reward model

The classic pipeline is three-stage RLHF: supervised fine-tune, train the
scorer on human preference pairs, then optimize the policy against that
scorer. Two developments blur its boundary with evals: eval oracles can serve
directly as reward functions (any measurable metric becomes a training
signal — with the attendant Goodhart risk that a metric doubling as a target
stops being a neutral measurement), and dedicated scorers overlap heavily
with fine-tuned [LLM-as-judge](/beliefs/glossary/llm-as-judge.md) models —
the judge rates for a report, the reward model rates for a gradient. Inkling's
own calibration training used reward models that verify claims via web
search, an example of the verifier-backed variety.

*Seen in:* [2026-07-16 evals-landscape spike thread](/meta/threads/2026-07-16-inkling-evals-landscape-spike.md), [inkling-open-weights-eval-landscape analysis](/meta/analysis/inkling-open-weights-eval-landscape.md)
