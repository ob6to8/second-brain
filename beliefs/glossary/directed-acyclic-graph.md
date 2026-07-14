---
id: em:802d4e
type: concept
title: directed acyclic graph
description: A graph of nodes joined by directed edges that contains no cycles, so following edges never returns to a starting node — the shape of dependencies, pipelines, and orderings.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, graphs, formalism, dag]
sense: common
timestamp: 2026-07-13
attribution:
  when: 2026-07-13
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-13 artifacts-concept-and-anthropic-node-restructure thread"
---

# directed acyclic graph

A graph (DAG) whose edges have a direction and which contains no cycles: starting
from any node and following edges, you can never return to it. This is the natural
shape for anything with a one-way dependency or ordering — build pipelines, task
dependencies, git commit history, and knowledge graphs of cross-linked concepts —
and it guarantees a valid topological order (a linear sequence respecting every
edge). Renders well as a visual — e.g. a Mermaid `flowchart` inside a Claude
[artifact](/beliefs/glossary/artifact.md).

*Seen in:* [2026-07-13 artifacts-concept-and-anthropic-node-restructure thread](/meta/threads/2026-07-13-artifacts-concept-and-anthropic-node-restructure.md)
