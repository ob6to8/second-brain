---
id: em:ac0e23
type: concept
title: harness (agent harness)
description: The software scaffolding that wraps a language model to make it an agent — the control loop that runs the model turn by turn, the tools it can call, and the context and memory management around it.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, agents, harness, agent-loop, anthropic]
sense: common
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T12:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "load-bearing term used throughout the 2026-07-13 advisor-pattern thread and recurring across the brain"
---

# harness (agent harness)

The software scaffolding that wraps a language model to turn it into an agent: the
**control loop** that runs the model turn by turn, the **tools** it can call, and
the **context/memory management** around it. The same model can run under
different harnesses tuned for different work — an interactive coding harness
(Claude Code), a narrow task-specific harness, or a hosted one
([Claude Managed Agents](/beliefs/glossary/claude-managed-agents.md)) — and Anthropic frames
a harness as *decoupling the "brain"* (the model's reasoning loop) *from the
"hands"* (sandboxes, tools, external systems), so one brain can drive many hands.
Choosing to build your own harness rather than use a vendor's turnkey feature
trades that convenience for control over prompts, context, call timing, model
pairing, and observability.

*Seen in:* [when-to-roll-your-own-advisor-harness analysis](/meta/analysis/when-to-roll-your-own-advisor-harness.md), [2026-07-13 advisor-pattern thread](/meta/threads/2026-07-13-advisor-pattern-and-rolling-your-own-harness.md)

*See also:* [Claude Agent SDK](/beliefs/glossary/claude-agent-sdk.md), [Claude Managed Agents](/beliefs/glossary/claude-managed-agents.md), [orchestration](/beliefs/glossary/orchestration.md)
