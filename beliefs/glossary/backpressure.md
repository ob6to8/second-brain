---
id: em:6c7e32
type: concept
title: backpressure
description: Flow control in which a slower downstream stage pushes back on faster producers — through bounded queues, pool limits, or demand signalling — so overload degrades gracefully instead of overwhelming the system.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, concurrency, flow-control, systems]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-12T09:05:38+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# backpressure

Under backpressure, overload turns into orderly waiting rather than unbounded memory growth or dropped work. The canonical agent-fleet case: many agents wanting concurrent LLM calls against a rate-limited, expensive provider, where bounded mailboxes and pools are the native answer.

*Seen in:* [dark-factory scenario analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
