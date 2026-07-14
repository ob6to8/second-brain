---
type: analysis
title: "Loomkin as existence proof: evaluating a shipped Jido-native agent harness against this bundle's tiered path"
description: An external-system evaluation finding that Loomkin (MIT, ~77K LOC, Elixir/OTP + the Jido stack) is a built instance of almost exactly the tier-2 endpoint mapped in this bundle's BEAM/Jido analyses — independently confirming the Jido abstraction fit, the staleness-cascade design, the fidelity-preserving-offload doctrine, the advisor cost pattern, and the shallow-DSL legibility rule — while differing on the load-bearing choices (reasoning memory over a governed corpus, autonomy-first over operator sovereignty, database provenance over git, confidence scores over binary verification); concludes this repo should not become Loomkin but is the kind of epistemic base a Loomkin would need underneath it, and records one change to the standing tier-2 re-evaluation baseline: a buy/adopt option now exists.
provenance: "Claude Code session (Claude Fable), 2026-07-14 — operator asked, with the AST/macro analysis in mind, to evaluate github.com/pass-agent/loomkin against this repo: parallels, differences, whether this repo could or should evolve into something similar, and what to learn. Loomkin facts read from the repo README, docs/architecture.md, and docs/why-elixir.md the same day"
tags: [meta, analysis, loomkin, elixir, beam, otp, jido, agents, harness, multi-agent, decision-graph, context-mesh, build-vs-buy, two-plane]
timestamp: 2026-07-14
attribution:
  when: 2026-07-14T00:00:00Z
  channel: agent-authored
  agent: "Claude Code session (Claude Fable), operator-directed external-system evaluation"
  why: "operator asked for Loomkin to be evaluated against this repo in light of the AST/macro analysis and, on review, directed the assessment be filed as the fourth leg of the BEAM/Jido analysis set"
  from: [/meta/threads/2026-07-14-elixir-ast-macros-and-loomkin-evaluation.md]
---

# Loomkin as existence proof: evaluating a shipped Jido-native agent harness against this bundle's tiered path

