---
id: sb:e1c3b6
type: concept
title: epistemic poisoning
description: The contamination of a shared knowledge base with false or attacker-shaped beliefs — typically via an agent ingesting untrusted content and filing it as fact — escalating prompt injection from hijacking one session to corrupting every future reader of the base.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, security, epistemics, trust, dark-factory]
sense: common
timestamp: 2026-07-12
attribution:
  when: 2026-07-12T09:05:38+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# epistemic poisoning

The contamination of a shared knowledge base with false or attacker-shaped beliefs, typically via an agent that ingests untrusted external content and files it as fact. It is [prompt injection](/beliefs/glossary/prompt-injection.md) escalated one level: instead of hijacking a single session, the attack corrupts the belief substrate every future agent reads, so one poisoned "fact" propagates to every decision that rests on it. Defenses are the knowledge base's immune system: immutable [provenance](/beliefs/glossary/provenance.md), evidence-backed [verification grounding](/beliefs/glossary/verification-grounding.md), quarantine states for unverified intake, and a single write choke point where checks cannot be bypassed.

*Seen in:* [dark-factory scenario analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
