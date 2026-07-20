---
id: em:617977
type: concept
title: observer agent
description: An experimental Claude Code subagent role in which a read-only watcher is paired one-to-one with a worker subagent, receives a digest of its activity, and may send at most one advisory, authority-free report — community-reported and absent from official documentation.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, claude-code, subagents, oversight, multi-agent]
sense: common
timestamp: 2026-07-18
attribution:
  when: 2026-07-18T19:05:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-18 observer-subagent-pattern intake thread"
---

# observer agent

Canonically captured in
[observer-subagent-pattern](/knowledge/SWE/agentic/anthropic/claude-code/observer-subagent-pattern.md),
which holds the mechanics, configuration, and unofficial-status caveat — this
entry is a pointer, not a second definition. The role inverts the
[advisor pattern](/beliefs/glossary/advisor-pattern.md): there the executor *pulls*
guidance from a stronger model when it chooses; an observer *pushes* its single
report unbidden, and the recipient owes it no obedience. Its
silence-is-the-steady-state posture is
[monitor by exception](/beliefs/glossary/monitor-by-exception.md) applied
agent-to-agent.

*Seen in:* [observer-subagent-pattern](/knowledge/SWE/agentic/anthropic/claude-code/observer-subagent-pattern.md), [2026-07-18 observer-subagent-pattern intake](/meta/threads/2026-07-18-observer-subagent-pattern-intake.md)
