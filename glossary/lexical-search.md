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
