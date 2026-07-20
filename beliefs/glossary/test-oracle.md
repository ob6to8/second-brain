---
id: em:88f07a
type: concept
title: test oracle
description: The mechanism that decides whether a system's output is correct for a given input — the part of an evaluation that knows the right answer.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, testing, evals, ground-truth]
sense: common
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T23:23:55+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-20 evals-harness-ledger thread"
---

# test oracle

Oracles are the scarce resource of eval design — constructible [ground truth](/beliefs/glossary/ground-truth.md) makes them cheap, which is this bundle's structural advantage. They need not be answer keys: the [routing ledger](/beliefs/glossary/routing-ledger.md)'s per-strand bookkeeping acts as a *completion* oracle for multi-step agent work, judging whether everything started was finished and accounted for rather than whether a specific output matched.

*Seen in:* [2026-07-20 evals and observation-records thread](/meta/threads/2026-07-20-evals-harness-ledger-and-observation-records.md), [harness-and-ledger analysis](/meta/analysis/harness-and-ledger-as-eval-infrastructure.md)
