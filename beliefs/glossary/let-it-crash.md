---
id: sb:862042
type: concept
title: let-it-crash
description: Erlang's fault-tolerance philosophy — rather than defensively handling every possible error in place, let a failing process crash and have a supervisor restart it in a known-good state, keeping error-handling logic out of business logic.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, erlang, fault-tolerance, supervision]
timestamp: 2026-07-12
---

# let-it-crash

The crash is safe because the process's isolated heap means nothing else is corrupted, and the supervisor doing the restart is an [OTP](/beliefs/glossary/otp.md) one — recovery becomes a structural property of the supervision tree instead of scattered rescue clauses. Paired with checkpointed state, it is what lets an unattended system self-heal at 3am.

*Seen in:* [dark-factory scenario analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
