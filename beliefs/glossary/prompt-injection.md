---
id: em:8654d1
type: concept
title: prompt injection
description: An attack in which instructions embedded in untrusted content an LLM processes — a web page, email, document, tool result — hijack the model into serving the attacker's intent instead of the user's task.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, security, llm, agents]
sense: common
timestamp: 2026-07-12
attribution:
  when: 2026-07-12T09:05:38+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# prompt injection

An attack in which instructions embedded in untrusted content an LLM processes — a web page it fetches, an email it summarizes, a document or tool result it reads — hijack the model into serving the attacker's intent instead of the user's task. It exploits the model's inability to firmly separate *data to analyze* from *instructions to follow*; when the hijacked agent can also write into shared memory, the attack compounds into [epistemic poisoning](/beliefs/glossary/epistemic-poisoning.md).

*Seen in:* [dark-factory scenario analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
