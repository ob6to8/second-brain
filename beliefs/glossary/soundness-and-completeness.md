---
id: em:2b6117
type: concept
title: soundness and completeness
description: The paired correctness properties of a proof system — sound: everything derivable is valid; complete: everything valid is derivable. Gödel (1929) proved first-order logic has both, aligning syntax with semantics.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, logic, proof-theory, metatheory]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-11T20:14:11+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "extracted in the glossary run over the eight epistemic prior-art docs"
---

# soundness and completeness

Both properties hold relative to a semantics: **soundness** means the system
proves no falsehoods, **completeness** that no truth lies out of reach. Gödel's 1929 completeness theorem
established both for first-order logic, making syntactic derivation and
semantic [entailment](/beliefs/glossary/entailment.md) coincide. The same vocabulary
recurs wherever a mechanical procedure answers for a semantic notion — e.g. an
ATMS [label](/beliefs/glossary/label-atms.md) is required to be sound *and* complete
with respect to derivability from environments.

*Seen in:* [FOL and OWL reference](/knowledge/knowledge-management/knowledge-representation/first-order-logic-and-owl.md), [de Kleer 1986 capture](/knowledge/knowledge-management/knowledge-representation/de-kleer-1986-an-assumption-based-tms.md)
