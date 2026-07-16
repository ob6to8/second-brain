---
id: em:143384
type: concept
title: fan-out
description: Splitting one task into many independent sub-tasks run concurrently, then combining their results — in agent orchestration, dispatching a fleet of subagents to work in parallel (e.g. one reader per subsystem) and synthesizing their structured returns.
provenance: "Agent-distilled glossary definition, 2026-07-16 code-tutorial session"
verified: false
tags: [glossary, orchestration, concurrency, agents]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T12:13:13Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-16 code-tutorial-and-code-map thread (the subagent-workflow read phase)"
---

# fan-out

Decomposing one task into many independent pieces dispatched to run
**concurrently**, then joining their outputs — the standard parallelism pattern
(distributed systems, MapReduce, concurrent I/O). Its value is wall-clock: the
work finishes in roughly the time of the slowest single piece rather than the sum,
and it applies whenever the pieces don't depend on each other.

In agent [orchestration](/beliefs/glossary/orchestration.md) it means spawning a
set of subagents that each handle one slice of a larger job in parallel — for
example, one reader per code subsystem, each returning structured findings that a
single stronger model then synthesizes. That read-in-parallel / synthesize-once
shape pairs naturally with [capability-matched model selection](/beliefs/glossary/capability-matched-model-selection.md):
cheap models absorb the high-volume fan-out, the strongest model does the join.

*Seen in:* [2026-07-16 code-tutorial-and-generated-code-map thread](/meta/threads/2026-07-16-code-tutorial-and-generated-code-map.md)
