---
id: sb:c29a22
type: reference
title: "Agent task time horizons — METR's 'Moore's Law for AI agents'"
description: METR's measurement of how long a task an agent can complete at a fixed success rate; the 50% time horizon has doubled roughly every 7 months (accelerating to ~4 months in 2024–25), reaching ~14 hours of human-equivalent work by early 2026.
resource: https://theaidigest.org/time-horizons
provenance: "Distilled from AI Digest's time-horizons tracker summarizing METR's measurements, fetched 2026-07-11"
tags: [agentic-loop, evaluation, long-horizon, reliability, benchmarks, metr]
timestamp: 2026-07-11
---

# Agent task time horizons — METR's "Moore's Law for AI agents"

METR's time-horizon metric answers *how long* an agent can work, not just how
smart it is — the measurement lens behind the whole long-horizon push in this
folder. A model's **time horizon** is the human-completion-time length of task it
succeeds at some fixed rate.

## The measurement

- **50% time horizon** — the task length (measured in human completion time) at
  which the agent succeeds half the time. **80% time horizon** is the same at the
  stricter 0.8 reliability bar, and is always much shorter.
- Method: ~230 tasks (mostly coding, plus reasoning), human times from <30s to
  8+ hours, correlating task length against agent success. Strong fit
  (**R² ≈ 0.83**) and clean exponential growth in achievable duration across
  2019–2026.

## The trend

- The 50% horizon **doubled roughly every 7 months** over 2019–2025, then
  **accelerated to ~every 4 months** in 2024–2025.
- By early 2026, frontier systems clear **~14 hours** of human-equivalent coding
  work at 50% — but far less at 80%, so structured, verifiable tasks are within
  reach well before open-ended ones.

## Why it matters for the brain

This is the quantitative frame for every agentic-loop note about running agents
longer: reliability falls steeply as tasks lengthen (the gap between the 50% and
80% horizons *is* that decay), which is exactly the bottleneck that
[loop design](/SWE/agentic-coding/agentic-loop/designing-agentic-loops.md) and
self-reflective architectures like
[PARC](/SWE/agentic-coding/agentic-loop/parc-self-reflective-long-horizon-agent.md)
exist to push back.

# Citations

AI Digest — A new Moore's Law for AI agents (time horizons), summarizing METR —
<https://theaidigest.org/time-horizons>
