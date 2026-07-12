---
type: analysis
title: "Claude Managed Agents vs. the BEAM/Jido direction: alternative, tandem, or both?"
description: A third companion to the BEAM/Jido evaluations finding that Anthropic's Managed Agents service (beta) is a direct managed alternative to the tier-1/tier-2 runtime the prior analyses mapped — supervision, durable scheduling, versioned agent configs, credential isolation, and rubric-graded verification loops off the shelf — while leaving exactly the layers those analyses called hardest (the librarian write-broker, the epistemic layer, the orchestrator-of-orchestrators) to "your application", which is a BEAM-shaped niche; re-prices the tier map's triggers, including a structural fix for the /news Routine.
provenance: "Claude Code session (Claude Fable), 2026-07-12 — operator follow-up to the dark-factory analysis: how does Anthropic's Claude Managed Agents API compare architecturally, and would it be used with the BEAM or instead of it? CMA facts taken from the bundled claude-api skill reference (managed-agents docs, beta managed-agents-2026-04-01), same day"
tags: [meta, analysis, architecture, managed-agents, anthropic, beam, otp, jido, agents, dark-factory, scheduling]
timestamp: 2026-07-12
---

# Claude Managed Agents vs. the BEAM/Jido direction: alternative, tandem, or both?

**Question.** Extend the [BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md)
and its [dark-factory re-score](/meta/analysis/dark-factory-epistemic-base-beam-jido.md):
how does Anthropic's **Claude Managed Agents** (CMA) service compare
architecturally? Would it be used *in conjunction with* a BEAM runtime, *in
tandem*, or as a *direct alternative*? What are the pros and cons of each
approach?

**Bottom line.** Both — split by layer. CMA is a **direct managed alternative to
tier 1 and most of tier 2** of the prior analyses' map: it rents, off the shelf,
almost exactly the runtime the dark-factory analysis said OTP/Jido would have to
provide — supervision-as-a-service, durable cron scheduling with run auditing,
versioned agent configs, event streams, multi-agent threads, credential
isolation, and even a rubric-graded iterate loop. It **dissolves the
"can't-rent-your-nervous-system" premise for the worker tier** — that argument
was aimed at Claude Code's operator-centric session harness, and CMA is a
different thing: a programmatic, autonomous harness built for exactly the
lights-out shape. But CMA explicitly leaves an "**your application**" role — the
process that holds event streams, answers custom-tool calls, receives webhooks,
creates and governs session fleets — and it leaves the entire **epistemic
layer** (dedup, grounding, staleness, the librarian write-broker) untouched.
Those residues are long-running, concurrent, fault-exposed services: precisely
the BEAM-shaped niche, now much smaller — and plain OTP-shaped rather than
Jido-shaped, since CMA subsumes Jido's worker runtime for Claude-cognition
fleets. The tier map's nearest trigger also re-prices: a CMA **scheduled
deployment** is a structural fix for the broken `/news` Routine that requires no
resident tier at all.

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
| **Orchestrator of the fleet** (hold streams, answer custom tools, receive webhooks, create/govern sessions, enforce the two-plane rule) | **Explicitly yours** — CMA's own client patterns assume a long-running application holding SSE streams and answering `custom_tool_use` events |

The pattern is stark: CMA covers nearly everything the dark-factory analysis
assigned to OTP/Jido, and nothing the analysis called *the hard problem*.

## 3. Alternative, tandem, or conjunction? All three, by layer

**Direct alternative — the worker/runtime tier.** For a fleet whose cognition is
Claude anyway, CMA replaces the tier-1 daemon's scheduler and supervisor and
tier-2 Jido's worker runtime outright. The dark-factory blocker-dissolution
argued a lights-out company "cannot rent its nervous system" because Claude
Code's harness is operator-centric and session-shaped; CMA is neither — it is
the rentable, purpose-built version of the thing tier 2 proposed to construct.
Building a Jido fleet to run Claude workers is now re-implementing a managed
product.

**Tandem — the nervous-system layer.** CMA's architecture *presupposes* a
customer-side application: something must hold the SSE streams, respond to
`agent.custom_tool_use` (the mechanism for host-side secrets and host-side
capabilities), receive webhooks, create sessions, rotate credentials, and watch
costs. For one session that's a script; for a company-scale fleet it is a
long-running, concurrent, fault-exposed service — a **BEAM-shaped workload**.
The natural tandem: CMA runs the agent loops; a small OTP application is the
company's own nervous system around them, and — crucially — the **librarian
write-broker lives there**, exposed *to* CMA agents as a custom tool or MCP
server, so every bundle mutation still passes one owned choke point regardless
of which rented runtime proposed it. This inverts the prior tier map nicely: the
BEAM piece shrinks from "the whole factory" to "the governor and the librarian,"
which is plain OTP — Jido's agent abstractions are not needed for it.