**Question.** [Loomkin](https://github.com/pass-agent/loomkin) is an
open-source multi-agent AI framework in Elixir. How does it compare to this
repo — parallels, differences? If this repo evolved, could it become something
similar? Should it? What can be learned from it?

**Thesis.** Loomkin is a built, shipping instance of almost exactly the
tier-2 endpoint mapped in
[the BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md) —
a resident BEAM system hosting Jido-based agent teams — but pointed at a
different object (a codebase, not a knowledge corpus) and organized around the
opposite doctrine (autonomy-first rather than operator-sovereign). It is the
strongest external validation yet of the judgments this bundle has filed
across the BEAM/Jido analysis set, and simultaneously a demonstration of what
this repo should *not* become. Its existence changes exactly one thing in the
standing baseline: when the recorded tier-2 triggers fire, the re-evaluation
now includes a **buy/adopt option** that did not exist when the 2026-07-12
analyses were written.

## 1. What Loomkin is (read 2026-07-14)

An MIT-licensed multi-agent framework (Elixir 1.20+/OTP 28+, ~77K LOC
application code, 2,700+ tests, Phoenix LiveView UI, PostgreSQL; ~179 GitHub
stars) for spawning teams of software-development agents — lead, researcher,
coder, reviewer, tester — as OTP-native GenServers under a DynamicSupervisor,
with per-agent model selection and per-team budget tracking. Its distinctive
pieces:

- **Decision graph.** A persistent DAG with 7 node types (goal, decision,
  option, action, outcome, observation, revisit) and typed edges (`leads_to`,
  `chosen`, `rejected`, `requires`, `blocks`, `enables`, `supersedes`), each
  node carrying a 0–100 confidence score. "Confidence cascades": when a
  decision's confidence drops, downstream nodes connected via
  `:requires`/`:blocks` edges receive `upstream_uncertainty` flags. Active
  goals and recent decisions are injected into the system prompt,
  token-budgeted.
- **Context mesh.** Overflow context is offloaded to **Keeper processes**
  that "hold offloaded context at full fidelity" instead of summarizing it
  away, with topic-boundary detection, access-frequency and staleness
  tracking, and cross-agent retrieval from prior sessions.
- **Verification gates.** "Upstream verifiers auto-spawn on task completion
  to validate output before dependents proceed"; autonomous
  write → test → diagnose → fix → re-test loops; self-healing via ephemeral
  diagnostician and fixer agents.
- **Permission system.** Per-tool, per-path approval with trust policies, an
  audit trail, and an auto-approve toggle for trusted workflows;
  region-level file locking lets multiple agents edit one file by claiming
  line ranges or symbols.
- **The Jido stack underneath.** "Every Loomkin tool is a `Jido.Action` with
  declarative schemas, automatic validation, and composability";
  `Jido.AI.ToolAdapter` "bridges our actions to LLM tool schemas in one
  line"; `req_llm` supplies 16+ providers. State persists to PostgreSQL via
  Ecto plus an ETS-journaled `Jido.Signal` bus (28+ signal types, replayable).

## 2. Parallels: filed judgments, independently confirmed

1. **The Jido abstraction fit is proven at production scale.**
   [The BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md)
   argued the fit was real ("`brain.*` verbs as Actions… one definition,
   three surfaces") but the timing wrong. Loomkin is that fit realized —
   actions-as-tools via exactly the macro mechanism verified in
   [the AST/macro analysis](/meta/analysis/elixir-ast-macros-for-llm-harnesses.md).
   Its `why-elixir.md` also confirms the runtime-level case: a lightweight
   process per tool execution, supervisors absorbing hung shells and
   timed-out providers, PubSub coordination with "no serialization overhead,
   no network hops," and hot code reloading of tools mid-session.
2. **The decision graph is the epistemic overlay's cousin, running in the
   wild.** Typed `requires`/`blocks` edges with `upstream_uncertainty` flags
   cascading downstream is precisely the
   [staleness-propagation](/beliefs/glossary/staleness-propagation.md)
   mechanism in the [epistemic overlay plan](/meta/plans/epistemic-overlay.md),
   implemented and queryable — a live schema to compare against, not a
   design sketch.
3. **The context mesh vindicates the capture doctrine.** Fidelity-preserving
   offload ("instead of summarizing it away… at full fidelity") is the same
   commitment as `/capture`'s rule — retained text verbatim, only noise
   stripped — arrived at independently: for memory that must be resumed
   from, offload beats lossy compression.
4. **"Cheap grunts + expensive judges (18x cost savings)"** is the
   advisor/orchestrator pattern of
   [the advisor-harness analysis](/meta/analysis/when-to-roll-your-own-advisor-harness.md),
   self-built over raw API calls — the client-side reimplementation path
   that analysis described, with the controls it predicted (per-agent model
   selection, per-team budget tracking) as the payoff.
5. **Their metaprogramming is restrained.** `why-elixir.md` leans on pattern
   matching and OTP, not macros; agent definitions are declarative Elixir
   modules with no custom DSL — the only DSL surface is Jido's shallow
   action macro. That is design constraint 4 of the AST/macro analysis (keep
   agent-facing DSLs shallow and legible), practiced by a team that shipped.

## 3. Differences: the load-bearing ones

1. **Different object.** Loomkin's persistent memory is *reasoning* memory
   about a codebase — what was tried, what was rejected, why. This bundle's
   corpus is *distilled knowledge* under an operator-ratified taxonomy.
   Loomkin's decision graph is roughly this repo's threads + routing ledger
   + analyses, machine-shaped instead of prose-shaped; it has no equivalent
   of the concept layer, the type vocabulary, or the compiled contract.
2. **Opposite doctrine on the human.** Loomkin's pitch is teams that "verify
   outputs without human intervention," with auto-approve for trusted
   workflows; its permission system is runtime, per-tool-call. This brain's
   governance is *shape-level*: agents act autonomously inside ratified
   structure, and the operator ratifies changes to the structure itself.
   Loomkin automates the approval away; the brain constitutionalizes it.
3. **Provenance substrate.** Loomkin persists to PostgreSQL plus an ETS
   signal journal — replayable, but a database. This bundle's provenance is
   the true-merge git graph over human-legible markdown: diffable,
   blame-able, renderable to a public site, portable as an OKF bundle. One
   is telemetry; the other is a document corpus.
4. **Confidence scores — the settled disagreement, with a nuance.** Loomkin
   scores every node 0–100;
   [the second-mind analysis](/meta/analysis/second-mind-taxonomy-and-the-belief-gap.md)
   rejected exactly this for the bundle (free-floating probabilities with no
   oracle rot silently) in favor of binary `verified` plus machine-checked
   evidence edges. The nuance worth keeping: Loomkin scores *decisions in
   flight* — working memory on an hours-to-days horizon — not durable
   knowledge. Confidence on working state is defensible; on a corpus meant
   to last, it is not. The disagreement is about scope/horizon, not a
   contradiction.
5. **Toolchain posture.** Elixir 1.20+/OTP 28+, Docker, Node 22, PostgreSQL —
   a heavier floor even than Jido's own, against this repo's
   zero-dependency Elixir 1.14 batch core. The constraint gap has widened.

## 4. Could this repo become something similar? Should it?

**Could — yes, structurally.** The tiered path already filed (batch core →
resident daemon → MCP tool surface → Jido agents) describes Loomkin's shape
almost exactly, and
[the dark-factory analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
is essentially Loomkin's operating scenario with this bundle as the epistemic
base. Loomkin is existence proof that the destination is reachable and works.

**Should — not by becoming it.** Loomkin also demonstrates the *cost* side of
[the two-plane analysis](/meta/analysis/claude-managed-agents-vs-beam-jido.md):
it hosts the deliberative plane itself, and consequently had to rebuild the
managed-product layer — budget tracking, trust policies, approval dashboards,
self-healing, audit — to the tune of ~77K lines and 2,700 tests. That is the
"months of engineering" prediction, quantified. More fundamentally,
everything that makes this repo distinctive is what Loomkin lacks: the
governed corpus, the compiled contract, git provenance, operator sovereignty.
Evolving into Loomkin would trade the epistemic base for a runtime —
backwards. The right relation is the one already on record: **this bundle is
the kind of thing a Loomkin needs underneath it.** Loomkin agents remember
*how they decided*; they have nowhere governed to put *what they know*. The
dedup/grounding/staleness layer the two-plane analysis called "the owner's
problem on every substrate" is unsolved in Loomkin too — its region-level
file locking handles write *conflict*, not epistemic *integrity* (no
[librarian](/beliefs/glossary/librarian-write-broker.md), no dedup gate, no
grounding).

**The one baseline change.** The 2026-07-12 tier-2 framing weighed
build-on-Jido against nothing; an MIT-licensed, tested, Jido-native harness
with a decision graph and verification gates now exists. When the recorded
triggers fire, the re-evaluation must include **adopt or fork Loomkin's
mechanical plane** alongside "build on Jido directly" — with its youth (~179
stars, single-org project) and heavyweight toolchain floor as the
counterweights. This paragraph is that recorded amendment; the prior analyses
stand otherwise unedited.

## 5. What to learn

- **Steal the cascade mechanics for the epistemic overlay.** The
  `requires`/`blocks` → `upstream_uncertainty` propagation is a working
  reference implementation of staleness propagation; compare Loomkin's
  7-node/7-edge schema against the overlay plan's four-typed DAG before
  building.
- **Steal auto-spawned verification gates for tier 1.** Verifiers that
  auto-spawn on task completion and block dependents are a mechanized
  version of this repo's verify-before-merge culture — a concrete design for
  the future daemon.
- **Keepers as a pattern, not a component.** Fidelity-preserving offload with
  access-frequency and staleness tracking is a runtime complement to thread
  docs, worth remembering if the brain ever holds working state.
- **The restraint lessons.** No custom DSL beyond Jido's shallow action
  macro (confirming the legibility budget), and confidence scores confined
  to working memory (sharpening *why* the bundle rejects them for durable
  knowledge: it is a horizon question).
- **What not to import:** the autonomy-first trust posture,
  database-resident provenance, and corpus-level confidence scoring — each
  the inverse of a deliberate, filed choice here.

**Recommendation.** Adopt nothing now; the tiered path and its triggers stand.
Record (here) the tier-2 buy/adopt option and re-read Loomkin's decision-graph
and verification-gate implementations when the epistemic-overlay plan or a
tier-1 daemon design is executed. Track the project loosely — its trajectory
over the next 6–12 months is itself evidence about Jido-stack viability, the
same seasoning argument the BEAM/Jido evaluation applied to Jido 2.

# Citations

- Loomkin repo — https://github.com/pass-agent/loomkin (MIT; ~77K LOC, 2,700+
  tests, ~179 stars; read 2026-07-14).
- Architecture — https://github.com/pass-agent/loomkin/blob/main/docs/architecture.md
  (decision graph node/edge types, confidence cascades, Keeper processes,
  Jido foundation quotes; read 2026-07-14).
- Language rationale — https://github.com/pass-agent/loomkin/blob/main/docs/why-elixir.md
  (processes, supervision, PubSub, hot code reloading, pattern-matching-not-macros;
  read 2026-07-14).
- Prior analyses this extends —
  [BEAM deployment and Jido 2 evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md) ·
  [managed minds, owned machinery](/meta/analysis/claude-managed-agents-vs-beam-jido.md) ·
  [Elixir AST/macro implications](/meta/analysis/elixir-ast-macros-for-llm-harnesses.md) ·
  [dark-factory epistemic base](/meta/analysis/dark-factory-epistemic-base-beam-jido.md) ·
  [second-mind taxonomy and the belief gap](/meta/analysis/second-mind-taxonomy-and-the-belief-gap.md) ·
  [advisor-harness build-vs-buy](/meta/analysis/when-to-roll-your-own-advisor-harness.md).
- Caveats: all Loomkin facts are from its own README/docs, not from running
  the system or reading its source — feature claims (e.g. "228K+ tokens
  preserved," "18x cost savings," "<500ms spawn") are the project's own,
  unverified; the project is young and single-org, so its shape may shift.
