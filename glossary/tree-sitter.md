---
id: sb:1efc5e
type: concept
title: Tree-sitter
description: An incremental parser-generator and library that builds a concrete syntax tree for source code across many languages, fast enough to reparse on every edit — the parsing layer code-intelligence tools use to extract structure.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, tree-sitter, parsing, code-intelligence, ast]
timestamp: 2026-07-11
---

# Tree-sitter

An incremental **parser-generator** and runtime library that produces a concrete
syntax tree for source code, with grammars for many languages and reparsing fast
enough to run on each keystroke. Code-intelligence tools use it as their front end:
parse files into syntax trees, then walk those trees to extract definitions, calls,
and imports — the raw structure that gets assembled into a
[code knowledge graph](/glossary/knowledge-graph.md). Both GitNexus and Codebase-Memory
build on it (66 languages in the latter).

*Seen in:* [2026-07-11 news-digest thread](/meta/threads/2026-07-11-news-digest-intake-and-daily-read.md), [Codebase-Memory](/SWE/agentic-coding/code-context/codebase-memory-mcp.md), [GitNexus](/SWE/agentic-coding/code-context/gitnexus.md)
