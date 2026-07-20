---
id: em:570e22
type: concept
title: routing ledger
description: The per-thread dispatch table (topic | state | routed-to | dangling) a captured thread carries — pointers and states only, never synthesized content.
provenance: "Agent-distilled glossary definition, pointer to the defining doc"
verified: false
tags: [glossary, routing, capture]
sense: repo
timestamp: 2026-07-20
attribution:
  when: 2026-07-11T08:41:24+02:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# routing ledger

A per-thread dispatch table (Topic | State | Routed-to | Dangling), often shortened to just "the ledger", that answers what you would need to know to reply to a thread without re-reading it — holding pointers and states only, never synthesized content. Each row tracks one [strand](/beliefs/glossary/strand.md) of the session's work. Canonically defined by the [routing-ledger policy](/meta/policy/routing-ledger.md).

*Seen in:* [2026-07-08 session-capture thread](/meta/threads/2026-07-08-adopt-session-capture-routing-and-route-tags.md), [2026-07-12 news→research rename thread](/meta/threads/2026-07-12-rename-news-skill-to-research.md), [2026-07-20 evals and observation-records thread](/meta/threads/2026-07-20-evals-harness-ledger-and-observation-records.md)
