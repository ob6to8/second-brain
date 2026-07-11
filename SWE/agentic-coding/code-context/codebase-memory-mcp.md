---
id: sb:532b22
type: reference
title: "Codebase-Memory — tree-sitter code knowledge graph served over MCP"
description: An open-source system that parses a codebase into a persistent Tree-sitter knowledge graph and serves it to agents over MCP, answering structural queries with ~10× fewer tokens and 2.1× fewer tool calls than file-by-file exploration.
resource: https://github.com/DeusData/codebase-memory-mcp
provenance: "Distilled from the Codebase-Memory paper (arXiv:2603.27277, Vogel et al.) and its GitHub repo, fetched 2026-07-11"
tags: [code-intelligence, knowledge-graph, agentic-coding, mcp, tree-sitter, code-context, retrieval]
timestamp: 2026-07-11
---

# Codebase-Memory — tree-sitter code knowledge graph served over MCP

Codebase-Memory is an open-source system (Vogel, Meyer-Eschenbach, Kohler,
Grünewald, Balzer; arXiv:2603.27277, submitted 2026-03-28) that builds a
**persistent, commit-updatable knowledge graph** of a codebase and exposes it to
LLM coding agents over the **Model Context Protocol (MCP)**, so an agent reasons
over *structure* instead of repeatedly reading files. It is the same architectural
bet as [GitNexus](/SWE/agentic-coding/code-context/gitnexus.md) — precompute the
graph, serve it as tools — measured against a file-exploration baseline.

## How it builds the graph

A multi-phase pipeline over **66 languages** (Tree-sitter parsing):

1. Structure discovery.
2. Parallel definition extraction.
3. Call / usage / semantic resolution.
4. Enrichment — tests, HTTP routes, config, git co-change history.
5. Bulk insertion into SQLite with deferred indexing.
6. Post-index processing — Louvain community detection, file hashes.

It exposes **14 MCP tools** in four groups: Indexing (4), Query (4), Analysis (3),
Code (3).

## Results

Evaluated across **31 real-world repositories** (31 languages):

- **~10× fewer tokens** consumed than a file-exploration agent.
- **2.1× fewer tool calls**.
- **83% answer quality vs 92%** for the file-explorer — i.e. it trades a modest
  quality drop for a large efficiency gain, and matches or beats the explorer on
  *graph-native* queries (hub detection, caller ranking, impact) on 19 of 31
  languages.

## Why it matters for the brain

Concrete, benchmarked evidence for the **index-first vs. agentic-search** tradeoff
in [code-context](/SWE/agentic-coding/code-context/index.md): pre-built graphs cut
token/tool overhead sharply for structural questions, while raw file exploration
still edges out on open-ended answer quality. The natural quantitative companion to
the GitNexus capture, which described the same design without head-to-head numbers.

# Citations

- Paper — Codebase-Memory (arXiv:2603.27277) — <https://arxiv.org/abs/2603.27277>
- Repository — <https://github.com/DeusData/codebase-memory-mcp>
