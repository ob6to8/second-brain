---
id: sb:8415bd
type: concept
title: KV cache
description: The stored key and value tensors for already-processed tokens in transformer inference, cached so each new token attends over them without recomputing the sequence — trading memory that grows with context length for speed.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, kv-cache, llm-inference, transformers, attention]
sense: common
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T18:01:58+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# KV cache

In transformer inference, the **key** and **value** tensors computed for every token
already processed, kept in memory so generating each new token attends over the
cached history instead of recomputing the whole sequence. It trades memory — which
grows linearly with context length and often dominates long-context serving — for
speed, which is why KV-cache **compression** (quantization, eviction, low-rank) and
lossless-verification schemes target it.

*Seen in:* [2026-07-11 news-digest thread](/meta/threads/2026-07-11-news-digest-intake-and-daily-read.md), [VeriCache](/knowledge/SWE/llm-engineering/vericache-lossless-kv-cache.md), [A brief history of KV cache compression](/knowledge/SWE/llm-engineering/kv-cache-compression-history.md)
