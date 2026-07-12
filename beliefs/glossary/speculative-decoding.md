---
id: sb:38d006
type: concept
title: speculative decoding
description: An LLM inference technique that proposes tokens with a cheap draft step and verifies them in parallel against the expensive full model, accepting the longest correct prefix — yielding the full model's exact output at higher throughput.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, llm-inference, speculative-decoding, throughput, draft-verify]
timestamp: 2026-07-11
---

# speculative decoding

An inference technique that speeds up autoregressive generation by splitting it into
**draft** and **verify**: a cheap proposer guesses several next tokens, and the full
model checks them in a single parallel pass, accepting the longest correct prefix and
falling back where they diverge. Because every emitted token is verified against the
full model, the output is **identical** to ordinary decoding — the speedup is free of
accuracy cost. VeriCache applies the same draft-and-verify pattern to a *compressed
KV cache* (draft from the compressed cache, verify against the full one) to make lossy
compression lossless.

*Seen in:* [2026-07-11 news-digest thread](/meta/threads/2026-07-11-news-digest-intake-and-daily-read.md), [VeriCache](/knowledge/SWE/llm-engineering/vericache-lossless-kv-cache.md)
