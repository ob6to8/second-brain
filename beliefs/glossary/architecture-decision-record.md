---
id: em:3f16ba
type: concept
title: architecture decision record (ADR)
description: A short per-decision document — context, decision, status, consequences — that records an architectural choice and its why at the time it is made, with supersession links chaining records into a de-facto decision history.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, design-rationale, decision-records, software-architecture, documentation]
sense: common
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T21:40:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-20 decision-records thread"
---

# architecture decision record (ADR)

The radically lightweight modern descendant (Michael Nygard, 2011) of the
structured [design-rationale](/beliefs/glossary/design-rationale.md) tradition:
where IBIS/QOC modeled whole argument graphs, an ADR is one small file per
decision, kept in the repository beside the code it governs, and never rewritten
— a reversed decision gets a *new* record whose `superseded-by` link chains the
history. A current research line automates ADR authoring with LLMs and agents
(captured under
[design-rationale](/knowledge/knowledge-management/design-rationale/index.md)).
In this brain the ADR *slot* is occupied by the
[plan type](/beliefs/glossary/plan-type.md) — "a design/decision record for a
proposed change" — rather than an imported ADR directory.

*Seen in:* [2026-07-20 decision-records thread](/meta/threads/2026-07-20-decision-records-as-history-abstraction.md), [decision-records analysis](/meta/analysis/decision-records-as-history-abstraction.md), [context-strategies capture](/knowledge/knowledge-management/design-rationale/context-strategies-for-adr-generation.md)
