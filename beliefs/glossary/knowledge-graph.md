---
id: em:7498cf
type: concept
title: knowledge graph
description: A structured representation of entities as nodes and their relationships as typed edges, queryable by traversing edges rather than scanning text; a code knowledge graph applies this to a codebase's files, symbols, calls, and imports.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, knowledge-graph, code-intelligence, graph, retrieval]
sense: common
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T18:01:58+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# knowledge graph

A representation of a domain as **nodes** (entities) joined by **typed edges**
(relationships), so questions are answered by *traversing* the graph rather than
scanning prose or embeddings. A **code knowledge graph** applies this to a codebase —
files, symbols, functions as nodes; `CALLS`, `IMPORTS`, `EXTENDS` as edges — letting a
coding agent query architecture and impact ("what calls this?") directly instead of
reading files one by one. It is the supply-side structure that tools like GitNexus and
Codebase-Memory precompute (via [Tree-sitter](/beliefs/glossary/tree-sitter.md)) and serve over
[MCP](/beliefs/glossary/model-context-protocol.md).

*Seen in:* [2026-07-11 news-digest thread](/meta/threads/2026-07-11-news-digest-intake-and-daily-read.md), [Codebase-Memory](/knowledge/SWE/agentic/code-context/codebase-memory-mcp.md), [GitNexus](/knowledge/SWE/agentic/code-context/gitnexus.md)
