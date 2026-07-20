---
id: em:6ced60
type: concept
title: baseline
description: A reference measurement against which change or merit is judged — a system's own prior score for trend comparison, or a deliberately naive method's score that shows whether reported numbers are actually impressive.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, evals, metrics]
sense: dual
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T23:23:55+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-20 evals-harness-ledger thread"
---

# baseline

Both common senses recur in benchmark reporting: the longitudinal anchor (did we regress since last month?) and the naive comparator (does a dumb heuristic already achieve this?); credible published results carry the second, since a number without one is uninterpretable.

**In this brain:** the committed `## Baseline` section of an eval gold doc — a *generated* figure refreshed by `mix brain.dedup_probe --update-baseline`, with the trend carried by the section's git history rather than a hand-kept log, per the [dedup-recall-probe plan](/meta/plans/dedup-recall-probe.md).

*Seen in:* [2026-07-20 evals and observation-records thread](/meta/threads/2026-07-20-evals-harness-ledger-and-observation-records.md), [2026-07-12 dedup recall probe thread](/meta/threads/2026-07-12-dedup-recall-probe-and-synonym-intake.md)
