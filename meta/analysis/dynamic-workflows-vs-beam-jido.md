---
type: analysis
title: "Ephemeral spine vs. standing fleet: Anthropic's Dynamic Workflows vs. BEAM/Jido 2"
description: An architecture comparison finding that Claude Code's Dynamic Workflows (a deterministic JS orchestrator over an ephemeral, session-scoped fan-out of stateless inference calls) and BEAM/Jido 2 (a runtime for long-lived, supervised, reactive, distributed stateful agents) occupy different layers rather than competing — so Dynamic Workflows does not obviate the BEAM, recreating it on the BEAM as a replacement is low-value, and the BEAM's real case is durability, event-reactivity, distribution, and fault-isolation of standing agents, best combined as a layered/hybrid architecture.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-16 — operator asked whether recreating Anthropic's new multi-agent Dynamic Workflows architecture on the BEAM with Jido 2 would have advantages, or whether the workflow feature obviates the BEAM. Dynamic Workflows execution model is first-hand (the Workflow tool is in the authoring agent's own toolset); public framing verified against Anthropic's announcement and coverage, Jido 2.0 facts against jido.run/GitHub, all 2026-07-16"
tags: [meta, analysis, architecture, anthropic, dynamic-workflows, orchestration, beam, otp, jido, agents, determinism, actor-model, layered-architecture]
timestamp: 2026-07-16T10:20:00Z
attribution:
  when: 2026-07-16T10:20:00Z
  channel: intake
  agent: "operator via /intake, Claude Code session"
  why: "operator asked whether recreating Anthropic's Dynamic Workflows multi-agent architecture on the BEAM with Jido 2 has any advantage, or whether the workflow feature obviates the BEAM"
---

# Ephemeral spine vs. standing fleet: Anthropic's Dynamic Workflows vs. BEAM/Jido 2

**Question.** Anthropic shipped **Dynamic Workflows** for Claude Code (research
preview, May 2026): Claude writes a JavaScript orchestration script and a separate
runtime executes it, fanning a job out to up to ~1,000 subagents. Given
[Elixir/BEAM](/beliefs/glossary/actor-model.md) and the
[Jido 2](/meta/analysis/beam-deployment-and-jido-2-evaluation.md) agent framework:
would recreating this evolving multi-agent architecture on the BEAM with Jido 2
components buy anything — or does Dynamic Workflows obviate the need for the BEAM?

**Thesis.** They are not competitors; they occupy **different layers**. Dynamic
Workflows is a deterministic [orchestrator](/beliefs/glossary/orchestrator-pattern.md)
for a **bounded, ephemeral fan-out of stateless inference calls** — it computes one
hard answer and exits. BEAM/Jido is a runtime for **long-lived, supervised,
event-reactive, distributed stateful entities** — it runs a standing fleet
indefinitely. Naming both "multi-agent" hides that they sit at different altitudes.
So (1) Dynamic Workflows does **not** obviate the BEAM — it addresses a different
axis entirely; (2) recreating Dynamic Workflows on the BEAM *as a replacement* is
**low-value** — you re-earn its features at a loss; and (3) the BEAM's genuine case
is durability, reactivity, distribution, and fault-isolation of *standing* agents,
which the workflow feature deliberately does not attempt. The strongest design is
**layered**: a BEAM/Jido outer runtime with a Dynamic-Workflows-style deterministic
combinator as the inner ephemeral step.

## 1. What each substrate actually is

**Dynamic Workflows — a deterministic spine over stateless inference.** The
execution model (observed first-hand — the Workflow tool is in this agent's own
toolset):

- **Agents are functions, not entities.** Prompt in → optionally schema-validated
  data out → back to the orchestrator. They hold **no identity or state between
  calls** and **never message each other** — every result routes through one JS
  control plane on a shared filesystem.
- **The control plane is a single script in a single context.** A
  [deterministic spine](/beliefs/glossary/deterministic-spine.md) — loops,
  conditionals, `parallel`/`pipeline` combinators — wrapped around
  non-deterministic model calls.
- **Ephemeral and session-scoped.** It spins up, computes, and exits; concurrency
  is capped (~16 in flight, ~1,000 total).
