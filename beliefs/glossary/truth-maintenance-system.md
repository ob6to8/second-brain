---
id: sb:cd2537
type: concept
title: truth maintenance system (TMS)
description: Classic-AI bookkeeping machinery that records beliefs with the justifications supporting them and revises belief when premises change; justification-based (JTMS, Doyle) and assumption-based (ATMS, de Kleer) variants.
provenance: "Agent-distilled glossary definition, pointer to the defining doc"
verified: false
tags: [glossary, epistemics, truth-maintenance, knowledge-representation]
sense: common
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T20:14:11+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "extracted in the glossary run over the eight epistemic prior-art docs"
---

# truth maintenance system (TMS)

A reasoner-side bookkeeping component that records every belief together with
the justifications supporting it, so retractions and contradictions propagate
to exactly the affected beliefs. Comes in a justification-based variant (JTMS,
Doyle 1979: one repaired-in-place belief set) and an assumption-based variant
(ATMS, de Kleer 1986: per-belief assumption labels, many coexisting contexts).
Canonically defined in
[truth maintenance systems (TMS / RMS)](/knowledge/knowledge-management/knowledge-representation/truth-maintenance-systems.md).

*Seen in:* [TMS reference](/knowledge/knowledge-management/knowledge-representation/truth-maintenance-systems.md), [Doyle 1979 capture](/knowledge/knowledge-management/knowledge-representation/doyle-1979-a-truth-maintenance-system.md), [de Kleer 1986 capture](/knowledge/knowledge-management/knowledge-representation/de-kleer-1986-an-assumption-based-tms.md), [belief-decomposition analysis](/meta/analysis/belief-decomposition-derived-vs-authored.md)
