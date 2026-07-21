---
id: em:5554e8
type: concept
title: LoRA
description: "Low-Rank Adaptation: a parameter-efficient fine-tuning method that trains two small low-rank matrices modifying a frozen base model's weights, so a specialized variant ships as a megabytes-scale adapter instead of a full model copy."
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, lora, fine-tuning, peft, adapters, machine-learning]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T12:25:27Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-16 Inkling/BEAM swarm-eval spike thread"
---

# LoRA

The standard interchange format is a **PEFT adapter** (from Hugging Face's parameter-efficient fine-tuning library), which inference servers like vLLM and SGLang can **hot-swap**: one set of base weights stays resident in VRAM while each request selects its adapter by name, so dozens of behavioral variants serve concurrently at roughly the cost of one model. Thinking Machines' published research argues adapters match full fine-tuning quality in the practical regime ("LoRA without regret"), which is the premise of [Tinker](/beliefs/glossary/tinker.md) being LoRA-only. For multi-agent work this enables cheap *population construction* — many role-specialized or deliberately-flawed agents sharing one frozen base, differing by a single trained artifact.

*Seen in:* [2026-07-16 Inkling/BEAM swarm-eval spike thread](/meta/threads/2026-07-16-inkling-beam-swarm-eval-spike.md), [inkling-beam-swarm-eval-substrate analysis](/meta/analysis/inkling-beam-swarm-eval-substrate.md)
