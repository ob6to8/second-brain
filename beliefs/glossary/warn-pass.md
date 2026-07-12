---
id: sb:de14e6
type: concept
title: warn pass
description: An advisory check that reports its findings without failing — the signal is a printed warning rather than a red gate — used where detection is mechanical but the underlying rule is tolerant or the judgment ultimately editorial.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, enforcement, tooling, ci]
timestamp: 2026-07-12
---

# warn pass

An advisory check that reports its findings without failing: the signal is a printed warning, never a non-zero exit, so it informs the next actor without blocking the pipeline. It is the [detector](/beliefs/glossary/detector.md) strength chosen when detection is mechanical but *enforcement* would overreach — because the underlying rule is deliberately tolerant (OKF conformance tolerates broken links) or the final judgment is editorial (whether an unlisted file *should* be listed). This brain has two: the route-tag ledger cross-check (row-level coverage, warns inside the `mix brain.route_tags` gate) and the docs-freshness pass (`SecondBrain.Links` — unresolved links and index-coverage gaps, printed by `mix brain.verify` on a green bundle). Contrast a gate, where the signal is a blocking failure.

*Seen in:* [docs-surface evaluation and the wiki question](/meta/analysis/docs-surface-evaluation-and-wiki-question.md), [the gate suite tutorial](/meta/tutorials/the-gate-suite-and-where-it-runs.md), [route-tagging policy](/meta/policy/route-tagging.md), [2026-07-12 docs-audit thread](/meta/threads/2026-07-12-docs-audit-wiki-verdict-and-freshness-warnings.md)
