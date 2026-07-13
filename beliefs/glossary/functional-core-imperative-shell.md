---
id: sb:83b180
type: concept
title: functional core, imperative shell
description: A design pattern that isolates pure computation in a stateless core wrapped by a thin imperative layer handling state and effects — the structure an agent instantiates with the model as core and the loop as shell.
provenance: "Agent-distilled glossary definition, 2026-07-13 session"
verified: false
sense: common
tags: [glossary, functional-programming, agent-architecture, terminology]
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T00:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-13 second-mind-taxonomy thread cited in Seen in"
---

# functional core, imperative shell

A software-design pattern that concentrates decision logic in a [pure-function](/beliefs/glossary/pure-function.md) core — easy to test and reason about — and pushes all state, I/O, and side effects into a thin imperative wrapper around it. An agent instantiates the pattern exactly: the model is the pure core, and the loop is the imperative shell that threads conversation state through it and executes the effects (tool calls) its output requests.

*Seen in:* [2026-07-13 second-mind-taxonomy thread](/meta/threads/2026-07-13-second-mind-taxonomy-analysis-and-belief-plan.md)
