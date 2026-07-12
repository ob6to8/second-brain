---
id: sb:82c03c
type: concept
title: two-plane rule
description: An architectural separation between a fast operational plane (ephemeral, high-frequency state — orders, telemetry, queues — living in databases and process state) and a slow epistemic plane (durable, verified beliefs living in the knowledge bundle), with writes to the epistemic plane kept deliberate and low-frequency by policy.
provenance: "Agent-distilled glossary definition — coined in the dark-factory scenario analysis"
verified: false
tags: [glossary, architecture, epistemics, dark-factory]
timestamp: 2026-07-12
---

# two-plane rule

The point is protection, not throughput: knowledge distills slowly even when operations run fast, and the deliberate epistemic write rate is what keeps the bundle from becoming a message bus (and keeps markdown + git viable as its substrate). The same fast/slow split also sorts *agentic work* — mechanical, high-frequency operations versus deliberative, expensive reasoning — which is why it doubles as a runtime-selection criterion between a per-process framework and a per-session hosted service.

*Seen in:* [dark-factory scenario analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md), [Managed Agents vs. Jido/BEAM analysis](/meta/analysis/claude-managed-agents-vs-beam-jido.md)
