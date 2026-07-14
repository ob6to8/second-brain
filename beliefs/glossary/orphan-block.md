---
id: em:3ee2d2
type: concept
title: orphan block
description: A block of generated output whose source has vanished — here, a dated per-thread block in a sink's excerpt log whose thread no longer tags that sink; the log fidelity check fails on it.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, routing, route-tagging, generated-artifacts]
sense: repo
timestamp: 2026-07-12
attribution:
  when: 2026-07-11T08:02:52+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# orphan block

A block of generated output whose source has vanished, leaving derived content
with nothing to re-derive it from. In this bundle: a dated per-thread block in
a [sink](/beliefs/glossary/route-tag-sink.md)'s
[excerpt log](/beliefs/glossary/excerpt-log.md) whose thread no longer
[tags](/beliefs/glossary/route-tag.md) that sink — the tag was removed or re-pointed,
or the thread deleted. `mix brain.route_tags`'s `log fidelity` check fails on
orphans, and [materialization](/beliefs/glossary/materialize.md) removes them
automatically — the two-directional projection built as P1 of the
[code-review toolchain hardening plan](/meta/plans/code-review-toolchain-hardening.md).

*Seen in:* [two-directional materialize elaboration](/meta/elaborations/two-directional-materialize.md), [route_tags materialize issue](/meta/issues/route-tags-materialize-leaves-orphan-blocks.md), [code-review toolchain hardening plan](/meta/plans/code-review-toolchain-hardening.md)
