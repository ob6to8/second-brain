---
id: em:b528d9
type: concept
title: durable execution
description: A workflow-runtime pattern in which a long-running program's progress is persisted as an event log and deterministically replayed after a crash, redeploy, or pause, so execution resumes exactly where it left off (the Temporal / Vercel Workflows family).
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, durability, workflows, runtime, agents]
sense: common
timestamp: 2026-07-17
attribution:
  when: 2026-07-17T20:30:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-17 vercel-eve comparison thread"
---

# durable execution

Two consequences make the pattern distinctive for agents. Checkpointed steps
give completed side effects exactly-once semantics: on replay, a step whose
result is already in the log returns that recorded result instead of
re-firing — where an ordinary retry loop is at-least-once and can re-send the
email or re-issue the refund. And a run can park indefinitely between events
(waiting for a human approval or the next message) without consuming compute.
The BEAM/OTP world reaches durability differently — crash, restart clean under
a supervisor, rehydrate from persisted state
([let-it-crash](/beliefs/glossary/let-it-crash.md)) — recovering the *process*
rather than replaying the *history*.

*Seen in:* [2026-07-17 vercel-eve comparison thread](/meta/threads/2026-07-17-vercel-eve-comparison-and-jido-host-plan.md), [vercel-eve-comparison analysis](/meta/analysis/vercel-eve-comparison.md)