- **Its distinctive feature is replay.** `Date.now`/`Math.random` are banned so a
  run can be *resumed* — the unchanged prefix of `agent()` calls returns cached
  results instantly. That is event-sourced determinism aimed at cost and iteration
  speed.

**BEAM/Jido 2 — a standing fleet of supervised entities.** The opposite shape (Jido
facts per [the Jido 2 evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md)):
"agents are data" — a struct of state + signal routes hosted inside a supervised
`GenServer` (`Jido.AgentServer`), processed through a pure reducer
`cmd(agent, action) → (new_agent, directives)` where **directives** are typed
descriptions of side effects the runtime executes. Coordination is
**signal-driven** (CloudEvents 1.0.2, trie router, pub/sub, parent-child
hierarchies), not orchestrated. It inherits OTP: supervision, "let it crash,"
process isolation, [backpressure](/beliefs/glossary/backpressure.md), distribution.
The one real overlap — Jido's `jido_action` ships its *own* DAG-based workflow
planner — is a component *inside* a standing system, not the system's reason to
exist.

## 2. The core point: different layers, not competitors

Dynamic Workflows answers **"compute one hard answer by fanning out inference, then
exit."** Jido/BEAM answers **"run a persistent fleet of stateful agents that react
to events, survive crashes, and scale across nodes, indefinitely."**

This is why **recreating Dynamic Workflows on the BEAM as a replacement is
low-value.** If all you need is a fan-out DAG runner for LLM calls *within a task*,
you would reimplement the orchestrator **plus** the caching/resume, the
structured-output validation, and the whole Claude harness/MCP-tool integration — to
arrive at roughly the same ephemeral batch executor, in an ecosystem with thinner
LLM tooling. OTP's superpowers (supervision, hot upgrades, distribution, durable
state) are **wasted on an ephemeral fan-out**: nothing lives long enough to
supervise or recover. This mirrors the standing conclusion that the brain's Elixir
layer wants no resident runtime *until a workload actually wants one*
([BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md)).

## 3. Where the BEAM genuinely wins — things Workflows structurally *can't* do

These are not "not yet"; the Dynamic Workflows design forecloses them:

1. **Durability across process/host death.** A workflow run is a live script; kill
   the box and you resume from cache *within the session*. There is no agent that
   survives independently. Jido agents are supervised processes with immutable
   state — a crash restarts one child with backoff, siblings untouched.
2. **Standing, event-reactive agents.** Workflows is *pull/orchestrate* — the script
   decides everything. Jido is *push/react* — signals arrive and route to actions.
   For always-on systems (an agent per user/session/device reacting to a stream),
   Workflows offers nothing.
3. **Distribution.** Workflows is single-node, single-process. The BEAM gives
   location-transparent messaging across a cluster (caveat in §5).
4. **Real [backpressure](/beliefs/glossary/backpressure.md) and streaming.**
   GenStage/Flow/Broadway give bounded queues, rate-limit shaping, token streaming;
   the workflow concurrency cap is a single crude knob.
5. **Live introspection and hot code upgrades.** Change fleet behavior without
   stopping it — irrelevant to a batch job, essential to a 24/7 system.
6. **Native integration into a running Elixir/Phoenix app.** If the agents *are*
   part of the production system, they belong in-VM, not in an external
   session-scoped runtime.

## 4. Where Workflows wins / the BEAM adds nothing

- **Deterministic replay + prefix caching, for free.** On the BEAM you would rebuild
  this via event sourcing — doable, not free.
- **Bounded one-shot tasks.** For "produce one report/audit/migration and stop," the
  BEAM's durability machinery is dead weight; the ephemeral model is *correct*.
- **Harness and ecosystem gravity.** Tight coupling to Claude's agent runtime, MCP
  tools, and structured output. Elixir's LLM stack (ReqLLM's model breadth, Jido,
  Instructor, Nx/Bumblebee) is improving fast but still thinner than the JS/Python
  side.

## 5. Direct answers, and the honesty caveat

- **Would recreating this on the BEAM have an advantage?** Only if you need what the
  BEAM adds — persistence, fault-recovery, distribution, event-reactivity, in-app
  integration for a *standing* agent system. For those, decisively yes. For
  reproducing Dynamic Workflows *as a fan-out task runner*, no — you re-earn its
  features at a loss.
