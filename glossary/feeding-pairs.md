---
id: sb:c0ed08
type: concept
title: feeding pairs
description: The set of (thread, sink) pairs the current route tags induce — a thread feeds a sink when at least one of its tagged regions lists that sink's stable id; the set is the domain of materialization in both directions.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, routing, route-tagging]
timestamp: 2026-07-12
---

# feeding pairs

The set of (thread, [sink](/glossary/route-tag-sink.md)) pairs that the
current [route tags](/glossary/route-tag.md) induce: a thread *feeds* a sink
when at least one of its tagged regions lists that sink's
[stable id](/glossary/stable-id.md). The set is derived fresh from the tags on
every run — nothing stores it — and it is the domain of
[materialization](/glossary/materialize.md) in both directions: a sink inside
it gets its [excerpt log](/glossary/excerpt-log.md) (re)written, a sink outside
it loses the section.

*Seen in:* [code-review toolchain hardening plan](/meta/plans/code-review-toolchain-hardening.md), [session-capture flow](/meta/flows/session-capture.md)
