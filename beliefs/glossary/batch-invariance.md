---
id: em:5787b0
type: concept
title: batch invariance
description: "The property that an inference server's numerical output for a request does not depend on which other requests it happened to be batched with — the missing ingredient that makes temperature-0 LLM inference actually deterministic."
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, batch-invariance, determinism, inference, reproducibility, llm-engineering]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T12:25:27Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-16 Inkling/BEAM swarm-eval spike thread"
---

# batch invariance

Standard GPU kernels for RMSNorm, matmul, and attention change their reduction order with batch shape, so the "same" forward pass yields different floating-point results under different server load — Thinking Machines' September 2025 *Defeating Nondeterminism in LLM Inference* identified this and published `batch_invariant_ops`, kernel replacements under which 1,000 identical prompts return 1,000 identical completions. SGLang extended the idea past greedy decoding with a seeded sampler (Gumbel noise from a hashed seed), giving reproducible sampling too. The payoff is twofold: **replayable evals** (an emergent multi-agent failure can be re-run bitwise from recorded seeds and ablated one variable at a time) and **stable on-policy RL** (sampler and trainer computing identical numbers keeps the policy-gradient loop from silently going off-policy). The guarantee is a property of the inference deployment, not the model — a generic shared endpoint forfeits it.

*Seen in:* [2026-07-16 Inkling/BEAM swarm-eval spike thread](/meta/threads/2026-07-16-inkling-beam-swarm-eval-spike.md), [inkling-beam-swarm-eval-substrate analysis](/meta/analysis/inkling-beam-swarm-eval-substrate.md), https://thinkingmachines.ai/blog/defeating-nondeterminism-in-llm-inference/
