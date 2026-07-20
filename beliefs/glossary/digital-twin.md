---
id: em:90e275
type: concept
title: digital twin
description: A behavioral clone of an external system — replicating its APIs, state transitions, and edge cases — that stands in for the real thing during testing, so behavior can be exercised at volumes and in failure modes production would never permit.
provenance: "Agent-distilled glossary definition, Claude Code session"
verified: false
sense: common
tags: [glossary, testing, simulation, agents, dark-factory]
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T19:35:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-20 intake of StrongDM's software factory"
---

# digital twin

The term originates in manufacturing and IoT, where a live simulation mirrors a
physical asset. In autonomous software pipelines it names the verification
plant's expensive core: StrongDM's factory has agents build twins of the SaaS
platforms its product integrates with (Okta, Slack, Jira), which is what makes
the observable behavior surface large enough to substitute for humans reading
the code — rate limits, sandbox quotas, and slow external APIs stop bounding how
much behavior a [holdout scenario](/beliefs/glossary/holdout-scenario.md) run can
observe.

*Seen in:* [StrongDM software-factory reference](/knowledge/SWE/agentic/adoption/strongdm-software-factory.md), [2026-07-20 intent-as-source and dark-factory pricing](/meta/threads/2026-07-20-intent-as-source-and-dark-factory-pricing.md)
