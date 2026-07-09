---
type: plan
title: "Epistemic overlay: the four operations as a frontmatter-native graph over concepts"
description: Promote the latent attestation/aggregation/inference/prescription structure already implicit in the type vocabulary to a first-class, queryable layer over existing concepts, with an integrity-checking mix brain.graph — while explicitly bounding out atomization and strength-as-count.
status: proposed
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-09 — derived from a comparison of this bundle against the Composable Beliefs repo"
tags: [meta, plan, epistemics, graph, knowledge-representation, composable-beliefs, edges]
timestamp: 2026-07-09
---

# Epistemic overlay: the four operations as a frontmatter-native graph over concepts

## Status & provenance

**Proposed** — not yet accepted. This plan records a design so a future session can
decide against something concrete. It came out of examining the operator's other repo,
[Composable Beliefs](https://github.com/composablebeliefs/composable-beliefs) (CB), and
noticing that this brain has been independently re-deriving CB's core substrate. It
builds directly on two decisions already made in this bundle:

- The **`methodology` type** ratification, and
- the link-model principle we settled on: **"type an edge only when a machine must
  traverse it; prose carries the semantics humans read, types carry the semantics
  machines act on."** That principle is the governor this plan must satisfy — and the
  discipline whose *absence* is the leading diagnosis for why CB became overwhelming.

## Motivation

This brain is currently a **mapped set of concepts**: a directory tree (the taxonomy)
plus untyped prose cross-links and one typed edge (`verified_by`, for evidence). CB
adds a layer this brain lacks: **four epistemic operations** — one per kind of
knowledge move — that decompose claims into a network of *conceptual dependencies*:

- **attestation** — what a single source says (grounded directly in a `source`).
- **aggregation** — what several dependencies jointly state (a merge over attestations).
- **inference** — a conclusion licensed to *exceed* its dependencies (a genuine leap).
- **prescription** — what should hold or be done (a directive).

The key observation: **this brain is already running a degenerate, unnamed version of
these four.** `source` ≈ attestation; `verified_by` aggregating captures ≈ aggregation;
a `claim`/`concept` grounded by evidence ≈ inference; `policy`/`methodology` ≈
prescription. This very session decomposed a design principle into "one prescription
grounded by two attestations" without naming the pattern. The epistemic layer is
**latent**, not foreign. This plan is about **promoting what is already implicit to
first-class and queryable** — not importing something alien.

What it buys:

- **Explorability across resources.** Walk "what grounds this?" / "what rests on this?"
  across the whole bundle — questions the directory tree cannot answer. The tree is one
  axis (topical taxonomy); the epistemic graph is an orthogonal axis (evidential
  structure).
- **Machine-checkable integrity.** Detect ungrounded inferences, and detect statements
  resting on premises that have since changed.

## Design — a frontmatter-native overlay (the load-bearing decision)

The single most important design commitment, and the line that separates "this brain
grows a spine" from "this brain becomes CB v2":

> **The overlay lives in the frontmatter of concepts that already exist. Each concept
> IS a node. There is no separate belief-node store.**

This preserves the crown-jewel simplification of this bundle — **the document is the
concept** — which CB gave up when it split JSON *beliefs* from OKF *artifacts*
(the "operations vs. artifacts" divide) and grew to ~400 atomized belief files.

Concretely:

1. **Epistemic role.** Each concept has one of the four roles. Prefer to **derive** it
   from the existing `type` where possible (`source` → attestation; a `verified`
   `concept`/`claim` → inference; `policy`/`methodology` → prescription; a synthesis
   over several → aggregation) rather than hand-maintain a parallel field. If derivation
   is too lossy, add exactly one orthogonal frontmatter key (`epistemic:`) and nothing
   else. **Open question — see below.**
2. **Typed dependency edges.** Generalize the evidence edge into grounding edges: a
   concept declares the ids it stands on. Keep `verified_by` semantics as the special
   case (evidence for a `verified: true` statement) so nothing already built is lost.
   **Open question:** widen `verified_by`, or add a broader `deps`/`grounds` beside it.
3. **One new read-only tool — `mix brain.graph`.** *This tool is the machine consumer
   that earns the typed edge under our own rule.* Until it exists, these edges stay
   prose. It does two things:
   - **Explorability:** walk deps up/down from any id; list all inferences resting on a
     given source; show a concept's grounding subtree.
   - **Integrity floor (pure, CI-gateable):** flag any `inference` that does not resolve
     to at least one live `attestation`; flag any concept whose deps point at a
     superseded/missing node. Boolean pass/fail, in the spirit of `mix brain.verify`.

## Scope boundaries (what this plan deliberately excludes)

These are the exact places CB's generality outran a committed purpose. Excluding them is
the point, not an oversight:

- **No atomization.** Concepts are not decomposed into sub-claim nodes in a separate
  store. The pull toward atomization will be constant and each step will feel justified;
  that pull is what made CB bottomless. Hold the line at concept-granularity.
- **No strength-as-count.** "Strength = number of connections" is out. Edge count
  measures *how much has been written*, not *how true* — it rewards verbosity and is
  trivially gamed. (CB itself refused confidence scores for this reason.) Structural
  signals are **observed, not optimized** (cf. matklad's *extent*): expose in/out-degree
  in `mix brain.graph` output explicitly **labeled as not a truth score.** Distinguish
  the two edge directions — out-edges → sources = *groundedness*; in-edges ← dependents
  = *importance / blast-radius* (a staleness signal, not a strength one). Integrity is a
  **floor predicate**, never a scalar ranking.
- **No contracts / eval rigor / codepath.** CB's `rules[]`/`invariants[]` interpreters,
  run-manifest ingest, cross-ruler/3-run machinery, and code-anchored tours serve CB's
  *other* purposes (eval-audit, agent-identity). Out of scope unless a purpose is
  committed that demands them.
- **No second `kind` axis.** Keep the single `type` vocabulary. CB's open `kind` field
  sprawled to 40+ values (many singletons) — a junk drawer to avoid.

## Machine-checkable property (precise statement)

The value delivered is **explorability + an integrity floor**, not a score:

- *Groundedness (integrity):* every `inference` resolves transitively to ≥1 `attestation`
  that itself resolves to a real, non-superseded `source`. Fail → named ids, like
  `mix brain.verify`.
- *Freshness (staleness):* no active concept depends on a superseded/retracted node
  without acknowledging it. (Requires supersession — see dependency below.)
- *Structure (observed only):* degree/centrality surfaced for navigation, never enforced,
  never called "strength" or "confidence."

## Dependencies & interactions

- **Supersession-instead-of-edit.** Staleness propagation needs a supersession chain
  (CB's `superseded_by`), but this bundle currently **edits in place** (the
  update-in-place policy). This is the one genuine gap versus CB and likely a
  prerequisite for the freshness check. Sequence it first, or scope the initial overlay
  to groundedness only.
- **Registry / `verified_by`.** Widening edges must not break `mix brain.verify`'s
  grounding rules or the `verified: true` ⇒ non-empty-evidence invariant.
- **Route tags / ledger.** The routing ledger is already an id-referencing edge set;
  check whether it should feed the same graph view rather than a parallel one.

## Open questions (for the operator / next session)

1. **Derive role from `type`, or add an `epistemic:` field?** Derivation keeps the
   surface minimal but may be lossy where `type` and epistemic role diverge.
2. **Widen `verified_by`, or add a separate `deps`/`grounds` edge?** One edge with modes,
   or two edges with distinct semantics.
3. **Is supersession a prerequisite, or can v1 ship groundedness-only** and defer
   freshness until supersession lands?
4. **Granularity guarantee.** How do we *encode* the "no atomization" boundary so a
   future session doesn't drift across it one reasonable step at a time — a policy, a
   verifier check, or just this plan?

## Suggested first slice (if accepted)

1. Decide Q1/Q2 (role + edge representation) — smallest viable frontmatter change.
2. Backfill deps on a handful of already-grounded concepts (the testing methodology and
   its two references are a ready-made worked example: prescription ← two attestations).
3. Ship `mix brain.graph` read-only: explorability walk + groundedness floor. No
   supersession, no staleness, no scores.
4. Evaluate whether it earns its keep before widening.

# Citations

- Comparison basis: [Composable Beliefs](https://github.com/composablebeliefs/composable-beliefs)
  (`okf/standard/types.md`; the four structural types; `docs/composable-beliefs-thesis.md`).
- Prior in-bundle decisions this builds on: the `methodology` type ratification and the
  "type an edge only when a machine must traverse it" link-model principle (see the
  `stable-identity` and `filenames-and-cross-linking` policies).
