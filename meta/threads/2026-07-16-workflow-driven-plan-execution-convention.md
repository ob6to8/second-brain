---
type: reference
title: 2026-07-16-workflow-driven-plan-execution-convention
description: Investigated how to formalize the fresh-context plan execution plans already reach for informally into a convention over the environment's Workflow tool; drafted it first as a proposed plan, then reframed it (on operator redirect) to a decision-support analysis carrying the open questions.
provenance: "Claude Code session (claude-opus-4-8), 2026-07-16; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, orchestration, workflow, agents, execution, fresh-context]
timestamp: 2026-07-16
pr: 99
---

# 2026-07-16-workflow-driven-plan-execution-convention

## Where this landed

The operator asked to investigate and formalize a convention for executing
ratified plans via the environment's `Workflow` tool (`agent()`, `parallel()`,
`pipeline()`, `phase()`, worktree isolation) — the fresh-context subagent
execution plans in this bundle already reach for informally (the rename plan's
"workstream A/B", the epistemic overlay's "Thread A/B"), with no defined payload
or fold-back.

The investigation produced a four-part shape: a per-workstream `## Execution`
spec a plan carries; a standard minimal **Execution Context Payload** that is a
thin pointer packet into the plan on disk (`plan_ref`, `workstream_id`,
scope+reading-allowlist, deliverable, gate commands) rather than full session
history — viable because persist-plans already makes the plan outlive its
session; a pre-execution readiness gate that keeps the context-fit assertion
honest; and a fold-back triangle (plan-doc execution record / PR+commit graph /
narrated capture) reconciling the Workflow fan-out with `/capture`, which freezes
only the delivered message stream. Parallel writes must partition files and
regenerate shared derived surfaces once, serially, per the alignment analysis's
collision constraint.

It was first drafted as a `type: plan` (`status: proposed`) and presented for
ratification. The operator then redirected: persist it as a `type: analysis`
(a reasoned recommendation on the question, carrying the open questions) rather
than a plan of committed work. The write-up now lives at
[executing-ratified-plans-via-workflow-fan-out](/meta/analysis/executing-ratified-plans-via-workflow-fan-out.md);
the earlier plan doc and its plans-index entry were removed. The four open
questions (pilot choice, execution-record home, mandate-vs-recommend the
narration rule, worktree default) remain for the operator, who said they will
read the write-up and respond.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Convention for executing ratified plans via Workflow fresh-context fan-out (Execution spec, ECP, readiness gate, fold-back triangle, write-partition) | open | [executing-ratified-plans-via-workflow-fan-out](/meta/analysis/executing-ratified-plans-via-workflow-fan-out.md) | The four open questions in §6 (pilot choice, execution-record home, mandate vs. recommend, worktree default), and whether to graduate the analysis into a ratified plan → pilot → methodology |
| Genre of the write-up: proposed plan vs. decision-support analysis | closed | [executing-ratified-plans-via-workflow-fan-out](/meta/analysis/executing-ratified-plans-via-workflow-fan-out.md) | - |

## User

Investigate and formalize a convention for executing ratified plans via the
Workflow tool's fresh-context subagent primitives, in this elixir-mind OKF
repo (CLAUDE.md at repo root is the compiled operating contract — read it
first).

## Background

This repo's plans already reach informally for fresh-context execution, but
only as ad hoc prose promises with no defined mechanism. Evidence already in
the bundle:
- meta/plans/rename-second-brain-to-elixir-mind.md — split into "workstream
  A" and "workstream B," with "Phase 1 execution handed to a fresh session"
- meta/plans/epistemic-overlay.md — "Thread A (CB asset import) and Thread B
  (architecture sketch) to be launched from the plan's execution-path
  addendum"

Neither names a standard payload for what the fresh session needs to start
cold, nor a standard way the results fold back into the plan doc / PR /
session-capture flow.

Anthropic's own current guidance for Claude Code (see code.claude.com/docs/en/
sub-agents and code.claude.com/docs/en/best-practices) recommends exactly
this shape of work: isolate bounded units of execution into subagents with
fresh, minimal, task-scoped context (not the full session history), keep the
orchestrating session thin, and — for sustained or heavier parallelism than a
single orchestrator-plus-subagents setup handles well — compose independent
"agent team" workers rather than one orchestrator fielding many children
serially. This environment's `Workflow` tool (agent(), parallel(), pipeline(),
phase(), worktree isolation) is the concrete mechanism for this: a script can
fan a ratified plan's workstreams out to fresh-context agents in parallel,
verify each independently, and return synthesized results — without ever
loading the full deliberation history that produced the plan.

