---
id: em:7d0700
type: concept
title: FActScore
description: Min et al.'s factuality metric (EMNLP 2023) — the percentage of a generation's atomic facts supported by a fixed knowledge source — plus the retrieve-then-verify estimator that automates it to within 2% of human scores.
provenance: "Agent-distilled glossary definition, pointer to the defining doc"
verified: false
tags: [glossary, evals, factuality, metrics]
sense: common
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T20:14:11+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "extracted in the glossary run over the eight epistemic prior-art docs"
---

# FActScore

Min et al.'s long-form factuality metric (EMNLP 2023): the percentage of a
generation's [atomic facts](/beliefs/glossary/atomic-fact.md) supported by a fixed
knowledge source (Wikipedia, in the original biography task), automated by a
retrieve-then-verify estimator that matches human scores to within 2% error.
Canonically covered in
[decompose-then-verify factuality evaluation](/knowledge/SWE/evals/decompose-then-verify-factuality.md).

*Seen in:* [decompose-then-verify factuality reference](/knowledge/SWE/evals/decompose-then-verify-factuality.md)
