---
id: sb:d73148
type: concept
title: blast radius (of a retracted premise)
description: The set of beliefs transitively dependent on a premise — everything that needs re-examination when it is retracted or changed; an importance/staleness signal, never a truth score.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, epistemics, dependencies, staleness]
sense: dual
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T09:07:29+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "operator-listed term from the belief-decomposition design discussion"
---

# blast radius (of a retracted premise)

The set of beliefs reachable from a premise along dependency edges — i.e.
everything that transitively rests on it, and therefore everything requiring
re-examination when that premise is retracted, revised, or superseded.
Computable mechanically once dependencies are explicit (it is what
dependency-directed backtracking in a
[truth maintenance system](/knowledge/knowledge-management/knowledge-representation/truth-maintenance-systems.md)
walks).

**In this brain:** per the
[epistemic-overlay plan](/meta/plans/epistemic-overlay.md)'s strength-as-count
boundary, in-degree/blast-radius is an *importance and staleness* signal — how
much is at stake — never a measure of how true the premise is.

*Seen in:* [epistemic-overlay plan](/meta/plans/epistemic-overlay.md), [truth maintenance systems](/knowledge/knowledge-management/knowledge-representation/truth-maintenance-systems.md), [belief-decomposition analysis](/meta/analysis/belief-decomposition-derived-vs-authored.md)
