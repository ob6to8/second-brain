---
type: analysis
title: "Managed minds, owned machinery: Claude Managed Agents vs. Jido/BEAM for an agent-operated knowledge system"
description: A first-principles division of labor for a system in which autonomous agents work over a governed knowledge base — agentic work splits into deliberative and mechanical kinds; a framework fits the kind whose granularity matches its primitive unit, so Claude Managed Agents (unit — a rented Claude session) serves the deliberative plane while Jido on the BEAM (unit — a supervised process that need not call an LLM) serves the mechanical plane; the two meet at an owned write-gatekeeper, enforced by reducer invariants on one side and credential custody on the other.
provenance: "Claude Code session (Claude Fable), 2026-07-12 — operator asked how Anthropic's Claude Managed Agents service compares architecturally to a Jido/BEAM runtime for an agent-operated knowledge system, and where each holds an advantage. CMA facts from the bundled claude-api skill reference (managed-agents docs, beta managed-agents-2026-04-01); Jido facts verified against hex.pm/hexdocs/GitHub the same day"
tags: [meta, analysis, architecture, managed-agents, anthropic, beam, otp, jido, agents, two-plane, write-governance]
timestamp: 2026-07-12
---

# Managed minds, owned machinery: Claude Managed Agents vs. Jido/BEAM for an agent-operated knowledge system

**Question.** Suppose a system in which autonomous agents continuously do
knowledge work over a governed knowledge base — researching, filing, verifying,
maintaining. Two candidate substrates exist for running those agents:
**Claude Managed Agents** (CMA), Anthropic's hosted agent service, and
**Jido 2** on the BEAM, an Elixir agent framework you deploy yourself. Which
belongs where, and why?

**Thesis.** Start from the work, not the frameworks. Agentic work in such a
system comes in two kinds with opposite operating profiles: **deliberative**
work (rare, long, expensive, open-ended — a mind spends an hour) and
**mechanical** work (constant, sub-second, cheap, mostly deterministic — a
graph is walked, an index is checked). Each framework has a primitive unit of
agency, and a framework fits exactly the kind of work whose granularity matches
its unit. CMA's unit is a **Claude session in a provisioned container** —
always a mind, never less — which fits deliberative work and misfits mechanical
work by orders of magnitude in cost and latency. Jido's unit is a **supervised
BEAM process with state and a mailbox** — a mind only optionally — which fits
mechanical work natively and re-implements a managed product if used to host
deliberative Claude fleets. The correct architecture is therefore not a choice
but a **division of labor**: rent the minds, own the machinery. The two planes
meet at a single owned **write-gatekeeper** through which every mutation of the
knowledge base passes — reachable in-process from the mechanical plane and over
the network from the deliberative plane, and enforceable by different means on
each side. What neither substrate supplies is the knowledge base's own
epistemic integrity — deduplication, grounding, staleness — which precedes both.

## 1. Two kinds of agentic work

An agent-operated knowledge system generates work along two distinct profiles:

- **Deliberative work.** Research a topic for an hour; draft and revise a
  document against a rubric; triage a day's feed; investigate a discrepancy.
  Characteristics: low frequency, long duration, high token cost, open-ended
  control flow, inherently stochastic (the value *is* the model's judgment),
  and tolerant of seconds-to-minutes of startup latency.
- **Mechanical work.** When a source document changes, walk the dependency
  graph and flag every statement resting on it; check each proposed concept
  against a deduplication index; run integrity sweeps on a cadence; route
  events; retry failures. Characteristics: high frequency, sub-second units,
  negligible marginal cost, mostly deterministic — needing at most an
  occasional dab of small-model judgment — and intolerant of heavyweight
  startup.

The two profiles impose contradictory requirements on a runtime. Deliberative
work wants managed depth: supervision of long runs, scheduling, sandboxes,
credential handling, audit. Mechanical work wants density: thousands of cheap,
always-resident workers with microsecond dispatch. A single substrate serving
both serves one of them badly.

## 2. The two substrates and their units of agency

### Claude Managed Agents (beta, `managed-agents-2026-04-01`)

CMA is the only Anthropic agent surface supplying both the **harness and the
deployment**: the agent loop runs on Anthropic's orchestration layer, and each
session provisions a sandboxed container where the agent's tools execute. Its
verified shape:

- **Agents** are persisted, *versioned* configs (model, system prompt, tools,
  MCP servers, skills); sessions pin to a version; updates are append-only.
  Control plane as version-controlled YAML via the `ant` CLI.
- **Sessions** mount resources — files, GitHub repositories cloned through a
  git proxy that injects the auth token *outside* the sandbox, memory stores —
  and emit an SSE event stream. Lifecycle `rescheduling → running ↔ idle →
  terminated`: retryable failures are re-picked-up by the platform.
- **Scheduled deployments** fire sessions on cron with per-attempt audit
  records, auto-pause on non-recoverable errors, and manual test runs.
- **Outcomes** run a rubric-graded iterate loop with an independent grader.
- **Vaults** keep credentials out of the sandbox entirely — secrets are
  substituted into outbound requests at egress; even a prompt-injected agent
  cannot read them. **Permission policies** (`always_ask`) pause a session
  until a human confirms a tool call.
- **Multi-agent**: a coordinator with a roster (≤20), subagent threads (≤25),
  delegation depth 1. Org-level rate caps. Cognition is Claude-only; the loop
  always runs on Anthropic's side (only *tool execution* can be self-hosted,
  via Python/TypeScript/Go workers or the CLI — no Elixir worker).

