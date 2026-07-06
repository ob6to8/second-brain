---
id: sb:c0961a
type: reference
title: "Effective context engineering for AI agents (Anthropic)"
description: Anthropic frames an agent as an LLM autonomously using tools in a loop, where each turn accumulates context that must be continuously curated to preserve a finite attention budget.
resource: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
provenance: "Distilled from Anthropic Applied AI (Rajasekaran, Dixon, Ryan, Hadfield), 2025-09-29"
tags: [agentic-loop, ai-agents, context-engineering, tool-use, attention-budget, memory]
timestamp: 2026-07-06
---

# Effective context engineering for AI agents (Anthropic)

Anthropic defines agents simply as *"LLMs autonomously using tools in a loop,"*
making iterative tool use the central mechanism rather than naming discrete
reason–act–observe steps. Their key concern is what the loop does to context: *"An
agent running in a loop generates more and more data that could be relevant for the
next turn of inference, and this information must be cyclically refined."* Context
engineering — curating the optimal set of tokens across system prompt, tools,
message history, and external data — becomes the loop's core management function,
replacing static prompt-writing. Because attention is a finite budget, each turn's
growing output risks context pollution, so engineers must select what stays
relevant downstream. They advocate just-in-time retrieval (agents pull data via
tools rather than preloading), plus compaction, structured note-taking, and
sub-agent architectures to sustain coherent, goal-directed behavior across long
multi-turn agentic runs.

# Citations

Anthropic, "Effective context engineering for AI agents", 2025-09-29 —
<https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents>
