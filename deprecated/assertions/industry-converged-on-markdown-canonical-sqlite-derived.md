---
type: assertion
tier: primitive
claim: "The AI agent industry has independently converged on markdown-canonical, SQLite-derived persistence for knowledge bases"
confidence: high
evidence:
  - source: "[[basic-memory-mcp-knowledge-graph]]"
    type: citation
  - source: "[[openclaw-memory-architecture]]"
    type: citation
  - source: "[[ai-agent-memory-markdown-files]]"
    type: supporting
tags: [agent-memory, markdown, sqlite, knowledge-management]
date_asserted: "2026-03-03"
supersedes: ""
related: []
---

Basic Memory, OpenClaw, and Manus arrived at the same pattern independently: markdown files are the source of truth (human-readable, portable, git-tracked), SQLite serves as a derived query/search layer rebuilt from files. If the database is lost, rebuild from files. The database is a cache, never canonical.
