# LLM engineering

Techniques for making LLM inference and retrieval cheaper, faster, or more
capable — context pruning, attention/KV-cache architecture, and related serving
concerns.

## References

- [Pruning RAG context with a small LLM before generation (Kapa.ai)](/knowledge/SWE/llm-engineering/rag-context-pruning-with-a-small-llm.md) — a cheap LLM grades retrieved chunks and discards low scorers before the expensive generator sees them. `sb:41be22` _(reference)_
- [A brief history of KV cache compression (Martin Alderson)](/knowledge/SWE/llm-engineering/kv-cache-compression-history.md) — MQA → GQA → sliding window → MLA → quantization; ~100x memory-per-token reduction since 2017. `sb:266c5e` _(reference)_
- [VeriCache — turning lossy KV-cache compression into lossless inference](/knowledge/SWE/llm-engineering/vericache-lossless-kv-cache.md) — draft from the compressed cache, verify against the full cache → output identical to full-KV decoding at up to 4× throughput, over any token-dropping/quantization compressor. `sb:1cac23` _(reference)_
