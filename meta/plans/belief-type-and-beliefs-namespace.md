---
type: plan
title: "The belief layer: a `belief` type and a real /beliefs/ namespace"
description: Introduce a belief type for operator-held, value-laden decision priors — epistemic-teleological statements outside the verification ladder, citable by plans and analyses the way doctrine is — and make /beliefs/ its actual home; keep doctrine governance-scoped, extend the verifier to exclude belief from verified, and add the epistemic/teleological filing test to the vocabulary.
status: proposed
provenance: "Claude Code session (2026-07-13) — actionable residue of the second-mind taxonomy analysis, from an operator dialogue over a shared ChatGPT conversation seeded with this bundle's doctrine definition"
attribution:
  when: 2026-07-13T00:00:00Z
  channel: agent-authored
  agent: "Claude Code agent, second-mind taxonomy session"
  why: "persists the belief-type design per the persist-plans policy, so the ratification decision is made against a concrete shape"
  from: [/meta/analysis/second-mind-taxonomy-and-the-belief-gap.md, /meta/threads/2026-07-13-second-mind-taxonomy-analysis-and-belief-plan.md]
tags: [meta, plan, beliefs, doctrine, type-vocabulary, taxonomy, second-mind]
timestamp: 2026-07-13
---

# The belief layer: a `belief` type and a real /beliefs/ namespace

## Status & provenance

**Proposed** — not yet ratified. Adding a type to the controlled vocabulary and
changing what a namespace means are both shape changes the operator ratifies
(taxonomy-evolution protocol); this plan records the design so that decision is
made against something concrete. It is the actionable residue of
[Do the second-brain → second-mind taxonomies point anywhere this bundle should head?](/meta/analysis/second-mind-taxonomy-and-the-belief-gap.md),
which holds the full evidence and the rejected alternatives — read it first.

## Problem

Two defects, one root:

1. **The [`/beliefs/`](/beliefs/index.md) namespace holds no beliefs.** It
   contains the glossary and a scratch note. The name promises a layer of the
   brain that does not exist.
2. **Operator-held, value-laden decision priors have no type.** "Prefer depth
   and trust over maximum reach" is not a `claim` (it can never graduate off the
   verification ladder), not a `doctrine` (scoped to the brain's own design;
   governance namespace), and not a `note` (loses citability as a prior). The
   type vocabulary covers what is *true* (claim → concept) and what direction
   the *brain* serves (doctrine), but not what the *operator* holds
   true-enough-to-act-on about the world.

The gap matters because an agent exercising judgment on the operator's behalf
needs somewhere to look up those priors instead of imposing hidden assumptions
or asking every time (see the analysis, Finding 3).

## The shape of the change

1. **A new `belief` type** in the controlled vocabulary
   ([controlled-type-vocabulary](/meta/policy/controlled-type-vocabulary.md)):
   an operator-held, value-laden decision prior — a statement held *true enough
   to guide action* even where unverifiable, uncertain, or normative. Sits
   parallel to `doctrine`, not beneath it: a belief is epistemic-with-values
   ("I hold that the world works this way"), a doctrine is teleological ("this
   is the standing direction"). Distinct from a `claim` (which is on the
   verification ladder and expects evidence or graduation) and a `note` (not
   citable as a prior). Bundle concept: carries an `em:` id, lives in the
   identity registry, citable by plans, analyses, and priority rankings the way
   doctrine already is.
2. **`/beliefs/` becomes the belief layer's home.** Its index is rewritten to
   say so. Beliefs file directly under `/beliefs/` (subdirectories as volume
   demands, per the directory-hierarchy policy).
3. **Verifier exclusion.** `belief` stays *outside* the verification machinery:
   `mix brain.verify`'s statement-type rule (currently `claim`/`note`/`concept`)
   is left unchanged, so a `verified` field on a `belief` is rejected — the
   whole point of the type is that these statements are not settled by evidence.
   A belief that turns out to be empirically checkable should be refiled as a
   `claim` (and may then graduate); the type boundary *is* the test.
4. **The filing test, in prose.** Add one line to the vocabulary's `belief` and
   `doctrine` entries: *epistemic (what is true) files as claim/concept;
   value-laden prior (what I act as if is true) files as belief; teleological
   (what standing direction) files as doctrine.*
5. **Contract recompile.** The vocabulary edit is a policy change →
   `mix brain.contract` / `/render-contract` regenerates `CLAUDE.md`.

## Scope boundaries (explicitly out)

- **No `values` type.** The value a direction serves is legible inside the
  doctrine or belief that serves it (analysis, Finding 2).
- **No confidence scores on beliefs.** Unenforceable probabilities rot; a
  belief's standing is binary — held or retired/refiled.
- **No widening of `doctrine`.** It stays governance-scoped (`meta/doctrine/`,
  the brain's own design). Belief and doctrine are parallel layers; collapsing
  them would re-blur exactly the distinction that motivated this plan.
- **Glossary stays put.** `/beliefs/glossary/` is arguably mis-filed once
  `/beliefs/` means the belief layer, but moving it churns every glossary link
  and the `/add-to-glossary` skill for a naming nicety. Deferred (below).

## Build order

1. Ratify this plan (operator).
2. Edit `meta/policy/controlled-type-vocabulary.md`: add the `belief` entry and
   the filing test; recompile the contract.
3. Rewrite `/beliefs/index.md` to describe the belief layer (glossary and
   scratch note stay listed).
4. Seed the layer: intake 2–3 real operator priors as the first `belief`
   concepts, minting ids, so the type exists as instances rather than only as
   vocabulary.
5. Confirm `mix brain.verify` rejects `verified` on a `belief` (rule 6 already
   keys on the statement-type allowlist; add a regression test).

## Deferred

- **Relocating the glossary** out of `/beliefs/` (e.g. to a `vocabulary/`
  namespace) — a rename-scale change touching skills and many links; graduates
  to its own plan if the cohabitation proves confusing in practice.
- **Typed edges from beliefs** (e.g. a plan's frontmatter citing the belief ids
  it serves, mirroring `verified_by`) — belongs to the
  [epistemic overlay](/meta/plans/epistemic-overlay.md) design space, not here.