## What to do

1. Read meta/policy/persist-plans.md, meta/policy/session-capture.md,
   meta/policy/controlled-type-vocabulary.md (the methodology/plan/analysis
   type distinctions), and meta/plans/index.md's Accepted/In-progress
   section for real pending execution cases to pilot against.
2. Search the bundle (update-in-place policy: search before creating) for
   any existing methodology docs of a similar shape, to avoid duplicating
   an existing convention.
3. Design the convention: what a plan's execution phase needs to specify for
   it to become a Workflow script — scope boundaries per workstream, a
   minimal "execution context payload" each spawned agent receives instead
   of full session history, and how results fold back into the plan doc / PR
   / thread-capture flow (threads freeze at /capture time, so work out how a
   Workflow-driven execution reconciles with normal session capture).
   Consider whether a pre-execution check step — verifying a workstream is
   actually scoped to fit a fresh context before spawning executors — belongs
   in the convention.
4. Per the persist-plans policy, draft this as a `type: plan` doc under
   meta/plans/ (status: proposed) — not a methodology doc yet, since it's
   still a proposed change to how the brain operates and needs operator
   ratification first. Present it to the operator for ratification.
5. On ratification: implement the convention, and pilot it against one real
   pending case (the elixir-mind rename plan's Phase 1, or the
   epistemic-overlay plan's Thread A/B split, are both good candidates
   already sitting in meta/plans/index.md's Accepted/In-progress section).
   The durable, repeatable procedure that comes out of a successful pilot is
   what becomes a `type: methodology` doc (check the taxonomy for where
   methodology docs live — unlike policy/tutorial/plan/analysis, the
   vocabulary doesn't pin it to meta/, so this may belong in the regular
   knowledge tree; follow the taxonomy-evolution-protocol if a new directory
   seems warranted).
6. Update meta/plans/index.md as usual.

## Assistant

The verifier passes. The only warning on my plan — `attribution` lacks `from` — is expected and correct: `from` is stamped later by `/create-pull-request` once the thread doc exists (per the resource-attribution policy's append-only carve-out); my `from: []` is the right placeholder. The unrelated inbox warnings pre-date this change.

## Assistant

Done. The proposed plan is filed, the index updated, the bundle verifies, and the work is committed and pushed to `claude/workflow-execution-convention-0xkaek` so it survives environment reclamation. I stopped short of implementing — this is a change to the *shape* of the brain (a new execution convention, eventually a new methodology doc and directory), so per the operating contract it waits on your ratification.

## What I found

Your plans already reach for fresh-context execution, but only as prose promises:
- **rename → elixir-mind**: "workstream A / workstream B", "Phase 1 execution handed to a fresh session" — but never says what that session receives to start cold.
- **epistemic overlay**: "Thread A / Thread B, in order, with filed captures as the handoff" — and it even writes a reading allowlist ("Thread B does not open CB"), the closest existing instance of the payload I standardized — but still hand-launched, no readiness gate, no defined fold-back.

There's **one** existing methodology doc (the testing one), so no convention to duplicate. And the orchestrator-alignment analysis names the constraint any parallel fan-out must respect: concurrent branches collide on `index.md`/registry — "make collision-prone surfaces regenerable, regenerate once."

## The convention (proposed) — `meta/plans/workflow-driven-plan-execution.md`

Six decisions:

1. **`## Execution` section** = the executable spec. Per workstream: id, scope, **reading allowlist**, deliverable (+schema), verification (gate commands), isolation, depends-on. Good plans already gesture at all of this.
2. **Execution Context Payload** — the standard cold-start packet, and the key move: since the plan doc *already* outlives its session, the ECP is a **thin pointer packet into the plan on disk** (plan_ref, workstream_id, scope+allowlist, deliverable, gate commands), **not** deliberation history. `CLAUDE.md` loads automatically. Context-fit = executable from the plan text + the bundle it may read, nothing session-only.
3. **Pre-execution readiness gate** (you asked whether this belongs — yes): a cheap `agent()` phase returning `ready` | `underspecified(named gaps)`, catching exactly the "promised fresh-context execution without writing down what it needs" failure.
4. **Fold-back triangle** — reconciling with `/capture` freezing only the *delivered* stream: one thin orchestrating session is the session of record; the orchestrator **must narrate synthesized results in chat text** (else the tool-call work vanishes from the thread — the Workflow analogue of your "ask in chat, not the dialog box" rule); commits carry per-change provenance; the plan doc gets an **execution record** + status flip.
5. **Parallel writes partition files; shared derived surfaces (index, registry, contract, route-tag logs) regenerate once, serially** — honoring the alignment gap.
6. Lands as a **`type: methodology`** doc after a pilot (not a policy — doctrine already supplies the "why"; a verifier gate is deferred until the shape settles).

## What I need from you to proceed

The plan's open questions, with my recommendations:

1. **Pilot choice** — I recommend **three-level-documentation** (`accepted`, self-contained, reads only the bundle, already near-decomposed into workstreams — a clean test of Decision 5). The task suggested the rename Phase 1 (now `done` — merged, so only a retrospective example) or epistemic Thread A/B (more ambitious, but `proposed` and needs the CB repos attached — better as a *second* pilot).
2. **Execution-record home** — plan doc (recommended) vs thread doc.
3. **Narration rule (4.2)** — hard convention or strong recommendation? (No mechanical oracle either way.)
4. **Worktree default** — always for mutating workstreams, or only when ≥2 mutate in parallel?

**Do you ratify the convention as drafted?** And your call on the four questions — especially the pilot. On ratification I'll implement (readiness gate + fan-out skeleton), run the pilot end-to-end, and distill the successful run into the methodology doc under `knowledge/SWE/agentic/orchestration/`.

## User

/glossary "bounded units of execution"
Then will read plan and respond
Ok lets instead persist this an an alaysis along with the questions you raise, then commit and push

## Assistant

Done. Reframed and persisted as an analysis, committed, and pushed to `claude/workflow-execution-convention-0xkaek`.

**What changed:**
- **New:** `meta/analysis/executing-ratified-plans-via-workflow-fan-out.md` (`type: analysis`) — the investigation as a Question → Bottom line → findings → recommendation, with the four open questions in §6.
- **Removed:** the earlier `type: plan` doc and its `meta/plans/index.md` entry.
- **Listed** the analysis in `meta/analysis/index.md`.
- Bundle verifies clean (the one advisory `from` warning is stamped later by `/create-pull-request` once the thread doc exists).

The analysis keeps the full substance as a recommendation rather than committed work: the per-workstream `## Execution` spec, the **Execution Context Payload** (a thin pointer packet into the plan on disk — `plan_ref`, `workstream_id`, scope+allowlist, deliverable, gate commands — not session history, viable because persist-plans already makes the plan outlive its session), the **pre-execution readiness gate**, and the **fold-back triangle** (plan execution record / PR+commit graph / narrated capture) that reconciles the fan-out with `/capture` freezing only the delivered stream. It recommends adopting the shape via a ratified plan → one pilot (three-level-documentation) → a methodology doc.

The four open questions are in §6 for when you've read it: pilot choice, execution-record home, mandate-vs-recommend the narration rule, and worktree default. Go ahead and read it — I'll respond to your take.
