---
id: em:3983f2
type: concept
title: hybrid search
description: Retrieval that combines a lexical ranker (typically BM25) with vector similarity, blending the two scores so exact-keyword precision and semantic matching cover each other's misses.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, search, retrieval, embeddings]
sense: common
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T18:20:51+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# hybrid search

Retrieval that combines a lexical ranker (typically [BM25](/beliefs/glossary/bm25.md)) with vector similarity from [embeddings](/beliefs/glossary/embeddings.md), blending the two scores — often with a fixed weighting and a minimum-score threshold — so exact-keyword precision and [semantic](/beliefs/glossary/semantic-search.md) matching cover each other's misses. It is the usual top tier of a staged retrieval strategy, adopted only once corpus size makes single-method [recall](/beliefs/glossary/recall.md) inadequate.

*Seen in:* [2026-07-11 deprecated-triage thread](/meta/threads/2026-07-11-deprecated-directory-triage-and-machinery-deletion.md), [AI agent memory management — when markdown files are all you need](/knowledge/SWE/agentic/context-engineering/ai-agent-memory-management-markdown-files.md)
