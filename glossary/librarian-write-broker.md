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

A write-governance design for a knowledge base with many concurrent agent writers: a supervised process (or one per namespace, mirroring the taxonomy) *solely owns* mutation of its part of the bundle. Agents never write files directly — they submit proposed concepts as messages, and the librarian runs the intake gauntlet ([dedup](/glossary/deduplication.md), verification, grounding checks) before serializing the commit with full provenance. The [actor model](/glossary/actor-model.md)'s ownership semantics do the coordination: contention becomes a mailbox instead of a merge conflict, and because all writes pass one choke point (also called the write-gatekeeper), integrity checks cannot be bypassed. When agents on different runtimes share one base, the broker is the owned seam between them — reachable in-process from local agents and over the network (as a custom tool or MCP server) from hosted ones, enforced by [reducer](/glossary/reducer.md) invariants on one side and credential custody on the other.

*Seen in:* [dark-factory scenario analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md), [Managed Agents vs. Jido/BEAM analysis](/meta/analysis/claude-managed-agents-vs-beam-jido.md)
