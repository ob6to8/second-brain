---
id: em:44f899
type: concept
title: Jido
description: An Elixir agent framework (2.x, 2026) that models agents as pure immutable data processed through a single cmd/2 reducer, with schema-validated Actions doubling as LLM tools, CloudEvents-based Signals, runtime-interpreted Directives, and GenServer-backed supervision; its jido_ai layer adds LLM reasoning strategies.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, jido, elixir, agents, multi-agent, beam]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-12T09:05:38+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# Jido

An Elixir framework for autonomous agents and multi-agent systems (2.x stable since early 2026). Its core move is separating the agent from its runtime: an agent is **pure immutable data** — schema-validated state plus signal routes — processed through a single `cmd(agent, {Action, params}) → {updated_agent, directives}` reducer, so decision logic is replayable and testable without an LLM. Around that core: **Actions** (validated functions that double as LLM-callable tools), **Signals** ([CloudEvents](/beliefs/glossary/cloudevents.md)-compliant messages with trie-based routing), **Directives** (structs the runtime interprets for side effects like spawn/schedule/emit), and a GenServer-backed supervised runtime on the [BEAM](/beliefs/glossary/beam.md); the separate `jido_ai` layer adds LLM reasoning strategies ([ReAct](/beliefs/glossary/react.md) by default). Notable gap as of mid-2026: no cross-node distribution story.

*Seen in:* [BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md), [dark-factory scenario analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md), [2026-07-13 advisor-pattern thread](/meta/threads/2026-07-13-advisor-pattern-and-rolling-your-own-harness.md), [2026-07-14 Elixir AST/macros and Loomkin thread](/meta/threads/2026-07-14-elixir-ast-macros-and-loomkin-evaluation.md) (the Action macro's compile-time validation and `to_tool/0` verified against hexdocs; Loomkin as a production adopter), [2026-07-16 Jido-caveats thread](/meta/threads/2026-07-16-jido-caveats-and-build-agent-linter-loop.md) (the distribution gap and `req_llm` cognition dependency, unpacked)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:44f899">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-16-jido-caveats-and-build-agent-linter-loop (2026-07-16)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:44f899`]**

Here's the expansion, which I'll also compile into the analysis doc.

**1. "No distribution story (single-node; `jido_cluster` unpublished)"**

The subtlety: the **BEAM has world-class distribution primitives** (transparent inter-node message passing, `:global`, `:pg`), but a *framework* only becomes distribution-aware if it makes deliberate choices on top of them. Jido makes the single-node choices:

- **Agent identity is node-local.** A Jido agent is a GenServer registered under an instance-scoped supervisor (`{Jido, name: MyApp.Jido}`) via a local Registry. That name resolves on *one* node. There's no cluster-wide registry that lets "agent Foo" be addressed from any node — so you can't transparently route to an agent that happens to live on a different machine.
- **Recovery is single-node crash recovery, not cross-node failover.** Jido's durability model is "rehydrate from persisted state" (Redis adapter since 2.1.0). That handles *a process crashing and its supervisor restarting it on the same node*. It does **not** handle *a node dying and its agents coming back up elsewhere* — there's no handoff/migration orchestrator watching for a dead node and re-spawning its fleet on survivors.
- **The signal bus is in-node.** Signals are trie-routed pub/sub over a per-node bus. Cluster-wide routing would need that bus to span nodes (via `:pg`, `phoenix_pubsub`, or `partisan`) — Jido doesn't ship it.
- **`jido_cluster` is the intended answer, but it's vapor for now.** A repo exists in the agentjido org, but it's *unpublished on hex* — you can't `mix deps.get` it, and the brain flagged its maturity as unconfirmed. So the distribution layer is gestating, not shippable.

**Why this matters (and why it mostly doesn't, until it does):** one BEAM node holds *millions* of lightweight processes, so "single-node" is a very high ceiling — vertical scaling alone carries a big fleet. What you *give up* is (a) horizontal scale across machines, (b) HA — that one node is a single point of failure for the whole fleet; no HA across machines, and (c) geographic distribution. For a dark factory that "eventually spans nodes," you'd be **building the distribution layer yourself** on raw BEAM primitives: `libcluster` for node discovery, `Horde` (or a hand-rolled `:global`/CRDT registry) for distributed process registration + handoff, and a distributed pubsub for the signal bus. That's exactly the "that layer would be ours to build" caveat — and distribution is genuinely hard (split-brain/netsplit handling, CAP tradeoffs on the registry, state-handoff races), which is *why* a young framework reasonably punts on it.

**2. "Makes `req_llm` load-bearing for all cognition"**

The architecture: Jido deliberately splits core `jido` (zero LLM code — the pure `cmd/2` reducer, agent-as-data) from `jido_ai` (the reasoning layer: ReAct/CoT/ToT strategies, tool-calling loops, structured output). `jido_ai` is built on `req_llm`, Jido's own in-house LLM client (they dropped LangChain). `req_llm` sits on `Req` (HTTP) and owns the provider adapters, the model catalog, streaming, and tool-call encoding.

"Load-bearing for all cognition" means: the reducer core is LLM-free *by design* (that's the replayable-without-a-model auditability win) — but the instant an agent actually **thinks** (any inference, any reasoning strategy, any structured extraction, any tool-selection decision), it goes through `jido_ai` → `req_llm`. There is no first-class alternate cognition path in the framework. Consequences:

- **One throat for every inference.** `req_llm`'s provider coverage, streaming correctness, tool-call encoding, retry/rate-limit semantics, and error handling *become your cognition's reliability envelope*. The single most volatile, most external, most expensive part of the system — model calls — has exactly one library standing under it.
- **Coupling to a young, in-house library.** `req_llm` was written during the ~18-month Jido 2 rewrite; the brain flagged even its "665+ models" claim as unconfirmed. When a new model, param, or feature lands (prompt caching, extended thinking, a changed tool-call format), you wait on `req_llm` to support it or you patch it — versus calling the Anthropic SDK directly, where you own the request shape.
- **It entangles with elixir-mind's zero-dep and duplicate-runtime blockers.** Adopting Jido's cognition pulls `req_llm` *and* a provider credential into the runtime tier — which is exactly why the verifier core must never depend on it and cognition must live in a separate mix project (blocker #2), and why a Jido deployment is "a second agent runtime with its own LLM credentials" (blocker #3).
- **The flip side — it's a reasonable design.** Isolating cognition behind a swappable client is *good* architecture: it's what keeps LLM code out of the reducer and makes decisions testable without a model, and in principle the client is replaceable. "Load-bearing" is a caveat about **concentration of dependency**, not a design flaw.

**Tie-back to the linting loop from earlier:** a Jido lint-fixer calling a cheap model would route that call *through* `req_llm` — so your ability to pin `claude-haiku-4-5`, set `max_tokens`, etc., is bounded by what `req_llm` exposes. And the single-node ceiling is irrelevant to a lint-fixer specifically; it only bites once linting becomes a fleet-scale continuous workload.
