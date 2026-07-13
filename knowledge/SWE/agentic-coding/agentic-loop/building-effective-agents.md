---
id: sb:06d95d
type: reference
title: "Building effective agents — agents vs. workflows (Anthropic)"
description: Anthropic frames an agent as an LLM that dynamically directs its own tool use in a loop, iterating on environmental feedback until the task is done, as opposed to a fixed-path workflow.
resource: https://www.anthropic.com/engineering/building-effective-agents
provenance: "Distilled from Erik Schluntz & Barry Zhang, Anthropic, 2024-12-19"
tags: [agentic-loop, ai-agents, anthropic, workflows, tool-use, agent-architecture]
timestamp: 2026-07-06
attribution:
  when: 2026-07-06T15:34:55+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# Building effective agents — agents vs. workflows (Anthropic)

The canonical reference for the agent/workflow distinction. It draws a sharp
architectural line: *"Workflows are systems where LLMs and tools are orchestrated
through predefined code paths. Agents, on the other hand, are systems where LLMs
dynamically direct their own processes and tool usage, maintaining control over
how they accomplish tasks."* The agentic loop itself is deliberately minimal —
agents *"are typically just LLMs using tools based on environmental feedback in a
loop."* Each cycle the model acts, receives tool results (observations), assesses
progress against the goal, and chooses the next action, continuing until a
completion or stopping condition. The defining property is autonomy: unlike
workflows' static execution paths, agents decide their own trajectory at runtime
from real-time feedback. Anthropic advises reaching for this looping autonomy only
when flexibility and model-driven decision-making at scale are genuinely needed,
since it trades predictability and cost for adaptability.

# Citations

Erik Schluntz & Barry Zhang, "Building effective agents", Anthropic, 2024-12-19 —
<https://www.anthropic.com/engineering/building-effective-agents>
