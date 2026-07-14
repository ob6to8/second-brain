---
id: sb:862042
type: concept
title: let-it-crash
description: Erlang's fault-tolerance philosophy — rather than defensively handling every possible error in place, let a failing process crash and have a supervisor restart it in a known-good state, keeping error-handling logic out of business logic.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, erlang, fault-tolerance, supervision]
sense: common
timestamp: 2026-07-12
attribution:
  when: 2026-07-12T09:05:38+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# let-it-crash

Erlang's fault-tolerance philosophy: rather than defensively anticipating and handling every possible error inside the code that hit it, let the failing process crash — its isolated heap means nothing else is corrupted — and have an [OTP](/beliefs/glossary/otp.md) supervisor restart it in a known-good state. Error recovery becomes a structural property of the supervision tree instead of scattered rescue clauses; paired with checkpointed state, it is what lets an unattended system self-heal at 3am.

*Seen in:* [dark-factory scenario analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
