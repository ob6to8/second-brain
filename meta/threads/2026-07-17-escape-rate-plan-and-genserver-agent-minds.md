---
type: reference
title: 2026-07-17-escape-rate-plan-and-genserver-agent-minds
description: The post-PR-#107 continuation — filed the parked auto-intake escape-rate sampling plan (proposed), then answered a design question on modeling swarm agents as supervised GenServers each referencing their own elixir-mind for persistence, filed as an analysis whose load-bearing finding is the two-tier memory model (private working mind + one brokered shared canonical mind); bundled both into a PR.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-17; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, escape-rate, auto-intake, genserver, otp, jido, agent-memory, two-tier-memory, beam, trust]
timestamp: 2026-07-17
session: https://claude.ai/code/session_01BpuP5CeA1sFEetYU4eFykn
pr: 108
---

# 2026-07-17-escape-rate-plan-and-genserver-agent-minds

Verbatim render. Retained operator messages and agent responses are reproduced
**verbatim** (the delivered text); only tool calls, tool results, reasoning, and
short pre-tool narration are stripped. Rendered from context via `/capture`'s
render-from-context path. This is the continuation after PR #107 merged — a new
thread doc rather than a rewrite of the sealed
[tier-3/4 thread](/meta/threads/2026-07-17-tier-3-4-interface-and-trust-with-adoption-intake.md).

## User

file plan

what would it look like to view "agents" as GenServers, and have each reference its own "elixir mind" for persistence?

## Assistant

