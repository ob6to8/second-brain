---
type: assertion
tier: primitive
claim: "Hybrid retrieval (70% vector + 30% BM25) significantly outperforms either pure vector or pure keyword search for agent memory"
confidence: medium
evidence:
  - source: "[[openclaw-memory-architecture]]"
    type: citation
tags: [agent-memory, vector-search, bm25, hybrid-search]
date_asserted: "2026-03-03"
supersedes: ""
related: []
---

OpenClaw's numbers: pure vector search gets ~76% recall, pure BM25 gets ~68%, combined 70:30 weighted gets ~89%. The union-based approach means results from either method contribute to final rankings — a chunk scoring high on vector similarity but containing no keywords still surfaces.

Confidence is medium because this is from a single project's measurements, not a controlled study.
