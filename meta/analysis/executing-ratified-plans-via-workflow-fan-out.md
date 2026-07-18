---
type: analysis
title: "How should ratified plans be executed via the Workflow tool's fresh-context subagents?"
description: Investigates how to formalize the fresh-context execution that plans already reach for informally (rename "workstream A/B", epistemic "Thread A/B") into a repeatable convention over the environment's Workflow tool — recommending a per-workstream `## Execution` spec, a standard minimal Execution Context Payload (a thin pointer packet into the plan on disk, not full session history), a pre-execution readiness gate, and a fold-back triangle reconciling Workflow fan-out with /capture freezing only the delivered stream; closes with the open questions ratification must settle.
provenance: "Claude Code session (claude-opus-4-8), 2026-07-15 — operator asked to investigate and formalize a convention for executing ratified plans via the Workflow tool's fresh-context subagent primitives, then redirected the write-up from a proposed plan to an analysis (a reasoned recommendation on the question) carrying the open questions"
attribution:
  when: 2026-07-15T14:21:49Z
  channel: agent-authored
  agent: "Claude Code agent, workflow-execution-convention session"
  why: "persists the investigation and recommendation on Workflow-driven plan execution as a decision-support analysis, per the operator's redirect"
  from: [/meta/threads/2026-07-16-workflow-driven-plan-execution-convention.md]
tags: [meta, analysis, orchestration, workflow, agents, execution, fresh-context, delegation]
timestamp: 2026-07-15
---

# How should ratified plans be executed via the Workflow tool's fresh-context subagents?

**Question.** This bundle's plans already reach for fresh-context execution —
handing bounded units of work to a fresh session rather than carrying the full
deliberation history — but only as ad hoc prose promises with no defined
mechanism. The environment's `Workflow` tool (`agent()`, `parallel()`,
`pipeline()`, `phase()`, worktree isolation) is a concrete primitive for exactly
this shape of work. What convention would turn a ratified plan's workstreams
into a Workflow fan-out: what must a plan specify, what minimal payload does each
spawned agent need to start cold, and how do results fold back into the plan
doc, the PR, and the session-capture flow?

**Bottom line.** A workable convention has four load-bearing parts, and each
rests on an invariant this bundle already holds. (1) A plan carries a
per-workstream **`## Execution` spec** — it formalizes boundaries good plans
already gesture at. (2) Each spawned agent receives a small, uniform **Execution
Context Payload (ECP)** that is *a thin pointer packet into the plan on disk*,
not a re-transcription of session history — this works because persist-plans
already guarantees the plan outlives its session. (3) A **pre-execution
readiness gate** keeps the payload's context-fit assertion honest, catching the
exact failure the informal plans risk: promising fresh-context execution without
writing down what the fresh context needs. (4) A **fold-back triangle** —
plan-doc execution record, PR/commit graph, narrated capture — reconciles the
fan-out with `/capture`, which freezes only the delivered message stream and
strips the tool calls a Workflow runs inside. Parallel *writes* must additionally
partition files and regenerate shared derived surfaces once, serially, per the
[orchestrator-alignment analysis](/meta/analysis/alignment-with-the-orchestrator-role.md)'s
collision constraint. The recommendation is to adopt this shape; the path to
adoption is a ratified plan → one pilot → a `type: methodology` doc.

## 1. The gap — plans already reach for this, informally

- [rename second-brain → elixir-mind](/meta/plans/rename-second-brain-to-elixir-mind.md)
  splits the lift into "workstream A" and "workstream B" with "Phase 1 execution
  handed to a fresh session" — but never says what that fresh session receives to
  start cold.
- [epistemic overlay](/meta/plans/epistemic-overlay.md) defines "Thread A (CB
  asset import) and Thread B (architecture sketch), in order, with filed captures
  as the handoff artifact" and even writes a per-thread reading allowlist
  ("Thread B does not open CB") — the closest existing instance of the payload
  this analysis standardizes — but each thread is still hand-launched prose, with
  no mechanical fan-out, no readiness gate, and no defined reconciliation back
  into the plan/PR/capture flow.

Neither names **a standard payload** for a cold start, nor **a standard
fold-back**. The convention supplies both.

## 2. The mechanism, and the doctrine that points here

