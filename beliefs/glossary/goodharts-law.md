---
id: em:9e28d2
type: concept
title: Goodhart's law
description: The observation that when a measure becomes a target it ceases to be a good measure — optimizing for the metric decouples it from the quality it once tracked.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, evals, metrics, incentives]
sense: common
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T23:23:55+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-20 evals-harness-ledger thread"
---

# Goodhart's law

Named for economist Charles Goodhart. An eval score wired in as a deploy gate is maximally exposed: every fix is made to pass the suite, which drifts from independent check toward a description of what the team optimized. The countermeasure is refreshing test cases from live operation faster than the system overfits to the old ones — structurally, this bundle's gold-harvest-at-intake step.

*Seen in:* [2026-07-20 evals and observation-records thread](/meta/threads/2026-07-20-evals-harness-ledger-and-observation-records.md)
