---
id: sb:82c03c
type: concept
title: two-plane rule
description: An architectural separation between a fast operational plane (ephemeral, high-frequency state — orders, telemetry, queues — living in databases and process state) and a slow epistemic plane (durable, verified beliefs living in the knowledge bundle), with writes to the epistemic plane kept deliberate and low-frequency by policy.
provenance: "Agent-distilled glossary definition — coined in the dark-factory scenario analysis"
verified: false
tags: [glossary, architecture, epistemics, dark-factory]
sense: repo
timestamp: 2026-07-12
attribution:
  when: 2026-07-12T09:05:38+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# two-plane rule

An architectural separation between the two kinds of state a running operation generates. The **fast operational plane** — orders, telemetry, queue positions, conversation state — is high-frequency and ephemeral, and belongs in databases and process state. The **slow epistemic plane** — what the operation durably *believes* — is low-frequency, worth verifying, and lives in the knowledge bundle. The rule's point is a policy, not a throughput fix: knowledge distills slowly even when operations run fast, and keeping the epistemic write rate deliberate is what protects the bundle from becoming a message bus (and keeps markdown + git viable as its substrate). The same fast/slow split also sorts *agentic work* — mechanical, high-frequency operations versus deliberative, expensive reasoning — which is why it doubles as a runtime-selection criterion between a per-process framework and a per-session hosted service.

*Seen in:* [dark-factory scenario analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md), [Managed Agents vs. Jido/BEAM analysis](/meta/analysis/claude-managed-agents-vs-beam-jido.md)
