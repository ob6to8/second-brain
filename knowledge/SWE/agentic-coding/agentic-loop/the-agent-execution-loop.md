---
id: sb:3fd44a
type: reference
title: "The agent execution loop — multi-step reasoning in a single run (Victor Dibia)"
description: An agent is defined by an execution loop that takes multiple model-call-and-tool-execution steps within one run until the task is complete.
resource: https://newsletter.victordibia.com/p/the-agent-execution-loop-how-to-build
provenance: "Distilled from Victor Dibia, Designing with Machines newsletter, 2025-12-11"
tags: [agentic-loop, ai-agents, tool-calling, context-engineering, multi-step-reasoning]
timestamp: 2026-07-06
---

# The agent execution loop — multi-step reasoning in a single run (Victor Dibia)

Dibia frames the agent execution loop as what distinguishes an agent from a plain
LLM call: *"An agent takes multiple steps (model call → tool execution → model
call) within a single run."* He breaks the loop into five stages: prepare context
(combine task, instructions, memory, and history); call the model; handle the
response (deciding whether it is final text or tool calls); iterate by appending
tool results back into context and returning to the model call; and finally return
the completed response. The defining property is iteration — the agent repeatedly
re-invokes the model, each time enriched with new observations, rather than
answering in one shot. Context assembly is treated as a first-class step rather
than an afterthought, emphasizing that what the model sees on each turn drives the
quality of its next action. The loop continues until the model emits a terminal
text response.

# Citations

Victor Dibia, "The Agent Execution Loop: How to Build an AI Agent From Scratch",
2025-12-11 — <https://newsletter.victordibia.com/p/the-agent-execution-loop-how-to-build>
