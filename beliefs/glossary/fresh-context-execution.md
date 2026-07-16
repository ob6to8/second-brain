---
id: em:27e7a7
type: concept
title: fresh-context execution
description: Running a bounded unit of work in a newly-spawned agent given only minimal, task-scoped context — the specific inputs it needs — rather than the full accumulated session history.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, agents, orchestration, context-engineering, delegation]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T14:21:49Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-16 Workflow-driven plan-execution convention thread as the core of the proposed execution mode"
---

# fresh-context execution

The point is as much negative as positive: *withholding* the dispatching
session's history is what keeps the worker's reasoning focused and its window
clean, avoiding the [context rot](/beliefs/glossary/context-rot.md) that sets in
as a long-lived context fills. It is the shape Anthropic's sub-agent guidance
recommends and the basis of the
[orchestrator pattern](/beliefs/glossary/orchestrator-pattern.md) — the
orchestrating session stays thin while each subagent starts cold from a defined
payload, so many workers run cheaply in parallel. In this brain it is the
execution mode proposed for a ratified plan's workstreams, where that defined
payload is an
[Execution Context Payload](/beliefs/glossary/execution-context-payload.md): a
pointer into the plan on disk rather than the deliberation that produced it.

*Seen in:* [executing-ratified-plans-via-workflow-fan-out analysis](/meta/analysis/executing-ratified-plans-via-workflow-fan-out.md), [2026-07-16 Workflow-driven plan-execution thread](/meta/threads/2026-07-16-workflow-driven-plan-execution-convention.md)

*See also:* [orchestration](/beliefs/glossary/orchestration.md), [Workflow (orchestration tool)](/beliefs/glossary/workflow-tool.md), [context rot](/beliefs/glossary/context-rot.md)
