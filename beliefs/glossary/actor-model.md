---
id: em:8f37a6
type: concept
title: actor model
description: A concurrency model in which independent, share-nothing processes ("actors") each own their private state and interact only by asynchronous message passing, so contention over a resource becomes a message queue at its owning actor rather than a lock.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, concurrency, actor-model, beam]
sense: common
timestamp: 2026-07-21
attribution:
  when: 2026-07-12T09:05:38+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# actor model

Ownership is what makes the model a natural idiom for write governance — one process owning mutation of a namespace, as in the [librarian write-broker](/beliefs/glossary/librarian-write-broker.md). The [BEAM](/beliefs/glossary/beam.md) is the canonical industrial implementation.

*Seen in:* [dark-factory scenario analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md), [2026-07-21 ECS intake thread](/meta/threads/2026-07-21-ecs-intake-and-agent-entity-substitution.md) (the actor/ECS tension: ECS makes entities passive data, actors own their behavior)
