---
id: sb:b74c61
type: concept
title: pure function
description: A function whose output depends only on its explicit inputs, with no side effects or hidden state — the property an LLM forward pass with frozen weights literally has.
provenance: "Agent-distilled glossary definition, 2026-07-13 session"
verified: false
sense: common
tags: [glossary, functional-programming, agent-architecture, terminology]
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T00:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-13 second-mind-taxonomy thread cited in Seen in"
---

# pure function

A function whose output is fully determined by its explicit inputs, with no side effects and no hidden mutable state — same inputs, same output, always. An LLM forward pass with frozen weights is literally one: `(weights, context, seed) → tokens`, with the [KV cache](/beliefs/glossary/kv-cache.md) a performance optimization carrying no semantic state. The purity is architecturally load-bearing for agents: because the model holds no state between calls, all state must live in the context, which is what makes retries, forking, subagents, and caching coherent (in practice, serving-stack effects like batching and floating-point non-associativity make deployments only approximately deterministic).

*Seen in:* [2026-07-13 second-mind-taxonomy thread](/meta/threads/2026-07-13-second-mind-taxonomy-analysis-and-belief-plan.md)

*See also:* [functional core, imperative shell](/beliefs/glossary/functional-core-imperative-shell.md)