**Plan filed** — [auto-intake-escape-rate-sampling](https://ob6to8.github.io/elixir-mind/meta/plans/auto-intake-escape-rate-sampling.html) (`type: plan`, `status: proposed`), indexed and verifying. It's written into the bundle on a fresh branch off the merged `main`, currently uncommitted — I'll bundle it into a PR with anything the question below produces, or on your say-so.

Now the architecture question — this is a good one, and it's the concrete shape of the multi-writer future the dark-factory analysis sketched.

### Agents as GenServers — mostly a solved shape

An agent-as-GenServer is essentially the Jido model already: an agent is a struct of state (task, context, budget, a reference to its mind) run inside a supervised process, and its reason→act→observe loop is a message-driven state transition. You get, for free, the things tier 3/4 actually needs: **cheap concurrency** (a thousand agents = a thousand ~KB processes the BEAM preempts fairly), **isolation** (separate heaps, one agent's crash can't corrupt another), and **let-it-crash supervision** (a wedged agent gets restarted, not babysat — the monitor-by-exception posture at the process level).

Two constraints bite immediately, and they're worth stating because they shape everything downstream:

1. **The LLM call is slow and the mailbox is sequential.** You must *not* make the blocking inference call inside `handle_call` — that freezes the agent's mailbox for seconds. The idiom is functional-core / imperative-shell at the process boundary: the GenServer holds state and control flow, but delegates the slow LLM/tool I/O to an async `Task`, and the result returns as a `handle_info` message. The process is cognition-orchestration; the cognition itself is I/O it awaits.
2. **Process state is ephemeral.** A GenServer's state dies with the process. So your instinct — *reference its own mind for persistence* — is exactly right and load-bearing: the durable memory is emphatically **not** the process state, it's the bundle on disk. The process is the compute; the mind is the substrate. On crash, the supervisor restarts the agent and it **rehydrates from its mind**. That clean split — let-it-crash for cognition, a durable OKF store for memory — is the whole payoff of putting persistence outside the process.

### "Its own elixir mind" — the fork that decides the architecture

This is the real question, and there's a trap in the naive reading. "Each agent has its own mind" can mean two very different things:

**The silo reading (trap): each agent fully owns an isolated bundle.** This destroys the corpus's entire value. A thousand agents with private minds is a thousand brains that don't learn from each other — the same paper gets re-intaken a thousand times, the same fact re-derived, and nothing deduplicates across them. You've paid for a knowledge base and gotten a thousand disconnected scratchpads.

**The two-tier reading (productive): private working mind + shared canonical mind, mediated by a broker.** This is the shape the existing analyses keep converging on, and your question makes its memory model explicit:

- **Each agent's own mind** = its *working memory*: in-flight context, provisional notes, the task's distillations-in-progress. Fast, private, writable without coordination, messy — a personal notebook. This is where "its own elixir mind" lives — a personal, writable, cheap memory. Could be literally a small OKF bundle scoped to the agent, or structured process-state that checkpoints to disk.
- **The shared canonical mind** = the corpus (this repo's role today). Agents **read** it freely and concurrently — reads need no coordination. But **writes go through a single serializing librarian-write-broker** (itself a GenServer, or a per-subtree pool) that owns the intake dedup, `mix brain.verify`, and the ratification chokepoints *in-process*, not as CI-after-the-fact.

The magic of the broker is that it turns one agent's discovery into the swarm's: when the 1,000th agent promotes "fact X" from its working mind, the broker's intake dedup finds X already filed and just adds a citation instead of a duplicate. That's the human-org pattern — personal notes → curated team wiki — and it's the only version that scales. It's also precisely the division of labor in claude-managed-agents-vs-beam-jido: reducer invariants enforced in-process at one owned write-gatekeeper.

### Where persistence strains — and why it's the interesting part

Git-on-disk as the durable memory is a genuine strength: every write carries provenance by construction (the session trailer, true-merge, attribution), so even in a swarm every fact traces to the agent and task that produced it. That audit substrate is exactly what makes the escape-rate measurement I just filed possible — you can only sample auto-intake escapes because every filing is attributed to a writer.

But **git is not a concurrent database**, and that's where the design gets hard — the same concurrent-writer problem the dark-factory analysis flagged as *the* hard problem (governance moves from "can we run agents" to "epistemic governance under concurrent autonomous writers"). Two agents committing to one working tree race on the index and refs. That constraint is *why* writes serialize through the broker rather than being a limitation to engineer around — the broker's single commit lane is the feature. Mitigations when the single lane becomes the bottleneck: per-agent private repos with async promotion; sharding the shared mind by taxonomy subtree with a broker lane per subtree; or keeping the canonical store in something with real concurrency and *deriving* git snapshots for provenance.

And the governance chokepoints don't survive contact with a swarm unchanged: today "new top-level directory" and "new type" are **operator** ratification gates. A swarm can't block on a human per shape-change. So the broker needs a two-class write policy — *autonomous-safe* (file into the existing tree) versus *escalate-to-human* (shape changes) — which is, again, the monitor-by-exception interface. The escape-rate metric is how you'd know the autonomous-write tier is trustworthy.

### The topology, concretely

```
Application.Supervisor
├── Librarian            # GenServer/pool: owns the shared mind's write lane +
│                        #   intake-dedup / verify / ratification gates
├── Sensors              # watch feeds/channels → spawn agents (Jido sensors)
└── DynamicSupervisor
    └── Agent × N         # state: {task, context, working_mind_ref, budget}
                          #   LLM calls via Task → handle_info
                          #   reads: shared mind, directly & concurrently
                          #   writes: Librarian.promote(fact) — serialized, gated
```

This is basically Jido + a librarian broker + OKF-on-disk as the two-tier memory. It is a coherent tier-3/4 architecture, and the honest conclusion matches the BEAM/Jido evaluation and loomkin: **this repo shouldn't *become* the swarm — it's the epistemic base the swarm would stand on.** It already holds the pieces the broker would enforce (intake dedup, the verify gate, attribution, the ratification protocol). What's missing is the three things the "not now" verdict named: a resident BEAM runtime, the broker as an *in-process* write-gate rather than CI-after-commit, and a concurrent-write story for the store. Your "each agent has its own mind" framing is the refinement that makes the memory tier explicit — private working minds promoting up to one brokered shared mind.

Want me to persist this as a `type: analysis` (it's a distinct question from the four existing BEAM/Jido analyses — the *per-agent two-tier memory model* specifically), and bundle it with the escape-rate plan into one PR? I'd cross-link it into the dark-factory and claude-managed-agents analyses as the memory-model companion.

## Assistant

Committed and pushed as `3f1261a` on `claude/ai-adoption-steps-6s6tei` (fresh off the merged `main`).

**State of play:**
- ✅ **Escape-rate plan** — filed, committed, pushed. auto-intake-escape-rate-sampling (`status: proposed`).
- ⏸ **GenServer / two-tier-memory answer** — delivered in chat, not yet persisted. It's a distinct question from the four existing BEAM/Jido analyses (the *per-agent private-working-mind + brokered shared-mind* memory model specifically), so it'd stand as its own `type: analysis`.

Two things whenever you're ready:
1. Want me to **persist the GenServer answer as an analysis** and cross-link it into the dark-factory and claude-managed-agents analyses?
2. Want a **PR** now for the pushed plan (bare `/create-pull-request`), or hold and bundle it with that analysis in one PR? Say `/create-pull-request merge` and I'll drive it to green and land it.

## User

yes
bundle both into a pr

## Where this landed

The continuation after PR #107 merged. Two governance docs filed and bundled into
one PR:

- **[auto-intake-escape-rate-sampling](/meta/plans/auto-intake-escape-rate-sampling.md)**
  (`type: plan`, `proposed`) — the parked follow-up from the tier-3/4 trust
  analysis: `mix brain.escape_rate`, the precision-side complement to the dedup
  recall probe, treating operator post-intake edits (git-derived, keyed on
  `channel:auto-intake`) as a near-zero-cost oracle, reporting reviewed-escape-rate
  alongside an explicit unreviewed-coverage fraction so silence is never counted as
  success.
- **[agents-as-genservers-with-per-agent-okf-mind](/meta/analysis/agents-as-genservers-with-per-agent-okf-mind.md)**
  (`type: analysis`) — the memory-model companion to the four BEAM/Jido analyses.
  Load-bearing finding: the process model is nearly solved (essentially Jido); the
  decision is what "its own mind" means. A private per-agent **silo** destroys the
  corpus's cross-agent-learning value; a **two-tier** model (private working mind +
  one brokered shared canonical mind) is the only version that scales. Process state
  is ephemeral, so the on-disk OKF bundle is the durable crash-recovery substrate;
  git-is-not-a-concurrent-DB forces the librarian broker's single serialized write
  lane; provenance-by-construction is the swarm's trust substrate and the
  precondition for the escape-rate metric. Repo is the epistemic base, not the
  swarm; timing unchanged.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| File the parked auto-intake escape-rate sampling plan | closed | [auto-intake-escape-rate-sampling](/meta/plans/auto-intake-escape-rate-sampling.md) | - |
| Agents as GenServers, each referencing its own elixir-mind for persistence (two-tier memory model) | closed | [agents-as-genservers-with-per-agent-okf-mind](/meta/analysis/agents-as-genservers-with-per-agent-okf-mind.md) | - |
