---
id: sb:bb0ef0
type: concept
title: advisor pattern
description: An agent cost pattern where a fast, low-cost executor model does the bulk of generation and consults a higher-intelligence advisor model at moments where planning matters, so most tokens bill at the cheaper executor rate while quality approaches advisor-solo.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, agents, llm-orchestration, cost-optimization, anthropic, advisor-tool]
sense: common
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T12:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-13 advisor-pattern thread and its filed analysis"
---

# advisor pattern

An agent cost-optimization pattern in which a fast, low-cost **executor** model
does the bulk of token generation and consults a higher-intelligence **advisor**
model only at the moments where a good plan or course-correction matters — so most
tokens bill at the cheaper executor rate while output quality approaches
advisor-solo. Anthropic ships a native implementation as the **advisor tool** (a
beta Messages API server-side tool, `advisor_20260301`): the executor emits an
empty `server_tool_use` block, Anthropic runs the advisor sub-inference over the
full transcript *inside the same request*, and the advice returns as an
`advisor_tool_result` the executor continues from. The pattern is reimplementable
in any framework as two ordinary API calls stitched together by your own control
flow, trading the native tool's single-request convenience for control over the
advisor's prompt, context, and call timing. Distinct from the
[orchestrator pattern](/beliefs/glossary/orchestrator-pattern.md) (one strong planner
dispatching parallel cheap workers) and, at a different layer entirely, from
[mixture-of-experts](/beliefs/glossary/mixture-of-experts.md) — a model-internal routing
architecture, not application-level orchestration.

*Seen in:* [when-to-roll-your-own-advisor-harness analysis](/meta/analysis/when-to-roll-your-own-advisor-harness.md), [2026-07-13 advisor-pattern thread](/meta/threads/2026-07-13-advisor-pattern-and-rolling-your-own-harness.md)

*See also:* [model cascade](/beliefs/glossary/model-cascade.md), [harness](/beliefs/glossary/harness.md), [speculative decoding](/beliefs/glossary/speculative-decoding.md)
