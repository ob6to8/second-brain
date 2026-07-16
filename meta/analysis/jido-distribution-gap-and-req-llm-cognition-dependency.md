---
type: analysis
title: "Jido's two structural caveats, unpacked: no distribution story, and req_llm load-bearing for all cognition"
description: A focused expansion of the two caveats the BEAM/Jido analyses name in passing — that Jido has no cross-node distribution (agent identity, recovery, and the signal bus are all node-local; jido_cluster is unpublished, so the distribution layer would be ours to build on raw BEAM primitives) and that its cognition layer routes every inference through the single young in-house req_llm client — finding neither reverses the "not now" verdict but both sharpen where a future owned runtime pays its costs, and connecting both back to the build-agent linter-loop question that prompted them.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-16 — operator asked, within a thread on building a build-agent/linter feedback loop, to expand on why/how Jido 'has no distribution story (single-node; jido_cluster unpublished), and makes req_llm load-bearing for all cognition'; grounded against the two prior BEAM/Jido analyses and their verified 2026-07-12 Jido baseline"
tags: [meta, analysis, architecture, beam, otp, jido, req_llm, distribution, agents, multi-agent, cognition, tooling]
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T07:00:26Z
  channel: agent-authored
  agent: "Claude Code agent, interactive session"
  why: "operator asked to expand the two Jido caveats named in passing by the prior BEAM/Jido analyses and persist the expansion as an analysis"
  from: [/meta/threads/2026-07-16-jido-caveats-and-build-agent-linter-loop.md]
---

# Jido's two structural caveats, unpacked

**Context.** The two BEAM/Jido evaluations —
[the base evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md) and
[the dark-factory scenario](/meta/analysis/dark-factory-epistemic-base-beam-jido.md) —
each name two Jido limitations in a single clause and move on: it *"has no
distribution story (single-node; `jido_cluster` unpublished)"* and it makes
*"`req_llm` … a core dependency for all cognition."* This analysis expands both,
because they surfaced again in a working thread on building a **build-agent
linter loop** (a hook that routes lint failures to a cheap model in a dedicated
context, and whether that implies deploying to the BEAM with a Jido linting
agent). Neither caveat reverses the standing **"not now"** verdict; both sharpen
*where* a future owned runtime pays its costs, and both bear directly on the
linter-loop design.

The Jido facts here inherit the **verified 2026-07-12 baseline** from the base
evaluation (checked against hex.pm, hexdocs, and the agentjido GitHub org) — this
doc reasons over that baseline rather than re-researching it, and carries its
unconfirmed items forward (chiefly `jido_cluster` maturity and `req_llm`'s model
count).

## 1. "No distribution story (single-node; `jido_cluster` unpublished)"

The point is easy to misread, because the substrate is famous for the opposite.
The **BEAM ships world-class distribution primitives** — transparent inter-node
message passing to remote PIDs, `:global` name registration, `:pg` process
groups. The caveat is not about the substrate; it is that a *framework* only
becomes distribution-aware if it makes deliberate choices on top of those
primitives, and **Jido makes the single-node choices** at each layer:

- **Agent identity is node-local.** A Jido agent is a GenServer wrapped by
  `AgentServer`, registered under an instance-scoped supervisor
  (`{Jido, name: MyApp.Jido}`) through a local `Registry`. That name resolves on
  exactly one node. There is no cluster-wide registry that lets "agent Foo" be
  addressed from any node, so an agent living on another machine cannot be routed
  to transparently.
- **Recovery is single-node crash recovery, not cross-node failover.** Jido's
  durability model is *rehydrate from persisted state* (a Redis adapter since
  2.1.0, Pods/partitions since 2.2.0). That covers *a process crashing and its
  supervisor restarting it on the same node*. It does **not** cover *a node dying
  and its agents resurrecting elsewhere*: there is no handoff/migration
  orchestrator watching for a dead node and re-spawning its fleet on the
  survivors. Let-it-crash is a within-node staffing model here, not a
  cross-machine HA model.
- **The signal bus is in-node.** [Signals](/beliefs/glossary/cloudevents.md) are
  trie-routed pub/sub over a per-node bus. Cluster-wide routing would require that
  bus to span nodes (via `:pg`, `phoenix_pubsub`, or `partisan`); Jido does not
  ship it.
