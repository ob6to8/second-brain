---
id: em:0dd178
type: concept
title: regression testing
description: Re-running an established test suite on every change so that a modification which silently breaks existing behavior is caught immediately rather than discovered in production.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, testing, ci, methodology]
sense: common
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T23:23:55+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-20 evals-harness-ledger thread"
---

# regression testing

Continuous automated evals are this practice transplanted onto agents: a probe scored once measures a moment, while one scored per commit measures a curve and attributes any bend to the diff that caused it. The transplant inherits the practice's hazards too — [flaky](/beliefs/glossary/flaky-test.md) verdicts from stochastic behavior, and [Goodhart](/beliefs/glossary/goodharts-law.md) pressure once the score gates deploys.

*Seen in:* [2026-07-20 evals and observation-records thread](/meta/threads/2026-07-20-evals-harness-ledger-and-observation-records.md)
