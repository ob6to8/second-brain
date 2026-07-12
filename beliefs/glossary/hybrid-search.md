---
id: sb:3983f2
type: concept
title: hybrid search
description: Retrieval that combines a lexical ranker (typically BM25) with vector similarity, blending the two scores so exact-keyword precision and semantic matching cover each other's misses.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, search, retrieval, embeddings]
timestamp: 2026-07-12
---

# hybrid search

The blend is typically a fixed weighting of the [BM25](/beliefs/glossary/bm25.md) and [embeddings](/beliefs/glossary/embeddings.md) scores with a minimum-score threshold. It is the usual top tier of a staged retrieval strategy, adopted only once corpus size makes single-method [recall](/beliefs/glossary/recall.md) — lexical or [semantic](/beliefs/glossary/semantic-search.md) alone — inadequate.

*Seen in:* [2026-07-11 deprecated-triage thread](/meta/threads/2026-07-11-deprecated-directory-triage-and-machinery-deletion.md), [AI agent memory management — when markdown files are all you need](/knowledge/SWE/agentic-coding/context-engineering/ai-agent-memory-management-markdown-files.md)
