---
id: em:862042
type: concept
title: let-it-crash
description: Erlang's fault-tolerance philosophy — rather than defensively handling every possible error in place, let a failing process crash and have a supervisor restart it in a known-good state, keeping error-handling logic out of business logic.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, erlang, fault-tolerance, supervision]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-12T09:05:38+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# let-it-crash

What makes it safe: a crashed process has an **isolated heap**, so nothing else is corrupted, and an [OTP](/beliefs/glossary/otp.md) supervisor brings it back up cleanly. Error recovery becomes a structural property of the supervision tree instead of scattered rescue clauses; paired with checkpointed state, it is what lets an unattended system self-heal at 3am.

*Seen in:* [dark-factory scenario analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
