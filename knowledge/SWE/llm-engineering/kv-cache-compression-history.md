---
id: sb:266c5e
type: reference
title: "A brief history of KV cache compression (Martin Alderson)"
description: Alderson traces how KV-cache memory per token fell roughly 100x since 2017 through a sequence of architectural compressions (MQA, GQA, sliding window, MLA, quantization, linear-attention hybrids), arguing the memory wall was solved with math rather than more VRAM.
resource: https://martinalderson.com/posts/a-brief-history-of-kv-cache-compression-developments/
provenance: "Distilled from Martin Alderson's blog, fetched 2026-07-06"
tags: [llm-inference, kv-cache, attention, transformers, model-architecture, quantization]
timestamp: 2026-07-06
attribution:
  when: 2026-07-07T03:41:02+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# A brief history of KV cache compression (Martin Alderson)

The KV cache stores a transformer's per-token key/value activations so each new
token doesn't recompute attention over the whole conversation — but *"the longer
your 'conversation' grows with the LLM, the more KV cache you need."* Alderson
traces the timeline of techniques that shrank this cost roughly 100x since 2017,
even as GPU memory grew only ~18x — his framing: *"the memory wall in AI has
mostly been solved with maths, not silicon."*

## Timeline

- **2017 — the problem.** A 128K-token context on a 70B model needed ~340GB of KV
  cache; top GPUs of the era had 16GB.
- **2019 — Multi-Query Attention (MQA, Shazeer).** All query heads share one KV
  head: *"a huge 64x reduction."* But *"quality took a real hit and training became
  less stable,"* limiting adoption.
- **2023 — Grouped Query Attention (GQA).** A middle ground — groups of query heads
  share a KV head — giving *"an 8x reduction — with very little quality loss."*
  Llama 2 and Mistral adopted it immediately; it became the open-model default.
- **2023 — sliding window attention (parallel track).** Layers attend only to a
  recent window of tokens, capping KV growth in those layers regardless of
  sequence length.
- **2024 — Multi-head Latent Attention (MLA, DeepSeek).** Compresses keys and
  values into a much smaller latent vector — *"a 93% reduction in KV cache size"* —
  while *improving* quality benchmarks, a watershed proving aggressive compression
  needn't cost quality.
- **2024–2025 — quantization and linear-attention hybrids.** KV cache quantized to
  8- or 4-bit precision cuts memory further; linear-attention hybrid architectures
  replace most attention layers with a fixed-size per-layer state, enabling
  million-token context windows.

See also [GitNexus](/knowledge/SWE/agentic-coding/code-context/gitnexus.md) and
[effective context engineering for AI agents](/knowledge/SWE/agentic-coding/agentic-loop/effective-context-engineering-for-agents.md)
for the agent-side consequences of what a model can hold in context.

# Citations

Martin Alderson, "A Brief History of KV Cache Compression Developments" —
<https://martinalderson.com/posts/a-brief-history-of-kv-cache-compression-developments/>
