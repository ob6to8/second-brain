---
id: sb:e203a2
type: concept
title: stale block
description: A materialized excerpt-log block whose content no longer matches its re-derivation from the current tags — the source changed without re-materializing; caught by the log fidelity check, fixed by re-running --materialize.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, routing, route-tagging, generated-artifacts]
timestamp: 2026-07-12
---

# stale block

A [materialized](/glossary/materialize.md) block in a
[sink](/glossary/route-tag-sink.md)'s [excerpt log](/glossary/excerpt-log.md)
whose content no longer matches its re-derivation from the current tags — the
source moved (a tagged region edited, a region added or dropped) without the
log being re-materialized. The `log fidelity` check catches it and re-running
`--materialize` fixes it, because the whole section is rewritten from the
current [feeding pairs](/glossary/feeding-pairs.md). Distinct from an
[orphan block](/glossary/orphan-block.md), whose source *vanished entirely*
rather than merely changed.

*Seen in:* [code-review toolchain hardening plan](/meta/plans/code-review-toolchain-hardening.md), [route_tags materialize issue](/meta/issues/route-tags-materialize-leaves-orphan-blocks.md)
