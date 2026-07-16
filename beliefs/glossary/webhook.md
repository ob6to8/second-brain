---
id: em:adf537
type: concept
title: webhook
description: An HTTP callback that inverts polling — instead of a client repeatedly asking a service whether something changed, the service POSTs to an endpoint the client operates the moment an event occurs, requiring an always-on receiver that authenticates and reacts to each delivery.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, http, events, integration, webhooks]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-12T15:12:24+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# webhook

The receiver typically checks an HMAC signature to confirm each POST is genuine before handling it. Common for state-transition notifications (a job finished, a credential failed) where the alternative is wasteful polling; a natural fit for the event-driven orchestrator that a hosted agent service like [Claude Managed Agents](/beliefs/glossary/claude-managed-agents.md) presupposes on the customer side.

*Seen in:* [Managed Agents vs. Jido/BEAM analysis](/meta/analysis/claude-managed-agents-vs-beam-jido.md)
