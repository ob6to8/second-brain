---
id: em:535978
type: concept
title: Workflow (orchestration tool)
description: The Claude Code execution environment's orchestration primitive — a script that fans work out to fresh-context subagents (agent(), with parallel()/pipeline() for concurrency, phase() for grouping, and optional git-worktree isolation) and returns synthesized results to a thin orchestrating session.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, agents, orchestration, claude-code, tooling]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T14:21:49Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-16 Workflow-driven plan-execution convention thread as the concrete fan-out mechanism"
---

# Workflow (orchestration tool)

The Claude Code execution environment's **orchestration primitive**: a plain
JavaScript script that deterministically coordinates many subagents. Its core
call is `agent(prompt, opts)`, which spawns a
[fresh-context](/beliefs/glossary/fresh-context-execution.md) subagent and
returns its result (a validated object when given a `schema`); `parallel()` runs
thunks concurrently behind a barrier, `pipeline()` streams items through stages
with no barrier between them, and `phase()` groups calls in the progress display.
An agent can run with `isolation: 'worktree'` so parallel file-mutating workers
each get their own [git worktree](/beliefs/glossary/git-worktree.md). The Workflow
runs *inside one tool call* of a thin orchestrating session and returns synthesized
results — which matters for capture, since
[session capture](/beliefs/glossary/session-capture.md) strips tool calls, so the
orchestrator must narrate the results in delivered text for them to be recorded.
It is the concrete mechanism this brain's proposed
[Workflow-driven plan-execution convention](/meta/analysis/executing-ratified-plans-via-workflow-fan-out.md)
uses to fan a plan's workstreams out for execution.

*Seen in:* [executing-ratified-plans-via-workflow-fan-out analysis](/meta/analysis/executing-ratified-plans-via-workflow-fan-out.md), [2026-07-16 Workflow-driven plan-execution thread](/meta/threads/2026-07-16-workflow-driven-plan-execution-convention.md)

*See also:* [orchestrator pattern](/beliefs/glossary/orchestrator-pattern.md), [fresh-context execution](/beliefs/glossary/fresh-context-execution.md), [git worktree](/beliefs/glossary/git-worktree.md)
