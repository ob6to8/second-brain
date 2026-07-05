---
type: assertion
tier: primitive
claim: "An operational conversation log and a curated knowledge store serve fundamentally different purposes and should be separate persistence layers"
confidence: medium
evidence:
  - source: "[[llm-cli-logging-to-sqlite]]"
    type: supporting
  - source: "[[basic-memory-mcp-knowledge-graph]]"
    type: supporting
  - source: "Reasoning: the llm CLI log captures process (how you got there, dead ends, full reasoning). The knowledge store captures product (curated claims with provenance). Conflating them forces one format to serve two masters."
    type: reasoning
tags: [knowledge-management, conversation-persistence, agent-memory]
date_asserted: "2026-03-03"
supersedes: ""
related: []
---

The `llm` CLI's SQLite log is an operational record — every raw exchange, including dead ends and exploratory queries. The markdown knowledge store (sources + assertions) is curated product. Basic Memory makes a similar separation: files are the knowledge layer, the SQLite index is a derived performance layer. Merging process and product into one store forces awkward compromises on both.
