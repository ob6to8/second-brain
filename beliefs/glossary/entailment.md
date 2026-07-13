---
id: sb:c2c638
type: concept
title: entailment (logical consequence)
description: The relation "every interpretation satisfying the premises also satisfies the conclusion" — the formal notion a per-edge entailment judgment approximates when a belief graph asks whether premises license a conclusion.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, logic, epistemics, semantics]
sense: common
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T20:14:11+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "extracted in the glossary run over the eight epistemic prior-art docs"
---

# entailment (logical consequence)

The relation between premises and a conclusion that holds when every
interpretation making the premises true also makes the conclusion true — truth
preserved in *all* models, not just observed ones. In first-order logic
entailment is provable (completeness) but only
[semidecidable](/beliefs/glossary/semidecidability.md); in a semiformal belief graph
it is the question each support edge poses ("do these premises license this
conclusion?"), answered by an LLM judgment rather than a proof calculus — same
shape, weaker oracle.

*Seen in:* [FOL and OWL reference](/knowledge/knowledge-management/knowledge-representation/first-order-logic-and-owl.md), [belief-decomposition analysis](/meta/analysis/belief-decomposition-derived-vs-authored.md)
