---
id: sb:f17e05
type: concept
title: deduplication
description: Detecting whether a candidate item already exists in a corpus before adding it, to avoid filing duplicates; here performed at intake by searching for semantically equivalent existing concepts.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, search, intake]
timestamp: 2026-07-12
---

# deduplication

Detecting whether a candidate item already exists in a corpus before adding it, to avoid filing duplicates (the update-in-place / don't-fragment rule). In this brain it is performed at intake time by searching for a semantically equivalent existing concept — whose reliability depends on search recall. The field comparison names intake dedup recall as the one semantic gate this brain's CI cannot cover: no [detector](/glossary/detector.md) exists for a near-duplicate, so a dedup miss is the entry point of the 500+ concept failure chain (duplicates fragment super-linearly — every future related fact lands on one twin arbitrarily, and the pair diverges).

*Seen in:* [2026-07-09 vector-DB recall thread](/meta/threads/2026-07-09-vector-db-recall-evaluation-and-analysis-type.md), [2026-07-11 news-digest thread](/meta/threads/2026-07-11-news-digest-intake-and-daily-read.md), [comparison with the 2026 second-brain field](/meta/analysis/comparison-with-the-2026-second-brain-field.md), [2026-07-12 docs-audit thread](/meta/threads/2026-07-12-docs-audit-wiki-verdict-and-freshness-warnings.md)
