---
id: sb:a030d9
type: reference
title: "A practical guide to building agents — the 'run' loop (OpenAI)"
description: OpenAI defines an agent as a system that independently accomplishes tasks by having an LLM manage workflow execution in a 'run' loop that continues until an exit condition is reached.
resource: https://openai.com/business/guides-and-resources/a-practical-guide-to-building-ai-agents/
provenance: "Distilled from OpenAI, 'A Practical Guide to Building Agents', 2025"
tags: [agentic-loop, ai-agents, openai, orchestration, run-loop, exit-conditions]
timestamp: 2026-07-06
---

# A practical guide to building agents — the 'run' loop (OpenAI)

OpenAI's guide (summarized — it is an extensive PDF) defines agents as *"systems
that independently accomplish tasks on your behalf,"* where an LLM *"manages
workflow execution and make[s] decisions,"* recognizes when work is complete,
self-corrects, and can halt and hand back to the user. It dynamically selects tools
based on the workflow's current state within guardrails. The loop is named
explicitly: *"Every orchestration approach needs the concept of a 'run', typically
implemented as a loop that lets agents operate until an exit condition is
reached."* Common exit conditions are a final-output tool call, a response with no
tool calls, an error, or a maximum turn count. In the Agents SDK, `Runner.run()`
loops over the LLM until one fires. The guide stresses this is foundational: *"This
concept of a while loop is central to the functioning of an agent,"* extending to
multi-agent systems via sequences of tool calls and handoffs that run multiple
steps until termination.

# Citations

OpenAI, "A Practical Guide to Building Agents", 2025 —
<https://openai.com/business/guides-and-resources/a-practical-guide-to-building-ai-agents/>
(PDF: <https://cdn.openai.com/business-guides-and-resources/a-practical-guide-to-building-agents.pdf>)