**The unit of agency is a session**: a rented mind in a rented room. Container
provisioning, token billing, minutes of wall clock. There is no smaller unit.

### Jido 2 on the BEAM (2.x, 2026)

Jido is an Elixir framework whose core deliberately contains **zero LLM code**.
An agent is pure data — schema-validated state plus signal routes — processed
through a single pure reducer, `cmd(agent, action) → (new_agent, directives)`,
and hosted at runtime as a supervised GenServer. Actions compose; side effects
are *declared* as directive data the runtime interprets; signals are
CloudEvents-compliant messages with trie routing; the optional `jido_ai` layer
adds LLM reasoning strategies over a multi-provider client (`req_llm`).

**The unit of agency is a supervised process**: state, a mailbox, microsecond
dispatch, thousands per node. A mind is an option, not a constitution.

## 3. Matching units to work

**Deliberative work belongs on CMA.** Hosting it yourself means building what
CMA already ships: supervision of long stochastic runs, audited cron,
versioned configs, sandbox provisioning, credential isolation stronger than
anything quickly homebuilt, a graded verification loop, and a native
human-confirmation gate. A self-operated Jido fleet running Claude workers
reconstructs this managed product piece by piece, at months of engineering
cost, for workers whose expensive component — the model call — is a network
round-trip in either case. The exceptions are the classic sovereignty
overrides: data that cannot leave, cognition that must be multi-provider or
local, topology beyond CMA's ceilings, or refusal to build on a beta.

**Mechanical work belongs on Jido/BEAM.** Running a staleness cascade as CMA
sessions would provision a container per graph edge — hiring a consultant to
flip a light switch. As in-process agents, the same cascade is a burst of
messages. Three properties make the fit specific rather than generic:

1. **Density and latency.** Supervised processes cost microseconds and
   kilobytes; the mechanical plane's thousands of small operations per hour are
   the actor model's home terrain.
2. **In-process integration with owned services.** Mechanical agents call the
   knowledge base's own machinery — verifier, index, gatekeeper — as typed,
   transactional function calls in the same VM, under one supervision tree,
   with backpressure as a mailbox. (This advantage covers the *plumbing*, not
   the *thinking*: an LLM call is a network call from Elixir too. It is
   precisely because mechanical work is mostly non-LLM that the advantage
   lands here.)
3. **The reducer as a governable harness.** Because every agent decision passes
   through one pure function and effects are declared directives, the harness
   is unit-testable with no network or tokens, replayable from an action log,
   and able to carry *structural* invariants — e.g. "no action sequence yields
   a commit directive without passing the verification action." Purity ends
   where a model call begins (replay treats model output as recorded input),
   but most agent defects live in the harness, and a provable harness is worth
   having where the harness *is* most of the agent — again, the mechanical
   plane.

## 4. The seam: one owned gatekeeper

Both planes read and write the same knowledge base, and concurrent autonomous
writers are exactly the condition under which its integrity fails — duplicate
concepts, ungrounded claims, silently stale beliefs. The remedy is structural:
a single owned **write-gatekeeper** (a [librarian](/beliefs/glossary/librarian-write-broker.md))
that solely mutates the bundle. Agents on either plane submit proposals; the
gatekeeper runs the gauntlet — [dedup](/beliefs/glossary/deduplication.md),
verification, grounding — and serializes commits.

