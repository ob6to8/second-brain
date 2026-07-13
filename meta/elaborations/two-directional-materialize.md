---
type: elaboration
title: two-directional materialize with unconditional orphan-block removal
description: Unpacks the P1 work-package phrase from the code-review hardening plan — the route-tag log materializer removing generated content whose source tags vanished, automatically and without a flag; proposed 2026-07-11, built 2026-07-12.
provenance: "Phrase coined in the 2026-07-11 code-review session (P1 of /meta/plans/code-review-toolchain-hardening.md); expansion agent-authored via /elaborate, 2026-07-11; refreshed 2026-07-12 after P1 landed"
tags: [elaboration, route-tagging, materialize, tooling]
timestamp: 2026-07-12
attribution:
  when: 2026-07-11T07:59:33+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-12-code-review-flows-hardening-and-elaborations.md]
---

# two-directional materialize with unconditional orphan-block removal

> "two-directional materialize with unconditional orphan-block removal"
> — P1 of the [code-review toolchain hardening plan](/meta/plans/code-review-toolchain-hardening.md),
> coined 2026-07-11 and **built 2026-07-12**, resolving the issue
> [route_tags: materialize cannot remove orphaned excerpt blocks](/meta/issues/route-tags-materialize-leaves-orphan-blocks.md).

## In plain terms

Some documents in this knowledge base contain a summary section that is
written by a program, not by hand. The program builds each summary from
markers placed in conversation records: add a marker, and the matching summary
gains an entry. The program used to work in one direction only — it added and
refreshed, but if a marker was later removed, the entry it once produced
stayed behind, and the checking tool complained about it forever, because the
one thing you're not allowed to do is delete it by hand. The phrase names the
fix, now built: the program removes what no longer has a source just as
readily as it adds what does — automatically, with no special option or
confirmation.

## The terms

- **[materialize](/beliefs/glossary/materialize.md)** — to compute derived content and write it to disk as
  ordinary file content, instead of recomputing it on demand. Here it names
  `mix brain.route_tags --materialize`
  ([`SecondBrain.RouteTags.materialize/1`](/lib/second_brain/route_tags.ex)),
  which maintains each concept's excerpt log from the current tags; the log is
  "generated, never hand-kept."
- **[route tag](/beliefs/glossary/route-tag.md)** — an inline `<routes ref="…">`
  region marking which concept(s) a paragraph of a frozen thread feeds;
  canonically defined by the
  [route-tagging policy](/meta/policy/route-tagging.md).
- **[sink](/beliefs/glossary/route-tag-sink.md)** — the concept document a route tag
  routes into, which accretes the aggregated log.
- **[excerpt log](/beliefs/glossary/excerpt-log.md)** — the `## Thread excerpts — route-tagged log` section inside
  a sink: per-thread, date-stamped blocks, each lifting the tagged regions
  whole. It is the materialized output.
- **[feeding pairs](/beliefs/glossary/feeding-pairs.md)** — the (thread, sink) pairs
  the current tags induce: derived fresh on every run, never stored, and the
  domain the materialization projects — in both directions.
- **[orphan block](/beliefs/glossary/orphan-block.md)** — a dated block in a sink's excerpt log whose thread no
  longer tags that sink (the tag was removed or re-pointed, or the thread
  deleted): generated content whose source has vanished. Distinct from a
  [stale block](/beliefs/glossary/stale-block.md), whose source merely *changed*
  without re-materializing.
- **two-directional** — the materialization is a true *projection* of the
  tags: additions in the source appear in the output **and** removals in the
  source disappear from the output. (Before P1 it was one-directional —
  add/refresh only.)
- **unconditional** — the removal needs no flag and no confirmation gate; it
  happens as a normal part of materializing.

## What's actually happening

When a session is captured, its [thread doc](/beliefs/glossary/thread-doc.md) carries
route tags saying "this paragraph feeds concept X." The materializer collects
the feeding pairs and rewrites each fed concept's excerpt-log section from
scratch. The gap it used to have: a concept that *had been* fed but whose
**last** feeding tag was gone was simply never visited — its dead section
stayed on disk, the verifier correctly failed on the orphan, and no tool could
fix it, because hand-editing a generated section is forbidden. In effect, a
spreadsheet whose summary column updated when you added rows but not when you
deleted them.

The fix, landed as P1: the materializer now also visits every concept that
*carries* a log section but no longer appears among the feeding pairs, and
deletes that section. "Unconditional" was the settled design decision — no
`--force` flag, because the tags are the single source of truth (a vanished
tag *must* vanish from the sink or the two diverge), and the safety net is
review, not the tool: the deletion shows up plainly in the PR diff, which is
where a mistakenly-removed tag gets caught, the same as any other change to a
generated artifact. Two scenario tests in
[capture_scenario_test.exs](/test/second_brain/capture_scenario_test.exs) pin
the behavior: a sink losing its last feeding thread loses its whole section,
and a still-fed sink drops one departed thread's block.
