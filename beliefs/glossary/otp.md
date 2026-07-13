---
id: sb:5d40bf
type: concept
title: OTP
description: Erlang/Elixir's standard framework of battle-tested abstractions for fault-tolerant systems on the BEAM — supervision trees that restart crashed processes by declared strategy, GenServers as generic stateful server processes, and applications as deployable, supervised units.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, otp, erlang, elixir, supervision, fault-tolerance]
sense: common
timestamp: 2026-07-12
attribution:
  when: 2026-07-12T09:05:38+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# OTP

Erlang/Elixir's standard framework of abstractions for building fault-tolerant systems on the [BEAM](/beliefs/glossary/beam.md). Its core pieces: **supervision trees** — hierarchies of supervisor processes that monitor children and restart them according to declared strategies when they crash (the mechanism behind [let-it-crash](/beliefs/glossary/let-it-crash.md)); **GenServers** — the generic stateful server-process behaviour most long-lived state lives in; and **applications** — supervised, deployable units. A codebase with no OTP application is Elixir used as a scripting language; adopting OTP is the line where a project becomes a resident system.

*Seen in:* [BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md), [dark-factory scenario analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
