---
id: em:d94806
type: concept
title: GenServer
description: An OTP behaviour implementing a single-process, sequential-mailbox server that holds state and handles one message at a time through callbacks — the standard Elixir/Erlang unit for a stateful, supervised concurrent actor.
provenance: "Agent-distilled glossary definition, Claude Code session"
verified: false
sense: common
tags: [elixir, otp, beam, concurrency, actor-model]
timestamp: 2026-07-17
attribution:
  when: 2026-07-17T18:52:15Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-17 GenServer-agent-minds thread"
---

# GenServer

The concrete realization of the [actor model](/beliefs/glossary/actor-model.md) in
Elixir/Erlang: client requests arrive as messages in a mailbox and are dispatched to
`handle_call` (synchronous), `handle_cast` (asynchronous), or `handle_info` (arbitrary
messages) callbacks, each returning the process's next state. Because it processes one
message at a time, a slow operation inside a callback blocks the whole mailbox — the
idiom for long I/O such as an LLM call is to spawn a `Task` and receive its result later
as a `handle_info` message rather than block. State lives only in the process, so it is
lost on crash; durability comes from an external store the process rehydrates from under
[supervision](/beliefs/glossary/let-it-crash.md).

*Seen in:* [agents-as-genservers-with-per-agent-okf-mind](/meta/analysis/agents-as-genservers-with-per-agent-okf-mind.md), [2026-07-17 escape-rate plan and GenServer agent minds](/meta/threads/2026-07-17-escape-rate-plan-and-genserver-agent-minds.md)

*See also:* [actor model](/beliefs/glossary/actor-model.md), [OTP](/beliefs/glossary/otp.md), [let it crash](/beliefs/glossary/let-it-crash.md), [two-tier memory](/beliefs/glossary/two-tier-memory.md)
