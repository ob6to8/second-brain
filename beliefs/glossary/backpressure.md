---
id: sb:6c7e32
type: concept
title: backpressure
description: Flow control in which a slower downstream stage pushes back on faster producers — through bounded queues, pool limits, or demand signalling — so overload degrades gracefully instead of overwhelming the system.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, concurrency, flow-control, systems]
timestamp: 2026-07-12
---

# backpressure

Flow control in which a slower downstream stage pushes back on faster upstream producers — via bounded queues, worker-pool limits, or explicit demand signalling — so that overload turns into orderly waiting rather than unbounded memory growth or dropped work. The canonical agent-fleet case: many agents wanting concurrent LLM calls against a rate-limited, expensive provider, where bounded mailboxes and pools are the native answer.

*Seen in:* [dark-factory scenario analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
