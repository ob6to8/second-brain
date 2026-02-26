---
title: "We built persistent memory for Cline — Here's what we learned"
url: "https://www.reddit.com/r/openclaw/comments/1regq4c/we_built_persistent_memory_for_openclaw_heres/"
aliases: ["mem0 cline plugin", "cline persistent memory"]
tags: [ai, agent-memory, context-engineering, cline, mem0, vector-search]
source: "r/openclaw (Reddit)"
authors: ["singh_taranjeet"]
date_published: "2025-02-26"
date_captured: "2026-02-25"
summary: >
  Mem0 team describes building a Cline plugin that moves memory outside the
  context window — auto-recall injects relevant memories each turn, auto-capture
  persists new facts after each response. Claims this solves compaction-induced
  forgetting. Community pushback notes Cline already has built-in vector + SQLite
  memory that survives compaction.
content_type: article
word_count: 1200
related:
  - "[[context-engineering-and-persistent-agent-memory]]"
---

## Key Claims

Cline agents are stateless between sessions. The default memory (MEMORY.md files) lives inside the context window, so context compaction can summarize, rewrite, or drop it.

The Mem0 plugin moves memory **outside the context window** via two automatic processes:

1. **Auto-Recall** — before each response, searches Mem0 for memories relevant to the current message and injects them into working context
2. **Auto-Capture** — after each response, sends the exchange to Mem0's extraction layer which decides what to persist, update, or merge

Memory is split into two scopes:
- **Long-term** (user-scoped) — persists across all sessions (name, tech stack, decisions)
- **Short-term** (session-scoped) — tracks active work without polluting the long-term store

Both scopes are searched every recall, long-term surfaced first.

## Explicit Tools

The plugin also exposes five tools for manual memory management:
- `memory_search` — semantic queries across all memories
- `memory_store` — explicitly save a fact
- `memory_list` — view all stored memories
- `memory_get` — retrieve by ID
- `memory_forget` — delete (GDPR-compliant)

## Self-hosted Option

Can run fully local: Ollama for embeddings, Qdrant for vectors, Anthropic for LLM. No Mem0 API key needed in open-source mode.

## Community Pushback

Several commenters pushed back on the premise:

- **nightofgrim**: "Cline already does this [...] The markdown files are just a mechanism for the agent to write things down for them to be indexed properly."
- **sprfrkr**: "When compaction runs, anything important in context gets written to MEMORY.md before compaction occurs and added to embeddings semantic search (if enabled) for lifetime retrieval." Links to Cline's built-in vector + SQLite memory docs.
- **iridescent_herb**: Compared mem0, memos, and hindsight — mem0 worked best out of the box. Asked about multi-agent isolation.

## Interesting Comment: 3-Layer Codex Card System

**Important_Quote_1180** described a different approach:
- Layer 0: one sentence describing the tech
- Layer 1: paragraph with rich description and connectors
- Layer 2: full code and wiki
- Claims dramatically reduced API calls with rigorous forced reading calls

## Relevance to Second Brain

This post directly addresses the same problem as [[context-engineering-and-persistent-agent-memory]]: the context window is treated as the source of truth but is actually a lossy viewport. The mem0 approach (external memory with auto-recall/auto-capture) is one architecture. The `llm` CLI + SQLite approach from our conversation is another — with the advantage of full transparency and user inspectability.

The 3-layer codex card system is interesting — it's essentially a tiered index, similar to our `index.json` (scan layer) → full `.md` files (detail layer) pattern, but with an explicit middle tier.
