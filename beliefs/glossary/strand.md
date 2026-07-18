---
id: em:bb2968
type: concept
title: strand
description: One topic's line of work through a session — the unit a routing ledger tracks, one row per strand, carrying a state (open/paused/closed) orthogonal to where its content was routed.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, routing, capture, session-init]
sense: repo
timestamp: 2026-07-16
attribution:
  when: 2026-07-11T18:52:27+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# strand

A session touches many matters; each matter's thread — picked up, paused on an open question, resumed, resolved — is a distinct strand that the [routing ledger](/beliefs/glossary/routing-ledger.md) gives its own row. State and where the strand was filed are independent axes: a live strand may already be routed, and a resolved one may never be. A **dangling strand** is one whose state or unanswered question leaves work outstanding after the thread is frozen; the [session-init digest](/beliefs/glossary/session-init-digest.md) harvests these from all captured threads so they surface as open work in later sessions.

*Seen in:* [routing-ledger policy](/meta/policy/routing-ledger.md), [2026-07-11 session-init thread](/meta/threads/2026-07-11-session-init-digest-and-priorities.md)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:bb2968">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-11-deprecated-directory-triage-and-machinery-deletion (2026-07-11)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:bb2968`]**

**Glossary results:**
- **Added** [strand](/glossary/strand.md) (`em:bb2968`) — one topic's line of work through a session: the unit the routing ledger tracks one row per, with a state (`open`/`paused`/`closed`) orthogonal to where its content routed, and "dangling strand" defined as the form the session-init digest harvests.
- **Merged, not duplicated:** *ledger* is the same concept as the existing [routing ledger](/glossary/routing-ledger.md) entry, so per the one-term-one-file rule that entry got the short-form note ("often shortened to just 'the ledger'") and a prose cross-link to *strand*, rather than a second file.
- All gates green; registry refreshed; root `log.md` updated. Glossary at 86 terms.
