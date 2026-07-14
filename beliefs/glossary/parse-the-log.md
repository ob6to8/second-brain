---
id: em:7adc45
type: concept
title: parse-the-log
description: A session-capture implementation path that renders a transcript by mechanically parsing the host session log file rather than reproducing text from the agent's live context, for higher fidelity.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, capture, tooling]
sense: repo
timestamp: 2026-07-10
attribution:
  when: 2026-07-11T08:41:24+02:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# parse-the-log

A session-capture implementation path that renders a transcript by mechanically parsing the host session log file (e.g. a `.jsonl`) rather than reproducing text from the agent's live context. It is preferred for fidelity because it yields the exact delivered text instead of a memory reconstruction; it contrasts with render-from-context.

*Seen in:* [2026-07-08 session-capture thread](/meta/threads/2026-07-08-adopt-session-capture-routing-and-route-tags.md)
