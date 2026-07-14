---
id: em:dcbb9e
type: concept
title: bipartite graph
description: A graph whose nodes divide into two disjoint sets with edges only between the sets; in belief graphs, belief nodes vs. justification nodes, so one conclusion can carry several independent justifications.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, graph-theory, epistemics]
sense: common
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T09:07:29+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "operator-listed term from the belief-decomposition design discussion"
---

# bipartite graph

A graph whose nodes divide into two disjoint sets such that every edge connects
a node in one set to a node in the other — never two nodes on the same side. In
epistemic/belief graphs the split is *belief nodes* vs. *justification nodes*
(the ATMS structure): a justification bundles premises → conclusion, so the
same conclusion can be held up by several independent justifications — a
distinction a plain belief-to-belief edge cannot represent and one that
consensus evaluation depends on.

*Seen in:* [truth maintenance systems](/knowledge/knowledge-management/knowledge-representation/truth-maintenance-systems.md), [the Toulmin model](/knowledge/knowledge-management/argumentation/toulmin-model-of-argument.md), [belief-decomposition analysis](/meta/analysis/belief-decomposition-derived-vs-authored.md)
