---
id: em:183eaa
type: concept
title: holdout scenario
description: An end-to-end behavioral specification kept outside the codebase and withheld from the developing agent's context, so generated code is validated against expectations it never saw — the ML train/validation split imported into software verification.
provenance: "Agent-distilled glossary definition, Claude Code session"
verified: false
sense: common
tags: [glossary, verification, testing, agents, dark-factory]
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T19:35:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-20 intent-as-source and dark-factory-pricing thread"
---

# holdout scenario

The separation exists to defeat a Goodhart failure specific to autonomous
pipelines: when one agent authors both the implementation and its tests, it can
teach to its own test suite, and passing proves little. Keeping the acceptance
criteria in a separate, human-governed store that the development loop cannot
read restores the independence a [test oracle](/beliefs/glossary/test-oracle.md)
requires. StrongDM's software factory popularized the mechanism, maintaining its
scenarios as user-story trajectories that remain the ultimate arbiter without
ever entering the development context.

*Seen in:* [StrongDM software-factory reference](/knowledge/SWE/agentic/adoption/strongdm-software-factory.md), [dark-factory oracle-pricing analysis](/meta/analysis/dark-factory-oracle-pricing-intent-as-source.md), [2026-07-20 intent-as-source and dark-factory pricing](/meta/threads/2026-07-20-intent-as-source-and-dark-factory-pricing.md)

*See also:* [satisfaction metric](/beliefs/glossary/satisfaction-metric.md), [software factory](/beliefs/glossary/software-factory.md)
