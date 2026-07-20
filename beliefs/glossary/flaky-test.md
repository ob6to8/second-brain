---
id: em:ec63e8
type: concept
title: flaky test
description: A test whose verdict varies across runs of the same code, passing and failing nondeterministically — eroding trust in the suite as failures get rerun until green and eventually ignored.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, testing, ci, nondeterminism]
sense: common
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T23:23:55+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-20 evals-harness-ledger thread"
---

# flaky test

Agent evals are flaky by nature — stochastic model behavior means the same commit can score differently on reruns — which is why wiring an eval score in as a hard deploy gate backfires, and why this bundle's editorial metrics warn rather than fail until a baseline history can justify an honest floor.

*Seen in:* [2026-07-20 evals and observation-records thread](/meta/threads/2026-07-20-evals-harness-ledger-and-observation-records.md)
