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

Detecting whether a candidate item already exists in a corpus before adding it, to avoid filing duplicates (the update-in-place / don't-fragment rule). In this brain it is performed at intake time by searching for a semantically equivalent existing concept — whose reliability depends on search [recall](/beliefs/glossary/recall.md), measured by the [recall probe](/beliefs/glossary/recall-probe.md) and improved at the entry gate by [synonym expansion](/beliefs/glossary/synonym-expansion.md) over the [lexical search](/beliefs/glossary/lexical-search.md) backend. The field comparison names intake dedup recall as the one semantic gate this brain's CI cannot cover: no [detector](/beliefs/glossary/detector.md) exists for a near-duplicate, so a dedup miss is the entry point of the 500+ concept failure chain (duplicates fragment super-linearly — every future related fact lands on one twin arbitrarily, and the pair diverges).

*Seen in:* [2026-07-09 vector-DB recall thread](/meta/threads/2026-07-09-vector-db-recall-evaluation-and-analysis-type.md), [2026-07-11 news-digest thread](/meta/threads/2026-07-11-news-digest-intake-and-daily-read.md), [comparison with the 2026 second-brain field](/meta/analysis/comparison-with-the-2026-second-brain-field.md), [2026-07-12 dedup recall probe thread](/meta/threads/2026-07-12-dedup-recall-probe-and-synonym-intake.md), [2026-07-12 docs-audit thread](/meta/threads/2026-07-12-docs-audit-wiki-verdict-and-freshness-warnings.md)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="sb:f17e05">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-12-news-auto-intake-featured-items (2026-07-12)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:f17e05`]**

**What "dedup" means**

**Dedup (deduplication)** here is one specific step inside `/intake`: *before* creating a new file, search the brain for a concept that's already about the same subject, so you **update that one in place** instead of spawning a near-duplicate. It's the machinery that enforces the contract's *"update-in-place, don't fragment"* rule. When you say "intake this margin-collapse piece" and the brain already has `sb:07610c` on exactly that, dedup is what's supposed to notice `sb:07610c` exists and route the new material *into* it rather than beside it.

So dedup isn't about the news feed's two dedup passes (those drop items already surfaced). It's the *intake-side* question: "does a home for this already exist in the bundle?"
