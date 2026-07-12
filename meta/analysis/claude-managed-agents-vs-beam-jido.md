---
type: analysis
title: "Claude Managed Agents vs. the BEAM/Jido direction: alternative, tandem, or both?"
description: Finds that Anthropic's Managed Agents service (beta) rents almost exactly the tier-1/tier-2 runtime the dark-factory analysis assigned to OTP/Jido, but that the comparison partly dissolves along the two-plane line once "agent" is examined — CMA's unit of agency is always a Claude session (right for slow-plane thinkers), Jido's is a supervised process that may not call an LLM at all (right for the fast-plane machinery: staleness cascades, dedup indexing, verification sweeps) — with the librarian at the border, enforced by Jido's pure-reducer gauntlet on one side and credential custody on the other; re-prices the /news trigger and revises the earlier "plain OTP, not Jido" claim.
provenance: "Claude Code session (Claude Fable), 2026-07-12 — operator follow-up to the dark-factory analysis (how does Anthropic's Managed Agents API compare; alternative or tandem?), rewritten the same day after the operator pressed the Jido steelman (Elixir-native librarian integration, the Redux/Elm reducer model, modularity) and the resulting two-plane verdict outgrew the first draft. CMA facts from the bundled claude-api skill reference (managed-agents docs, beta managed-agents-2026-04-01); Jido facts inherit the BEAM/Jido evaluation's verified baseline"
tags: [meta, analysis, architecture, managed-agents, anthropic, beam, otp, jido, agents, dark-factory, scheduling, two-plane]
timestamp: 2026-07-12
---

# Claude Managed Agents vs. the BEAM/Jido direction: alternative, tandem, or both?

**Question.** Extend the [BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md)
and its [dark-factory re-score](/meta/analysis/dark-factory-epistemic-base-beam-jido.md):
how does Anthropic's **Claude Managed Agents** (CMA) service compare
architecturally? Is it used *with* a BEAM runtime or *instead of* it? And —
pressed by the operator — does Jido 2 retain any real advantage: its
Elixir-native integration with an Elixir librarian, its modularity, its
Redux/Elm-style reducer?

**Bottom line.** CMA rents, off the shelf, almost exactly the tier-1/tier-2
runtime the dark-factory analysis assigned to OTP/Jido — supervision-as-a-service,
audited cron scheduling, versioned agent configs, event streams, multi-agent
threads, credential isolation, and a rubric-graded verification loop — which
makes it a **direct managed alternative for the slow-plane workers** (long,
autonomous, Claude-cognition knowledge work) and dissolves the
"can't-rent-your-nervous-system" objection for that tier. But the comparison
**partly dissolves rather than resolves**, because the two frameworks disagree
about what an agent *is*: CMA's unit of agency is always a Claude session in a
container; Jido's is a supervised process that may never call an LLM at all.
Measured against this bundle's own [two-plane rule](/glossary/two-plane-rule.md),
they sit on opposite sides of the line: **CMA for the thinkers, Jido for the
machinery** — the high-frequency, cheap, mostly deterministic fast-plane work
(staleness cascades, dedup indexing, verification sweeps) where Jido's
in-process integration and pure-reducer harness are genuine, tested advantages.
The **librarian write-broker sits at the border**, owned in every configuration,
enforced by the reducer on the fast side and by credential custody on the slow
side. This revises the first draft's "plain OTP, not Jido" verdict: OTP suffices
while the owned layer only supervises and relays; Jido earns its place the
moment the fast plane grows agents of its own. The critical path — dedup probe,
epistemic overlay — is unchanged under every option.

## 1. What CMA is (verified baseline, beta as of 2026-07)

Facts from the claude-api skill's bundled managed-agents reference (beta header
`managed-agents-2026-04-01`); recorded so future re-evaluation has a baseline.

- **The harness/deployment split.** Among Anthropic's four agent-building
  surfaces (manual loop, SDK Tool Runner, Claude Agent SDK, CMA), CMA is the
  only one supplying **both** the harness *and* managed deployment: the agent
  loop runs on Anthropic's orchestration layer, and each session provisions a
  sandboxed container where the agent's tools (bash, file ops, code) execute.
