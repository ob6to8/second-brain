---
id: em:f518a7
type: concept
title: fault injection
description: "A testing technique that deliberately introduces failures — crashed processes, delayed, dropped, or reordered messages, network partitions — into a running system to observe how it degrades and recovers."
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, fault-injection, chaos-engineering, testing, reliability, beam]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T12:25:27Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-16 Inkling/BEAM swarm-eval spike thread"
---

# fault injection

The chaos-engineering discipline (Netflix's Chaos Monkey is the canonical ancestor) turns reliability from an assumption into an experiment: hypothesize the blast radius, break the thing on purpose, measure. The [BEAM](/beliefs/glossary/beam.md) is unusually congenial to it because the breakage vocabulary is built into the runtime rather than mocked — `Process.exit/2` kills an actor, `:sys.suspend/1` wedges one, a proxy process delays or drops mail, `:erlang.disconnect_node/1` partitions — and [let-it-crash](/beliefs/glossary/let-it-crash.md) supervision is the recovery machinery under test. In multi-agent evals, a *scheduled* fault plus recorded seeds yields a reproducible failure trace: the same coordinator death at the same turn, replayable.

*Seen in:* [2026-07-16 Inkling/BEAM swarm-eval spike thread](/meta/threads/2026-07-16-inkling-beam-swarm-eval-spike.md), [inkling-beam-swarm-eval-substrate analysis](/meta/analysis/inkling-beam-swarm-eval-substrate.md)
