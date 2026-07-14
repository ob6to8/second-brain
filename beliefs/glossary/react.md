---
id: em:f5c2bd
type: concept
title: ReAct
description: The foundational LLM agent loop — the model alternates free-form reasoning traces with tool actions whose observations feed back into further reasoning; canonically defined in the filed reference on the Yao et al. paper.
provenance: "Agent-distilled glossary pointer entry"
verified: false
tags: [glossary, agentic-loop, react, pointer]
sense: common
timestamp: 2026-07-12
attribution:
  when: 2026-07-12T09:05:38+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# ReAct

The foundational LLM agent loop: the model alternates free-form **rea**soning traces with tool **act**ions, and each action's observation feeds back into the next round of reasoning. Widely reused as the default strategy in agent frameworks (including [Jido](/beliefs/glossary/jido.md)'s `jido_ai`).

Canonically defined in [ReAct — reasoning + acting as the thought-action-observation loop (Yao et al.)](/knowledge/SWE/agentic/agentic-loop/react-reasoning-and-acting.md).

*Seen in:* [BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md)
