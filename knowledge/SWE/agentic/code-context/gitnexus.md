---
id: em:b89ea1
type: reference
title: "GitNexus — client-side code knowledge graph for agent context"
description: A zero-server tool that parses a codebase into a multi-layered knowledge graph (calls, imports, clusters, execution flows) and serves it to coding agents over MCP so they get architectural context in one query.
resource: https://github.com/abhigyanpatwari/GitNexus
provenance: "Distilled from the GitNexus GitHub repository README (Abhigyan Patwari), fetched 2026-07-06"
tags: [code-intelligence, knowledge-graph, agentic, mcp, tree-sitter, code-analysis, ai-agents]
timestamp: 2026-07-06
attribution:
  when: 2026-07-06T16:07:40+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# GitNexus — client-side code knowledge graph for agent context

GitNexus is a client-side "code intelligence engine" that builds a knowledge graph
of a codebase and exposes it to AI coding agents. Its tagline: *"The nervous system
for agent context."* The premise is that coding agents (Claude Code, Cursor, etc.)
miss dependencies and break call chains because they explore a repo one file at a
time; GitNexus **precomputes** structure — dependencies, call chains, clusters,
execution flows — so an agent gets architectural context in a single query rather
than many exploratory tool calls. It is the supply side of
[context engineering for the agent loop](/knowledge/SWE/agentic/agentic-loop/effective-context-engineering-for-agents.md).

## How it builds the graph

1. Parse files into ASTs with **Tree-sitter**.
2. Resolve imports, calls, and type relationships across files into typed edges
   (`CALLS`, `IMPORTS`, `EXTENDS`, `IMPLEMENTS`) carrying confidence scores.
3. Cluster related symbols into functional communities (Leiden community detection).
4. Trace execution flows ("processes") from entry points through call chains.
5. Build hybrid search indexes (BM25 + semantic embeddings + reciprocal rank fusion).

## Architecture & execution

- **Two runtimes:** a Node.js CLI (native Tree-sitter bindings, embedded database) and
  a browser Web UI built on WASM (Tree-sitter WASM, an embedded WASM vector DB,
  transformers.js for embeddings) — so it can run with no server.
- **Agent interface:** a Model Context Protocol (MCP) server exposing a set of tools
  over stdio (`impact`, `query`, `context`, `trace`, `cypher`, …), mirrored as CLI
  subcommands. Queries are **explicit tool parameters, not free-text NL→Cypher**.
- **Visualization:** WebGL graph explorer (Sigma.js + Graphology).
- **Languages:** broad Tree-sitter coverage (TypeScript/JavaScript, Python, Java,
  Kotlin, C#, Go, Rust, PHP, Ruby, Swift, C/C++, Dart) with varying feature depth.

## Notable capabilities

- **Impact analysis / "blast radius"** — what depends on a symbol, grouped by depth.
- **Process-grouped search** — hybrid results grouped by execution flow.
- **360° symbol context** — incoming/outgoing calls and process participation.
- **Git-diff impact** — maps changed lines to affected processes.
- **Raw Cypher** — Neo4j-style graph queries.
- **Auto MCP setup** — detects and wires supported editors/agents.

## Meta

- **License:** PolyForm Noncommercial 1.0.0 (noncommercial use of the OSS version;
  commercial licensing offered separately).
- **Author:** Abhigyan Patwari ([@abhigyanpatwari](https://github.com/abhigyanpatwari)).
- Actively developed, with Docker support and published documentation. (Specific
  star/version/commit figures from the fetch are omitted as unverified.)

# Citations

GitNexus repository — <https://github.com/abhigyanpatwari/GitNexus>
