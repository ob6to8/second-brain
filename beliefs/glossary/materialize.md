---
id: sb:15fe73
type: concept
title: materialize
description: To compute derived content and write it to disk as ordinary file content, instead of recomputing it on demand — trading always-fresh derivation for inspectability, at the cost of needing a freshness check.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, tooling, generated-artifacts]
timestamp: 2026-07-13
---

# materialize

Inspectability here means readable and diffable without running the tool; the paired freshness check re-derives and compares (the generated-not-hand-kept discipline). In this bundle the term names `mix brain.route_tags --materialize`
([`SecondBrain.RouteTags.materialize/1`](/lib/second_brain/route_tags.ex)),
a **two-directional projection** of the current
[route tags](/beliefs/glossary/route-tag.md): it writes each fed
[sink](/beliefs/glossary/route-tag-sink.md)'s
[excerpt log](/beliefs/glossary/excerpt-log.md) from its
[feeding pairs](/beliefs/glossary/feeding-pairs.md) and removes the section of any
sink no longer fed; `CLAUDE.md`, `meta/registry.md`, and the glossary index's
`## Terms` section (`mix brain.glossary --materialize`) are materializations
in the same sense.

*Seen in:* [two-directional materialize elaboration](/meta/elaborations/two-directional-materialize.md), [code-review toolchain hardening plan](/meta/plans/code-review-toolchain-hardening.md), [route-tagging policy](/meta/policy/route-tagging.md), [2026-07-12 root-reorganization thread](/meta/threads/2026-07-12-root-reorganization-knowledge-and-beliefs.md), [2026-07-13 glossary single-overview thread](/meta/threads/2026-07-13-glossary-single-overview-dedup-and-check.md)
