---
id: em:733448
type: concept
title: distributed Erlang
description: The BEAM's built-in clustering — named nodes connect into a mesh and processes exchange messages with PIDs on remote nodes transparently, with `:global` naming and `:pg` process groups — the substrate on which cross-node concurrency and failover are built, but which a framework must deliberately opt into.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, distributed-erlang, beam, otp, distribution, clustering]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T07:00:26Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-16 Jido-caveats thread expanding why Jido has no distribution story"
---

# distributed Erlang

The [BEAM](/beliefs/glossary/beam.md)'s native clustering mechanism: named nodes
connect into a fully-connected mesh over which a process can send a message to a
PID on any other node *transparently* — the same `send`/receive semantics as
local, plus `:global` for cluster-wide name registration and `:pg` for distributed
process groups. It is the substrate on which horizontal scale, high availability,
and cross-node failover are built on the BEAM.

Crucially, having the primitives is not the same as using them: a *framework* only
becomes distribution-aware if it makes each layer cluster-aware — where an agent's
identity is registered, how a dead node's processes are handed off and rehydrated
elsewhere, whether the pub/sub bus spans nodes. Many mature Elixir systems (and
young ones like [Jido](/beliefs/glossary/jido.md), whose identity, recovery, and
signal bus are all node-local) stay single-node-first, because distribution forces
genuinely hard choices — split-brain/netsplit handling, the CAP tradeoff on the
registry, and state-handoff races. Building it yourself typically means composing
`libcluster` (node discovery), `Horde` or a hand-rolled registry (distributed
naming + handoff), and a distributed pubsub — a net-new layer, not a config flag.

*Seen in:* [2026-07-16 Jido-caveats thread](/meta/threads/2026-07-16-jido-caveats-and-build-agent-linter-loop.md), [jido-distribution-gap-and-req-llm-cognition-dependency analysis](/meta/analysis/jido-distribution-gap-and-req-llm-cognition-dependency.md)

*See also:* [BEAM](/beliefs/glossary/beam.md), [OTP](/beliefs/glossary/otp.md), [actor model](/beliefs/glossary/actor-model.md)
</content>
