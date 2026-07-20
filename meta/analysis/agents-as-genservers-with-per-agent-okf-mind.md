---
type: analysis
title: "Agents as GenServers with a per-agent OKF mind: the two-tier memory model"
description: Evaluates modeling swarm agents as supervised GenServers that each reference their own elixir-mind for persistence; finds the load-bearing choice is not the process model (that's essentially Jido) but the reading of "its own mind" — a private per-agent silo destroys the corpus's value, whereas a two-tier model (private working mind + one brokered shared canonical mind) is the only version that scales, with process state ephemeral and the on-disk OKF bundle as the durable crash-recovery substrate, and the concurrent-writer strain forcing the librarian broker's single write lane.
tags: [beam, genserver, otp, jido, agent-memory, librarian-write-broker, swarm, persistence, two-tier-memory, provenance, elixir-mind]
timestamp: 2026-07-17
attribution:
  when: 2026-07-17T18:52:15Z
  channel: agent-authored
  agent: "Claude Code session, tier-3/4 adoption dialogue"
  why: "operator asked what it would look like to view agents as GenServers, each referencing its own elixir-mind for persistence"
  from: [/meta/threads/2026-07-17-escape-rate-plan-and-genserver-agent-minds.md]
---

# Agents as GenServers with a per-agent OKF mind: the two-tier memory model

The operator asked what it would look like to model swarm agents as GenServers, each
referencing its own [elixir-mind](/beliefs/glossary/elixir-mind.md) for persistence.
This is the concrete shape of the multi-writer future the
[dark-factory analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
sketched, and it is the memory-model companion to the four existing BEAM/Jido
analyses. The finding: the process model is nearly a solved shape (it is essentially
[Jido](/beliefs/glossary/jido.md)); the load-bearing decision is what "its own mind"
means, and one reading is a trap.

## 1. Agents as GenServers — a mostly-solved shape with two hard constraints

An agent-as-GenServer is the Jido model already: an agent is a struct of state (task,
context, budget, a reference to its mind) run inside a supervised process, its
reason→act→observe loop a message-driven state transition. This buys exactly what the
high autonomy tiers need — cheap concurrency (thousands of ~KB processes preemptively
scheduled), real isolation (separate heaps; one crash cannot corrupt a sibling), and
[let-it-crash](/beliefs/glossary/let-it-crash.md) supervision (a wedged agent is
restarted, not babysat — [monitor-by-exception](/beliefs/glossary/monitor-by-exception.md)
at the process level).

Two constraints bite immediately and shape everything downstream:

- **The LLM call is slow; the mailbox is sequential.** A blocking inference call inside
  `handle_call` freezes the agent's mailbox for seconds. The idiom is
  [functional-core / imperative-shell](/beliefs/glossary/functional-core-imperative-shell.md)
  at the process boundary: the GenServer holds state and control flow but delegates the
  slow LLM/tool I/O to an async `Task`, whose result returns as a `handle_info` message.
  The process orchestrates cognition; the cognition is I/O it awaits. (This is the
  [`req_llm`](/beliefs/glossary/req-llm.md)-load-bearing surface the
  [Jido-distribution analysis](/meta/analysis/jido-distribution-gap-and-req-llm-cognition-dependency.md)
  names, seen from the process side.)
- **Process state is ephemeral.** A GenServer's state dies with the process — so the
  operator's instinct to reference the mind *for persistence* is exactly right and
  load-bearing. The durable memory is emphatically not the process state; it is the
  bundle on disk. The process is the compute, the mind is the substrate, and on crash
  the supervisor restarts the agent and it **rehydrates from its mind**. Let-it-crash
  for cognition, a durable OKF store for memory: that division is the whole payoff of
  externalizing persistence.

## 2. "Its own mind" — the fork that decides the architecture

There are two readings of "each agent has its own mind," and they diverge sharply.

**The silo reading (trap): each agent fully owns an isolated bundle.** This destroys
the corpus's entire value. A thousand agents with private minds is a thousand brains
that never learn from each other — the same paper re-intaken a thousand times, the same
fact re-derived, nothing deduplicated across them. It converts a knowledge base into a
thousand disconnected scratchpads.

**The two-tier reading (productive): private working mind + shared canonical mind,
mediated by a broker.** This is the shape the existing analyses keep converging on, and
the operator's framing makes its memory model explicit:

- **Each agent's own mind** = its *working memory*: in-flight context, provisional
  notes, the task's distillations-in-progress. Fast, private, writable without
  coordination — a personal notebook. Literally a small OKF bundle scoped to the agent,
  or checkpointed process state.
- **The shared canonical mind** = the corpus (this repo's role today). Agents **read**
  it freely and concurrently (reads need no coordination). **Writes go through a single
  serializing [librarian-write-broker](/beliefs/glossary/librarian-write-broker.md)**
  (itself a GenServer, or a per-subtree pool) that owns intake dedup, `mix brain.verify`,
  and the [ratification](/beliefs/glossary/ratification.md) chokepoints *in-process*,
  not as CI-after-the-fact.

The broker's payoff is that it turns one agent's discovery into the swarm's: when the
1,000th agent promotes a fact from its working mind, the broker's intake
[deduplication](/beliefs/glossary/deduplication.md) finds it already filed and adds a
citation rather than a duplicate. That is the human-org pattern — personal notes →
curated team wiki — and it is the only version that scales. It is also precisely the
division of labor in
[claude-managed-agents-vs-beam-jido](/meta/analysis/claude-managed-agents-vs-beam-jido.md):
reducer invariants enforced in-process at one owned write-gatekeeper.

## 3. Persistence mechanics — and where they strain

Git-on-disk as the durable memory is a real strength: every write carries provenance by
construction (the session trailer, [true-merge](/beliefs/glossary/true-merge.md),
[attribution](/beliefs/glossary/attribution.md)), so even in a swarm every fact traces
to the agent and task that produced it. That audit substrate is exactly what makes the
[escape-rate](/beliefs/glossary/escape-rate.md) measurement
([the auto-intake escape-rate plan](/meta/plans/auto-intake-escape-rate-sampling.md))
possible — you can only sample escapes because every filing is attributed to a writer.

But **git is not a concurrent database**, and that is where the design gets hard — the
concurrent-writer problem the dark-factory analysis flagged as *the* hard problem
(governance moves from "can we run agents" to "epistemic governance under concurrent
autonomous writers"). Two agents committing to one working tree race on the index and
refs. That constraint is *why* writes serialize through the broker rather than being a
limitation to engineer around: the broker's single commit lane is the feature.
Mitigations when the lane becomes the bottleneck — per-agent private repos with async
promotion; sharding the shared mind by taxonomy subtree with a broker lane per subtree;
or keeping the canonical store in something with real concurrency and *deriving* git
snapshots for provenance.

The governance chokepoints also do not survive a swarm unchanged. Today "new top-level
directory" and "new type" are **operator** ratification gates; a thousand agents cannot
block on a human per shape-change. The broker therefore needs a two-class write policy —
*autonomous-safe* (file into the existing tree) versus *escalate-to-human* (shape
changes) — which is again the monitor-by-exception interface. The escape rate is how
one would know the autonomous-write class had earned its autonomy.

## 4. The topology, concretely

```
Application.Supervisor
├── Librarian            # GenServer/pool: owns the shared mind's write lane +
│                        #   intake-dedup / verify / ratification gates
├── Sensors              # watch feeds/channels → spawn agents (Jido sensors)
└── DynamicSupervisor
    └── Agent × N         # state: {task, context, working_mind, budget}
                          #   LLM calls via Task → handle_info
                          #   reads: shared mind, directly & concurrently
                          #   writes: Librarian.promote(fact) — serialized, gated
```

That is Jido + a librarian broker + OKF-on-disk as the two-tier memory.

## Findings

1. **The process model is not the hard part.** Agent-as-supervised-GenServer is
   essentially Jido; the BEAM supplies concurrency, isolation, and crash recovery
   directly.
2. **Two constraints are non-negotiable:** the slow LLM call must run off-process via
   `Task`/`handle_info` (never block the mailbox), and process state must be treated as
   ephemeral — the on-disk mind is the persistence and the crash-recovery checkpoint.
3. **"Its own mind" as a private silo is a trap** — it destroys cross-agent learning
   and multiplies duplication. The productive reading is two-tier: private working minds
   promoting up to one brokered shared canonical mind.
4. **The concurrent-writer strain is structural, not incidental.** Git-as-store forces a
   serializing librarian broker; the broker's single write lane is the design's load
   point and its correctness boundary.
5. **Provenance-by-construction is the swarm's trust substrate** — and it is what ties
   this architecture to the escape-rate metric: attribution on every write is the
   precondition for measuring whether autonomous writes can be trusted.

## Recommendation

This repo should **not become the swarm — it is the epistemic base the swarm would
stand on**, the same conclusion the
[BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md) and
[loomkin-as-existence-proof](/meta/analysis/loomkin-as-existence-proof.md) reached, now
refined by the per-agent memory model. The repo already holds the pieces the broker
would enforce (intake dedup, the verify gate, attribution, the ratification protocol).
What is missing is the three things the "not now" verdict named: a resident BEAM
runtime, the broker as an *in-process* write-gate rather than CI-after-commit, and a
concurrent-write story for the store. The operator's "each agent has its own mind"
framing is the contribution this analysis records: it makes the memory tier explicit —
private working minds + one brokered shared mind — and it is the natural companion to
the [escape-rate plan](/meta/plans/auto-intake-escape-rate-sampling.md), which measures
whether the broker's autonomous-write class has earned its trust. Timing is unchanged:
the trigger is still the resident-runtime threshold the BEAM/Jido analyses set, not this
memory model, which sharpens the target without moving the date.
