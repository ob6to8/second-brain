---
id: em:0a43ba
type: concept
title: sink (route-tag sink)
description: The document a route tag routes into and that accretes the aggregated excerpt log — referenced by a canonical id when it aggregates, or by a path for a non-aggregating back-link.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, routing, route-tagging]
sense: dual
timestamp: 2026-07-16
attribution:
  when: 2026-07-11T08:41:24+02:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# sink (route-tag sink)

In dataflow terminology, a sink is the endpoint that consumes or absorbs what flows into it — the counterpart of a source; data moves source → transforms → sink.

**In this brain:** a [route tag](/beliefs/glossary/route-tag.md) sink freezes acceptance of new excerpt blocks when its matter resolves. A sink left **unfed** — no thread's tags reference it anymore — loses its [excerpt log](/beliefs/glossary/excerpt-log.md) section on the next [materialize](/beliefs/glossary/materialize.md), since the section only ever mirrors the tags that exist.

*Seen in:* [2026-07-08 session-capture thread](/meta/threads/2026-07-08-adopt-session-capture-routing-and-route-tags.md), [code-review toolchain hardening plan](/meta/plans/code-review-toolchain-hardening.md)
