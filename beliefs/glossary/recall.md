---
id: sb:5e7da1
type: concept
title: recall
description: In information retrieval, the fraction of relevant items that a search actually surfaces for a query; low recall means existing relevant material is missed.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, search, information-retrieval]
timestamp: 2026-07-12
---

# recall

In information retrieval, the fraction of relevant items that a search actually surfaces for a query. Low recall means existing relevant material is missed — the failure mode that matters for [dedup](/beliefs/glossary/deduplication.md) at intake time.

A **recall failure** at intake sets off a quiet chain: intake dedup runs a [lexical search](/beliefs/glossary/lexical-search.md) for an existing home; because that search misses the semantically-equivalent concept (it shares meaning but not enough surface tokens), intake concludes *nothing exists* and files a **new** concept beside the one it should have updated. Nothing errors — the miss is invisible at write time — so the duplicate lands silently and the two concepts drift apart, splitting one subject's knowledge across [residual fragments](/beliefs/glossary/residual-fragmentation.md). That is why low recall is dangerous rather than merely lossy: it converts a retrieval gap into committed [fragmentation](/beliefs/glossary/deduplication.md) that only a later editorial pass, not an error message, can catch.

*Seen in:* [2026-07-09 vector-DB recall thread](/meta/threads/2026-07-09-vector-db-recall-evaluation-and-analysis-type.md), [dedup-recall-probe plan](/meta/plans/dedup-recall-probe.md)

*See also:* [recall probe](/beliefs/glossary/recall-probe.md), [recall@k](/beliefs/glossary/recall-at-k.md), [lexical search](/beliefs/glossary/lexical-search.md), [residual fragmentation](/beliefs/glossary/residual-fragmentation.md)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="sb:5e7da1">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-12-news-auto-intake-featured-items (2026-07-12)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:5e7da1`]**  (co-feeds: `sb:96a610`)

**`/elaborate`: low recall → silent fragmentation**

This is now written into `recall.md`, but plainly: intake dedup fires a **lexical** search for an existing home for the new item. Because lexical search matches shared *words*, not *meaning*, it misses a concept that says the same thing in different terms (the recall failure). Intake therefore concludes "nothing exists" and files a **new** concept next to the one it should have updated. Crucially, **nothing errors** — the miss is invisible at write time — so the duplicate lands *silently*, gets committed to history, and the two files drift apart. That's why low recall is dangerous rather than merely lossy: it quietly converts a retrieval gap into committed fragmentation that only a later editorial pass, never an error message, can catch. (This is exactly the debt Fork A is meant to avoid paying.)
