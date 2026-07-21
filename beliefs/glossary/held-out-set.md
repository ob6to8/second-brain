---
id: em:430dbb
type: concept
title: held-out set
description: Test cases deliberately kept away from the system under test — absent from its training data, repository, and context — so the score reflects competence on genuinely unseen material.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, evals, benchmarks, methodology]
sense: common
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T23:23:55+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-20 evals-harness-ledger thread"
---

# held-out set

The standard cure for [contamination](/beliefs/glossary/contamination.md), inherited from machine learning's train/test split. For corpus-maintenance benchmarking it means generating a fresh synthetic corpus and answer key that never lands in any repo the agent reads — the constructible-[ground-truth](/beliefs/glossary/ground-truth.md) affordance is exactly the generator.

*Seen in:* [2026-07-20 evals and observation-records thread](/meta/threads/2026-07-20-evals-harness-ledger-and-observation-records.md)

*See also:* [holdout scenario](/beliefs/glossary/holdout-scenario.md), [contamination](/beliefs/glossary/contamination.md)
