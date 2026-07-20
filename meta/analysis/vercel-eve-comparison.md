---
type: analysis
title: "Vercel eve and this bundle: the same substrate with figure and ground inverted"
description: A comparison of Vercel's eve agent framework (June 2026) against this bundle finding both converged on the same substrate — a directory of markdown files under git as the definition of an agentic system — with the figure and ground inverted (eve is an agent carrying knowledge as an accessory; this bundle is knowledge hiring agents as transient labor), yielding opposite meanings of durability (execution replay vs. epistemic record), opposite typing targets (tools vs. knowledge), opposite duplication stances (vendored copies vs. update-in-place), and opposite human-in-the-loop models (operational approval vs. constitutional ratification) — and locating the practical synergy in eve's host-layer shape, handed to the thin-Jido-host plan.
provenance: "Claude Code session, 2026-07-17 — operator asked to examine vercel.com/eve in the context of this repo (synergies, differences, philosophy, architecture), then drilled into skill scoping, skill duplication across agents, and tool registration vs. convention; eve facts verified against vercel.com docs/blog and the vercel/eve GitHub repo the same day"
tags: [meta, analysis, architecture, agents, eve, vercel, skills, tools, filesystem-native, okf, governance]
timestamp: 2026-07-17
attribution:
  when: 2026-07-17T20:00:00Z
  channel: agent-authored
  agent: "Claude Code agent, interactive session"
  why: "operator asked to persist the eve-vs-bundle comparison developed over the session as an analysis document"
  from: [/meta/threads/2026-07-17-vercel-eve-comparison-and-jido-host-plan.md]
---

# Vercel eve and this bundle: the same substrate with figure and ground inverted

**Question.** Vercel launched [eve](https://vercel.com/eve) (June 2026, Ship
London): an open-source, TypeScript-native agent framework where every agent is
a directory of files compiled to a durable service. How does it compare to this
bundle — philosophically and architecturally? Where are the synergies, where
the differences?

**Bottom line.** Eve and this bundle independently converged on the same
substrate — a directory of markdown files under git as the definition of an
agentic system — from opposite directions: Vercel from infrastructure ("make
agents deployable like web apps"), this repo from knowledge management ("make a
second brain operable by agents"). The figure and ground are inverted: eve is
an **agent** that carries knowledge as an accessory; this bundle is
**knowledge** that hires agents as transient labor. Every downstream divergence
— what "durable" means, what gets typed, how duplication is handled, what
human-in-the-loop gates — follows from that one inversion. The practical
residue is eve's *host-layer shape* (instructions + skills + tools + channels +
cron over a durable runtime), which maps onto this brain's missing owned
automation layer; that residue is committed as the
[thin Jido host plan](/meta/plans/thin-jido-brain-host.md).

## 1. What eve is (verified 2026-07-17)

Facts checked against the eve docs, launch blog, and GitHub repo (citations
below), recorded so a future session re-evaluates against a baseline:

- **An agent is a directory.** Everything under `agent/` is auto-discovered by
  name, validated, and compiled into a manifest served as a deployable app:
  `instructions.md` (the always-on system prompt), `agent.ts` (model config,
  resolved through AI Gateway), `tools/*.ts` (one typed tool per file; the
  filename becomes the tool name), `skills/*` (on-demand markdown procedures),
  `subagents/*` (child agents with narrower config and fresh history),
  `channels/*` (HTTP, Slack, cron entry points), `connections/*` (typed
  integrations keeping credentials out of the prompt and runtime),
  `sandbox/` (an isolated bash-style compute environment). Their pitch: "Like
  Next.js for web apps, but for agents" — the framework owns the plumbing the
  way Next.js owns routing, and "a file's name and place in the tree are its
  definition."
- **Sessions are durable by replay.** Sessions run on Vercel Workflows: an
  event log is persisted and deterministically replayed to reconstruct state,
  so a session survives cold starts, redeploys, and indefinite pauses.
  Completed tool calls are checkpointed and never re-run within a session.
- **Production concerns are defaults.** Sandboxed compute (ephemeral microVMs
  for model-generated commands), human-in-the-loop approvals
  (`needsApproval: always()/once()/predicate`) that park a run durably at
  `session.waiting` without consuming compute, OpenTelemetry tracing, built-in
  evals, and an Agent Runs dashboard.
- **Scale claim.** Vercel reports 100+ internal production agents on eve, and
  that agents now trigger more than half of commits on their platform (up from
  under 3% six months prior).

## 2. Where the philosophies genuinely converge

- **The tree is the definition.** Eve's founding claim is nearly a paraphrase
  of the [tree-is-the-taxonomy policy](/meta/policy/tree-is-the-taxonomy.md):
  both reject databases and config objects for a legible, git-native hierarchy
  where structure carries semantics.
