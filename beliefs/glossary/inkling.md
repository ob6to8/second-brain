---
id: em:2015c6
type: concept
title: Inkling
description: "Thinking Machines Lab's first open-weights foundation model (released 2026-07-15): an Apache-2.0 multimodal Mixture-of-Experts transformer with 975B total / 41B active parameters, up to 1M-token context, a controllable thinking-effort knob, and fine-tuning support via Tinker."
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, inkling, thinking-machines, open-weights, moe, foundation-model]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T12:25:27Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-16 Inkling/BEAM swarm-eval spike thread"
---

# Inkling

The vendor positions it for adaptation rather than leaderboard dominance — "many real-world problems aren't solved well by even the best generalist models" — which is why it ships everywhere the open ecosystem runs (vLLM, SGLang, llama.cpp; hosted on TogetherAI, Fireworks, Modal, Databricks, Baseten) and pairs with [Tinker](/beliefs/glossary/tinker.md) for LoRA customization. A lighter **Inkling-Small** (12B active) targets latency- and cost-sensitive deployments; the full [MoE](/beliefs/glossary/mixture-of-experts.md) (66 layers, 6-of-256 routed experts plus 2 shared) needs ~2TB VRAM in BF16 or ~600GB quantized to self-host. Self-reported agentic benchmarks at launch: 77.6% SWEBench Verified, 63.8% Terminal Bench 2.1. It was also trained for calibrated probabilistic forecasting via RL against claim-verifying reward models.

*Seen in:* [2026-07-16 Inkling/BEAM swarm-eval spike thread](/meta/threads/2026-07-16-inkling-beam-swarm-eval-spike.md), [inkling-beam-swarm-eval-substrate analysis](/meta/analysis/inkling-beam-swarm-eval-substrate.md), https://thinkingmachines.ai/news/introducing-inkling/
