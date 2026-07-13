---
type: doctrine
title: "Capability-matched model selection"
description: Match the model tier to the epistemic weight of the motion — concentrate the strongest models where output becomes canonical or a judgment is rendered, and delegate mechanical, derivational, and oracle-checked motions to cheaper tiers; selection is a runtime act enforceable only through its attribution shadow (provenance naming the producing model).
provenance: "Claude Code session, 2026-07-13 — raised by the operator as an open question on the three-level-documentation plan (should the plan instruct on model use?); resolved to the doctrine layer and ratified for filing in the same session"
attribution:
  when: 2026-07-13T14:29:00Z
  channel: agent-authored
  agent: "Claude Code agent, three-level documentation session"
  why: "operator resolved that model-use guidance is standing direction, filed as doctrine"
  from: [/meta/threads/2026-07-13-three-level-documentation-plan-and-model-doctrine.md, /meta/plans/three-level-documentation.md]
tags: [meta, doctrine, models, delegation, orchestration, agents]
timestamp: 2026-07-13
---

# Capability-matched model selection

This is a **standing direction** for how agents allocate model capability when
working on the brain: which model tier performs which motion. It is deliberately
doctrine, not policy — model selection happens at runtime and leaves no
committed artifact a verifier could gate, so it can only *inform judgment*, not
be mechanically enforced (see the enforceability note below). It is the
model-layer application of
[the engineer as orchestrator](/meta/doctrine/engineer-as-orchestrator.md):
orchestration includes allocating capability, and the scarce resource — strong-
model attention — is spent where judgment concentrates, exactly as the
operator's own attention is.

## The direction

**Match the model tier to the epistemic weight of the motion, not to habit or
availability.**

Concentrate the strongest available models where:

- **Output becomes canonical.** Writing or substantively revising a canonical
  body — a concept's technical tier, a policy, a doctrine, a plan's decisions —
  creates the source of truth other artifacts derive from. Errors here
  propagate.
- **A judgment is rendered.** Verification verdicts, routing and editorial
  calls, dedup decisions, design trade-offs, priority rankings — anything
  where the output *is* the judgment and there is no oracle behind it.
- **Errors are silent.** If nothing downstream would mechanically catch a
  mistake, the model is the last line of defense.

Delegate downward — to cheaper, faster tiers — where:

- **The motion is derivational.** The source of truth exists elsewhere and the
  task is to re-render it: regenerating a plain-tier block from its canonical
  body, index upkeep, format transforms, materialized views. A wrong
  derivation is recoverable by re-deriving.
- **A mechanical oracle exists.** CI gates, verifiers, or tests will catch a
  bad output (`mix brain.verify`, `--check` gates, the test suite). The oracle
  bears the correctness burden, so the producer need not.
- **The work is high-volume and low-stakes per item.** Bulk scans, candidate
  sweeps, extraction passes — breadth matters more than per-item depth, and a
  strong model reviews the aggregate.

Current model names (Fable, Opus, Sonnet, Haiku, and their successors) are
deliberately *not* bound to motions here: the mapping goes stale with every
model generation, while the principle — weight-matched allocation — survives
them all. An agent applies the direction against whatever tiers exist at run
time.

## Enforceability — and the attribution shadow

Selection itself **cannot be enforced**: it is a runtime act (a session's
model, a subagent spawn, a workflow stage) that the repository never records
as a checkable artifact. What the repository *does* record is **attribution**:
the `provenance` field on agent-authored documents already names the producing
model by convention, and commit trailers name the session's model. Attribution
is the enforceable shadow of selection — you cannot audit whether capability
was matched to a motion unless the artifact says which model performed it.

If this doctrine is to become auditable, the path is a thin **attribution
policy** (operator-ratified, like any contract rule): *agent-authored
governance and statement documents record the producing model in
`provenance`.* That rule is mechanically checkable in the way selection never
will be. Until and unless such a policy is ratified, this doctrine binds
agent judgment only — which is exactly what doctrine is for.

## What cites this

- The [three-level documentation plan](/meta/plans/three-level-documentation.md)
  — the originating context: plain-tier re-rendering is a derivational motion
  (delegate down); canonical-body writing and verification judgment stay with
  the strongest tier. Plans instruct on model use only by citing this
  direction, never by embedding their own model guidance — a plan finishes and
  its guidance gets buried; doctrine stands.