- **Object model.** An **Agent** is a persisted, *versioned* config (model,
  system prompt, tools, MCP servers, skills) — create once, pin sessions to a
  version; updates are append-only versions. An **Environment** is a container
  template (`cloud` or `self_hosted`). A **Session** is a run: it references an
  agent + environment, mounts **resources** (files; GitHub repos cloned via a
  git proxy that injects the auth token *outside* the sandbox; memory stores),
  and produces an SSE **event stream** you send user messages and tool results
  into. Recommended control-plane flow: agents/environments as version-controlled
  YAML applied with the `ant` CLI; sessions from application code.
- **Supervision semantics.** Session lifecycle `rescheduling → running ↔ idle →
  terminated`: retryable errors put the session into `rescheduling` for pickup
  by the orchestration system — restart-on-failure is the platform's job.
  Compaction and prompt caching are built into sessions.
- **Scheduling.** **Scheduled deployments**: cron expression + IANA timezone →
  each firing creates a session autonomously; every attempt writes an auditable
  run record (success → `session_id`; failure → typed error); auto-pause on
  non-recoverable errors; manual test runs; lifecycle webhooks. Max 1,000 per
  org.
- **Multi-agent.** A coordinator agent declares a roster (≤20 agents); subagents
  run as context-isolated **threads** (≤25 concurrent) sharing the container
  filesystem; delegation is one level deep.
- **Verification loop.** **Outcomes**: send `user.define_outcome` with a
  gradeable rubric; an independent grader scores each iteration and feeds
  per-criterion gaps back until satisfied or `max_iterations` (≤20).
- **Trust boundary.** **Vaults** hold credentials that *never enter the
  sandbox* — MCP OAuth (auto-refreshed) and environment-variable secrets
  substituted into outbound requests at egress; the sandbox sees an opaque
  placeholder. **Permission policies** (`always_ask`) pause the session until a
  human sends a `tool_confirmation`. **Memory stores** are workspace-scoped,
  version-audited (immutable per-mutation snapshots, redactable), with
  `content_sha256` preconditions for optimistic concurrency.
- **Self-hosted sandboxes** move tool execution (not the loop) onto your infra
  via an outbound-polling worker — SDK workers exist for Python/TypeScript/Go
  only (plus the `ant` CLI); no Elixir worker.
- **Limits and status.** Beta; org-level RPM caps (e.g. 300 RPM creates, 60 RPM
  environment ops); the loop always runs Anthropic-side; cognition is
  Claude-only; cost is token-usage-based on Anthropic's meter.

## 2. The mapping: CMA against the tier plan

The prior analyses specified what a resident runtime must provide. Component by
component:

