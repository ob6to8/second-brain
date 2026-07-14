---
type: plan
title: "Epistemic overlay: the four operations as a frontmatter-native graph over concepts"
description: Promote the latent attestation/aggregation/inference/prescription structure already implicit in the type vocabulary to a first-class, queryable layer over existing concepts, with an integrity-checking mix brain.graph — while explicitly bounding out atomization and strength-as-count.
status: proposed
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-09 — derived from a comparison of this bundle against the Composable Beliefs repo"
tags: [meta, plan, epistemics, graph, knowledge-representation, composable-beliefs, edges]
timestamp: 2026-07-13
attribution:
  when: 2026-07-09T18:59:03+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-09-testing-methodology-types-and-cb-epistemic-overlay.md, /meta/threads/2026-07-13-epistemic-overlay-reconciliation.md]
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

## Addendum — stabilization reframing (2026-07-10)

A follow-on evaluation,
[CB's overlay as a failure-chain stabilizer](/meta/analysis/cb-epistemic-overlay-as-failure-chain-stabilizer.md),
re-examined CB against the five-stage 500+ failure chain
([field-comparison analysis](/meta/analysis/comparison-with-the-2026-second-brain-field.md))
and feeds three updates into this plan, still `proposed`:

1. **Motivation upgrade.** The overlay's primary value is not
   explorability-plus-integrity but *stabilization*: it mechanically covers stage 3
   (cross-reference drift — supersede an attestation and the affected set is the
   transitive closure of dependents, computed not guessed) and stage 5 (trust
   collapse — per-statement epistemic state makes distrust local and calibrated).
   It does nothing for stage 2 (dedup — see the
   [dedup recall probe plan](/meta/plans/dedup-recall-probe.md), which stays prior
   work); the two are complements.
2. **Open question 2 has CB's current answer.** Per the current glossary, deps is
   "the only kind of edge the DAG has" — typing lives on *nodes*, one edge kind.
   Attestations carry no deps; aggregations/inferences require them. So: one `deps`
   edge beside (or subsuming) `verified_by`; no edge-type zoo.
3. **Open question 3 flips.** For the stabilization purpose, supersession is the
   mechanism, not a deferrable phase — a groundedness-only v1 delivers audit but
   not anti-drift. Sequence supersession-for-statements in. CB's **dep-repoint**
   (atomic drop-plus-add swinging a dep from a superseded node to its successor) is
   the most import-worthy operational primitive identified.

Caveat carried over: the analysis's source-staleness check found CB's *thesis doc*
had drifted from its schema (deprecated type names, missing edge rules) — a live
stage-3 demonstration inside CB itself. Enforcement in the gate suite is the
stabilizer; an advisory DAG rots like advisory anything.

## Addendum — execution path (2026-07-10)

Ratified approach for executing this plan: **two fresh threads, in order, with
filed captures as the handoff artifact.** Each thread starts from this section —
point the agent here and say "go." Rationale: an agent free-ranging over CB's
motley doc set absorbs stale material (demonstrated 2026-07-10 — see the
[stabilizer analysis](/meta/analysis/cb-epistemic-overlay-as-failure-chain-stabilizer.md)'s
source-staleness check), so CB's usable content is imported once, vetted, into
the bundle, and the architecture work then reads only the bundle.

### Thread A — CB asset import (run first)

**Goal:** a curated, freshness-vetted asset base inside the bundle, sufficient
for Thread B to execute without ever opening CB.

- **Setup:** `composablebeliefs/composable-beliefs` and the `cb-tut` repo must
  be on disk in the session — ideally attached as sources when the session is
  created (they clone automatically); otherwise added via `add_repo`. Filesystem
  access is required, not a convenience: the manifest needs the verifier code
  read directly, targeted `git log` for dating documents, and the live belief
  graph queried with CB's own `mix bs` tasks — none of which work over
  page-by-page web fetching.
- **Freshness tiers** (record the tier in each capture's `provenance`):
  - *Tier 1 — authoritative:* `docs/guide/` (the most recent doc set),
    `docs/glossary.md`, the code (`CB.Schema.Verifier`, the deps / supersession /
    dep-repoint implementations), and the live belief graph itself (`mix bs`
    queries) — per CB's own "query it rather than restating it."
  - *Tier 2 — secondary:* `cb-tut` (mostly accurate per the operator); verify any
    load-bearing statement against Tier 1 before capturing.
  - *Quarantined:* `docs/composable-beliefs-thesis.md` and older plans/docs —
    known stale; consult only to date material, never capture from them.
  - *Terminology guard:* current type names are **attestation / aggregation /
    inference / prescription**; the older names (primitive / compound /
    directive) appearing in any document mark it as predating the rename — treat
    that as a staleness flag for vetting. Do not file the rename history itself:
    Thread B and all later agents read only this bundle, so it would be noise.
    Targeted `git log` on schema/glossary files may be used the same way — as a
    dating instrument, not as content.
- **Capture manifest** — file under `knowledge/knowledge-management/composable-beliefs/`
  (new subdirectory under the established `knowledge/knowledge-management/` domain:
  autonomous per the taxonomy protocol; create its `index.md`, mint ids, and give
  every new doc a mandatory `attribution` frontmatter map per the current contract —
  no hand-kept `log.md` exists to append to; git history is the provenance layer):
  1. `reference` — CB overview as it currently is: typed nodes over a single
     `deps` edge, supersession chain, OKF-floor / CB-ceiling positioning.
  2. `source` — the four role definitions, verbatim from glossary/guide.
  3. `source` — per-type dep rules (attestation: no deps; aggregation/inference:
     required; non-contract prescription: required-or-stipulated).
  4. `source` — the supersession model (`superseded_by`, new-node-never-edit,
     retraction).
  5. `source` — staleness: definition and audit-detection semantics.
  6. `source` — dep-repoint: exact atomicity semantics, from the implementation.
  7. `source` — the verifier's integrity predicates relevant to the overlay
     (groundedness, schema, supersession discipline), extracted from
     `CB.Schema.Verifier` as *predicates, not code*; note eval-specific
     contracts as out of scope.
  8. *(optional)* `source` — CB test cases worth mirroring as scenario tests.
- **Rules:** every capture carries `resource` (the CB path/URL) and verbatim
  quotes for definitions; code semantics are captured as invariants/predicates,
  never as ported code. Captures are evidence (no `verified` field). All gates
  green before finishing.
- **Deliverable:** the captures filed and indexed, and this plan's Citations
  updated to reference their `sb:` ids.

### Thread B — architecture sketch (run after A)

**Goal:** revise this plan to `accepted` with the concrete design.

- **Reads only this bundle:** this plan and its addenda; the
  [stabilizer](/meta/analysis/cb-epistemic-overlay-as-failure-chain-stabilizer.md),
  [field-comparison](/meta/analysis/comparison-with-the-2026-second-brain-field.md),
  and [eval-suitability](/meta/analysis/eval-suitability-of-the-corpus-maintenance-failure-space.md)
  analyses; and the Thread A captures. **Thread B does not open CB.** Anything
  found missing becomes a follow-up item for another Thread A pass, not ad-hoc
  fetching.
- **Decide the remaining forks:** Q1 (derive epistemic role from `type` vs. an
  `epistemic:` field) and Q4 (how to encode the anti-atomization boundary). Q2
  and Q3 are already answered by the stabilization addendum (one `deps` edge,
  typing on nodes; supersession is load-bearing and sequenced in).
- **Draw the exact frontmatter surface** on the worked example (the testing
  methodology prescription grounded by its two attestations).
- **Specify supersession-for-statements** — the one real policy change (it
  amends update-in-place) — including how `superseded_by` interacts with the
  registry and `verified_by`.
- **Define `mix brain.graph` v1** (groundedness floor; staleness once
  supersession lands), reimplemented `elixir_mind`-style against
  frontmatter-native concepts; mirror the captured CB test cases in the
  scenario-test idiom.
- **Output:** this plan revised to `accepted` (or a superseding revision), with
  the design's technical claims carrying `verified_by` edges into the Thread A
  captures — the overlay's own evidence machinery, dogfooded.

## Addendum — reconciliation with repo drift and a sibling plan (2026-07-13)

Three days after the execution-path addendum was written, the bundle had moved:
a root reorganization, an unrelated belief-decomposition exploration, and one
concrete drift artifact all landed. This addendum corrects the operative
instructions in place (rather than leaving them stale for Thread A/B to trip
over) and records why, so the correction itself doesn't need re-deriving.

**A live instance of the drift this plan exists to fight.** Two references to
CB's own `docs/glossary.md` had been silently rewritten to `docs/beliefs/glossary.md`
— an artifact of this bundle's *own* glossary restructuring (`/glossary/` →
`/beliefs/glossary/`), whose rewrite tooling matched the literal string
`glossary.md` without distinguishing an internal path from a quoted external
one. Fixed in place above (Tier-1 list and Citations). This is stage-3
cross-reference drift, mechanically caused, inside the very document
proposing a mechanism against it — worth citing directly if `mix brain.graph`'s
scope discussion ever needs a concrete motivating example.

**Path drift from the root reorg.** `SWE/` and `knowledge-management/` moved
under a new `knowledge/` top-level (now `knowledge/SWE/` and
`knowledge/knowledge-management/`). Thread A's capture-manifest filing
location is corrected above to `knowledge/knowledge-management/composable-beliefs/`.
Thread B's worked example (the testing-methodology prescription and its two
attestations) is unmoved in spirit but now lives at
`knowledge/SWE/testing/elixir-mind-testing-methodology.md` — verify the
live path before use rather than trusting either version of this plan's prose.

