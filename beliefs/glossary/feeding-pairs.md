---
id: sb:c0ed08
type: concept
title: feeding pairs
description: The set of (thread, sink) pairs the current route tags induce — a thread feeds a sink when at least one of its tagged regions lists that sink's stable id; the set is the domain of materialization in both directions.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, routing, route-tagging]
sense: repo
timestamp: 2026-07-12
attribution:
  when: 2026-07-12T09:10:24+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# feeding pairs

The set of (thread, [sink](/beliefs/glossary/route-tag-sink.md)) pairs that the
current [route tags](/beliefs/glossary/route-tag.md) induce: a thread *feeds* a sink
when at least one of its tagged regions lists that sink's
[stable id](/beliefs/glossary/stable-id.md). The set is derived fresh from the tags on
every run — nothing stores it — and it is the domain of
[materialization](/beliefs/glossary/materialize.md) in both directions: a sink inside
it gets its [excerpt log](/beliefs/glossary/excerpt-log.md) (re)written, a sink outside
it loses the section.

*Seen in:* [code-review toolchain hardening plan](/meta/plans/code-review-toolchain-hardening.md), [session-capture flow](/meta/flows/session-capture.md)
