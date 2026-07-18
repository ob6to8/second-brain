---
id: em:a832e0
type: reference
title: "How coding agents work (Simon Willison)"
description: A coding agent is a harness that wraps an LLM with a system prompt and callable tools, running them in a loop that feeds tool results back as new context.
resource: https://simonwillison.net/guides/agentic-engineering-patterns/how-coding-agents-work/
provenance: "Distilled from Simon Willison, Simon Willison's Weblog, 2026-03-16"
tags: [agentic-loop, ai-agents, coding-agents, tool-use, system-prompt, llm-harness]
timestamp: 2026-07-06
attribution:
  when: 2026-07-06T15:34:55+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# How coding agents work (Simon Willison)

Willison demystifies the mechanics: *"A coding agent is a harness for an LLM,
extending it with capabilities powered by prompts and callable tools."* Rather
than naming a formal reason–act–observe cycle, he describes the architecture as
LLM + system prompt + tools in a loop. The stateless model starts fresh each
turn; a lengthy system prompt tells it how to behave and which tools exist; the
harness extracts function calls from the output, executes them, and appends the
results to conversation history before re-submitting. A modern reasoning layer
lets the model "think through" problems first. His key point is that the
underlying loop is "surprisingly straightforward" — a basic version is only
dozens of lines of code — even though production-grade harnesses require far more
sophistication around token caching, prompt design, and tool definitions.

See also [designing agentic loops](/knowledge/SWE/agentic/agentic-loop/designing-agentic-loops.md).

# Citations

Simon Willison, "How coding agents work" (Agentic Engineering Patterns) —
<https://simonwillison.net/guides/agentic-engineering-patterns/how-coding-agents-work/>