The gatekeeper's placement and enforcement follow from the division of labor:

- It lives on the **owned side**, in the same VM as the mechanical plane —
  which reaches it in-process, at mechanical frequency.
- Deliberative CMA agents reach it **over the network**, as a custom tool or
  MCP server: the session pauses, the request crosses to the owned
  application, the verdict returns. Acceptable at deliberative frequency.
- Enforcement is two-sided: on the mechanical side, the **reducer invariant**
  (no commit directive without verification — a property of the code); on the
  deliberative side, **credential custody** (only the gatekeeper holds write
  credentials to the repository, so no rented mind can bypass it, prompt
  injection included).

CMA supplies no equivalent. Sessions mounting the same repository contend at
git; memory-store `content_sha256` preconditions give per-file optimistic
concurrency, not a broker; and nothing in the platform deduplicates, grounds,
or propagates staleness. The epistemic layer is the owner's problem on every
substrate.

## 5. The owned application is one system

CMA's own architecture presupposes a customer-side application: something must
hold the SSE event streams for the duration of every run, answer
`custom_tool_use` requests (the mechanism by which agents use host-side
secrets and capabilities), receive and verify webhooks, create and retire
sessions, and meter spend — the platform enforces no budget. At fleet scale
this is a long-running, highly concurrent, fault-exposed service: the workload
profile the BEAM was built for.

That orchestrator, the write-gatekeeper, and the mechanical-plane agents are
not three systems but one: a single supervised Elixir application in which
plain OTP carries the supervision and relaying, and Jido carries whatever
parts of the mechanical plane are agent-shaped — sweepers, indexers,
small-model triage. Whether Jido enters at all is a granularity question
*within* the owned system, not a competition with CMA: the two frameworks
never contest the same work.

## 6. Decision rules and application

**General rules.**

1. Classify each workload by profile, not by the word "agent": long/stochastic
   /expensive → deliberative → CMA; frequent/cheap/mostly-deterministic →
   mechanical → owned BEAM.
2. Sovereignty, provider flexibility, and topology are overrides that pull
   deliberative work onto the owned side despite the re-implementation cost.
3. Every write to the knowledge base passes the owned gatekeeper, regardless
   of which plane proposed it.
4. Build the epistemic layer first; it is a prerequisite under every runtime
   configuration.

**Applied to this bundle.**

- The scheduled-automation need — today the
  [daily /research Routine that never lands](/meta/issues/daily-news-routine-runs-not-landing.md) —
  has a managed structural fix requiring no owned runtime: a CMA scheduled
  deployment (cron → fresh session → repository mounted with a PAT through the
  git proxy → commit and push), with per-firing audit records in place of
  silent failures. The cheaper operator action (clearing the approval gate on
  the existing Routine) still comes first.
- The prerequisites are already this repo's active plans: the
  [dedup recall probe](/meta/plans/dedup-recall-probe.md) gives the
  gatekeeper's entry gate a measured recall floor, and the
  [epistemic overlay](/meta/plans/epistemic-overlay.md) supplies the grounding
  graph that [staleness propagation](/beliefs/glossary/staleness-propagation.md)
  traverses. Both are substrate-independent and precede any agent fleet,
  rented or owned.

# Citations

- CMA — bundled claude-api skill reference (managed-agents docs; beta
  `managed-agents-2026-04-01`), read 2026-07-12; live docs at
  https://platform.claude.com/docs/en/managed-agents/overview.md (and sibling
  pages: sessions, environments, tools/vaults, events, outcomes, multi-agent,
  scheduled deployments, self-hosted sandboxes, webhooks, memory).
- Jido 2 — facts verified 2026-07-12 against https://hex.pm/packages/jido
  (2.3.2) · https://jido.hexdocs.pm/readme.html · https://github.com/agentjido/jido ·
  https://hex.pm/packages/jido_ai · https://hex.pm/packages/req_llm; fuller
  baseline in [the BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md).
- Related concepts — [two-plane rule](/beliefs/glossary/two-plane-rule.md) ·
  [librarian write-broker](/beliefs/glossary/librarian-write-broker.md) ·
  [actor model](/beliefs/glossary/actor-model.md) ·
  [deterministic spine](/beliefs/glossary/deterministic-spine.md).
- Caveats: CMA is beta — shapes, limits, and availability may shift; platform
  pricing beyond token usage was not stated in the reference consulted; Jido
  has no published cross-node distribution story (`jido_cluster` unreleased).
