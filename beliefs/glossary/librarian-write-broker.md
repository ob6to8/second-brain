---
id: sb:01be3a
type: concept
title: librarian write-broker
description: A supervised process that solely owns mutation of a knowledge namespace — agents submit proposed concepts as messages, and the librarian runs the intake gauntlet (dedup, verification, grounding checks) and serializes commits, turning concurrent write contention into a mailbox and making integrity checks unbypassable.
provenance: "Agent-distilled glossary definition — coined in the dark-factory scenario analysis"
verified: false
tags: [glossary, architecture, actor-model, intake, write-governance, dark-factory]
timestamp: 2026-07-12
---

# librarian write-broker

The design can shard — one librarian per namespace, mirroring the taxonomy — and each serialized commit lands with full provenance. The [actor model](/beliefs/glossary/actor-model.md)'s ownership semantics do the coordination: the mailbox replaces what would otherwise be a merge conflict, and the single choke point (also called the write-gatekeeper) is where the gauntlet's [dedup](/beliefs/glossary/deduplication.md) and grounding checks hang. When agents on different runtimes share one base, the broker is the owned seam between them — reachable in-process from local agents and over the network (as a custom tool or MCP server) from hosted ones, enforced by [reducer](/beliefs/glossary/reducer.md) invariants on one side and credential custody on the other.

*Seen in:* [dark-factory scenario analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md), [Managed Agents vs. Jido/BEAM analysis](/meta/analysis/claude-managed-agents-vs-beam-jido.md)
