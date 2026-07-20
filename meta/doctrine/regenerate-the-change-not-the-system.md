---
type: doctrine
title: "Regenerate the change, not the system"
description: The standing direction for how this brain's agents treat any rebuild of code or generated artifacts — a specification selects an equivalence class of programs rather than one program, so the unit of legitimate regeneration is the change and the existing artifact is a first-class input to it, never merely its disposable output; pinning properties is choosing what is allowed to vary, and stability is itself load-bearing.
provenance: "Claude Code session, 2026-07-20 — operator proposed treating code as a natural-language compilation target and, over three turns, stress-tested it into an equivalence-class frame"
tags: [meta, doctrine, direction, regeneration, llm-assisted-development, specs, invariants, equivalence-class, code-as-artifact]
timestamp: 2026-07-20
attribution:
  when: 2026-07-20
  channel: agent-authored
  agent: "Claude Code agent, in-session authoring"
  why: "authored at operator request (\"Yes, how should we divide all this?\") to persist the standing direction the session converged on"
---

# Regenerate the change, not the system

This is a **standing direction** — the *why* that should inform how this brain's
agents rebuild, regenerate, or re-derive any artifact, code included. It is not an
enforceable rule (that is a [`policy`](/meta/policy/index.md)); it is the intention
policies, plans, and tooling decisions serve. The reasoned judgment that produced
it — with the full for/against and the arguments that survive — is
[Code as a natural-language compilation target](/meta/analysis/code-as-natural-language-compilation-target.md);
this doctrine is the fixed direction, that analysis is its derivation.

## The direction

**A specification selects an equivalence class of programs, never one program.** A
description — a ticket, a prompt, a spec — does not name a single implementation.
It fences a whole family of programs that all satisfy it, the same way two
competent engineers hand the same ticket produce different, equally acceptable
code. What you aim at is the family, not any one member.

Four commitments follow, and they are the direction:

- **The unit of legitimate regeneration is the change, not the system.** Rebuilding
  a whole artifact from scratch to make one fix is not maintenance — it is
  replacement wearing maintenance's clothes. A human engineer perturbs the current
  artifact locally (a small step from where they are); a from-scratch rebuild is a
  random restart that discards all accumulated progress. Regenerate the delta.
- **The existing artifact is a first-class input to every regeneration, never just
  its output.** A living artifact is the physical store of every property people
  rely on but nobody wrote down — the mental models built around *this* code, the
  incidental behaviors downstream depends on, the bugs already found and fixed in
  the gaps. That store has value *as an artifact*, independent of the behavior it
  carries, and a rebuild that forgets it destroys it silently.
- **Pinning properties is choosing what is allowed to vary.** Tests, types, and
  invariants declare which properties are load-bearing; everything left unpinned is
  surrendered to the generator on every rebuild. The hard part of this style of
  development is not writing the spec — it is being honest about how much you
  actually care about, because everything you leave unstated, you agree to let
  change.
- **Stability is itself a load-bearing property.** "Behaves tomorrow as it did
  today, except where I deliberately changed it" is, for most live software, the
  single most important property there is — and the one property whole-system
  regeneration structurally cannot preserve, because a from-scratch rebuild has no
  memory of "today."

## What it commits the brain to

- **Deltas over replacements.** When an agent rebuilds anything here — code, or the
  brain's own artifacts — it works against the current artifact as a constraint, not
  by re-rolling from the source alone. This brain's *deterministic* regenerations
  (`CLAUDE.md` from policy, `meta/registry.md`, the route-tag logs) are safe to
  re-roll wholesale precisely because their source fully pins their output; code
  regeneration is not that kind of act and must not be treated as if it were.
- **Ratchet emergent properties into the pinned set.** Every time a regeneration
  changes something that turns out to matter, that is the *discovery* of a
  load-bearing property that was never stated. Capture it as a test or invariant so
  the pinned set converges toward completeness. Regeneration's own surprises are the
  forcing function that makes the next regeneration safer.
- **Keep the two operations distinct.** Choosing a member of the equivalence class
  (a fresh build) and swapping members under a running system (a rebuild) are
  different jobs. The first is licensed by the equivalence-class frame; the second
  is a replacement and must justify itself as one.

## Standing against this direction

The argument that produced this direction — including the point where the
"code is a disposable compilation target" thesis is *conceded* to weaken the longer
a system stays alive — is recorded in
[Code as a natural-language compilation target](/meta/analysis/code-as-natural-language-compilation-target.md).
That analysis is the derivation and the periodic reference; this doctrine is the
direction it points to.
