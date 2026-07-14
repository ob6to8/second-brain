---
id: sb:f948df
type: reference
title: "smolagents — the agent loop as code-writing ReAct (Hugging Face)"
description: Agents run a multi-step ReAct loop where an LLM repeatedly chooses and executes actions — ideally written as code — until observations show the task is solved.
resource: https://huggingface.co/blog/smolagents
provenance: "Distilled from Aymeric Roucher, merve, and Thomas Wolf, Hugging Face blog, 2024-12-31"
tags: [agentic-loop, ai-agents, react, code-agents, tool-calling, smolagents]
timestamp: 2026-07-06
attribution:
  when: 2026-07-06T15:34:55+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# smolagents — the agent loop as code-writing ReAct (Hugging Face)

The smolagents post frames the agent as a system where an LLM controls its own
workflow through a multi-step ReAct-style loop. It distills the mechanism to a
compact pseudocode loop: initialize memory with the task, then while the LLM
decides to continue, get the next action, execute it, and append both action and
observations back to memory. In the authors' words, the system *"runs in a loop,
executing a new action at each step... until its observations make it apparent
that a satisfactory state has been reached to solve the given task."* The
reason–act–observe cycle is thus driven by the model's own judgment of completion.
The post's distinctive contribution is arguing that actions should be expressed as
executable **code** rather than JSON tool calls, giving better composability,
object handling, generality, and alignment with how LLMs were trained — making
each loop step more expressive.

# Citations

Aymeric Roucher, merve, Thomas Wolf, "Introducing smolagents", Hugging Face,
2024-12-31 — <https://huggingface.co/blog/smolagents>
