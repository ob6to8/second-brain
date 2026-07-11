---
type: elaboration
title: two-directional materialize with unconditional orphan-block removal
description: Unpacks the P1 work-package phrase from the code-review hardening plan — making the route-tag log materializer remove generated content whose source tags vanished, automatically and without a flag.
provenance: "Phrase coined in the 2026-07-11 code-review session (P1 of /meta/plans/code-review-toolchain-hardening.md); expansion agent-authored via /elaborate, 2026-07-11"
tags: [elaboration, route-tagging, materialize, tooling]
timestamp: 2026-07-11
---

# two-directional materialize with unconditional orphan-block removal

> "two-directional materialize with unconditional orphan-block removal"
> — P1 of the [code-review toolchain hardening plan](/meta/plans/code-review-toolchain-hardening.md),
> resolving the issue
> [route_tags: materialize cannot remove orphaned excerpt blocks](/meta/issues/route-tags-materialize-leaves-orphan-blocks.md).

## In plain terms

Some documents in this knowledge base contain a summary section that is
written by a program, not by hand. The program builds each summary from
markers placed in conversation records: add a marker, and the matching summary
gains an entry. Today the program only ever *adds and refreshes* — if a marker
is later removed, the entry it once produced just stays behind, and the
checking tool complains about it forever, because the one thing you're not
allowed to do is delete it by hand. The phrase describes the fix: teach the
program to *remove* what no longer has a source, just as readily as it adds
what does — and to do so automatically, without a special option or
confirmation.

## The terms

- **materialize** — to compute derived content and write it to disk as
  ordinary file content, instead of recomputing it on demand. Here it names
  `mix brain.route_tags --materialize`
  ([`SecondBrain.RouteTags.materialize/1`](/lib/second_brain/route_tags.ex)),
  which writes each concept's excerpt log from the current tags; the log is
  "generated, never hand-kept."
- **[route tag](/glossary/route-tag.md)** — an inline `<routes ref="…">`
  region marking which concept(s) a paragraph of a frozen thread feeds;
  canonically defined by the
  [route-tagging policy](/meta/policy/route-tagging.md).
- **[sink](/glossary/route-tag-sink.md)** — the concept document a route tag
  routes into, which accretes the aggregated log.
- **excerpt log** — the `## Thread excerpts — route-tagged log` section inside
  a sink: per-thread, date-stamped blocks, each lifting the tagged regions
  whole. It is the materialized output.
- **orphan block** — a dated block in a sink's excerpt log whose thread no
  longer tags that sink (the tag was removed or re-pointed, or the thread
  deleted): generated content whose source has vanished. The `log fidelity`
  check fails on it.
- **two-directional** — the materialization becomes a true *projection* of the
  tags: additions in the source appear in the output **and** removals in the
  source disappear from the output. Today it is one-directional (add/refresh
  only).
- **unconditional** — the removal needs no flag and no confirmation gate; it
  happens as a normal part of materializing.

## What's actually happening

When a session is captured, its [thread doc](/glossary/thread-doc.md) carries
route tags saying "this paragraph feeds concept X." Running the materializer
collects every currently-tagged (thread, concept) pair and rewrites each fed
concept's excerpt-log section from scratch. The gap: a concept that *used to*
be fed but whose **last** feeding tag is gone is simply never visited — its
stale section stays on disk, the verifier correctly fails on the orphan, and
no tool fixes it, because hand-editing a generated section is forbidden. In
effect, it's a spreadsheet whose summary column updates when you add rows but
not when you delete them.

The fix makes the materializer also visit every concept that *carries* a log
section but no longer appears among the fed pairs, and delete that section.
"Unconditional" is the design decision about how: no `--force` flag, because
the tags are the single source of truth — a vanished tag *must* vanish from
the sink or the two diverge — and the safety net is review, not the tool: the
deletion shows up plainly in the PR diff, which is where a mistakenly-removed
tag gets caught, the same as any other change to a generated artifact.
