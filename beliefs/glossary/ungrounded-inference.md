---
id: sb:570738
type: concept
title: ungrounded inference
description: A derived belief that does not resolve, transitively through its justifications, to any evidence leaf (attestation/source) — the primary defect an epistemic-graph integrity check flags.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, epistemics, verification, integrity]
sense: common
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T09:07:29+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "operator-listed term from the belief-decomposition design discussion"
---

# ungrounded inference

A derived belief (an inference) whose justification chain never bottoms out in
evidence: walking its dependencies transitively reaches no live attestation or
source. It is the primary defect a mechanical integrity check over an epistemic
graph can flag — a floor predicate ("every inference resolves to ≥1
attestation"), not a truth score. The
[epistemic-overlay plan](/meta/plans/epistemic-overlay.md) makes exactly this
check the core of its proposed `mix brain.graph`, and a hidden ungrounded
inference mid-tree is what invalidates an
[assurance case](/knowledge/knowledge-management/argumentation/assurance-cases-and-gsn.md)
above it.

*Seen in:* [epistemic-overlay plan](/meta/plans/epistemic-overlay.md), [assurance cases and GSN](/knowledge/knowledge-management/argumentation/assurance-cases-and-gsn.md), [belief-decomposition analysis](/meta/analysis/belief-decomposition-derived-vs-authored.md)
