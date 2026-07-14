---
id: em:121072
type: concept
title: orchestrator pattern
description: A multi-agent cost pattern ("plan big, execute small") where a high-intelligence orchestrator model decomposes a task and dispatches subtasks to multiple cheaper worker models in parallel, so most tokens bill at the lower worker rate.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, agents, multi-agent, llm-orchestration, cost-optimization, anthropic]
sense: common
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T12:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-13 advisor-pattern thread as the sibling of the advisor pattern"
---

# orchestrator pattern

A multi-agent cost pattern — Anthropic's phrasing is "plan big, execute small" —
in which a high-intelligence **orchestrator** model decomposes a task and
dispatches the subtasks to multiple cheaper **worker** models running in
parallel, so the bulk of tokens bill at the lower worker rate. Anthropic
benchmarked it under [Claude Managed Agents](/beliefs/glossary/claude-managed-agents.md)
(a Fable orchestrator with Sonnet workers reaching roughly 96% of all-Fable
BrowseComp performance at about 46% of the cost). It is the heavier sibling of the
[advisor pattern](/beliefs/glossary/advisor-pattern.md): rather than a single in-request
advisor sub-inference, it spins up concurrent sub-agents, which is why it lives in
a managed-agent or agent-SDK runtime rather than a lone Messages API call. It is
the planner–executor / supervisor–worker shape common to agent frameworks such as
LangGraph and AutoGen.

*Seen in:* [when-to-roll-your-own-advisor-harness analysis](/meta/analysis/when-to-roll-your-own-advisor-harness.md), [2026-07-13 advisor-pattern thread](/meta/threads/2026-07-13-advisor-pattern-and-rolling-your-own-harness.md)

*See also:* [orchestration](/beliefs/glossary/orchestration.md), [advisor pattern](/beliefs/glossary/advisor-pattern.md), [harness](/beliefs/glossary/harness.md)
