---
id: sb:8f37a6
type: concept
title: actor model
description: A concurrency model in which independent, share-nothing processes ("actors") each own their private state and interact only by asynchronous message passing, so contention over a resource becomes a message queue at its owning actor rather than a lock.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, concurrency, actor-model, beam]
timestamp: 2026-07-12
---

# actor model

A concurrency model in which independent processes ("actors") share nothing: each owns its private state, and the only way to affect another actor is to send it an asynchronous message. Ownership replaces locking — contention over a shared resource becomes a queue of messages at the one actor that owns it, which is what makes the model a natural idiom for write governance (one process owning mutation of a namespace, as in the [librarian write-broker](/glossary/librarian-write-broker.md)). The [BEAM](/glossary/beam.md) is the canonical industrial implementation.

*Seen in:* [dark-factory scenario analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
