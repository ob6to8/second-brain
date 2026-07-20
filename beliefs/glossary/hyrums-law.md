---
id: em:41dbfd
type: concept
title: "Hyrum's law"
description: With enough users, every observable behavior of a system — documented or not — will be depended on by somebody, so changing any unspecified behavior breaks someone.
provenance: "Agent-distilled glossary definition, Claude Code session"
verified: false
sense: common
tags: [glossary, api-design, compatibility, testing, regeneration]
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T19:35:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-20 intent-as-source and dark-factory-pricing thread"
---

# Hyrum's law

Coined for API evolution (Hyrum Wright, Google), the law bounds
regeneration-from-spec: everything a specification and its tests leave unpinned
is free to vary each time an artifact is regenerated, silently shifting exactly
the surface consumers have quietly come to rely on. The intent-as-source
discussion used an inverted form — a bundle whose own integrity tooling depends
on its verifier's unspecified behavior is its own Hyrum-exposed consumer.

*Seen in:* [dark-factory oracle-pricing analysis](/meta/analysis/dark-factory-oracle-pricing-intent-as-source.md), [2026-07-20 intent-as-source and dark-factory pricing](/meta/threads/2026-07-20-intent-as-source-and-dark-factory-pricing.md)
