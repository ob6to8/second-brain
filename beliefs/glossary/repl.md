---
id: sb:e6f894
type: concept
title: REPL
description: Read-eval-print loop — an interactive interpreter cycle that reads an expression, evaluates it, prints the result, and recurses; the structure the agent loop has over model output.
provenance: "Agent-distilled glossary definition, 2026-07-13 session"
verified: false
sense: common
tags: [glossary, programming-languages, agent-architecture, terminology]
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T00:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-13 second-mind-taxonomy thread cited in Seen in"
---

# REPL

Read-eval-print loop: the interactive interpreter cycle that reads an expression, evaluates it, prints the result, and recurses (Elixir's `iex`, the shell, a Lisp prompt). The agent loop is a REPL over model output — read the emission, dispatch on its form (tool call vs. final answer), evaluate the tool, append the result to context, recurse — which is what qualifies the loop as the strictest interpreter in the [tower of interpreters](/beliefs/glossary/tower-of-interpreters.md).

*Seen in:* [2026-07-13 second-mind-taxonomy thread](/meta/threads/2026-07-13-second-mind-taxonomy-analysis-and-belief-plan.md)