**A sibling plan emerged: read it before deciding Q1/Q4.** On 2026-07-11 the
operator independently proposed a related idea, producing
[`belief-decomposition-analysis-mode`](/meta/plans/belief-decomposition-analysis-mode.md)
(`proposed`) and its commissioning
[analysis](/meta/analysis/belief-decomposition-derived-vs-authored.md). It
addresses a different layer — a **derived, regenerable, never-authored** belief
graph for ad hoc audit (groundedness/conflict/consensus over LLM-judged edges,
no `sb:` ids, no CI gate) — and its own text declares itself "compatible with,
not competing against" this plan: this plan governs the *storage* layer
(concept-granularity roles and committed `deps` edges); the sibling adds an
*analysis* mode that atomizes freely because it never stores. Both share the
same no-atomization boundary, arrived at independently — a second
triangulation of the line this plan already drew against CB.

The sibling plan names a concrete dependency this plan must now honor: *"if
[`mix brain.graph`]'s walker lands first, the audit algorithms (reachability,
groundedness floor) should be shared library code, with this tool supplying
derived nodes instead of concepts."* **Thread B's charter is amended
accordingly:** before deciding Q1/Q4, read both the sibling plan and its
analysis in full; when defining `mix brain.graph` v1, factor the
reachability/groundedness core as pure functions over a generic node/edge
shape (not hard-coded to bundle-concept frontmatter) so the analysis-mode plan
can reuse it over its derived nodes rather than reimplementing the same graph
algorithms twice. This does not change Q1/Q4 themselves, only the shape of
the implementation once decided.

