---
id: sb:adf537
type: concept
title: webhook
description: An HTTP callback that inverts polling — instead of a client repeatedly asking a service whether something changed, the service POSTs to an endpoint the client operates the moment an event occurs, requiring an always-on receiver that authenticates and reacts to each delivery.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, http, events, integration, webhooks]
timestamp: 2026-07-12
---

# webhook

An HTTP callback that inverts the polling relationship: rather than a client repeatedly asking a service "did anything change?", the service sends an HTTP POST to an endpoint the client operates the moment an event happens. The trade-off is that the client must run an always-available receiver — a small service that answers, verifies the delivery is genuine (typically an HMAC signature), and reacts. Common for state-transition notifications (a job finished, a credential failed) where the alternative is wasteful polling; a natural fit for the event-driven orchestrator that a hosted agent service like [Claude Managed Agents](/beliefs/glossary/claude-managed-agents.md) presupposes on the customer side.

*Seen in:* [Managed Agents vs. Jido/BEAM analysis](/meta/analysis/claude-managed-agents-vs-beam-jido.md)
