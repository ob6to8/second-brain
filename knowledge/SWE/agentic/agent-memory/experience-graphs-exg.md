---
id: em:221e3e
type: reference
title: "EXG: Self-Evolving Agents with Experience Graphs (2026)"
description: A plug-and-play memory module that organizes an agent's accumulated successes and failures into a structured relational graph — grown online during execution or consolidated offline — showing better performance-efficiency trade-offs than reflection- and unstructured-memory baselines on code-generation and reasoning benchmarks.
resource: https://arxiv.org/abs/2605.17721
provenance: "Distilled from the paper's abstract (arXiv:2605.17721), fetched 2026-07-20"
tags: [agent-memory, experience-graph, self-evolving-agents, llm-agents, structured-memory]
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T21:05:00Z
  channel: intake
  agent: "Claude Code agent, decision-tree-dev-history session"
  why: "representative of the 2026 structured-agent-memory literature showing distilled, linked records beat raw trajectories — the reasoning-efficiency evidence in the decision-records analysis"
---

# EXG: Self-Evolving Agents with Experience Graphs

arXiv:2605.17721 (2026). Most deployed LLM agents are "behaviorally static" —
they don't improve from their own history — and prior self-evolution attempts
(ad-hoc reflection, unstructured memory accumulation) suffer fragmentation and
"delayed usability." EXG instead **"explicitly organizes accumulated successes
and failures into a structured, relational representation"** — an experience
graph — enabling systematic knowledge reuse across tasks.

## Mechanics and results

- **Dual operation modes:** online, real-time graph growth during execution
  (immediate cross-task reuse) and offline consolidation as an external memory
  module. Positioned as a **plug-and-play component** for existing agents.
- On code-generation and reasoning benchmarks, EXG shows **"more favorable
  performance-efficiency trade-offs than reflection- and memory-based
  baselines"** in both online and offline evaluation.
- Framed as "a principled foundation for scalable and transferable self-evolving
  agent behavior."

## Why it matters here

EXG is representative of a converging 2026 literature (graph memory,
event-centric "logic map" memory, episodic-memory reasoning): **agents reason
better and cheaper over distilled, linked records than over raw trajectories.**
A session thread body is a raw trajectory; a decision graph over distilled
records is exactly the form this literature favors — the reasoning-efficiency
half of the case made in the
[decision-records analysis](/meta/analysis/decision-records-as-history-abstraction.md).

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:221e3e">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-20-decision-records-as-history-abstraction (2026-07-20)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:221e3e`]**

**3. Structured memory for agentic reasoning (very current).** [EXG: Self-Evolving Agents with Experience Graphs](https://arxiv.org/abs/2605.17721) (2026) shows organizing accumulated successes/failures into a relational graph yields better performance-efficiency trade-offs than reflection- and unstructured-memory baselines; a cluster of 2026 papers (graph memory, event-centric "logic map" memory, episodic-memory reasoning) converges on the same result: **agents reason better and cheaper over distilled, linked records than over raw trajectories.** Thread bodies are raw trajectories; a decision graph is exactly the distilled-and-linked form this literature favors.
