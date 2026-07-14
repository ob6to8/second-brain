---
id: sb:a9bb1d
type: concept
title: context mesh
description: Loomkin's memory architecture in which overflow conversation context is offloaded at full fidelity to dedicated Keeper processes — with staleness and access-frequency tracking and cross-agent retrieval — instead of being summarized away.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, agents, memory, context, loomkin, beam]
sense: common
timestamp: 2026-07-14
attribution:
  when: 2026-07-14T00:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-14 Elixir AST/macros and Loomkin thread"
---

# context mesh

Loomkin's answer to context-window overflow: rather than compressing old conversation history with lossy summarization, the system detects topic boundaries and offloads the overflow to dedicated **Keeper processes** that "hold offloaded context at full fidelity," tracking access frequency and staleness, with cross-agent retrieval so other (and later) agents can pull the archived context back in. The commitment — preserve fidelity, evict by *location* rather than by *compression* — is the same one this bundle's [session capture](/beliefs/glossary/session-capture.md) makes (retained text verbatim, only noise stripped), arrived at independently for runtime state rather than durable records.

*Seen in:* [2026-07-14 Elixir AST/macros and Loomkin thread](/meta/threads/2026-07-14-elixir-ast-macros-and-loomkin-evaluation.md), [Loomkin analysis](/meta/analysis/loomkin-as-existence-proof.md)
