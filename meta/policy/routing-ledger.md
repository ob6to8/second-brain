---
type: policy
title: Routing ledger
description: Every captured thread carries a ## Routing table — one row per topic, holding dispatch state and pointers only, never synthesized content.
section: session-workflow
order: 2
status: active
tags: [meta, governance, threads, routing, workflow]
timestamp: 2026-07-08
---
Every captured thread carries a **`## Routing`** section: a per-thread dispatch
table with one row per topic the session touched. It is a **router, never a
digest** — it answers exactly one question: *what would I need to know to reply
to this thread without re-reading it?*

Four columns:

| Column | Holds |
|--------|-------|
| **Topic** | what the strand is about, one line |
| **State** | `open` (live) · `paused` (waiting on a dangling question) · `closed` (resolved; nothing further expected) |
| **Routed to** | a markdown link to the `concept` doc that absorbed the strand's content, or `unrouted` |
| **Dangling** | the open question, when `open`/`paused` (else `-`) |

- **Pointers and states only — never content.** Synthesized content lands in the
  routed-to `concept` doc; if it also lived in the ledger the ledger would become
  a stale shadow copy of that doc. State (the strand) and routed-to (the
  dispatch) are orthogonal: a strand can be routed yet still `open`, or `closed`
  and `unrouted`.
- **Routed-to targets are `concept` docs**, linked by bundle-absolute path
  (e.g. `[foo](/knowledge/SWE/…/foo.md)`). The route-tagging cross-check reads this column
  to confirm every concept-routed row is covered by a tag (see the route-tagging
  policy).
- **In-doc, maintained at capture time.** The ledger is a section of the thread
  doc itself (not a sibling file), written and updated by `/capture` in the same
  motion that routes content — routing and ledger update are one act, not a
  regeneration step that can be forgotten.
