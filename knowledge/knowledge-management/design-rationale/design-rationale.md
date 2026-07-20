---
id: em:2e4803
type: concept
title: "Design rationale — capturing the why behind decisions (IBIS, QOC, DRL, and the capture problem)"
description: The research tradition of representing design as a linked structure of issues, considered alternatives, and arguments (IBIS/gIBIS, QOC, DRL), whose practical failure — the capture problem, where the author of rationale pays its cost while others reap its benefit — is the economic constraint any rationale system must dissolve.
provenance: "Distilled by the agent from the classic design-rationale literature (Rittel's IBIS; Conklin & Begeman's gIBIS, 1988; MacLean et al.'s QOC, 1991; Lee's DRL, 1991; Grudin's collaboration-cost analyses)"
verified: false
tags: [design-rationale, ibis, qoc, adr, knowledge-capture, decision-records]
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T21:05:00Z
  channel: agent-authored
  agent: "Claude Code agent, decision-tree-dev-history session"
  why: "grounds the decision-records-as-history-abstraction analysis in the prior research tradition the proposal descends from"
---

# Design rationale — capturing the why behind decisions

**Design rationale** (DR) is the reasoning underlying a design choice: the
question being settled, the alternatives considered, the arguments for and
against each, and why the chosen one won. A research tradition from the 1970s
through the 1990s built structured representations for it:

- **IBIS** (Issue-Based Information System, Horst Rittel) — design as a graph of
  *issues*, *positions* (candidate answers), and *arguments* supporting or
  objecting to positions. **gIBIS** (Conklin & Begeman, 1988) implemented it as a
  graphical hypertext tool.
- **QOC** (Questions, Options, Criteria — MacLean et al., 1991) — "design space
  analysis": each design question spans a space of options assessed against
  explicit criteria, so the *rejected* options and the criteria that rejected
  them are first-class.
- **DRL** (Decision Representation Language — Lee, 1991) — a more formal
  vocabulary of decision problems, alternatives, goals, and claims, supporting
  computation over the rationale structure.

The modern, radically lightweight descendant is the **Architecture Decision
Record** (ADR, Michael Nygard, 2011): one short document per decision —
context, decision, status, consequences — with `superseded-by` links chaining
records into a de-facto decision graph over time.

## The capture problem

The tradition's famous practical failure is the **capture problem** (analyzed by
Jonathan Grudin for groupware generally): rationale capture imposes its cost on
the designer *at design time*, while its benefit accrues to *other people,
later*. Under that incentive structure humans reliably under-document, and DR
tools failed in practice however good the representation was. The enduring
lesson: rationale capture succeeds only when it is a **byproduct of the work
itself**, not an extra authoring task.

An agent-operated knowledge system inverts the economics: the agent bears the
authoring cost, at the moment of decision, as part of a capture motion it
performs anyway — which is why the representation research (the graphs) becomes
newly applicable even though the tools built on it died.

## Seen in

- [Decision records as an abstraction over development history](/meta/analysis/decision-records-as-history-abstraction.md)
  — applies this tradition to the elixir-mind bundle's thread/routing machinery.
- The ADR-automation literature captured beside this concept:
  [LLMs recovering design rationale](/knowledge/knowledge-management/design-rationale/llms-recovering-design-rationale.md),
  [context strategies for ADR generation](/knowledge/knowledge-management/design-rationale/context-strategies-for-adr-generation.md),
  [AgenticAKM](/knowledge/knowledge-management/design-rationale/agentic-architecture-knowledge-management.md),
  [Architecture Without Architects](/knowledge/knowledge-management/design-rationale/architecture-without-architects.md).