| Tier-1/2 component (from the prior analyses) | CMA equivalent |
|---|---|
| Supervision / "the night-shift manager" (OTP supervision trees, let-it-crash + checkpoint restart) | Session lifecycle with `rescheduling`; platform-owned retry and recovery |
| Durable cron owning the `/news` feed (tier 1's first trigger) | **Scheduled deployments** — cron + timezone, per-firing run records, auto-pause, manual runs |
| Jido agents-as-versioned-config with auditable decisions | Versioned Agent objects; event history as the per-session audit trail |
| Signals / CloudEvents bus | SSE event streams + webhooks (thin, HMAC-signed) |
| Pods / departments (multi-tenancy) | Workspaces; multiagent coordinator + threads |
| Continuous verification / immune-system sweeps | Outcomes (rubric-graded iterate loop) — per-session, not yet fleet-wide |
| Operator ratification gate | `always_ask` permission policies → `tool_confirmation` events — a *native primitive* for this bundle's ratification protocol |
| Governance by compilation (per-role fleet contracts from `meta/policy/`) | Compile policies → agent `system` prompts, applied as version-controlled YAML via `ant` from CI — the render-target idea, productized |
| Credential isolation against epistemic poisoning's injection surface | Vaults: secrets substituted at egress, unreadable from the sandbox even under prompt injection |
| **Librarian write-broker** (serialized bundle mutation, unbypassable checks) | **Absent.** Sessions mount the repo and push; concurrent writers still contend at git. (Memory-store `content_sha256` preconditions are a single-file optimistic-concurrency primitive, not a broker.) |
| **Epistemic layer** (dedup recall, grounding, staleness propagation) | **Absent** — entirely this system's own problem, on any substrate |
| **Orchestrator of the fleet** (hold streams, answer custom tools, receive webhooks, create/govern sessions, watch costs, enforce the two-plane rule) | **Explicitly yours** — CMA's own client patterns assume a long-running application holding SSE streams and answering `custom_tool_use` events |

The pattern is stark: CMA covers nearly everything the dark-factory analysis
assigned to OTP/Jido, and nothing that analysis called *the hard problem*.

## 3. The deepest difference: what each framework considers "an agent"

The feature tables above understate the real divergence. In CMA, an agent is
**always a Claude session** — a rented mind in a rented room. The unit is
heavyweight by construction: a container provisions, tokens burn, minutes pass.
That is the right shape when the task is "spend an hour researching and produce
a deliverable."

In Jido, an agent is **a supervised process with state and a mailbox** that
*may* call an LLM — the core framework deliberately contains zero LLM code. An
agent can be pure code reacting to events in microseconds, or a `jido_ai`
reasoning loop, and both live in one fabric under one supervision tree.

The future machinery of this knowledge base is full of the first kind of work:
when a source changes, walk the dependency graph and flag the fifty statements
resting on it ([staleness propagation](/glossary/staleness-propagation.md));
check each proposed concept against the dedup index; run the verification sweep
on a cadence. High-frequency, cheap, mostly deterministic, needing at most an
occasional dab of *small-model* judgment. Running each as a CMA session is
hiring a consultant to flip a light switch; running them as in-process agents
is trivial. **This is the two-plane rule reappearing as a framework-selection
criterion**: CMA's unit of agency fits the slow plane; Jido's fits the fast
plane.

## 4. The Jido steelman, tested

Three claimed advantages, each with its boundary stated.

**Elixir-native integration with an Elixir librarian — real, bounded.** Jido
agents live *in the same running VM* as the librarian: handing it a proposed
concept is a typed, transactional function call, and the existing
zero-dependency verifier (`SecondBrain.Verifier`) is invoked in-process. A CMA
agent reaches the librarian over the network instead — the session idles, a
`custom_tool_use` event travels to the host application, the result travels
back, the session resumes. Fine once per intake; painful hundreds of times an
hour. Same-VM also means one supervision tree (the librarian supervises its own
worker agents) and backpressure as a mailbox rather than cross-network
rate-limit diplomacy. *Boundary:* the advantage covers the plumbing, not the
thinking — LLM calls are network calls from Elixir too, so in-process wins
matter exactly where work is frequent and mostly non-LLM: the fast plane.

**The Redux/Elm reducer — Jido's most distinctive advantage, also bounded.**
Every agent decision passes through one pure function:
`cmd(agent, action) → (new_agent, directives)`, with side effects *declared* as
directive data the runtime inspects before executing. Three consequences:

1. **Testability without an LLM.** Every scaffolding path — retries, routing,
   gating — unit-tests with no network, tokens, or container. This is the same
   philosophy this repo already practices (pin the
   [deterministic spine](/glossary/deterministic-spine.md), leave only the
   genuinely fuzzy part fuzzy), applied to an agent runtime.
2. **Replayability.** State is a fold over an action log; the agent's beliefs
   at any moment reconstruct deterministically. CMA's event history lets you
   *see* what happened but never *re-execute* it — the decisions live inside
   Claude and Anthropic's orchestration.
3. **Provable gates.** "No action sequence yields a commit directive without
   passing the verification action" can be a structural, property-testable
   invariant of the reducer — the
   [librarian](/glossary/librarian-write-broker.md)'s guarantee expressed in
   code. CMA's nearest equivalents (per-tool permission policies; the librarian
   alone holding git credentials) are access control, not proof.

*Boundary:* purity ends where the model begins. An action that calls Claude is
a stochastic step; replay treats it as recorded input. The reducer yields a
deterministic, auditable *harness* around a non-deterministic core — worth a
lot, since most agent bugs live in the harness, but it does not make the
thinking testable.

