---
id: sb:3c4af9
type: concept
title: tower of interpreters
description: The framing of an agent as stacked interpreters, each giving operational meaning to the layer above's output — model over natural language, loop over model emissions, tools over structured arguments.
provenance: "Agent-distilled glossary definition, 2026-07-13 session"
verified: false
sense: common
tags: [glossary, agent-architecture, programming-languages, terminology]
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T00:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-13 second-mind-taxonomy thread cited in Seen in"
---

# tower of interpreters

A framing of agent architecture as a stack of interpreters, each layer giving operational meaning to the output of the layer above: the model interprets natural language (the prompt as a program in a radically underspecified language), the loop interprets model emissions (a [REPL](/beliefs/glossary/repl.md) whose AST is the tool-call schema — the model's tokens have no causal effect until the loop enacts them), and tools interpret structured arguments into world effects (the tool boundary as a foreign function interface). Each layer compiles intent down one level of abstraction: English → model → tool-call IR → loop → tool → syscalls.

*Seen in:* [2026-07-13 second-mind-taxonomy thread](/meta/threads/2026-07-13-second-mind-taxonomy-analysis-and-belief-plan.md)
