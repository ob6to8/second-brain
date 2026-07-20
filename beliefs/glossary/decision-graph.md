---
id: em:cd979f
type: concept
title: decision graph
description: A persistent DAG of an agent system's reasoning — goals, decisions, options, outcomes as typed nodes and edges — kept so later sessions can recall what was tried, what was rejected, and why; in this brain, the proposed compiled view over capture-time decision records.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, agents, memory, dag, loomkin, reasoning, decision-records]
sense: dual
timestamp: 2026-07-20
attribution:
  when: 2026-07-14T00:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-14 Elixir AST/macros and Loomkin thread"
---

# decision graph

A persistent [directed acyclic graph](/beliefs/glossary/directed-acyclic-graph.md) recording an agent system's *reasoning* rather than its knowledge: goals, decisions, options considered, actions, outcomes, and observations as nodes, connected by [typed edges](/beliefs/glossary/typed-edge.md) (chosen, rejected, requires, blocks, supersedes). The point is resumability — a later session can recall what was tried, what was rejected, and why. Loomkin's implementation adds per-node 0–100 confidence scores with cascade propagation: when a decision's confidence drops, nodes downstream of `requires`/`blocks` edges receive uncertainty flags — a working cousin of [staleness propagation](/beliefs/glossary/staleness-propagation.md). Reasoning memory of this kind is complementary to, not a substitute for, a governed knowledge corpus: it records *how the system decided*, not *what it knows*.

**In this brain:** the proposed derived view of the
[decision-graph plan](/meta/plans/decision-extraction-and-compiled-decision-graph.md)
— per-decision records minted at capture time, joined by
`implements`/`supersedes`/`refines` edges keyed on stable ids and materialized
by `mix brain.decisions` into a CI-verified tree rooted in doctrine. Unlike
Loomkin's variant it carries no confidence scores: records are asserted,
operator-ratifiable statements.

*Seen in:* [2026-07-14 Elixir AST/macros and Loomkin thread](/meta/threads/2026-07-14-elixir-ast-macros-and-loomkin-evaluation.md), [Loomkin analysis](/meta/analysis/loomkin-as-existence-proof.md), [2026-07-20 decision-records thread](/meta/threads/2026-07-20-decision-records-as-history-abstraction.md)
