---
type: analysis
title: "Would deploying to the BEAM — or integrating Jido 2 — benefit this brain?"
description: An architecture evaluation finding that the brain's Elixir layer is a deliberately zero-dependency batch toolchain whose real runtime is Claude Code sessions plus CI, so a resident BEAM deployment buys nothing today and Jido 2 is triply blocked (toolchain floor, zero-dep constraint, duplicate agent runtime) — but mapping a tiered future path (resident daemon → MCP tool server → Jido agents) with concrete adoption triggers, the nearest being the broken /research Routine and tier-2 embedding dedup.
provenance: "Claude Code session (Claude Fable), 2026-07-12 — operator asked whether deploying to the BEAM or integrating the Jido 2 library could benefit this repo, and what direction could leverage BEAM/Elixir/Jido capabilities; Jido facts verified against hex.pm/hexdocs/GitHub by a research subagent the same day"
tags: [meta, analysis, architecture, beam, otp, elixir, jido, agents, automation, tooling, mcp]
timestamp: 2026-07-12
attribution:
  when: 2026-07-12T00:15:58+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-12-beam-jido-evaluation-and-dark-factory-scenario.md]
---

# Would deploying to the BEAM — or integrating Jido 2 — benefit this brain?

**Question.** The brain's tooling is written in Elixir. Would deploying it to the
BEAM as a resident system pay off? Would integrating the
[Jido 2](https://github.com/agentjido/jido) agent framework add capabilities? What
direction could leverage BEAM/OTP, Elixir, and Jido synergies?

**Bottom line.** Not now — and the reason is structural, not dismissive. The
Elixir layer is a **batch compiler/verifier toolchain**, not an application: every
workload is a one-shot, offline, deterministic `mix` task, and the system's actual
*runtime* is Claude Code sessions plus GitHub Actions. The BEAM's distinctive
strengths (supervision of long-lived state, massive concurrency, fault-tolerant
services) have nothing to grip. Jido 2 is additionally blocked three ways: it
needs Elixir 1.17+/OTP 26+ against this repo's pinned 1.14/OTP 24–25 floor; it
would break the load-bearing zero-dependency constraint; and it is a second agent
runtime parallel to the one this brain already has (Claude Code + skills). **But**
there is a real future in which a small resident BEAM process becomes the right
move — this analysis maps that path as three tiers with explicit adoption
triggers, the nearest of which is already an open issue
([the /research Routine that never lands](/meta/issues/daily-news-routine-runs-not-landing.md)).

## 1. What the Elixir layer actually is today

Evidence from the repo, not aspiration:

- **~3,000 lines, zero dependencies, by design.** `mix.exs` declares no deps and
  says why: *"the contract compiler parses the small YAML frontmatter subset the
  bundle uses with the standard library only, so it runs offline in any sandbox
  with Elixir/OTP installed."* Portability-into-any-sandbox is a stated
  constraint, not an accident.
- **Every entry point is a one-shot batch task.** `brain.contract`,
  `brain.registry`, `brain.verify`, `brain.route_tags`, `brain.site`,
  `brain.session_init`, `brain.id`, `brain.evidence` — each reads the tree,
  computes, writes or checks, exits. There is no OTP application module, no
  supervision tree, no GenServer, no process that outlives a task.
- **The runtime is elsewhere.** The long-running, stateful, concurrent part of
  this system is the *agent harness*: Claude Code sessions (skills, hooks,
  Routines) do the acting; CI and the pre-commit hook do the enforcing; the
  Elixir code is the deterministic substrate both call into. Ops burden today is
  effectively zero: a git repo, a hook, and two workflows.
- **The active plans double down on this shape.** The
  [dedup recall probe](/meta/plans/dedup-recall-probe.md) specifies
  "zero-dependency, offline, deterministic — the probe must run in CI and any
  sandbox"; the [epistemic overlay](/meta/plans/epistemic-overlay.md)'s
  `mix brain.graph` is another CI-runnable integrity checker.

So the question "should this deploy to the BEAM?" decomposes into: *is there a
workload here that wants a resident process?* Today: no. Every job is
latency-insensitive, runs to completion in seconds, and gains correctness from
being deterministic and stateless. Elixir is serving as an excellent scripting
language with a great standard library — and that is a legitimate, complete use
of it.

## 2. What the BEAM offers — and which of it this repo could ever use

The BEAM's differentiated capabilities, checked against this brain's actual and
plausible workloads:

| BEAM capability | Gripping surface here? |
|---|---|
| Lightweight process concurrency | Marginal today — `brain.site`/`brain.verify` could parallelize per-file scans with `Task.async_stream`, a one-line change needing no deployment. Corpus is ~40 concepts; wall-clock is trivial. |
| Supervision / fault tolerance | Nothing to supervise — no long-lived state. Becomes relevant only with a resident daemon (tier 1 below). |
| Hot code upgrades, distribution | No fit foreseeable; even Jido has no live-migration story (agents recover from persisted state, per its author). |
| Scheduled, durable jobs (cron on the BEAM) | **Real fit.** The one live operational failure — the daily `/research` Routine producing no commits — is precisely a "no resident runtime we control" problem. A supervised BEAM process owning the schedule would remove the approval-gate failure mode entirely. |
| Long-lived in-memory state (ETS) | **Future fit.** Tier-2 embedding dedup (the quantified trigger in the [vector-DB analysis](/meta/analysis/vector-db-recall-for-the-scaling-bundle.md)) wants a persistent index rather than re-embedding the corpus per intake. |
| Ports/NIFs to serve tools over a protocol | **Future fit.** The `brain.*` verbs are already a clean tool surface; a thin MCP server would let *any* agent session call them without shelling out. |

The honest summary: the BEAM's value here is entirely in the **future resident
tier**, and the two workloads that would justify it are already named in this
brain's own open work — scheduled automation and the embedding index.

## 3. Jido 2, in brief (verified 2026-07-12)

Facts checked against hex.pm, hexdocs, and the agentjido GitHub org (full
citations below); this section exists so a future session can re-evaluate against
a known baseline rather than re-researching from scratch.

- **What it is.** An "autonomous agent framework for Elixir, built for workflows
  and multi-agent systems" (Apache-2.0, ~1.8k stars). Jido 2.0 is an ~18-month
  rewrite of an overengineered 1.0 (the author's own characterization), stable
  2026-02-22; latest `jido` 2.3.2 (2026-06-09), ~4.4k downloads/week.
- **Core model.** An agent is **pure immutable data** — schema-validated state
  plus signal routes — processed through a single
  `cmd(agent, {Action, params}) → {updated_agent, directives}` reducer
  (Redux/Elm-style), unit-testable with no LLM or network. **Actions**
  (`jido_action`) are validated-schema functions that double as LLM tools;
  **Directives** are structs the runtime interprets for side effects (Spawn,
  Emit, Schedule, Cron…); **Signals** (`jido_signal`) are CloudEvents-compliant
  messages with trie-routed pub/sub; **Sensors** are owner-monitored event
  sources; **Strategies** (replacing 1.x Runners) control how `cmd/2` executes.
- **Runtime.** `AgentServer` wraps agents in GenServers under an instance-scoped,
  user-owned supervisor (`{Jido, name: MyApp.Jido}`), with lifecycle APIs,
  durable in-house cron (since 2.1.0), partitioned multi-tenancy and "Pods"
  (durable agent groups, 2.2.0+), and persistence adapters (Redis since 2.1.0).
  **No distribution story**: no cross-node migration; a `jido_cluster` repo
  exists but is unpublished on hex.
- **LLM layer.** Deliberately split out: core `jido` contains zero LLM code.
  `jido_ai` 2.2.0 adds tool-using agent loops with eight reasoning strategies
  (ReAct default, CoT, Tree-of-Thought, …) and schema-constrained structured
  output, on the in-house `req_llm` client (LangChain was dropped).
- **Floor.** Elixir 1.17+/OTP 26+ per README (changelog says ~>1.18) — either
  way, well above this repo's toolchain.

## 4. Mapping Jido onto the brain: the synergies are real, the timing is wrong

If one *were* building a resident runtime for this brain, Jido's abstractions map
onto it strikingly well — worth recording precisely because the fit is good:

- **`brain.*` verbs as Actions.** Each mix task is already shaped like a
  `Jido.Action`: validated input, deterministic effect, meaningful return.
  Wrapped as Actions they become simultaneously supervised jobs, signal handlers,
  and **LLM-callable tools** — one definition, three surfaces.
- **Intake as an agent loop.** `/intake` is a dedup-search → distill → file →
  verify pipeline; as a `jido_ai` ReAct agent with the brain's verbs as tools, it
  gains retries, schema-constrained output, and checkpointed state. (Today,
  Claude Code's skill system provides the same loop with the operator in it —
  which this brain's governance actually *wants*: taxonomy changes require
  ratification.)
- **The Routine problem, solved structurally.** Jido's durable cron + a
  fresh-context `jido_ai` agent could own the daily `/research` run end-to-end —
  fetch, match against the taxonomy, write `inbox/`, commit, push — with no
  dependence on the Claude Code Routine approval stream. This is the single
  strongest concrete use case, because it fixes the one open operational issue.
- **Sensors feeding the inbox.** RSS/arXiv/HN sensors emitting CloudEvents
  signals routed to a triage agent is a natural upgrade of `/research` from
  pull-on-schedule to push-on-event.
- **Signals as the file-change bus.** A file-watcher sensor triggering
  incremental `brain.verify`/`brain.route_tags`/`brain.site` on save would give
  live feedback instead of commit-time feedback.
- **The epistemic overlay as agent-queryable graph.** If the
  [epistemic overlay](/meta/plans/epistemic-overlay.md) lands, "what grounds
  this? / what rests on this?" become traversal Actions — the graph becomes a
  tool surface for verification agents, not just a CI check.

And the three blockers that make "not now" the verdict despite the fit:

1. **Toolchain floor.** Jido needs Elixir 1.17+/OTP 26+; this repo, its CI
   matrix, and its sandboxes run Elixir 1.14 on OTP 24–25. Adopting Jido means a
   toolchain migration first — a prerequisite project, not a dependency bump.
2. **The zero-dependency constraint is load-bearing.** The verifier core must run
   in any sandbox, offline. Pulling the Jido tree (jido, jido_action,
   jido_signal, jido_ai, req_llm) into `second_brain` would tie contract
   compilation to hex availability and a young dependency tree. If a runtime is
   ever built, it must be a **separate mix project** (e.g. `runtime/` beside
   `lib/`, or a sibling repo) that *depends on* the core — the core never depends
   on it.
3. **It duplicates the incumbent agent runtime.** This brain already has an agent
   harness: Claude Code sessions with skills, hooks, session-init, and an
   operator-ratification protocol woven through the governance. A Jido deployment
   is a second, parallel harness with its own LLM credentials (via `req_llm`),
   hosting, persistence, and monitoring — real ops cost for a system whose
   current ops cost is zero. Jido 2 is also five months post-stable; letting it
   season costs nothing.

## 5. The direction: three tiers, each with a trigger

- **Tier 0 (now): batch core, unchanged.** Keep the zero-dep verifier/compiler
  exactly as is; it is the correct architecture for what it does. Cheap
  BEAM-native win available anytime: `Task.async_stream` over per-file scans if
  the corpus ever makes `brain.verify`/`brain.site` slow. No deployment.
- **Tier 1: a small resident daemon (no Jido).** A plain supervised OTP app —
  separate mix project, depending on the core — owning (a) the scheduled `/research`
  feed and (b) later, the embedding index for tier-2 dedup, possibly exposing the
  `brain.*` verbs over MCP so any agent session can call them as tools.
  **Trigger:** the [/research Routine issue](/meta/issues/daily-news-routine-runs-not-landing.md)
  proves unfixable inside Claude Code's Routine machinery, **or** the
  [dedup probe](/meta/plans/dedup-recall-probe.md) fires its tier-2 threshold
  (an index wants a home).
- **Tier 2: Jido agents on that daemon.** When the daemon hosts more than one
  autonomous loop (research triage + intake dedup + verification sweeps) and they
  need supervision, scheduling, and signal routing between them, adopt Jido
  rather than reinventing it — the abstraction fit in §4 is why. **Triggers:**
  tier 1 exists and is accreting hand-rolled GenServer/cron/pubsub code; the
  toolchain has migrated to Elixir 1.17+/OTP 26+; Jido 2.x has another
  6–12 months of API stability behind it.

**Recommendation.** Adopt nothing now. File this map, fix the `/research` Routine the
cheap way first (clear the approval gate), and let the two named triggers — a
structurally unfixable Routine, or the dedup probe demanding a persistent index —
decide if and when tier 1 begins. Re-evaluate Jido at that point against this
section's baseline.

# Citations

- Jido repo & README — https://github.com/agentjido/jido · https://jido.hexdocs.pm/readme.html
- Jido 2.0 announcement — https://jido.run/blog/jido-2-0-is-here · HN discussion: https://news.ycombinator.com/item?id=47263036
- Packages — https://hex.pm/packages/jido (2.3.2) · https://hex.pm/packages/jido_ai (2.2.0) · https://hex.pm/packages/jido_action · https://hex.pm/packages/jido_signal · https://hex.pm/packages/req_llm · https://hex.pm/packages/ash_jido
- Unconfirmed at research time: fate of `Jido.Instruction` as a first-class 2.0 abstraction; `req_llm`'s "665+ models" count; "agentic memory" depth; `jido_cluster` maturity (unpublished); exact Elixir minimum (1.17 vs 1.18 — README/changelog disagree).
- Repo evidence — `mix.exs` (zero-dep rationale), `lib/second_brain/*.ex` (batch tasks only), `.github/workflows/ci.yml` (OTP 25 / Elixir 1.14 matrix).
