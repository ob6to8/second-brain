---
id: sb:927eb2
type: concept
title: typed edge
description: A machine-traversable, id-based relationship declared in a document's structured metadata, reserved for relationships tooling must consume or enforce — as opposed to an untyped prose link.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, identity, edges]
sense: dual
timestamp: 2026-07-13
---

# typed edge

In graph modeling, an edge that carries a label naming the kind of relationship it represents (`CALLS`, `IMPORTS`, `supports`), so traversals can select by relationship type instead of treating all connections alike — the edge form a [knowledge graph](/beliefs/glossary/knowledge-graph.md) is built from.

**In this brain:** a machine-traversable, id-based relationship declared in a document's structured metadata (like `verified_by`), as opposed to an untyped prose link. The governing principle: type an edge only when a machine must traverse it; otherwise prose carries the semantics.

*Seen in:* [2026-07-09 testing-methodology thread](/meta/threads/2026-07-09-testing-methodology-types-and-cb-epistemic-overlay.md), [2026-07-11 doctrine-vs-policy thread](/meta/threads/2026-07-11-doctrine-vs-policy-and-glossary-cross-linking.md)