- **`jido_cluster` is the intended answer, but unshippable today.** A repo exists
  in the agentjido org, but it is **unpublished on hex** — it cannot be
  `mix deps.get`-ed, and its maturity was flagged unconfirmed in the baseline. The
  distribution layer is gestating, not available.

**What the single-node ceiling actually costs.** One BEAM node holds *millions*
of lightweight processes, so "single-node" is a very high ceiling — vertical
scaling alone carries a large fleet, and for most workloads the ceiling never
binds. What you forfeit is specifically: (a) **horizontal scale across machines**;
(b) **high availability** — that one node is a single point of failure for the
entire fleet; and (c) **geographic distribution**. For the
[dark-factory](/beliefs/glossary/dark-factory.md) scenario that "eventually spans
nodes," the distribution layer would be **ours to build** on raw BEAM primitives:
`libcluster` for node discovery, `Horde` (or a hand-rolled `:global`/CRDT-backed
registry) for distributed naming plus process handoff, and a distributed pubsub
for the signal bus.

**Why a young framework reasonably punts on this.** Distribution is genuinely
hard: netsplit/split-brain handling, the CAP tradeoff you are forced to take on
the registry (a globally consistent registry sacrifices availability under
partition; an available one admits conflicting registrations), and state-handoff
races during migration. Many mature Elixir systems stay single-node-first for
exactly these reasons. The caveat is a **scope/maturity boundary, not a defect** —
but it means the dark factory's horizontal-scale and HA properties are *net-new
engineering* on top of Jido, not features it confers.

## 2. "Makes `req_llm` load-bearing for all cognition"

Jido's cleanest architectural move is separating the agent from its runtime: the
**core `jido` package contains zero LLM code**. An agent is pure immutable data
processed through a single `cmd(agent, {Action, params}) → {updated_agent,
directives}` [reducer](/beliefs/glossary/reducer.md) — replayable and testable
with no model in the loop. That LLM-free core is the source of the auditability
property both prior analyses prize.

Cognition lives one layer out, in **`jido_ai`** (tool-using agent loops, eight
reasoning strategies — [ReAct](/beliefs/glossary/react.md) by default, CoT,
Tree-of-Thought — and schema-constrained structured output), and `jido_ai` is
built on **`req_llm`**, Jido's **in-house** LLM client (LangChain was dropped
during the 2.0 rewrite). `req_llm` sits on `Req` (HTTP) and owns the provider
adapters, the model catalog, streaming, and tool-call encoding.

"Load-bearing for all cognition" is the consequence of that split: the reducer
core is deliberately LLM-free, but the instant an agent actually **thinks** — any
inference, any reasoning strategy, any structured extraction, any tool-selection
decision — it flows through `jido_ai` → `req_llm`. There is **no first-class
alternate cognition path** in the framework. Four consequences:

- **One throat for every inference.** `req_llm`'s provider coverage, streaming
  correctness, tool-call encoding, and retry/rate-limit/error semantics *become
  the reliability envelope of all cognition*. The single most volatile, most
  external, most expensive part of the system — the model call — has exactly one
  library standing under it.
- **Coupling to a young, in-house library.** `req_llm` was written during the
  ~18-month Jido 2 rewrite; even its "665+ models" claim was flagged unconfirmed
  in the baseline. When a new model, parameter, or capability lands (prompt
  caching, extended thinking, a changed tool-call schema), you wait on `req_llm`
  to add it or you patch it — versus calling a vendor SDK/API directly, where you
  own the request shape. This is a **concentration of dependency** on the fastest-
  moving surface in the stack.
