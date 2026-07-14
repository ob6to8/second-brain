---
id: sb:401ff6
type: reference
title: Truth maintenance systems (TMS / RMS)
description: Classic-AI knowledge-representation machinery (Doyle's JTMS, de Kleer's ATMS) that tracks beliefs together with the justifications that support them, revising belief when premises change — the original bipartite belief/justification dependency graph.
resource: https://en.wikipedia.org/wiki/Reason_maintenance
provenance: "Distilled from the Wikipedia article on reason maintenance (fetched 2026-07-11), with mechanics supplemented from the standard literature (Doyle 1979; de Kleer 1986); layered breakdown via /summarize-technical"
tags: [knowledge-representation, epistemics, truth-maintenance, belief-revision, classic-ai, dependency-graph]
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T09:07:29+00:00
  channel: intake
  agent: "Claude Code agent, /intake"
  why: "operator-directed prior-art capture for the belief-decomposition assessment; body later restructured via /summarize-technical"
---

# Truth maintenance systems (TMS / RMS)

## Summary

A reasoning program that draws conclusions from what it currently believes has
a problem the moment it learns something new that contradicts an earlier
belief: which of its conclusions must it now give up? Throwing everything away
and re-deriving from scratch is wasteful; undoing the most recent guesses is
often simply wrong, because the fault may lie with an old assumption.

The truth maintenance system (late 1970s–80s AI) is the classic answer: a
bookkeeping component that sits beside the reasoner and records, for every
conclusion, exactly which earlier statements it was derived from and by what
step. Those records form a network — conclusions linked back through
derivation steps to the basic statements they rest on. When a contradiction
appears, the system follows the recorded links *backwards* to find the small
set of assumptions actually responsible, withdraws one, and then follows links
*forwards* to retract precisely the conclusions that depended on it — nothing
more.

Two designs matter. Jon Doyle's original (1979) keeps a single current set of
beliefs and repairs it in place whenever a contradiction arises. Johan de
Kleer's variant (1986) instead tags every conclusion with *all* the
combinations of assumptions under which it would hold, so several rival
worldviews — each internally consistent, mutually contradictory — can be
explored side by side without ever being merged. That second design is what
lets a machine reason about incompatible alternatives without its knowledge
base collapsing into nonsense.

## Key terms

- **Truth/reason maintenance system (TMS/RMS)** — the bookkeeping component
  above: it maintains the belief records and their derivation links, while a
  separate *reasoner* supplies the inferences. The two communicate through an
  interface — inference happens in one place, belief status in the other.
- **Dependency network** — the record structure: each node is a knowledge-base
  entry, each arc an inference step through which a node was derived.
- **Premise** — a node believed unconditionally; the floor the network stands
  on. Distinct from an **assumption**, a node believed provisionally and
  eligible for retraction.
- **Justification** — the record of one derivation step: the set of nodes that
  jointly license a conclusion. A node may hold several independent
  justifications; it stays believed while at least one is valid. (This makes
  the network a [bipartite graph](/beliefs/glossary/bipartite-graph.md): belief nodes
  and justification nodes, never belief-to-belief edges directly.) The
  classical forms are the *support list* (believe this if these are believed)
  and the *conditional proof* (believe this if that would follow from those).
- **IN / OUT (non-monotonic justification)** — Doyle's support lists carry two
  parts: nodes that must be believed (IN) and nodes that must be *absent from
  belief* (OUT). The OUT half is what makes the system non-monotonic — a
  belief can rest on the *lack* of another, and adding information can remove
  conclusions.
- **JTMS (justification-based TMS)** — Doyle's design: one current belief set,
  each node labeled believed/disbelieved by well-founded support from
  premises, repaired in place on contradiction.
- **Dependency-directed backtracking** — the JTMS repair move: trace back from
  a contradiction through the justification records to the underlying
  assumptions, and retract a culprit assumption — rather than undoing choices
  in chronological order.
- **ATMS (assumption-based TMS)** — de Kleer's design: instead of one belief
  set, every node carries a **label**: the set of minimal **environments**
  (combinations of assumptions) from which it derivably follows.
- **Nogood** — an environment discovered to be inconsistent, recorded so that
  no context is ever built on it again.
- **Context** — everything derivable from one consistent environment; the
  ATMS's unit of "a coherent worldview." Multi-context operation is what
  gives the ATMS its paraconsistency: contradictions are quarantined per
  context instead of poisoning the whole store.

## Technical summary

A TMS pairs a reasoner with a reason-maintenance component over a shared
dependency network: nodes are KB entries (premises, assumptions, derived
beliefs), and each derivation is recorded as a justification — a support-list
(IN-list, OUT-list) or conditional-proof record — so the network is bipartite
between beliefs and justifications. A node is believed iff it has at least one
valid justification; premises are unconditionally justified; OUT-list
dependence makes belief non-monotonic.

In Doyle's JTMS the network carries a single belief labeling computed by
well-founded support from premises. On derivation of a contradiction node,
dependency-directed backtracking walks the justification structure backwards
to the supporting assumption set, selects a culprit, and installs a
justification that retracts it; the labeling then relaxes forward, so exactly
the [blast radius](/beliefs/glossary/blast-radius.md) of the retracted assumption is
re-examined — the same mechanism that today makes the blast radius of any
retracted premise a computable set rather than a guess.

De Kleer's ATMS replaces the single labeling with per-node labels: each node
stores the minimal consistent environments (assumption sets) entailing it,
with inconsistent environments recorded as nogoods and excluded. A context —
the closure of one consistent environment — plays the role the whole belief
set plays in a JTMS, and many contexts coexist: the ATMS is effectively
paraconsistent across contexts while classical within each. For epistemic
comparison work, the environment/label machinery is the canonical answer to
comparing internally-coherent, mutually-inconsistent belief systems without
merging them.

## Why it is in this brain

The TMS is the closest classic-AI ancestor of the epistemic-substrate idea
this brain is exploring: an [epistemic overlay](/beliefs/glossary/epistemic-overlay.md)
of atomic beliefs and justification edges over artifacts, audited
mechanically. The ATMS environment concept answers how to compare two
internally-coherent but mutually-contradictory documents without merging them
into one inconsistent store. See the
[belief-decomposition analysis](/meta/analysis/belief-decomposition-derived-vs-authored.md)
and the [derived analysis-mode plan](/meta/plans/belief-decomposition-analysis-mode.md).

# Citations

- Reason maintenance — Wikipedia:
  <https://en.wikipedia.org/wiki/Reason_maintenance>
- Jon Doyle, "A Truth Maintenance System," *Artificial Intelligence* 12(3), 1979
  — [captured passages](/knowledge/knowledge-management/knowledge-representation/doyle-1979-a-truth-maintenance-system.md).
- Johan de Kleer, "An Assumption-based TMS," *Artificial Intelligence* 28(2), 1986
  — [captured passages](/knowledge/knowledge-management/knowledge-representation/de-kleer-1986-an-assumption-based-tms.md).