Fresh-context subagent execution is the model-and-tooling application of two
ratified directions this bundle already holds:

- [The engineer as orchestrator, not implementer](/meta/doctrine/engineer-as-orchestrator.md)
  — "agent coordination over hand-implementation"; the orchestrator's binding
  constraint is *judgment-context across many delegated matters*.
- [Capability-matched model selection](/meta/doctrine/capability-matched-model-selection.md)
  — allocate capability by the epistemic weight of the motion; delegate
  mechanical / derivational / oracle-checked motions downward.

It is also what Anthropic's current Claude Code guidance recommends: isolate
bounded units of execution into subagents with fresh, minimal, task-scoped
context — not the full session history — keep the orchestrating session thin,
and compose independent workers for parallelism heavier than one orchestrator
handles serially. The `Workflow` tool is the concrete substrate: a script can
fan a ratified plan's workstreams out to fresh-context agents, verify each
independently, and return synthesized results without ever loading the
deliberation history that produced the plan.

## 3. Recommended shape

### 3.1 The `## Execution` section — a plan's executable spec

An accepted plan opts into Workflow execution by carrying an `## Execution`
section: an **execution order** (independent workstreams → `parallel()`, chained
→ `pipeline()`, strictly ordered → sequential) plus, per workstream, a spec:

| Field | Holds | Why it's needed |
|-------|-------|-----------------|
| **id / label** | short slug, e.g. `workstream-A` | names the `agent()` label and the execution-record row |
| **scope** | the in/out boundary — what this workstream changes and must not touch | plans already write this; it becomes the agent's mandate |
| **reading allowlist** | what the fresh agent may read (bundle paths, plan sections, attached repos) — and must *not* open | context-fit; the epistemic overlay's "Thread B does not open CB" made this a `type` distinction — here it is a first-class field |
| **deliverable** | what the agent produces and returns — structured (schema) when it folds back mechanically, else synthesized prose | the Workflow `agent(..., {schema})` contract; defines fold-back shape |
| **verification** | gate commands / residue checks the agent runs to self-certify before returning | delegates the correctness burden to a mechanical oracle per capability-matched doctrine |
| **isolation** | `read-only` (mutates nothing) or `mutates-files` (needs `isolation: 'worktree'`) | decides worktree cost and the §3.5 write-partition |
| **depends-on** | ids of workstreams that must complete first | maps to `parallel` vs `pipeline` vs sequential |

A plan naming workstreams in prose is *retrofitted* by lifting the boundaries it
already states into the table — the section formalizes what good plans gesture
at; it adds no new planning burden.

### 3.2 The Execution Context Payload — the standard cold-start packet

The core question is *what a fresh session needs to start cold*. The answer rests
on an existing invariant: **the plan doc already survives its session** (that is
the whole point of persist-plans). So the ECP is not a re-transcription of
deliberation history — it is a **thin pointer packet into the plan on disk**.
Every spawned `agent()` receives exactly:

1. **`plan_ref`** — the bundle path to the plan doc (present in the checkout /
   worktree the agent runs in).
2. **`workstream_id`** — which workstream spec (§3.1) to execute.
3. **scope + reading allowlist** — lifted from the spec as hard bounds.
4. **deliverable contract** — what to return, with the `schema` when structured.
5. **verification commands** — the gate/residue checks to run before returning.

Deliberately **excluded**: the deliberation thread, chat history, the reasoning
that produced the plan, and sibling workstreams' internal work. `CLAUDE.md` is
*not* in the payload — it loads automatically because the agent runs inside the
repo. The **context-fit assertion** is precisely that a workstream is executable
from *the plan text plus the bundle it is allowed to read* — nothing session-only.
This keeps the ECP small, uniform, and auditable: five fields, all derivable from
the `## Execution` section, no free-form context dump.

### 3.3 A pre-execution readiness gate before any executor spawns

A pre-execution check belongs in the convention — it keeps the ECP's context-fit
assertion honest and catches the exact failure the two informal plans risk. It is
a cheap first phase (one `agent()`, or the orchestrator itself) reading only the
plan's `## Execution` section and returning a **structured readiness verdict per
workstream**:

