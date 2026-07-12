---
id: sb:f97e44
type: concept
title: lineage
description: The provenance chain that produced an artifact — for a flow doc, the analysis → plan → thread → PR arc — recorded as a canonical frontmatter block from which human-readable views are derived.
provenance: "Agent-distilled glossary definition, 2026-07-12"
verified: false
tags: [glossary, provenance, flows, tooling]
timestamp: 2026-07-12
---

# lineage

The provenance chain that produced an artifact, made explicit rather than left implicit in scattered backward citations. For a [flow doc](/glossary/flow-touch-sequence.md), lineage is the arc `analysis → plan → thread → PR → flow` — the problem identified against evidence, the design that answered it, the session that built it, and the pull request that merged it — recorded as a canonical `lineage:` [frontmatter](/glossary/single-source-of-truth.md) block. Human-readable views (a per-doc blockquote, a cross-flow flowchart) are [materialized](/glossary/materialize.md) from that block, never hand-kept, so the arc reads top-to-bottom and the upstream docs gain the forward pointer plain citations lack. The flow-scoped precursor of the [typed edges](/glossary/typed-edge.md) an [epistemic overlay](/glossary/epistemic-overlay.md) would generalize across all concepts.

*Seen in:* [2026-07-12 fuzzy-search spike and flow lineage thread](/meta/threads/2026-07-12-fuzzy-search-spike-and-flow-lineage.md)
