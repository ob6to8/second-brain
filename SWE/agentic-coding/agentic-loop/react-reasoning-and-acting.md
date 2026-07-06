---
id: sb:f63910
type: reference
title: "ReAct — reasoning + acting as the thought-action-observation loop (Yao et al.)"
description: ReAct establishes the foundational agent loop by having an LLM alternate free-form reasoning traces with task actions whose observations feed back into further reasoning.
resource: https://arxiv.org/abs/2210.03629
provenance: "Distilled from Yao, Zhao, Yu, Du, Shafran, Narasimhan, Cao; arXiv:2210.03629, 2022-10-06 (ICLR 2023)"
tags: [agentic-loop, ai-agents, react, reasoning, tool-use, foundational-paper]
timestamp: 2026-07-06
---

# ReAct — reasoning + acting as the thought-action-observation loop (Yao et al.)

ReAct is the primary source (summarized — it is an academic paper) for the
reason–act–observe loop that later "agentic loop" framings build on. It has an LLM
generate, in alternating sequence, verbal reasoning traces ("thoughts") and
task-specific actions, where actions query external sources (APIs, environments)
that return observations fed back into the next thought. The synergy is its thesis:
*"reasoning traces help the model induce, track, and update action plans as well as
handle exceptions, while actions allow it to interface with external sources."*
Reasoning without acting is prone to hallucination and error propagation because it
can't ground itself in external facts; acting without reasoning lacks high-level
planning. Interleaving both — thought informs action, observation informs the next
thought, iterating until the task resolves — yields more interpretable,
controllable trajectories and reduces hallucination on knowledge-intensive
(HotpotQA, FEVER) and decision-making (ALFWorld, WebShop) benchmarks.

# Citations

S. Yao et al., "ReAct: Synergizing Reasoning and Acting in Language Models",
arXiv:2210.03629, 2022 (ICLR 2023) — <https://arxiv.org/abs/2210.03629>
