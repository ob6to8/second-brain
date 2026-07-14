---
type: plan
title: "A /council skill: adversarial draft-PR review, gated on disposition"
description: Build a /council skill implementing the operator-supplied council-round protocol (structured, adversarial, multi-agent review run as draft-PR comments through open/review/respond/close motions, gated on every finding receiving a disposition) after four bindings reconcile it with this bundle's existing policies. Accepted, execution deferred.
status: accepted
provenance: "Claude Code session, 2026-07-13 — operator pasted the council-round protocol and asked for a suitability evaluation; ratified the analysis's integrate verdict into this plan the same session, deferring execution"
attribution:
  when: 2026-07-13T22:30:00Z
  channel: agent-authored
  agent: "Claude Code agent, council-round suitability session"
  why: "persists the ratified integrate-as-skill decision per the persist-plans policy, so the four bindings and build order survive the session that worked them out"
  from: [/meta/analysis/council-round-suitability.md, /meta/threads/2026-07-13-council-round-suitability-evaluation.md]
tags: [meta, plan, council, review, adversarial, pr-workflow, skills]
timestamp: 2026-07-13
---

# A /council skill: adversarial draft-PR review, gated on disposition

## Problem

The bundle has no defined gate between *work drafted* (committed to a branch)
and *work merged* — PRs land on operator say-so with no structured review
record. The operator supplied a protocol for exactly this gate: a **council
round**, run as adversarial reviewer subagents posting ID'd findings on a
[draft pull request](/beliefs/glossary/draft-pull-request.md), the author
replying to each with a [disposition](/beliefs/glossary/disposition.md)
(agree/refute/defer), and a close motion that refuses to converge while any
finding lacks one.

[council-round-suitability](/meta/analysis/council-round-suitability.md)
evaluated the protocol against this bundle's operating contract and
recommended integration — the protocol composes with machinery already here
(the merge-strategy policy's SHA-reachability guarantee is exactly what its
cite-by-commit-SHA provenance rule depends on; its hand-off artifact is what
[persist-plans](/meta/policy/persist-plans.md) already mandates) — conditional
on four bindings that reconcile it with policies it wasn't written against.
This plan ratifies that verdict and records the bindings as the build spec;
**execution is deferred** to a later session.

## Decision

Build `.claude/skills/council/SKILL.md`, with the protocol's four motions
(open/review/respond/close) implemented against this bundle's four required
bindings:

1. **Narrow the no-transcripts rule, don't weaken session-capture.** The
   protocol's "session notes, transcripts, and review dumps do not get
   committed" collides with `/create-pull-request` running `/capture`
   unconditionally. Resolution: the council rule targets *review dumps as
   pseudo-plans*, not thread docs — a captured thread is a noise-stripped
   record (session-capture policy), and reviewer-subagent findings arrive as
   tool results, which `/capture` drops anyway. `/council` does not disable or
   special-case `/capture`.
2. **Bind the distillation target.** The protocol's `<FILL IN>` distillation
   target is a `type: plan` doc under `meta/plans/` — created or updated by
   the close motion, carrying the dated "rejected: X because Y" block for
   refuted/superseded alternatives. Deferrals from the respond motion file as
   `issue` or `todo` per their existing types. No new type is needed.
3. **Reconcile with the PR machinery.** The open motion's draft-PR creation
   needs the same invocation-is-authorization clause as
   [`/create-pull-request`](/.claude/skills/create-pull-request/SKILL.md) —
   running `/council` *is* the operator's yes to open the chamber PR. Position
   `/council` as the heavy, converging gate for **shape-of-brain changes**
   (policy edits, new machinery, plans, genre changes); routine content diffs
   keep the lighter `/code-review`/`/review`. The council chamber PR is the
   same PR that ships: close the round, then run the ordinary ship path
   (capture, glossary, mark ready-for-review), then merge with a
   [true merge](/beliefs/glossary/true-merge.md).
4. **Land as a ratified contract change.** New skill file, a
   [skills-registry](/meta/policy/skills-registry.md) policy edit listing it,
   and a `/render-contract` recompile. This plan is that ratification, per the
   propose-and-ratify posture in the
   [taxonomy-evolution protocol](/meta/policy/taxonomy-evolution-protocol.md).

## Build order (deferred — none of this is shipped yet)

1. Write `.claude/skills/council/SKILL.md` with the four motions and the four
   bindings above baked in directly (not left as external caveats).
2. Edit the skills-registry policy to list `/council`; run `/render-contract`
   to recompile `CLAUDE.md`.
3. Run one **hand-run** round (per the protocol's own provenance rule, labelled
   as such in the closing comment) on a real branch as the founding example —
   ideally the next shape-of-brain change large enough to warrant one.
4. Only after a hand-run round proves the disposition gate out, consider a
   `mix brain.council`-style verifier: the gate is mechanizable (finding IDs
   are enumerable, unlike route-tag coverage) but not required for v1.

## Scope boundaries

- Not a replacement for `/code-review` or `/review` — those stay the default
  for ordinary diffs; `/council` is reserved for changes to the brain's own
  shape or machinery.
- Not building the mechanical disposition-gate verifier in this pass — step 4
  above is explicitly a later trigger, not part of this plan's execution.
- The evaluated prompt and full reasoning stay in
  [council-round-suitability](/meta/analysis/council-round-suitability.md);
  this plan does not restate them, only the build spec extracted from the
  ratified verdict.
