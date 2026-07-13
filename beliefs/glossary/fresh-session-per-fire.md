---
id: sb:e56fb4
type: concept
title: fresh-session-per-fire
description: A scheduling mode where each firing of a trigger starts a brand-new, clean agent session rather than resuming a persistent one, so a run inherits no state from prior firings.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, scheduling, automation]
sense: common
timestamp: 2026-07-10
---

# fresh-session-per-fire

A scheduling mode in which each firing of a trigger starts a brand-new, clean agent session rather than resuming a persistent one, so a run inherits no state or context from prior firings. It is configured via the scheduler's `create_new_session_on_fire` flag.

*Seen in:* [2026-07-09 news-Routine thread](/meta/threads/2026-07-09-daily-news-inbox-routine.md), [2026-07-09 news-issue thread](/meta/threads/2026-07-09-news-routine-issue-and-featuring.md)
