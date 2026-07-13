---
id: sb:3384ba
type: reference
title: "Designing agentic loops (Simon Willison)"
description: An LLM agent solves goals by running tools in a loop, and the craft lies in carefully designing those tools, permissions, and the sandbox the loop runs in.
resource: https://simonwillison.net/2025/Sep/30/designing-agentic-loops/
provenance: "Distilled from Simon Willison, Simon Willison's Weblog, 2025-09-30"
tags: [agentic-loop, ai-agents, loop-engineering, coding-agents, tool-use, sandboxing]
timestamp: 2026-07-06
attribution:
  when: 2026-07-06T15:34:55+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# Designing agentic loops (Simon Willison)

Willison frames the agentic loop as a "brute force" method: given a clear goal
and the right tools, an LLM iterates toward a solution through trial and error.
His thesis: *"An LLM agent runs tools in a loop to achieve a goal. The art is
carefully designing the tools and loop."* The design work is mostly about safety
and fit. Running agents in "YOLO mode" (auto-approving commands) sharply boosts
effectiveness but demands isolation — Docker containers or GitHub Codespaces
rather than your laptop — plus scoped credentials and hard budget caps. Agents
favor plain shell commands over formal protocols like MCP, and an `AGENTS.md`
helps them self-discover capabilities. The loop shines on trial-and-error
problems with clear success criteria: debugging, performance tuning, dependency
upgrades, and container optimization, where strong automated tests amplify the
agent's ability to verify its own progress.

# Citations

Simon Willison, "Designing agentic loops", 2025-09-30 —
<https://simonwillison.net/2025/Sep/30/designing-agentic-loops/>