- plan `status` is `accepted`/`in-progress` (never execute a `proposed` plan);
- each workstream names all seven spec fields;
- **context-fit** (the judgment call): executable from `plan_ref` + its reading
  allowlist alone, or does it smuggle a dependency on session-only knowledge?
  Flag underspecified workstreams with the missing piece named;
- **isolation sanity**: any `mutates-files` workstream declares its file
  partition (§3.5); no two parallel workstreams claim the same files or the same
  derived surface.

`ready` → fan out. `underspecified` → the orchestrator stops and reports the gaps
for a plan edit, rather than spawning executors that improvise. This is the
readiness gate as a Workflow `phase()`, in the spirit of `mix brain.verify`: a
boolean floor before the expensive work, not a score.

### 3.4 Fold-back — the orchestrating session is the single session of record

This is the subtle reconciliation: **threads freeze at `/capture` time**, and
`/capture` renders only the *delivered* `## User` / `## Assistant` stream — it
strips tool calls and reasoning. A Workflow runs *inside a tool call*, so its
subagents' internal work never enters the delivered stream. Three rules resolve
this without breaking any existing policy:

1. **One thin orchestrating session, captured normally.** The Workflow runs
   inside one orchestrating session; that session is what `/capture` freezes and
   what `/create-pull-request` ships as one PR + one thread doc, with the usual
   routing ledger and route tags. Subagents do **not** produce their own thread
   docs — they have no delivered stream to capture.
2. **The orchestrator must narrate the synthesized results in delivered chat
   text.** Because `/capture` strips the tool calls the Workflow ran in, an
   execution that is *only* tool calls vanishes from the thread doc. So after the
   Workflow returns, the orchestrator reports each workstream's synthesized result
   and verification verdict as ordinary `## Assistant` text — that narration is
   what capture retains verbatim. (This is the Workflow analogue of the existing
   "ask the operator in the chat, not the dialog box" rule: only the delivered
   stream is captured.)
3. **Commits carry per-change provenance; the plan doc carries the execution
   record.** The thread narrates the *synthesis*; the **commit graph** records the
   *actual changes*, and via true-merge into `main` (never squash/rebase, per the
   merge-strategy policy) those commits stay reachable with the orchestrating
   session's trailer. On completion the orchestrator appends an **execution
   record** to the plan doc — which workstreams ran, the Workflow `runId` and
   persisted script path, the verification verdicts, and the resulting PR — and
   flips `status`. This mirrors how the rename plan already records "Both PRs
   merged 2026-07-14." The three surfaces are orthogonal: **plan doc** = how it
   executed + status; **PR/commits** = the changes + provenance; **thread doc** =
   the narrated synthesis.

### 3.5 Parallel writes — partition files; regenerate shared surfaces once

The [orchestrator-alignment analysis](/meta/analysis/alignment-with-the-orchestrator-role.md)'s
gap 3 is load-bearing: this bundle's collision-prone surfaces — `index.md` files,
`meta/registry.md`, `CLAUDE.md`, the materialized route-tag logs — are shared
derived artifacts that parallel writers corrupt. Worktree isolation (see
[git worktrees for parallel agents](/knowledge/SWE/version-control/git/git-worktrees-for-parallel-agents.md))
turns silent overwrites into merge-time conflicts, but the cleaner discipline
avoids the conflict:

- **Read-only / spec / analysis workstreams** (e.g. the epistemic overlay's
  Thread A captures and Thread B sketch) return synthesized content; the
  **orchestrator writes and commits it** in the main session. No worktree needed.
- **Independent file-mutating workstreams** run with `isolation: 'worktree'` and
  must claim **disjoint file sets** — enforced by the readiness gate's
  isolation-sanity check.
- **Shared derived surfaces are never regenerated in parallel.** Index upkeep,
  `mix brain.registry`, `mix brain.contract`, and
  `mix brain.route_tags --materialize` run **once, serially, in a final
  integration phase** by the orchestrator — exactly the "make collision-prone
  surfaces regenerable, regenerate once" palliative the analysis prescribes.
  Regeneration is a derivational motion (delegate-down per capability-matched
  doctrine); the correctness oracle is the `--check` gate suite.

## 4. Scope boundaries the recommendation draws