- **Does the workflow feature obviate the BEAM?** No. It obviates one *narrow*
  reason to reach for the BEAM — using it merely as a concurrent LLM fan-out engine
  for a within-task computation. It does not touch the BEAM's actual mandate:
  long-lived, fault-tolerant, distributed, stateful concurrency.
- **Honesty caveat on the concurrency argument.** The BEAM's "millions of processes"
  edge is largely *theoretical* for LLM orchestration: the real ceiling is provider
  rate limits and token cost, not runtime scheduling. Both Anthropic's ~16-concurrent
  cap and a BEAM fleet bottleneck on the same external API. Justify the BEAM on
  **durability, reactivity, distribution, and fault isolation**, not raw fan-out
  throughput.

## 6. The architecture worth building: layered, not either/or

Treat them as two altitudes of one stack:

- **BEAM/Jido as the durable outer runtime** — the standing fleet, supervision
  trees, signal ingress, persistent state, distribution, backpressure. The
  always-on nervous system.
- **A Dynamic-Workflows-style deterministic combinator as the inner, ephemeral
  step** — when a standing agent must *compute one hard answer* (investigate a bug,
  audit a subsystem, synthesize from N sources), it spawns a bounded, resumable
  fan-out, gets structured data back, and returns to its supervised life.

You would not recreate Dynamic Workflows to *replace* it; you would want a
Jido-native equivalent (its DAG planner is the seed) *only* so those fan-outs run
inside the BEAM system with BEAM's fault and distribution guarantees — i.e. when the
orchestration itself must be durable and clustered, not session-scoped.

## Relation to the prior BEAM/Jido analyses

This sits beside a family of bundle analyses on Anthropic-vs-BEAM/Jido questions,
and is distinct from each: the [Managed Agents comparison](/meta/analysis/claude-managed-agents-vs-beam-jido.md)
weighs a *different* Anthropic product — **hosted long-running deliberative
sessions** — against Jido's mechanical plane, landing on a
[two-plane](/beliefs/glossary/two-plane-rule.md) division of labor. Dynamic
Workflows is a **third** shape: an *ephemeral deterministic spine over the
deliberative plane* — closer to that comparison's CMA multi-agent coordinator than
to Jido, but with an explicit orchestration layer and replay. Placed in that frame,
Dynamic Workflows is a deliberative-plane *fan-out primitive*; it does not reach the
mechanical plane the BEAM owns, which is exactly why it cannot obviate the BEAM. See
also the [dark-factory scenario](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
(where a standing agent network dissolves the "runtime is elsewhere" premise) and
[Loomkin as existence proof](/meta/analysis/loomkin-as-existence-proof.md) (a shipped
Jido-native standing harness).

# Citations

- Dynamic Workflows — execution model observed first-hand (the Workflow tool in the
  authoring session's toolset); public framing:
  https://claude.com/blog/introducing-dynamic-workflows-in-claude-code ·
  https://www.infoq.com/news/2026/06/dynamic-workflows-claude-code/ ·
  https://alexop.dev/posts/claude-code-workflows-deterministic-orchestration/
  (all read 2026-07-16). Research preview, May 2026; ~1,000 subagents, ~16
  concurrent.
- Jido 2.0 — https://jido.run/blog/jido-2-0-is-here · https://github.com/agentjido/jido ·
  https://github.com/agentjido/jido_signal (read 2026-07-16); fuller verified
  baseline in [the BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md).
- Related concepts — [actor model](/beliefs/glossary/actor-model.md) ·
  [deterministic spine](/beliefs/glossary/deterministic-spine.md) ·
  [orchestrator pattern](/beliefs/glossary/orchestrator-pattern.md) ·
  [backpressure](/beliefs/glossary/backpressure.md) ·
  [two-plane rule](/beliefs/glossary/two-plane-rule.md).
- Caveat: Dynamic Workflows was in research preview at analysis time — caps and
  behavior may shift; the BEAM concurrency advantage for LLM orchestration is bounded
  by provider rate limits, not runtime scheduling.
