---
id: sb:b6353e
type: reference
title: "Own your control flow — Factor 8 of 12-Factor Agents (HumanLayer)"
description: An agent should be built as a program you control, not a black-box loop, so you can interrupt, resume, and apply custom logic at each step of the reason-act cycle.
resource: https://github.com/humanlayer/12-factor-agents/blob/main/content/factor-08-own-your-control-flow.md
provenance: "Distilled from HumanLayer (Dexter Horthy et al.), 12-Factor Agents project"
tags: [agentic-loop, ai-agents, control-flow, human-in-the-loop, interrupt-resume, tool-use]
timestamp: 2026-07-06
attribution:
  when: 2026-07-06T15:34:55+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# Own your control flow — Factor 8 of 12-Factor Agents (HumanLayer)

Factor 8 argues that developers should own the agent's execution loop rather than
delegate it to a framework's opaque "while not done" runner. The agent is modeled
as a decision loop that selects a next step, then dispatches it through custom code
rather than one fixed path — *"if you own your control flow, you can do lots of fun
things."* The critical seam is between tool *selection* and tool *invocation*:
owning it lets you pause for human review, serialize and resume state, and treat
different tool calls differently. It distinguishes async breaks (approvals,
clarifications that suspend and await outside input) from sync continuations (data
fetches passed straight back to the model), plus custom logic for summarization,
caching, rate-limiting, and memory. Without this granularity you face a trilemma:
restart-from-scratch pauses, restricting agents to low-stakes actions, or letting
risky actions run unvetted. Ownership converts the loop into governable, resumable
infrastructure enabling safe high-stakes work.

# Citations

HumanLayer, "12-Factor Agents — Factor 8: Own Your Control Flow" —
<https://github.com/humanlayer/12-factor-agents/blob/main/content/factor-08-own-your-control-flow.md>
