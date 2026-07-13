---
id: sb:ad7525
type: concept
title: mixture-of-experts (MoE)
description: A neural-network architecture that sparsely routes each input to a small subset of specialized "expert" sub-networks instead of activating the whole model, giving a large parameter count at a smaller per-token compute cost.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, machine-learning, model-architecture, moe, sparse-routing]
sense: common
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T12:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-13 advisor-pattern thread as the model-internal contrast to application-level orchestration"
---

# mixture-of-experts (MoE)

A neural-network **architecture** that sparsely routes each input (typically per
token, per layer) to a small subset of specialized "expert" sub-networks rather
than activating the entire model, so a model can hold a very large parameter count
while paying a much smaller per-token compute cost. The routing happens inside a
single forward pass and is a property of the *model* — invisible at the API and
not something an application developer opts into or configures. This makes it a
different layer of the stack from application-level patterns like the
[advisor pattern](/beliefs/glossary/advisor-pattern.md),
[orchestrator pattern](/beliefs/glossary/orchestrator-pattern.md), or
[model cascade](/beliefs/glossary/model-cascade.md), which orchestrate across two or more
complete, separate model inferences; the two are easily conflated because both
involve "routing to capacity where it's needed."

*Seen in:* [2026-07-13 advisor-pattern thread](/meta/threads/2026-07-13-advisor-pattern-and-rolling-your-own-harness.md)
