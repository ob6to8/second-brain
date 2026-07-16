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

Running a bounded unit of work in a **newly-spawned agent** that receives only
**minimal, task-scoped context** — the specific inputs the task needs — instead
of the full accumulated history of the session that dispatched it. Keeping the
worker's context clean and its reasoning focused is the point: it avoids context
rot from irrelevant history and lets an orchestrator run many workers cheaply.
It is the shape Anthropic's sub-agent guidance recommends and the basis of the
[orchestrator pattern](/beliefs/glossary/orchestrator-pattern.md) — the
orchestrating session stays thin and each subagent starts cold from a defined
payload. In this brain it is the execution mode proposed for a ratified plan's
workstreams, where the defined payload is an
[Execution Context Payload](/beliefs/glossary/execution-context-payload.md).

*Seen in:* [executing-ratified-plans-via-workflow-fan-out analysis](/meta/analysis/executing-ratified-plans-via-workflow-fan-out.md), [2026-07-16 Workflow-driven plan-execution thread](/meta/threads/2026-07-16-workflow-driven-plan-execution-convention.md)

*See also:* [orchestration](/beliefs/glossary/orchestration.md), [Workflow (orchestration tool)](/beliefs/glossary/workflow-tool.md), [context rot](/beliefs/glossary/context-rot.md)
