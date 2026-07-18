---
id: em:6a6054
type: concept
title: F1@K
description: SAFE's long-form factuality aggregate — harmonic mean of factual precision (fraction of supplied facts supported) and recall against K, a stipulated facts-per-response target; penalizes both fabrication and under-informing.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, evals, metrics, factuality]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-11T20:14:11+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "extracted in the glossary run over the eight epistemic prior-art docs"
---

# F1@K

K stands in for the user's preferred response length; the
[atomic facts](/beliefs/glossary/atomic-fact.md) are the unit precision counts
over. The recall arm is the point: precision
alone rewards a model for answering in one timid, safe sentence, so the metric
penalizes under-informing as well as fabrication. Companion metric to
[recall@k](/beliefs/glossary/recall-at-k.md) in this glossary's retrieval cluster —
same "@K" convention, different task.

*Seen in:* [decompose-then-verify factuality reference](/knowledge/SWE/evals/decompose-then-verify-factuality.md)
