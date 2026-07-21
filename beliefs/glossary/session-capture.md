---
id: em:243d56
type: concept
title: session capture
description: Rendering a working session into a thread doc, keeping every retained exchange verbatim and stripping only tool calls, reasoning, and short pre-tool narration.
provenance: "Agent-distilled glossary definition, pointer to the defining doc"
verified: false
tags: [glossary, capture]
sense: repo
timestamp: 2026-07-16
attribution:
  when: 2026-07-11T08:41:24+02:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# session capture

The drop rule is exact: an assistant text block is stripped only when it is both under ~300 characters and immediately followed by a tool call. Canonically defined by the [session-capture policy](/meta/policy/session-capture.md) and performed by [`/capture`](/.claude/skills/capture/SKILL.md).

*Seen in:* [2026-07-08 session-capture thread](/meta/threads/2026-07-08-adopt-session-capture-routing-and-route-tags.md), [2026-07-12 ban-dialog-box-questions thread](/meta/threads/2026-07-12-ban-dialog-box-questions-in-threads.md), [2026-07-13 council-round thread](/meta/threads/2026-07-13-council-round-suitability-evaluation.md), [2026-07-19 session-URL-persistence thread](/meta/threads/2026-07-19-session-url-persistence-and-plan-vs-capture-policy.md)
