---
id: em:76ccba
type: concept
title: agent swarm
description: "A multi-agent system in which many concurrently running LLM agents coordinate on shared work, whose aggregate behavior — coordination, cascades, consensus, contention — emerges from the interactions rather than from any single member's competence."
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, agents, multi-agent, swarm, coordination, failure-modes]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T12:25:27Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-16 Inkling/BEAM swarm-eval spike thread"
---

# agent swarm

The unit of analysis shifts from the individual to the population: a swarm can fail while every member performs acceptably, through dynamics like coordination collapse and deadlock, duplicated or contended work, error and hallucination cascades, groupthink and premature consensus, stale-belief propagation, message-storm amplification, and Byzantine (adversarial or poisoned) members. Evaluating one therefore means measuring the *interaction graph* — cascade depth, redundancy ratios, time-to-consensus, recovery after member loss — on top of task success, and stressing it with [fault injection](/beliefs/glossary/fault-injection.md). The [dark factory](/beliefs/glossary/dark-factory.md) scenario is a swarm operated as a company; a swarm writing to a shared knowledge base is where this brain's concurrent-writer governance questions become live.

*Seen in:* [2026-07-16 Inkling/BEAM swarm-eval spike thread](/meta/threads/2026-07-16-inkling-beam-swarm-eval-spike.md), [inkling-beam-swarm-eval-substrate analysis](/meta/analysis/inkling-beam-swarm-eval-substrate.md), [dark-factory scenario analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