**Housekeeping drift (no action required, noted for orientation).** The
hand-kept `log.md` files were retired repo-wide — git's merge-commit history
is now the sole provenance layer; reserved-file upkeep is `index.md` entries
only. `/create-pull-request` now also runs `/add-to-glossary` and stamps the
session's thread into `attribution.from` on every governance doc it revised —
Thread A/B need not do this by hand. New governance docs (Thread A's captures,
the revised plan) require the now-mandatory `attribution` frontmatter map
(`channel: agent-authored`, per the resource-attribution policy) — the
frontmatter-schema and verifier already enforce this; nothing in either
thread's charter needs to change beyond including the field. And
[`dedup-recall-probe`](/meta/plans/dedup-recall-probe.md), referenced in the
prior addendum as `proposed`, is now `status: done` and fully shipped — purely
informational; neither thread depends on it.

# Citations

- Comparison basis: [Composable Beliefs](https://github.com/composablebeliefs/composable-beliefs)
  (`okf/standard/types.md`; the four structural types; `docs/glossary.md` for the
  current schema — the thesis doc `docs/composable-beliefs-thesis.md` was found
  stale on 2026-07-10 and should not be treated as authoritative).
- Prior in-bundle decisions this builds on: the `methodology` type ratification and the
  "type an edge only when a machine must traverse it" link-model principle (see the
  `stable-identity` and `filenames-and-cross-linking` policies).
- Follow-on evaluation: [CB's overlay as a failure-chain stabilizer](/meta/analysis/cb-epistemic-overlay-as-failure-chain-stabilizer.md).
- Sibling plan (reconciled 2026-07-13): [Belief decomposition as a derived analysis mode](/meta/plans/belief-decomposition-analysis-mode.md) and its
  [commissioning analysis](/meta/analysis/belief-decomposition-derived-vs-authored.md).
