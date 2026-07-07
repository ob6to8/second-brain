---
id: sb:41be22
type: reference
title: "Pruning RAG context with a small LLM before generation (Kapa.ai)"
description: Kapa.ai inserts a cheap LLM scoring step between retrieval and generation that grades each retrieved chunk's relevance and discards low scorers, cutting 68% of chunks while preserving 96% recall and 34% net cost.
resource: https://www.kapa.ai/blog/how-we-prune-rag-context
provenance: "Distilled from the Kapa.ai engineering blog, fetched 2026-07-06"
tags: [rag, retrieval, llm-inference, context-pruning, cost-optimization, reranking]
timestamp: 2026-07-06
---

# Pruning RAG context with a small LLM before generation (Kapa.ai)

**Problem:** retrievers over-fetch on purpose to maximize recall, so most retrieved
chunks are noise the generator never needed — yet retrieved context alone made up
two-thirds of Kapa.ai's per-query token cost.

**Fix:** insert a pruning step between retrieval and generation. *"A small, cheap
LLM reads the question and all the retrieved chunks together, and throws out the
chunks the answer will not need before the expensive model ever sees them."*

## How the scoring works

- **Listwise, not pointwise** — the question and *all* candidate chunks go to the
  scorer together in one pass, so it can catch interdependent or
  partially-relevant chunks that a pointwise reranker (scoring one chunk at a time)
  would miss.
- **Five-level relevance scale**: Essential (answer impossible without it) →
  Contributing → Supporting (on-topic, likely unnecessary) → Tangential → Unrelated.
  A fixed threshold works across queries because the levels are defined
  semantically, not by a per-query score distribution.
- **Cheap by construction** — the scoring model runs at low reasoning effort so
  pruning itself costs less than the tokens it saves.
- **Top-K protection** — the highest-ranked chunks always pass through regardless
  of grade, bounding worst-case recall loss.

## Results

| Metric | Value |
|---|---|
| Chunks removed | 68% |
| Recall preserved | 96% (roughly 1 in 25 questions loses a needed chunk) |
| Net cost reduction | 34% per query |
| Added latency | ~0.7s |

Naive truncation, by comparison, only achieved 7% compression at the same 98%
recall — the semantic scoring step is what unlocks the much higher compression
ratio (30%+) at equivalent recall.

# Citations

Kapa.ai, "How we prune RAG context" — <https://www.kapa.ai/blog/how-we-prune-rag-context>