- **Markdown as the agent-facing primitive.** Eve's `instructions.md` +
  `skills/` is structurally the same pattern as this repo's compiled
  `CLAUDE.md` + `.claude/skills/*/SKILL.md`: prose documents that program
  agent behavior, loaded progressively rather than stuffed into every prompt.
  Eve's docs state the rationale in this bundle's own terms: skills keep "the
  right context only when it is relevant" out of the always-on prompt.
- **Change ships through git.** Eve agents deploy via ordinary git + CI/CD;
  each capability is a one-file diff. Here, knowledge lands via PR under CI
  gates (`mix brain.verify`, `brain.route_tags`, `brain.contract --check`)
  with the commit graph as the provenance layer per the
  [merge-strategy policy](/meta/policy/merge-strategy.md). Both treat "review
  the diff" as the governance interface.
- **Compiled artifacts from source files.** Eve compiles a directory into a
  manifest and service; this repo compiles `CLAUDE.md` from `meta/policy/`,
  `meta/registry.md` from per-file ids, and the Pages site from the bundle —
  generated artifacts, never hand-edited, freshness-checked in CI.
- **Scheduled autonomy.** Eve's cron channel is the shape of this brain's
  daily `/research` Routine: an agent waking on a schedule to do bounded,
  attributed work.

## 3. Where they diverge — one inversion, five consequences

**The inversion.** In eve, the agent is the durable product and knowledge
exists to make the agent behave; the agent directory is the hermetic unit of
compilation and deployment. Here, the documents are the durable product and
agents are explicitly ephemeral — sessions are reclaimed, branches deleted,
and the [session-capture policy](/meta/policy/session-capture.md) exists
precisely because agent working memory is treated as disposable.

1. **Two meanings of "durable."** Eve's durability is *execution* durability:
   replayed event logs, parked sessions, exactly-once tool effects. This
   bundle has none and wants none; its durability is *epistemic* — `/capture`
   freezes sessions into verbatim thread docs,
   [stable `em:` ids](/meta/policy/stable-identity.md) survive refactors,
   `attribution` records the ingestion event immutably, and true-merge-only
   git keeps cited SHAs reachable. Eve remembers so the *process* can resume;
   this bundle remembers so the *record* can be read, cited, and verified.
2. **What gets typed.** Eve types execution — tools are schema-validated
   TypeScript — while its knowledge layer (skills) is untyped prose. This
   bundle is the mirror image: execution is untyped (whatever a session does),
   while knowledge is rigorously typed — the controlled `type` vocabulary,
   the frontmatter schema, `verified_by` evidence edges, all machine-enforced.
   Eve validates that a tool call is well-formed; this bundle validates that a
   claim is grounded.
3. **Human-in-the-loop: operational vs. constitutional.** Eve's HITL pauses an
   *action* until approved, then resumes. This bundle's HITL is the
   [taxonomy-evolution protocol](/meta/policy/taxonomy-evolution-protocol.md):
   the operator ratifies changes to the *shape* of the brain (new top-level
   directories, new types, new policies) while agents act autonomously within
   the ratified shape. Eve gates actions; the contract gates structure. Eve's
   broader governance story (Passport, credential vaults, OTel) is
   enterprise/security governance; this repo's (`meta/policy/`, doctrine above
   policy) is epistemic governance — a layer eve does not attempt.
4. **Fixed schema vs. emergent taxonomy.** Eve imposes its directory anatomy
   the way Next.js imposes routing — the opinionation is the product. Here the
   taxonomy is deliberately *not* imposed: it emerges bottom-up and evolves by
   ratification. Eve's tree describes a fixed anatomy; this tree is an
   open-ended ontology.
5. **Runtime coupling.** Eve is portable across models (any provider via AI
   Gateway) but coupled to its runtime (Vercel Functions, Workflows). This
   bundle is the opposite: coupled to no runtime — the contract is
   prompt-level, so any agent that can read `CLAUDE.md` can operate the brain
   — with the Elixir layer serving as verifier and compiler, never agent host.

## 4. Skill scoping and the duplication question

