---
id: sb:2523b4
type: concept
title: agent time horizon
description: The human-completion-time length of task an AI agent can finish at a fixed success rate (e.g. the 50% time horizon), used to measure and track agent capability over time.
provenance: "Agent-distilled glossary definition, pointer to the defining doc"
verified: false
tags: [glossary, agentic-loop, evaluation, long-horizon, metr]
timestamp: 2026-07-11
---

# agent time horizon

The length of a task — measured in how long it takes a *human* — that an AI agent can
complete at a fixed success rate. The **50% time horizon** is the task length the
agent finishes half the time; the **80% horizon** is the same at a stricter bar and is
always shorter, so the gap between them is a measure of reliability decay as tasks
lengthen. METR's finding that this horizon doubles every few months is the basis for
"a Moore's Law for AI agents." Defined by [Agent task time horizons](/knowledge/SWE/agentic-coding/agentic-loop/agent-task-time-horizons.md).

*Seen in:* [2026-07-11 news-digest thread](/meta/threads/2026-07-11-news-digest-intake-and-daily-read.md), [Agent task time horizons](/knowledge/SWE/agentic-coding/agentic-loop/agent-task-time-horizons.md)
