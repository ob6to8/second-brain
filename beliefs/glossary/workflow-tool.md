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

The script is plain JavaScript, run deterministically: `agent(prompt, opts)`
spawns a [fresh-context](/beliefs/glossary/fresh-context-execution.md) subagent
and returns its result (a schema-validated object when one is given); `parallel()`
runs thunks concurrently behind a barrier, `pipeline()` streams items through
stages with *no* barrier between them, and `phase()` groups calls in the progress
display. Passing `isolation: 'worktree'` gives each parallel file-mutating worker
its own [git worktree](/beliefs/glossary/git-worktree.md), pushing conflicts to
merge time. One consequence matters for this brain: because the whole script runs
*inside one tool call* of its dispatching session, the subagents' work is
invisible to [session capture](/beliefs/glossary/session-capture.md), which strips
tool calls — so the orchestrator must narrate the results in delivered text for
them to reach the thread record. It is the concrete mechanism the proposed
[Workflow-driven plan-execution convention](/meta/analysis/executing-ratified-plans-via-workflow-fan-out.md)
uses to fan a plan's workstreams out for execution.

*Seen in:* [executing-ratified-plans-via-workflow-fan-out analysis](/meta/analysis/executing-ratified-plans-via-workflow-fan-out.md), [2026-07-16 Workflow-driven plan-execution thread](/meta/threads/2026-07-16-workflow-driven-plan-execution-convention.md)

*See also:* [orchestrator pattern](/beliefs/glossary/orchestrator-pattern.md), [fresh-context execution](/beliefs/glossary/fresh-context-execution.md), [git worktree](/beliefs/glossary/git-worktree.md)
