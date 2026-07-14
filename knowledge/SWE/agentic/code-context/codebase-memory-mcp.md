---
id: em:532b22
type: reference
title: "Codebase-Memory — tree-sitter code knowledge graph served over MCP"
description: An open-source system that parses a codebase into a persistent Tree-sitter knowledge graph and serves it to agents over MCP, answering structural queries with ~10× fewer tokens and 2.1× fewer tool calls than file-by-file exploration.
resource: https://github.com/DeusData/codebase-memory-mcp
provenance: "Distilled from the Codebase-Memory paper (arXiv:2603.27277, Vogel et al.) and its GitHub repo, fetched 2026-07-11"
tags: [code-intelligence, knowledge-graph, agentic, mcp, tree-sitter, code-context, retrieval]
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T17:29:20+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# Codebase-Memory — tree-sitter code knowledge graph served over MCP

Codebase-Memory is an open-source system (Vogel, Meyer-Eschenbach, Kohler,
Grünewald, Balzer; arXiv:2603.27277, submitted 2026-03-28) that builds a
**persistent, commit-updatable knowledge graph** of a codebase and exposes it to
LLM coding agents over the **Model Context Protocol (MCP)**, so an agent reasons
over *structure* instead of repeatedly reading files. It is the same architectural
bet as [GitNexus](/knowledge/SWE/agentic/code-context/gitnexus.md) — precompute the
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
in [code-context](/knowledge/SWE/agentic/code-context/index.md): pre-built graphs cut
token/tool overhead sharply for structural questions, while raw file exploration
still edges out on open-ended answer quality. The natural quantitative companion to
the GitNexus capture, which described the same design without head-to-head numbers.

# Citations

- Paper — Codebase-Memory (arXiv:2603.27277) — <https://arxiv.org/abs/2603.27277>
- Repository — <https://github.com/DeusData/codebase-memory-mcp>

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:532b22">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-11-news-digest-intake-and-daily-read (2026-07-11)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:532b22`]**  (co-feeds: `em:1cac23 em:f02167 em:c29a22 em:8b9548 em:49eae4`)

Both jobs are done and pushed to `claude/news-feature-w5dsgl`.

**1. Intaked all 6 candidates**

Each is now a permanent bundle concept — ids minted, registry recompiled, indexes and root log updated, digest lines marked `✓ intaken`. All fit existing directories, so no taxonomy ratification was needed. Bundle verifies clean.

| Concept | id | Filed under | Extends |
|---|---|---|---|
| Codebase-Memory (paper + repo) | `em:532b22` | code-context | GitNexus `em:b89ea1` |
| VeriCache — lossless KV cache | `em:1cac23` | llm-engineering | KV-cache history `em:266c5e` |
| PARC — self-reflective long-horizon agent | `em:f02167` | agentic-loop | — |
| METR agent time-horizons | `em:c29a22` | agentic-loop | — |
| Git worktrees for parallel agents | `em:8b9548` | version-control/git | branches note `em:4c9e1f` |
| State of AI Coding 2026 (New Relic) | `em:49eae4` | testing | test-features `em:a5ea86` |

One judgment call worth flagging: I captured **Codebase-Memory the paper and its repo as one concept** (resource = the GitHub repo, arXiv cited in the body) rather than two files — the anti-fragmentation policy says one project = one concept, matching how GitNexus was filed. PARC and time-horizons landed under a new **"Reliability & long-horizon"** section of the agentic-loop index. Say the word if you'd rather split Codebase-Memory into a separate paper `source` + tool `reference`.
