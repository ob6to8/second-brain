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

Made explicit, the chain replaces the scattered backward citations it would otherwise live in: each [flow doc](/beliefs/glossary/flow-touch-sequence.md)'s `lineage:` [frontmatter](/beliefs/glossary/single-source-of-truth.md) block names the problem identified against evidence (the analysis), the design that answered it (the plan), the session that built it (the thread), and the pull request that merged it. The human-readable views — a per-doc blockquote, a cross-flow flowchart — are [materialized](/beliefs/glossary/materialize.md) from that block, never hand-kept, so the arc reads top-to-bottom and the upstream docs gain the forward pointer plain citations lack. The flow-scoped precursor of the [typed edges](/beliefs/glossary/typed-edge.md) an [epistemic overlay](/beliefs/glossary/epistemic-overlay.md) would generalize across all concepts.

*Seen in:* [2026-07-12 fuzzy-search spike and flow lineage thread](/meta/threads/2026-07-12-fuzzy-search-spike-and-flow-lineage.md)