**Conjunction — self-hosted sandboxes.** The hybrid where CMA keeps the loop but
tools execute on infrastructure you control (data can't leave, or host binaries
are needed). Note the friction for this repo's stack: worker helpers are
Python/TS/Go only — an Elixir host would drive the `ant` CLI worker rather than
embed one.

## 4. Pros and cons

**CMA (rent):**
- *Pros.* Zero runtime engineering — supervision, scheduling-with-audit,
  compaction, caching, container provisioning, vaults, webhooks, outcomes,
  versioned configs ship today; a credential story stronger than anything
  quickly homebuilt (egress substitution directly narrows the
  epistemic-poisoning injection surface); a native ratification primitive;
  governance-as-YAML from CI; and the fastest path from this repo's current
  state to autonomous operation.
- *Cons.* Beta surface with org-level rate caps and evolving semantics; the
  loop cannot run on-prem (only tools can); Claude-only cognition; topology
  ceilings (delegation depth 1, ≤25 threads); cost sits on Anthropic's meter;
  vendor coupling for the company's most operational layer; and no help
  whatsoever with write governance or belief integrity.

**BEAM/Jido (own):**
- *Pros.* Full ownership: on-prem, provider-agnostic (`req_llm`), unbounded
  topology, fine-grained supervision semantics, infra-only marginal cost, no
  beta dependency.
- *Cons.* You build and operate everything CMA ships — months of engineering
  before the first useful agent; the toolchain migration; credential isolation
  and scheduling auditability are on you; and for Claude-cognition fleets it
  duplicates a product the vendor is actively investing in.

## 5. Verdict and the re-priced tier map

**The comparison sharpens, rather than changes, the standing conclusion.** The
critical path is still the epistemic layer — the
[dedup recall probe](/meta/plans/dedup-recall-probe.md) and
[epistemic overlay](/meta/plans/epistemic-overlay.md) are prerequisites under
*every* runtime option, rented or owned — and the librarian write-broker is
still the first genuinely new artifact the autonomous scenario demands, now with
a clearer home (an owned service CMA agents call, not a feature to await).

Three concrete updates to the prior analyses:

1. **The `/news` trigger re-prices.** The nearest tier-1 trigger — the
   [Routine that never lands](/meta/issues/daily-news-routine-runs-not-landing.md) —
   now has a *managed* structural fix cheaper than any resident daemon: a CMA
   scheduled deployment (cron → fresh session → repo mounted via
   `github_repository` with a PAT through the git proxy → commit and push), with
   per-firing run records replacing today's silent failures and no
   approval-gate dependency. The cheap fix (clear the gate) still comes first;
   the structural fallback is no longer "build tier 1."
2. **Tier 2 forks by ownership.** For Claude-cognition fleets, CMA *is* tier 2,
   rented. Jido's remaining case is the ownership branch: on-prem requirements,
   multi-provider cognition, or topology beyond CMA's ceilings.
3. **The BEAM niche narrows and hardens.** What remains owned in every
   configuration — librarian, webhook/stream orchestrator, fleet and cost
   governor, fast-plane services under the two-plane rule — is a smaller but
   load-bearing system, and it wants plain OTP, not an agent framework.

# Citations

- Prior evaluations — [/meta/analysis/beam-deployment-and-jido-2-evaluation.md](/meta/analysis/beam-deployment-and-jido-2-evaluation.md) · [/meta/analysis/dark-factory-epistemic-base-beam-jido.md](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
- CMA facts — bundled claude-api skill reference (managed-agents docs; beta `managed-agents-2026-04-01`), read 2026-07-12; live docs at https://platform.claude.com/docs/en/managed-agents/overview.md (and sibling pages: sessions, environments, tools/vaults, events, outcomes, multi-agent, scheduled deployments, self-hosted sandboxes, webhooks, memory)
- Caveats: CMA is beta — object shapes, limits, and availability may shift; container/platform pricing beyond token usage was not stated in the reference consulted; the four-surface harness/deployment framing follows Anthropic's own docs.
- Critical path unchanged — [/meta/plans/dedup-recall-probe.md](/meta/plans/dedup-recall-probe.md) · [/meta/plans/epistemic-overlay.md](/meta/plans/epistemic-overlay.md)
