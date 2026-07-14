---
id: em:683301
type: concept
title: drift class
description: A category of staleness whose instances share one detection mechanism — e.g. unresolved internal links, or files present in a directory but missing from its index — making the class as a whole checkable by a single detector.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, enforcement, corpus-health, tooling]
sense: repo
timestamp: 2026-07-12
attribution:
  when: 2026-07-12T09:43:37+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# drift class

A category of staleness whose instances all share one detection mechanism, making the whole class checkable by a single [detector](/beliefs/glossary/detector.md) rather than instance-by-instance vigilance. The docs audit identified two: **unresolved internal links** (a link's target no longer exists on disk) and **index-coverage gaps** (a file or subdirectory present in a directory but unlisted in its `index.md`) — both now announced by the docs-freshness [warn pass](/beliefs/glossary/warn-pass.md). Classifying drift this way separates what can be made structural from what stays editorial: a drift class with a mechanical oracle gets a detector; staleness without one (a README paragraph describing retired behavior) must be minimized by design instead, e.g. by keeping such prose a thin pointer into generated surfaces.

*Seen in:* [docs-surface evaluation and the wiki question](/meta/analysis/docs-surface-evaluation-and-wiki-question.md), [2026-07-12 docs-audit thread](/meta/threads/2026-07-12-docs-audit-wiki-verdict-and-freshness-warnings.md)
