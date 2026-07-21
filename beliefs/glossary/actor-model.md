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

*Seen in:* [dark-factory scenario analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md), [2026-07-21 ECS intake thread](/meta/threads/2026-07-21-ecs-intake-and-agent-entity-substitution.md) (the actor/ECS tension: ECS makes entities passive data, actors own their behavior), [Dynamic Workflows vs. BEAM/Jido 2 analysis](/meta/analysis/dynamic-workflows-vs-beam-jido.md)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:8f37a6">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-16-dynamic-workflows-vs-beam-jido (2026-07-16)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:8f37a6`]**  (co-feeds: `/meta/analysis/dynamic-workflows-vs-beam-jido.md`)

**Jido 2 on the BEAM** is the opposite shape: a runtime for *long-lived, stateful, supervised entities*. "Agents are data" — a struct of state+actions running inside a supervised `GenServer` (`Jido.AgentServer`). Actions are a pure functional core (`cmd/2` → updated agent + a list of **directives** = typed descriptions of side effects the runtime executes). Coordination is **signal-driven** (CloudEvents 1.0.2, trie router, pub/sub bus, parent-child hierarchies), not orchestrated. It inherits OTP: supervision, "let it crash," process isolation, distribution.
