---
id: sb:792b23
type: concept
title: lexical search
description: Search that matches on the literal surface form of text — tokens or substrings — rather than meaning; fast and dependency-free, but blind to synonym and jargon gaps.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, search]
timestamp: 2026-07-12
---

# lexical search

Search that matches on the literal surface form of text — tokens or substrings, case-folded at most — rather than on meaning. It is fast, deterministic, and dependency-free (a `grep`-class match, or a ranked variant like [BM25](/glossary/bm25.md)), which is why it is the default backend for intake [deduplication](/glossary/deduplication.md) here. Its blind spot is vocabulary mismatch: it cannot bridge synonym/jargon gaps the way [semantic search](/glossary/semantic-search.md) or [hybrid search](/glossary/hybrid-search.md) can — the gap that [synonym expansion](/glossary/synonym-expansion.md) papers over without embeddings.

*Seen in:* [2026-07-12 dedup recall probe thread](/meta/threads/2026-07-12-dedup-recall-probe-and-synonym-intake.md)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="sb:792b23">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-12-news-auto-intake-featured-items (2026-07-12)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:792b23`]**

**What the problem is**

The intake dedup search is currently **lexical** — it matches on shared words (case-insensitive match over titles, descriptions, tags, bodies). Two failure modes:

- **Same concept, different words** → missed. "Margin collapse" vs "inference gross margins eroding under open-weight parity" share almost no tokens, so lexical search returns nothing, intake concludes "no home exists," and creates a duplicate. This is a **recall** failure — *recall* = of the concepts that genuinely should have matched, what fraction did the search actually surface. Low recall → silent fragmentation.
- The plan cites the hard number: a hand-run probe found **~6 of 14** natural-phrasing queries *missed their existing target* at just **39 concepts**. That's the un-fixed weak point. It's masked today only because the corpus is small enough that the agent holds much of it in context — a subsidy that "expires as the corpus outgrows agent context." Which is precisely what auto-intake accelerates.