**Why eve scopes skills per agent, contextually.** Per agent because the
`agent/` directory is the compilation unit — there is no repo scope distinct
from agent scope; an eve repo *is* an agent (subagents are the only narrowing
mechanism). Contextually for context-window economics: descriptors are
advertised cheaply, bodies load on demand — the same progressive-disclosure
logic as this bundle's `index.md` hierarchy and skill system. Notably, eve
adopted the emerging cross-vendor SKILL.md convention (skills install via
`npx skills add <owner/repo>` from the [skills.sh](https://skills.sh) registry
and "work with 18+ AI agents including Claude Code") rather than inventing a
format — this repo's skills are already format-compatible with that ecosystem.

**Duplication across agents is managed npm-style, not solved.** Installing a
skill *copies* it into each agent's `agent/skills/`; there is no reference,
symlink, or shared-library mechanism, because the runtime only reads what is
physically under the hermetic `agent/` directory. Deduplication happens one
level up: the canonical copy is the upstream git repo, updates propagate by
re-install (pull, not push), and fleet drift is an operational discipline, not
a framework guarantee. The two systems take opposite positions for coherent
reasons: eve *accepts* copies (a deployed agent that cannot drift at runtime
is a feature — isolation), while this bundle *forbids* them (the
[update-in-place policy](/meta/policy/update-in-place.md) mandates one
document per subject, because a stale copy of knowledge is a bug, not an
isolation guarantee). Where derived copies must exist here (`CLAUDE.md`, the
registry, route-tag logs), they are generated and CI-checked against the
single source.

## 5. Tool registration: conventional definition, unconventional lifecycle

Eve's tool *definition* is the classic function-calling contract verbatim —
`description`, `inputSchema` (Zod), `execute(input, ctx)` — essentially the
Vercel AI SDK's `tool()` helper. The departures from convention sit around it:

- **Registration by filesystem convention, resolved at build time.**
  Conventionally the toolset is a property of runtime code (a `tools` array
  assembled per request, or an object wired into an agent constructor). In
  eve it is a property of the *directory*: any `agent/tools/*.ts` default
  export is discovered at build, the filename becomes the model-facing name,
  and the toolset is validated and frozen at deploy. Adding a capability is a
  one-file git diff with no wiring edits.
- **Exactly-once semantics per session.** Checkpointed tool results are never
  re-executed on replay — where a conventional loop has at-least-once
  semantics and re-fires non-idempotent side effects on retry.
- **Approvals as a declarative property** (`needsApproval`) rather than
  hand-built loop surgery, with parked runs consuming no compute.
- **Capability-scoped context injection.** `ctx` hands the tool the session,
  the sandbox, and skills, while `connections/` keeps credentials out of both
  prompt and tool code.

Against the other poles: MCP solves cross-process, runtime tool discovery for
many consumers where eve tools are in-process, build-time, single-agent
(hermetic, again). And Claude Code — this repo's actual host — sits at the
opposite extreme: a handful of generic tools (Bash, Read, Edit) of unbounded
power, governed *editorially* by prose contract with enforcement *after* the
act (verifier, CI, PR review), where eve narrows each capability into a typed,
individually approvable action with enforcement *before* it. Typed narrow
tools scale to fleets of unattended agents doing known operations; generic
tools plus a prose contract scale to open-ended work no schema anticipated —
which is why a knowledge bundle chose the latter shape.

## 6. Relation to the standing BEAM/Jido line, and the residue

This analysis joins the existing runtime-evaluation family without disturbing
its verdict. The [BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md)
established that this brain's runtime is elsewhere (Claude Code + CI) and
mapped a tiered future path;
[managed minds, owned machinery](/meta/analysis/claude-managed-agents-vs-beam-jido.md)
split agentic work into deliberative and mechanical planes meeting at an owned
write-gatekeeper; the [caveats analysis](/meta/analysis/jido-distribution-gap-and-req-llm-cognition-dependency.md)
priced Jido's single-node and `req_llm` concentrations; and
[Loomkin](/meta/analysis/loomkin-as-existence-proof.md) supplied a tier-2
buy/adopt existence proof. What eve adds to that family is a *shape*, not a
verdict change: a minimal, named anatomy for an owned host —
instructions + skills + tools + channels + cron over a durable runtime — that
is small enough to specify concretely. Eve itself is not that host (it would
re-rent the runtime from Vercel instead of Anthropic, and its hermetic
per-agent model contradicts the bundle-as-single-source), but its anatomy,
crossed with the standing Jido analyses, is committed as the
[thin Jido host plan](/meta/plans/thin-jido-brain-host.md) — including the
observation that two of the three standing blockers dissolve for a separate
sibling application.

# Citations

- eve product page — https://vercel.com/eve
- Introducing eve (launch blog) — https://vercel.com/blog/introducing-eve
- eve Concepts (docs) — https://vercel.com/docs/eve/concepts
- eve tools guide — https://vercel.com/kb/guide/how-to-add-eve-tools
- Agent Skills / skills CLI — https://vercel.com/docs/agent-resources/skills · https://skills.sh
- vercel/eve repo — https://github.com/vercel/eve
- Launch coverage — https://thenewstack.io/vercel-launches-eve-an-open-source-framework-that-treats-agents-as-directories/ · https://www.infoq.com/news/2026/06/vercel-eve-agents/ · https://www.theregister.com/devops/2026/06/19/vercel-debuts-eve-open-source-agent-framework-tries-to-fix-shadow-ai-with-passport/5258726
- Unconfirmed at research time: skills-CLI update/versioning mechanics beyond
  install (no lockfile/pinning documented); subagent skill inheritance;
  eve pricing.