- **No new policy or verifier gate — yet.** The convention should land as a
  `type: methodology` doc (the repeatable how-to), not a machine-enforced policy.
  Whether a thin policy later *requires* accepted plans to carry a well-formed
  `## Execution` section — and whether `mix brain.verify` grows a check for it —
  is best deferred until a pilot shows the section shape is stable and worth
  gating. Doctrine already supplies the "why"; a premature policy would gate a
  shape still in flux.
- **No autonomous execution of unratified plans.** The gate refuses any plan not
  `accepted`/`in-progress`. This is about *executing* ratified decisions, never
  *making* them — ratification stays the operator's, per the preamble's role split.
- **No cross-session parallelism beyond one orchestrator's Workflow.** The unit is
  one orchestrating session running one Workflow. Coordinating multiple
  independent *orchestrator* sessions (the "agent team" scale, the librarian
  write-broker of the
  [dark-factory analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md))
  stays out of scope — this is the near-term, single-orchestrator step toward the
  alignment analysis's parallel-coordination goal, not the end state.
- **No committing of generated Workflow scripts as bundle documents.** The script
  is an ephemeral execution artifact; its persisted path and `runId` are recorded
  in the plan's execution record for reproducibility, but it is not filed as a
  `type` document. The plan's `## Execution` section is the durable spec; the
  script is regenerated from it.

## 5. Path to adoption

This analysis recommends adopting the shape above. Because it changes how the
brain operates — a new repeatable execution mode and, eventually, a new
methodology doc and directory — the next steps follow the persist-plans and
taxonomy-evolution disciplines, not a direct build:

1. **A ratified `type: plan`** capturing this shape as intended work (this
   analysis is the decision-support behind it) — flipped to `accepted` on
   operator ratification.
2. **Implement** the readiness-gate `agent()` (prompt + readiness-verdict schema)
   and the fan-out Workflow skeleton (reads a plan's `## Execution` section, runs
   the readiness phase, fans workstreams out with per-workstream ECPs, returns
   synthesized results for the orchestrator to fold back).
3. **Pilot** against one real pending case, end to end (readiness gate → fan-out →
   fold-back). Recommended pilot:
   **[three-level documentation](/meta/plans/three-level-documentation.md)**
   (`accepted`, self-contained, reads only this bundle, already decomposed into
   near-independent workstreams with an explicit gate suite — a clean test of the
   §3.5 write-partition). The
   [epistemic overlay](/meta/plans/epistemic-overlay.md) Thread A/B is the more
   ambitious pilot (it best exercises the reading-allowlist field) but is
   `proposed`, not `accepted`, and Thread A needs the Composable Beliefs repos
   attached — better as a second pilot. The
   [rename plan](/meta/plans/rename-second-brain-to-elixir-mind.md)'s Phase 1,
   named in the originating request, is now `done` (both PRs merged) — a
   retrospective illustration, no longer a live pilot.
4. **Distill** the successful run into a `type: methodology` doc. Placement, per
   the taxonomy-evolution protocol: `methodology` is not pinned to `meta/`, and
   the one existing methodology
   ([testing methodology](/knowledge/SWE/testing/elixir-mind-testing-methodology.md))
   lives in the knowledge tree. This one is about orchestrating *this brain's*
   plan execution via the Workflow tool, so it fits the established
   `knowledge/SWE/agentic/` domain — most likely a new
   `knowledge/SWE/agentic/orchestration/` subdirectory (autonomous: a subdir under
   an already-established top-level domain; its `index.md` added on creation).

## 6. Open questions (for the operator / a ratifying plan)

1. **Pilot choice** — three-level-documentation (recommended, self-contained) or
   epistemic Thread A/B (more ambitious, needs CB attached and the overlay plan
   accepted first)?
2. **Execution-record home** — append the record to the plan doc (recommended,
   keeps how-it-executed with the decision) or to the thread doc? The plan
   outlives the branch and already carries status; the thread records the PR.
3. **Mandate vs. recommend** — is the orchestrator-narration rule (§3.4.2) a hard
   convention or a strong recommendation? It has no mechanical oracle (like
   route-tag coverage), so enforcement is editorial either way; the question is
   how firmly the methodology states it.
4. **Worktree default** — default file-mutating workstreams to
   `isolation: 'worktree'` always, or only when two or more mutate in parallel?
   Worktrees cost setup + disk; a single mutating workstream in an otherwise
   read-only fan-out may not need one.
