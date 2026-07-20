---
id: em:c50864
type: concept
title: satisfaction metric
description: A probabilistic acceptance criterion for generated software — the fraction of observed end-to-end trajectories judged likely to satisfy the user — replacing boolean pass/fail where agents author both the code and its tests.
provenance: "Agent-distilled glossary definition, Claude Code session"
verified: false
sense: common
tags: [glossary, verification, testing, agents, dark-factory, sampling]
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T19:35:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-20 intent-as-source and dark-factory-pricing thread"
---

# satisfaction metric

The move concedes that correctness of generated systems cannot be pinned
absolutely and shifts quality control to instrumented sampling — the acceptance
apparatus of a physical lights-out plant (tolerable defect rates, continuous
measurement) applied to software. It is kin to the
[escape rate](/beliefs/glossary/escape-rate.md) as a sampled trust signal, and it
has a genre boundary: statistical acceptance suits surfaces whose failures are
observable and recoverable by users, and misfits integrity layers, where a
checker that is almost always right silently corrupts what it guards the rest of
the time.

*Seen in:* [StrongDM software-factory reference](/knowledge/SWE/agentic/adoption/strongdm-software-factory.md), [dark-factory oracle-pricing analysis](/meta/analysis/dark-factory-oracle-pricing-intent-as-source.md), [2026-07-20 intent-as-source and dark-factory pricing](/meta/threads/2026-07-20-intent-as-source-and-dark-factory-pricing.md)

*See also:* [test oracle](/beliefs/glossary/test-oracle.md), [holdout scenario](/beliefs/glossary/holdout-scenario.md)
