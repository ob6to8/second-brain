---
id: sb:f02167
type: reference
title: "PARC — a self-reflective agent for long-horizon autonomous execution"
description: A hierarchical multi-agent coding system that adds an independent self-assessment/self-feedback agent to catch high-level strategic errors, sustaining autonomous progress across multi-day scientific and data-science workflows.
resource: https://arxiv.org/abs/2512.03549
provenance: "Distilled from the PARC paper (arXiv:2512.03549, Orimo et al.), fetched 2026-07-11"
tags: [agentic-loop, long-horizon, self-reflection, multi-agent, autonomy, reliability]
timestamp: 2026-07-11
---

# PARC — a self-reflective agent for long-horizon autonomous execution

PARC (Yuki Orimo, Iori Kurata, Hodaka Mori, Ryuhei Okuno, Ryohto Sawada, Daisuke
Okanohara; arXiv:2512.03549, submitted 2025-12-03) targets the dominant failure of
the [agent execution loop](/SWE/agentic-coding/agentic-loop/the-agent-execution-loop.md)
at scale: reliability decays as tasks lengthen, and a plain reason→act→observe loop
drifts off-strategy over hours or days with no mechanism to notice.

## The mechanism

PARC adds an **independent evaluation agent** that runs *self-assessment and
self-feedback* over the executor's actions and outcomes — not line-level linting,
but detection of **high-level strategic errors** — so the system can re-plan and
correct course without a human in the loop. It sits in a **hierarchical
multi-agent architecture** separating task planning, execution, and independent
assessment. This is the reflect/recover step that
[designing agentic loops](/SWE/agentic-coding/agentic-loop/designing-agentic-loops.md)
argues long-running agents need, made a first-class component.

## Results

Demonstrated on genuinely long-horizon work rather than short benchmarks:

- Autonomously **reproduced materials-science findings** (lithium-ion conduction,
  alloy segregation), orchestrating dozens of parallel simulations — each ~43 hours
  of computation — with end-to-end monitoring and error correction.
- Produced **Kaggle solutions competitive with human-engineered baselines** from
  minimal natural-language instructions.

## Why it matters for the brain

Concrete architecture for the reliability-over-time problem the
[time-horizon data](/SWE/agentic-coding/agentic-loop/agent-task-time-horizons.md)
quantifies: an explicit, *independent* self-reflection layer is one answer to why
"doubling task duration more than doubles failure," extending the loop lexicon this
folder tracks with a supervise-and-recover tier.

# Citations

PARC (arXiv:2512.03549) — <https://arxiv.org/abs/2512.03549>
