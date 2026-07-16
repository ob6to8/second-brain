---
id: em:5b4fca
type: concept
title: Tinker
description: "Thinking Machines Lab's managed LoRA fine-tuning API (launched 2025-10): low-level Python primitives (forward_backward, optim_step, sample, save_state) over managed distributed-training infrastructure, exporting standard PEFT adapters or merged Hugging Face models."
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, tinker, thinking-machines, fine-tuning, lora, rl, training]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T12:25:27Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-16 Inkling/BEAM swarm-eval spike thread"
---

# Tinker

Its design bet is abstracting the *infrastructure* of distributed training without hiding the *algorithm*: the user writes the training loop, loss, and data handling in ordinary Python while the service owns GPU allocation, sharding, and checkpoints. Because the trained artifact is a [LoRA](/beliefs/glossary/lora.md) adapter over a frozen base, results deploy by hot-swap onto vLLM/SGLang rather than by shipping new model weights. The companion tinker-cookbook carries reference loops for supervised learning, RLHF, tool-use tasks, and multi-agent RL — Berkeley's SkyRL ran async off-policy multi-agent training on it. Supports [Inkling](/beliefs/glossary/inkling.md) and 28+ other open models; launch-era pricing was per-million-token (prefill / sampling / training metered separately).

*Seen in:* [2026-07-16 Inkling/BEAM swarm-eval spike thread](/meta/threads/2026-07-16-inkling-beam-swarm-eval-spike.md), [inkling-beam-swarm-eval-substrate analysis](/meta/analysis/inkling-beam-swarm-eval-substrate.md), https://tinker-docs.thinkingmachines.ai/
