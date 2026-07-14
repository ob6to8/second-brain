---
id: sb:ea15aa
type: reference
title: "Chroma — open-source embedding/search database for AI retrieval"
description: Chroma is an open-source, serverless database for vector, full-text, regex, and metadata search, used for RAG and context engineering, with tiered storage across memory, SSD, and object storage to keep large-scale retrieval affordable.
resource: https://www.trychroma.com
provenance: "Distilled from the Chroma homepage (trychroma.com), fetched 2026-07-06"
tags: [vector-database, embeddings, rag, retrieval, llm-engineering, open-source]
timestamp: 2026-07-06
attribution:
  when: 2026-07-06T00:00:00Z
  channel: intake
  agent: "Claude Code agent, /intake (ccr-architecture-notes session); transplanted to the reorganized tree 2026-07-13"
  why: "captured as the open-source retrieval database underpinning RAG/context-engineering, cross-referencing the brain's context-rot and RAG-pruning concepts"
---

# Chroma — open-source embedding/search database for AI retrieval

Chroma describes itself as *"Fast, serverless, and scalable infrastructure
supporting vector, full-text, regex, and metadata search."* It's a database
purpose-built for AI retrieval — semantic similarity search, lexical search, and
metadata filtering — used as the storage/retrieval layer under RAG pipelines and
other context-engineering setups, without the operational overhead of running a
general-purpose database for the job.

## Architecture

Chroma tiers storage across three layers: an in-memory cache for hot data, SSD
caching for warm data, and object storage (S3/GCS) for cold data. This lets it
use cheap cloud storage for the bulk of a collection while keeping frequently
accessed data fast, rather than forcing everything into expensive memory- or
SSD-backed storage.

## Deployment and license

- **Chroma Cloud** — managed, serverless.
- **Self-hosted** — open source (Apache 2.0).
- **Enterprise BYOC** — bring-your-own-cloud, deployed inside the customer's VPC.

Widely adopted: 26,000+ GitHub stars, 11M+ monthly downloads, used across
90,000+ open-source projects.

## Notable features

- Sparse vector search (BM25, SPLADE) alongside dense embedding search.
- Collection forking, for A/B testing retrieval configurations.
- Dataset versioning.
- Automatic scaling; SOC 2 Type II compliance.

## Relation to other captures

The company behind Chroma also published the
[context rot research](/knowledge/SWE/agentic/context-engineering/context-rot-chroma-research.md)
cited in this brain's currency check on
[effective context engineering for AI agents](/knowledge/SWE/agentic/agentic-loop/effective-context-engineering-for-agents.md) —
Chroma-the-product is the retrieval infrastructure; that research is evidence
for *why* careful retrieval and context curation matter regardless of how large
a model's context window gets. Also relevant to
[Kapa.ai's RAG context pruning](/knowledge/SWE/llm-engineering/rag-context-pruning-with-a-small-llm.md),
which addresses the same over-fetch-then-prune problem from the generation side
rather than the storage side.

# Citations

Chroma — <https://www.trychroma.com>