**Modularity, multi-provider, topology, sovereignty — real, situational.**
Actions compose; strategies swap; `req_llm` routes to any provider (small or
local models for cheap steps — fine-grained cost engineering CMA's
Claude-only, per-session pricing can't express); topology is unbounded (CMA:
delegation depth 1, ≤25 threads, ≤20 roster); and the ownership branch
(on-prem, no vendor beta, egress control) stands as stated in the prior
analyses. None of this outweighs CMA for the flagship slow-plane workload; all
of it compounds on the fast plane.

## 5. Verdict: the comparison dissolves along the two-plane line

**As a direct alternative** — for slow-plane workers (long, autonomous,
Claude-cognition knowledge work) — CMA wins: building a Jido fleet to run
Claude workers is re-implementing a managed product. The dark-factory
"can't-rent-your-nervous-system" objection targeted Claude Code's
operator-centric session harness; CMA is the rentable, purpose-built version of
what tier 2 proposed to construct.

**As a tandem** — CMA's architecture *presupposes* a customer-side application:
something must hold the SSE streams, answer `custom_tool_use` (the host-side
secrets and capabilities mechanism), receive webhooks, create and govern
sessions, and watch costs. At fleet scale that is a long-running, concurrent,
fault-exposed service — a BEAM-shaped workload — and it is also where the
**librarian** lives, exposed *to* CMA agents as a custom tool or MCP server so
every bundle mutation passes one owned choke point.

**The revision this rewrite exists for:** the first draft said that owned layer
wants "plain OTP, not Jido." That holds only while the layer merely supervises
and relays. The moment the fast plane grows *agents of its own* — staleness
sweepers, dedup indexers, small-model triage — Jido stops being a CMA
competitor and becomes the fast plane's natural framework: in-process with the
librarian, reducer-gated, provider-flexible, and cheap per agent. The two
frameworks then aren't alternatives at all; they sit on opposite sides of the
bundle's own two-plane line, with the librarian at the border — enforced by the
reducer on the fast side and by credential custody on the slow side.

**Re-priced tier map (unchanged from the first draft):**

1. **The `/news` trigger re-prices.** The
   [Routine that never lands](/meta/issues/daily-news-routine-runs-not-landing.md)
   now has a *managed* structural fix cheaper than any resident daemon: a CMA
   scheduled deployment (cron → fresh session → repo mounted via
   `github_repository` with a PAT through the git proxy → commit and push),
   with per-firing run records replacing today's silent failures and no
   approval-gate dependency. The cheap fix (clear the gate) still comes first.
2. **Tier 2 forks by plane, not just by ownership.** Slow-plane Claude fleets →
   CMA (rented) unless sovereignty forbids; fast-plane machinery → Jido/OTP
   (owned) by construction.
3. **The critical path is unchanged** — the
   [dedup recall probe](/meta/plans/dedup-recall-probe.md) and
   [epistemic overlay](/meta/plans/epistemic-overlay.md) are prerequisites
   under every runtime option, rented or owned; the librarian remains the first
   genuinely new artifact the autonomous scenario demands, now with a clearer
   home and, via the reducer, a clearer enforcement mechanism.

# Citations

- Prior evaluations — [/meta/analysis/beam-deployment-and-jido-2-evaluation.md](/meta/analysis/beam-deployment-and-jido-2-evaluation.md) (verified Jido 2 baseline, incl. the `cmd/2` reducer and zero-LLM core) · [/meta/analysis/dark-factory-epistemic-base-beam-jido.md](/meta/analysis/dark-factory-epistemic-base-beam-jido.md) (two-plane rule, librarian, tier map)
- CMA facts — bundled claude-api skill reference (managed-agents docs; beta `managed-agents-2026-04-01`), read 2026-07-12; live docs at https://platform.claude.com/docs/en/managed-agents/overview.md (and sibling pages: sessions, environments, tools/vaults, events, outcomes, multi-agent, scheduled deployments, self-hosted sandboxes, webhooks, memory)
- Caveats: CMA is beta — object shapes, limits, and availability may shift; container/platform pricing beyond token usage was not stated in the reference consulted; the four-surface harness/deployment framing follows Anthropic's own docs; Jido claims inherit the first evaluation's unconfirmed items (distribution/`jido_cluster` maturity chief among them).