- **It entangles with elixir-mind's own blockers.** Adopting Jido's cognition
  pulls `req_llm` *and* a provider credential into the runtime tier — which is
  exactly why the [zero-dependency constraint](/beliefs/glossary/dependency-free.md)
  forces cognition into a **separate mix project** the verifier core never depends
  on (base-evaluation blocker #2), and why a Jido deployment reads as "a second
  agent runtime with its own LLM credentials" (blocker #3). The distribution gap
  (§1) and this cognition gap therefore land on the *same* tier — the owned
  runtime — and both stay off the zero-dep auditor core by construction.
- **The flip side — it is a reasonable design.** Isolating cognition behind a
  swappable client is *good* architecture: it keeps LLM code out of the reducer,
  makes decisions testable without a model, and in principle lets the client be
  replaced. The caveat flags **where the concentrated risk sits**, not a flaw in
  the shape.

## 3. Why neither caveat moves the verdict — and what they do move

Both prior analyses already priced these in; expanding them does not change the
conclusion, and it is worth being explicit about why:

- **Distribution** only binds when a fleet outgrows one machine *or* demands HA
  across machines. Today's regime is episodic, effectively single-writer sessions
  plus CI — the ceiling is nowhere near. Even in the dark-factory scenario, the
  distribution layer is a **tier-3 concern** (fleet governance/scale), reached
  only after the tier-1 daemon and tier-2 Jido worker-agents exist. It raises the
  eventual build's ceiling cost; it does not touch the near-term path.
- **`req_llm` load-bearing** matters only *once you adopt Jido's cognition at
  all*, which is tier 2 at the earliest, gated behind the toolchain migration
  (Elixir 1.17+/OTP 26+) and more API-stability seasoning. Until then there is no
  `req_llm` in the tree to be load-bearing.

What they *do* move is the **precision of the tier-2/tier-3 cost estimate**: the
future owned runtime inherits (a) a distribution layer it must build itself if it
ever spans nodes, and (b) a single young client under all of its thinking. Both
belong in the tier-2 gate review the base evaluation defers to, and both reinforce
the [two-plane rule](/beliefs/glossary/two-plane-rule.md) and the layering
discipline — the zero-dep verifier core must sit *below* and *independent of* the
tier where these dependencies live.

## 4. Bearing on the build-agent linter loop

These caveats surfaced inside a thread on closing an agent-in-the-loop lint/fix
cycle (agent writes code → gate fails → failure routed to a cheap model in a
dedicated context → fix → gate re-runs). Two concrete implications:

- **Routing a lint failure to a cheaper model does not require the BEAM.** That is
  an orchestration concern the incumbent harness already serves — a `PostToolUse`
  hook that either delegates to a Haiku-pinned subagent (its own context window)
  or shells out to a cheap model out-of-band, applies the patch, and re-runs the
  gate. A one-shot lint/fix task is episodic and stateless between runs — the
  workload with "nothing to grip" that the base evaluation identifies. **The
  single-node distribution gap is irrelevant to it**; it would bind only once
  linting became a continuous fleet-scale verification workload (the
  "verification inverts from gate to workload" regime of the dark-factory
  analysis).
- **A Jido lint-fixer would route its cheap-model call through `req_llm`.** If the
  linter loop ever *did* become a supervised Jido worker, its model-choice freedom
  — pinning `claude-haiku-4-5`, setting `max_tokens`, using a cheaper reasoning
  strategy — would be bounded by what `req_llm` exposes. That is the §2 dependency
  made concrete at the smallest scale: even a trivial linting agent inherits the
  one-throat-for-cognition property.

The net: build the linter loop in the harness (subagent/hook, cheap model,
dedicated context) — that inherits neither caveat. Reserve the Jido/BEAM answer,
and with it both of these costs, for the resident-fleet runtime the dark-factory
scenario would justify as a whole.

# Citations

- Base evaluation (verified 2026-07-12 Jido baseline; tier map; the two caveats
  in source form) —
  [/meta/analysis/beam-deployment-and-jido-2-evaluation.md](/meta/analysis/beam-deployment-and-jido-2-evaluation.md)
- Dark-factory scenario (the runtime inversion; "verification inverts from gate to
  workload"; the "distribution layer would be ours to build" note) —
  [/meta/analysis/dark-factory-epistemic-base-beam-jido.md](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
- Planes division (cognition vs. mechanical work; the owned write-gatekeeper) —
  [/meta/analysis/claude-managed-agents-vs-beam-jido.md](/meta/analysis/claude-managed-agents-vs-beam-jido.md)
- Term definitions — [Jido](/beliefs/glossary/jido.md) ·
  [BEAM](/beliefs/glossary/beam.md) · [OTP](/beliefs/glossary/otp.md) ·
  [actor model](/beliefs/glossary/actor-model.md) ·
  [let-it-crash](/beliefs/glossary/let-it-crash.md) ·
  [reducer](/beliefs/glossary/reducer.md)
- No new external research: all Jido/`req_llm`/`jido_cluster` claims inherit the
  base evaluation's 2026-07-12 verification and its listed unconfirmed items
  (`jido_cluster` maturity; `req_llm` model count; exact Elixir minimum).
</content>
</invoke>
