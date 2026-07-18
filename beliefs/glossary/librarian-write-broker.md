---
id: em:01be3a
type: concept
title: librarian write-broker
description: A supervised process that solely owns mutation of a knowledge namespace — agents submit proposed concepts as messages, and the librarian runs the intake gauntlet (dedup, verification, grounding checks) and serializes commits, turning concurrent write contention into a mailbox and making integrity checks unbypassable.
provenance: "Agent-distilled glossary definition — coined in the dark-factory scenario analysis"
verified: false
tags: [glossary, architecture, actor-model, intake, write-governance, dark-factory]
sense: repo
timestamp: 2026-07-16
attribution:
  when: 2026-07-12T09:05:38+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# librarian write-broker

Often one broker per namespace, mirroring the taxonomy. The gauntlet's stages are [dedup](/beliefs/glossary/deduplication.md), verification, and grounding, and the accepted commit lands with full provenance. The [actor model](/beliefs/glossary/actor-model.md)'s ownership semantics supply the coordination: a mailbox rather than a merge conflict, and a single choke point (also called the write-gatekeeper) that no write can route around. When agents on different runtimes share one base, the broker is the owned seam between them — reachable in-process from local agents and over the network (as a custom tool or MCP server) from hosted ones, enforced by [reducer](/beliefs/glossary/reducer.md) invariants on one side and credential custody on the other.

*Seen in:* [dark-factory scenario analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md), [Managed Agents vs. Jido/BEAM analysis](/meta/analysis/claude-managed-agents-vs-beam-jido.md)
