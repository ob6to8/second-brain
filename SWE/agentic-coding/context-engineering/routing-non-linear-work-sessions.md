---
id: sb:d479e3
type: concept
title: Routing non-linear work sessions — per-topic pages plus a dispatch ledger
description: A technique for managing a single working session that touches many topics — synthesize each topic's content into a durable per-topic page, and track dispatch (which strands opened, paused, or routed where) in a per-thread ledger of pointers and states — so the session is resumable from the record, not from memory.
tags: [context-engineering, knowledge-management, threads, workflow]
verified: false
timestamp: 2026-07-08
---

# Routing non-linear work sessions — per-topic pages plus a dispatch ledger

A single working session rarely runs in a straight line. It opens several
matters, spins off side quests, pauses strands on an unanswered question, and
resolves others. Left in the transcript, that state lives only in the
participant's head: to reply you must re-read the whole thread and reconstruct
which threads dangle.

The technique that dissolves this splits the problem in two, along orthogonal
axes:

- **Content is homed per topic, not per session.** Each matter has one durable
  page that is rewritten in place as understanding compiles — the session's
  synthesized output lands there, next to everything else ever said about that
  matter. The session itself produces no authoritative synthesis of its own.
- **Dispatch is tracked per session, in a ledger of pointers.** A small
  per-thread table records, one row per topic: the strand's **state** (live,
  paused-on-a-question, or resolved) and where its content was **routed**. The
  ledger holds *only* pointers and states — never the content itself, or it
  would decay into a stale duplicate of the per-topic pages. It answers exactly
  one question: *what would I need to know to reply without re-reading?*

State and dispatch are independent: a strand can be routed yet still live
(deliberation continues on its page), or resolved and unrouted (nothing worth
keeping). Keeping them separate is what lets the ledger stay a router rather than
a digest.

An optional third layer makes the routing auditable: mark each region of the
frozen session with the page(s) it feeds, and let those marks materialize an
append-only, dated excerpt log into each page — so a matter's whole cross-session
discussion is readable in one place, and what was *left out* of a page is a
visible boundary rather than a hidden editorial choice.

## Relation to other captures

- [Conversation Tree Architecture](/SWE/agentic-coding/context-engineering/conversation-tree-architecture.md)
  attacks the same non-linearity one level down, inside the model's context
  window: it branches the *live* conversation so tangents keep isolated context
  and only useful results merge back. Routing is the durable-artifact analogue —
  CTA manages the working context during the session; routing manages where the
  session's output lands after it. The two compose: branch to think, route to
  persist.
- [Granularity-aware evaluation for dialogue topic segmentation](/SWE/agentic-coding/context-engineering/granularity-aware-evaluation-for-dialogue-topic-segmentation.md)
  is the measurement angle on the same "where does one topic end and the next
  begin?" question that per-topic routing answers by hand.

## Provenance

Distilled while adopting a session-capture / routing-ledger / route-tagging
workflow into this brain (see the operating contract's *Session capture, routing
& route tags* section and the [2026-07-08 thread](/meta/threads/2026-07-08-adopt-session-capture-routing-and-route-tags.md)).

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="sb:d479e3">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-08-adopt-session-capture-routing-and-route-tags (2026-07-08)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:d479e3`]**

A single working session (a "thread") is non-linear: it touches many topics,
pauses some on open questions, and routes each topic's synthesized content into
a durable per-topic page. The mechanisms:

  1. SESSION CAPTURE renders the conversation into a readable `thread` doc -
     substantive responses only, the reasoning/tool-call noise stripped.
  2. ROUTING LEDGER - a per-thread table (pointers + states, never content), so
     a multi-topic thread can be resumed from the table instead of from memory.
  3. PROTO-BELIEF DOCUMENTS - the durable per-matter page where synthesized
     content actually lands. In OKF terms THIS IS A `concept` DOC.
  4. ROUTE TAGS - `<routes ref="...">` regions marked on the finalized thread
     body that mechanically materialize an append-only, date-stamped excerpt
     log into each referenced concept doc, plus a verifier that re-derives the
     log from the tags and fails on divergence.
