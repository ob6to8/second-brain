---
type: source
source_type: article
title: "OpenClaw Memory Architecture — Hybrid Search and Pre-Compaction Flush"
url: "https://www.mmntm.net/articles/openclaw-memory-architecture"
aliases: ["openclaw memory", "openclaw memory architecture"]
tags: [ai, agent-memory, vector-search, bm25, hybrid-search, sqlite, markdown]
authors: []
date_published: ""
date_captured: "2026-03-03"
summary: >
  Deep dive into OpenClaw's memory architecture: markdown files as canonical
  source of truth, SQLite with embeddings as derived index, hybrid search
  (70% vector + 30% BM25 = 89% recall), and pre-compaction flush that
  checkpoints memories before context overflow.
word_count: 1100
related:
  - "[[basic-memory-mcp-knowledge-graph]]"
  - "[[persistent-memory-for-openclaw-mem0-plugin]]"
---

## Core Design Philosophy

OpenClaw implements agent memory through pragmatic tradeoffs that prioritize accessibility and reliability. The system uses "plain Markdown as source of truth, hybrid search combining vectors with keywords, and a clever pre-compaction flush that saves memories before context overflow."

## File-Based Source of Truth

Rather than starting with databases, OpenClaw anchors memory in three Markdown-based layers:

1. **MEMORY.md** - Curated, long-term facts and preferences the agent should always retain
2. **memory/YYYY-MM-DD.md** - Append-only daily logs where agents write running notes during sessions
3. **SQLite Index** - A derived layer at `~/.openclaw/memory/{agentId}.sqlite` storing chunked embeddings for rapid semantic retrieval

The critical principle: "The index is derived, the files are canonical." This means debugging involves reading text files rather than querying databases, enabling `grep` searches and `git diff` version tracking.

## Hybrid Search Strategy

Rather than requiring results to score well on both vector and keyword metrics, OpenClaw employs a **union-based approach**. This means:

- Results from either semantic or keyword search contribute to final rankings
- A chunk scoring high on vector similarity but containing no keywords still surfaces (with `textScore: 0`)
- Conversely, exact keyword matches without semantic similarity still appear (with `vectorScore: 0`)

The default weighting assigns "70% vector, 30% keyword," allowing tuning based on use case priorities.

## Technical Implementation Details

**BM25 Rank Normalization:** Keyword search returns ordinal ranks (1st, 2nd, 3rd) rather than normalized scores. The system converts these using the formula `1 / (1 + normalized)`, where rank 0 becomes 1.0, rank 1 becomes 0.5, and rank 9 becomes 0.1.

**Keyword Query Building:** Raw queries tokenize into AND-logic FTS5 queries. The phrase "commit hash" becomes `"commit" AND "hash"`, making keyword search strict for exact matches while preventing false positives from partial word overlaps.

## Pre-Compaction Memory Flush

When context windows fill and compaction occurs, OpenClaw triggers an automatic intervention prompting agents to save important information before older messages get summarized and discarded.

The flush activation checks three conditions:
- Total tokens exceed a calculated threshold
- The threshold equals context window minus reserve floor minus soft threshold buffer
- The flush hasn't already executed for the current compaction cycle

A default soft threshold of "4,000 tokens" provides headroom before hard limits trigger compaction, effectively creating checkpoints that preserve memories during destructive operations.

## Embedding Provider Strategy

The system implements graceful degradation through a local-first, cloud-fallback approach:

1. **Local** (ggml models like embedding-gemma-300M) - if configured and model files exist
2. **OpenAI** (text-embedding-3-small) - if API credentials present
3. **Gemini** - if API credentials present

If all embeddings fail, the system degrades to BM25-only keyword search rather than breaking entirely.

## Content Chunking with Overlap Preservation

Before embedding, Markdown files split into chunks preserving context across boundaries. The default configuration targets "400 tokens (~1,600 characters)" per chunk with "80 tokens (~320 characters)" of overlap between consecutive chunks. This overlap ensures sentences spanning chunk boundaries appear in multiple chunks, improving retrieval for queries matching that sentence.

## Memory as an Agent Tool

Agents access memory through a `memory_search` tool explicitly described as a "Mandatory recall step: semantically search MEMORY.md + memory/*.md... before answering questions about prior work, decisions, dates, people, preferences, or todos."

The tool description teaches models *when* to use memory—during questions about prior context—not just *how* to invoke it.

## Key Design Patterns

Five transferable principles emerge from this architecture:

- **Files as authoritative source** enable debugging through reading rather than querying
- **Hybrid search as weighted union** succeeds with either vector or keyword approaches alone
- **Pre-compaction flush** converts destructive operations into checkpoints
- **Graceful degradation** allows partial failures without complete system breakdown
- **Local-first priority** maintains offline capability with cloud fallback
