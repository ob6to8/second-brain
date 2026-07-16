---
id: em:5d40bf
type: concept
title: OTP
description: Erlang/Elixir's standard framework of battle-tested abstractions for fault-tolerant systems on the BEAM — supervision trees that restart crashed processes by declared strategy, GenServers as generic stateful server processes, and applications as deployable, supervised units.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, otp, erlang, elixir, supervision, fault-tolerance]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-12T09:05:38+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# OTP

Supervision trees are the mechanism behind [let-it-crash](/beliefs/glossary/let-it-crash.md); GenServers are the behaviour where most long-lived state lives. On the [BEAM](/beliefs/glossary/beam.md), a codebase with no OTP application is Elixir used as a scripting language — adopting OTP is the line where a project becomes a resident system.

*Seen in:* [BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md), [dark-factory scenario analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
