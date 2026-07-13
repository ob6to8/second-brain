---
id: sb:bc34de
type: concept
title: decompose-then-verify
description: The evaluation pattern of atomizing a long output into individually checkable statements, verifying each against a source, and aggregating the local verdicts mechanically — validated at scale by FActScore and SAFE.
provenance: "Agent-distilled glossary definition, pointer to the defining doc"
verified: false
tags: [glossary, evals, factuality, claim-decomposition, methodology]
sense: common
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T20:14:11+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "extracted in the glossary run over the eight epistemic prior-art docs"
---

# decompose-then-verify

The evaluation pattern of atomizing a long generation into
[atomic facts](/beliefs/glossary/atomic-fact.md), verifying each independently against
a knowledge source, and aggregating the local verdicts into a score
mechanically — beating holistic judging because it localizes error and makes
factuality additive and auditable per claim. Validated at scale by
[FActScore](/beliefs/glossary/factscore.md) and [SAFE](/beliefs/glossary/safe.md); the
empirically grounded core that belief-decomposition generalizes from
support-checking to entailment and conflict. Canonically covered in
[decompose-then-verify factuality evaluation](/knowledge/SWE/evals/decompose-then-verify-factuality.md).

*Seen in:* [decompose-then-verify factuality reference](/knowledge/SWE/evals/decompose-then-verify-factuality.md), [belief-decomposition analysis](/meta/analysis/belief-decomposition-derived-vs-authored.md)
