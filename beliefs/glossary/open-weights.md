---
id: em:02dc95
type: concept
title: open weights
description: "A model release mode in which the trained parameters are published for download and self-hosting under a license, without necessarily disclosing training data, code, or recipe — sitting between closed API-only access and fully open-source releases."
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, open-weights, licensing, models, self-hosting]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T12:25:27Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-16 Inkling/BEAM swarm-eval spike thread"
---

# open weights

What it buys: custody (data never leaves your infrastructure), local fine-tuning, and — critically for evaluation work — **pinning**: a checkpoint you hold can never be silently revised, deprecated, or retired by a provider, so longitudinal measurements keyed on a weights hash stay comparable indefinitely, where a closed API's model is a moving target. What it does not buy: the ability to reproduce or audit *training* (data and recipe stay private), and it shifts serving cost and ops burden onto the deployer. Examples in this brain's orbit: [Inkling](/beliefs/glossary/inkling.md) (Apache 2.0), the Llama and Qwen families.

*Seen in:* [2026-07-16 Inkling/BEAM swarm-eval spike thread](/meta/threads/2026-07-16-inkling-beam-swarm-eval-spike.md), [inkling-beam-swarm-eval-substrate analysis](/meta/analysis/inkling-beam-swarm-eval-substrate.md)
