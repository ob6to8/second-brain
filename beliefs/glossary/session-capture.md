---
id: sb:243d56
type: concept
title: session capture
description: Rendering a working session into a thread doc, keeping every retained exchange verbatim and stripping only tool calls, reasoning, and short pre-tool narration.
provenance: "Agent-distilled glossary definition, pointer to the defining doc"
verified: false
tags: [glossary, capture]
sense: repo
timestamp: 2026-07-12
---

# session capture

Rendering a working session into a thread doc that keeps every retained exchange verbatim and strips only tool calls, reasoning, and short pre-tool narration (the drop rule: text under ~300 chars and followed by a tool call). Canonically defined by the [session-capture policy](/meta/policy/session-capture.md) and performed by [`/capture`](/.claude/skills/capture/SKILL.md).

*Seen in:* [2026-07-08 session-capture thread](/meta/threads/2026-07-08-adopt-session-capture-routing-and-route-tags.md), [2026-07-12 ban-dialog-box-questions thread](/meta/threads/2026-07-12-ban-dialog-box-questions-in-threads.md)
