---
type: analysis
title: "Would CB's four-typed DAG, as an overlay, stabilize this knowledge base against the failure chain? Yes for drift and trust — through supersession — and no for dedup"
description: An evaluation of Composable Beliefs' epistemic layer (attestation/aggregation/inference/prescription over a single deps edge) as an add-on overlay against the five-stage 500+ failure chain — finding it a genuine mechanical stabilizer for cross-reference drift and trust collapse, useless for the dedup entry gate, and viable as a portable spec only if enforcement and edge-authoring stay host-native; includes a source-staleness check that corrected two claims traced to CB's outdated thesis doc.
provenance: "Claude Code session (Claude Fable), 2026-07-10 — operator asked whether enlisting CB's four-typed DAG as an overlay above the second brain could stabilize it against the failure modes, and whether it could be language-agnostic; initial read used CB's stale thesis doc, corrected against the current glossary after the operator flagged deprecated terminology"
tags: [meta, analysis, composable-beliefs, epistemics, overlay, dag, supersession, staleness, failure-modes, drift, portability]
timestamp: 2026-07-10
attribution:
  when: 2026-07-10T21:29:04+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-10-field-comparison-evals-and-cb-overlay-execution-path.md]
---

# Would CB's four-typed DAG, as an overlay, stabilize this knowledge base against the failure chain?

**Question.** The [field-comparison analysis](/meta/analysis/comparison-with-the-2026-second-brain-field.md)
modeled the five-stage failure chain that kills knowledge systems past ~500
concepts. Could enlisting [Composable Beliefs](https://github.com/composablebeliefs/composable-beliefs)'
four-typed DAG as an add-on overlay above this second brain stabilize it against
those failure modes? And could such an overlay be truly language-agnostic, or does
it need native integration with the knowledge base?

**Bottom line.** Yes, with precision: the overlay is a genuine *mechanical*
stabilizer for stage 3 (cross-reference drift) and stage 5 (trust collapse) — in
both cases the mechanism runs through **supersession**, which this bundle lacks —
partial for stage 1, useless for stage 2 (dedup remains the unguarded entry gate;
the [dedup recall probe](/meta/plans/dedup-recall-probe.md) stays prior work), and
conditionally helpful for stage 4 only inside the anti-atomization boundaries the
[epistemic overlay plan](/meta/plans/epistemic-overlay.md) already draws. On
portability: the *format* can and should be language-agnostic (CB itself frames CB
as an "opt-in ceiling" over OKF as "portable knowledge methodology"), but the
*enforcement* and the *edge-authoring moment* must be host-native — explorability
travels; stabilization doesn't.

## Source-staleness check (the operator's correction, and what it changed)

The first pass at this question leaned on CB's `docs/composable-beliefs-thesis.md`,
which uses the type names *primitive / compound / inference / directive*. The
operator flagged these as deprecated (current: **attestation / aggregation /
inference / prescription**) and asked the right follow-up: if the terminology was
stale, was anything else sourced from that doc stale too? Re-verification against
the current glossary (`docs/beliefs/glossary.md`) found:

| Claim from the thesis read | Status after re-check |
|---|---|
| "No formal edge rules between types are stated" | **Wrong.** The glossary specifies per-type dep rules: attestations carry *no* deps ("grounded in an artifact and dated evidence, with no deps"); aggregations and inferences *require* deps; non-contract prescriptions are "required-or-stipulated". |
| "CB makes no portability claims" | **Wrong.** CB explicitly positions OKF as "portable knowledge methodology" with CB as an **"opt-in ceiling"** layer — i.e. CB already architected itself as exactly the kind of overlay this analysis evaluates. |
| Supersession + staleness propagation ("every compound depending on a superseded primitive is flagged as potentially stale") | **Survives, sharpened.** Current model: supersession is "a new node, never an in-place edit" (`superseded_by`); staleness = active nodes depending on superseded/retracted nodes, detected by audit; and repair has a first-class primitive — the **"dep-repoint front door"**, an atomic drop-plus-add that swings a dep from a superseded node to its successor. |
| The four operations themselves | Same four, current names as above. Aggregation is strict: "a conjunction whose claim states exactly what its deps (two or more) jointly state, *no more*"; inference is the ampliative one, "licensed to exceed what its deps jointly state". |
| Structure of the graph | Clarified: **deps is the only kind of edge the DAG has** — the typing lives on *nodes*, not edges (plus the separate `superseded_by` chain). |

Two meta-observations. First, the corrections *strengthened* the overlay case
rather than weakening it — the formal edge rules and the "opt-in ceiling" framing
are both pro-overlay facts the stale source hid. Second, the thesis going stale
inside CB itself — while `docs/belief-graph.md` says of the schema "query it rather
than restating it" — is a **live demonstration of stage-3 drift** hitting exactly
the prose that lives outside the enforced graph. The system built to prevent
dependency staleness had its own narrative doc rot, because narrative docs aren't
nodes. That is simultaneously the best evidence that the mechanism works where it
applies and a scope warning about where it doesn't.

## The overlay against the five stages

**Stage 3, cross-reference drift — yes; this is the headline.** Drift is not
knowing which existing pages a new or contradicting source touches: an *unbounded
recall problem* in an untyped corpus, which is why LLM lint passes degrade at scale.
A dependency DAG with supersession converts it into *bounded graph traversal*:
supersede an attestation and the affected set is the transitive closure of its
dependents — computed, not guessed — with dep-repoint as the atomic repair. The
deeper reason it works is a **timing asymmetry**: dependency edges are cheapest to
create at intake, when the source is fully in context; drift detection is needed
forever afterward, when context is gone. The overlay moves the epistemically hard
work to the one moment it is easy. The honest conditional: edges must exist and be
correct, and edge creation is itself probabilistically-enforced agent behavior. So
the overlay does not eliminate the probabilistic-enforcement root cause — it
**relocates the bet** from "update all affected pages, forever, from partial views"
(unbounded, repeated) to "record your dependencies once, at intake, in full
context" (bounded, one-time). A far better place for the bet, and a measurable one:
edge-completeness is the fan-out eval of the
[eval-suitability analysis](/meta/analysis/eval-suitability-of-the-corpus-maintenance-failure-space.md)
in graph clothes.

**Stage 5, trust collapse — yes, second-strongest.** Trust collapses because
degradation is invisible and therefore binary. The overlay makes epistemic state
visible *per statement*: this concept rests on a superseded attestation; this
inference is ungrounded; this node has twelve dependents (blast radius). Trust
becomes calibrated and local instead of global and brittle — the system says
*exactly what* to distrust. A brain that shows its wounds does not lose the
operator the way a brain that rots silently does.

**Stage 1, context saturation — partial.** The DAG gives agents *principled*
partial views: walk the grounding subtree outward from a relevant node instead of
relying on arbitrary retrieval. It changes what a partial view is, not whether you
have one — and attaching new content still requires finding the attachment point,
which is the recall problem again.

**Stage 2, dedup/fragmentation — no.** The DAG does not help find the existing
twin. A missed duplicate is somewhat worse in a DAG — each twin accretes its own
dependency subtree — though dep-repoint makes the eventual merge-rewiring atomic
rather than hand-surgical (a correction from the staleness check; the first pass
overweighted this cost). One partial offset: a mandatory-grounding discipline
forces a structured search for candidate deps at intake, which can surface the twin
as a side effect — but that is the dedup search under another name. **The overlay
does not defend the chain's entry gate.** The dedup recall probe stays prior work
regardless; probe and overlay are complements attacking different stages.

**Stage 4, taxonomy entropy — conditional.** The graph is an axis orthogonal to
the tree and can absorb pressure that otherwise deforms the taxonomy (over-nesting
to express relatedness). But CB is its own cautionary tale: the open `kind` axis
sprawled past 40 values and atomization produced hundreds of belief files — a DAG
can generate entropy of its own kind. Stabilizing only inside the epistemic-overlay
plan's boundaries: closed four-role enum, concept-granularity nodes, no second axis.

**The structural summary.** The overlay extends this bundle's core move —
structural enforcement — from *form* into a slice of *semantics* (groundedness,
dependency-freshness): precisely the territory the field-comparison analysis said
CI couldn't reach. Not all semantics — dedup and filing quality stay editorial —
but stages 3 and 5 are the covered slice, and they are two of the three stages that
do the killing. Two load-bearing conditions follow:

1. **Supersession is the mechanism, not a phase.** Staleness propagation requires
   supersede-not-edit, and this bundle edits in place. If the overlay's purpose is
   *stabilization* (this analysis) rather than *explorability* (the plan's original
   framing), the plan's open question 3 flips: a groundedness-only v1 delivers
   audit but not the anti-drift machinery. Supersession-for-statements needs to be
   sequenced in, not deferred out.
2. **An advisory DAG rots like any advisory structure.** Edges nobody verifies go
   stale like prose links; CB understood this (deterministic contracts, no LLM in
   the read path). `mix brain.graph` in the gate suite is not an accessory — it is
   the stabilizer.

## Language-agnostic overlay, or native integration?

Split the overlay into three layers; they answer differently:

- **Data model — genuinely agnostic, and should be specified that way.** Node role
  plus a single `deps` edge as frontmatter over stable ids is exactly
  `verified_by`'s shape today: YAML any toolchain can parse, over plain markdown.
  CB's own current architecture endorses this — OKF as the portable floor, CB as
  an opt-in ceiling. Specified as an OKF extension, the overlay could sit above any
  bundle-shaped knowledge base; the field survey found nobody offering structural
  epistemics, so a portable spec would be first of its kind.
- **Verifier — host-native in practice.** The integrity floor only stabilizes if
  it sits in the host's merge path (CI + pre-commit); a detached verifier is
  advisory with extra steps. Edges reference ids only the host registry resolves —
  a sidecar re-implementing id scanning duplicates the source of truth and drifts.
- **Edge-authoring moment — necessarily native.** The whole stage-3 argument rests
  on capturing deps *inside* `/intake` and `/capture`, when the source is in
  context. A bolt-on that infers edges after the fact forfeits the timing
  asymmetry — post-hoc edge inference *is* the fan-out problem it was meant to
  solve.

So: **agnostic format, native enforcement and authoring** — the pattern of OKF
itself (portable spec, per-host tooling), already proven once in this bundle:
`verified_by` is a CB-style edge natively integrated (registry-resolved,
CI-checked, intake-authored). A standalone tool draped over any KB without
integration would deliver explorability (read-only graph walks travel fine) but
not stability, because stability lives at write time and intake time, both
host-coupled.

## Implications for the epistemic-overlay plan

This analysis feeds three concrete updates into
[the plan](/meta/plans/epistemic-overlay.md) (recorded there as an addendum):

1. **Motivation upgrade:** from "explorability + integrity floor" to *stabilizer
   of failure-chain stages 3 and 5* — the strongest argument yet for accepting it.
2. **Open question 2 gets CB's answer:** one `deps` edge kind with typing on
   nodes — deps is "the only kind of edge the DAG has". Keep `verified_by` as the
   evidence-special-case or fold it in, but do not grow an edge-type zoo.
3. **Open question 3 flips:** supersession moves from "possible prerequisite" to
   load-bearing for the stabilization purpose; and CB's **dep-repoint** (atomic
   drop-plus-add swinging a dep to a successor node) is the single most
   import-worthy operational primitive found in this re-examination.

# Citations

- Current CB sources (fetched 2026-07-10): repository README;
  `docs/beliefs/glossary.md` (four type definitions, deps as sole edge kind, per-type dep
  rules, supersession, staleness-by-audit, dep-repoint, OKF-floor/CB-ceiling);
  `docs/belief-graph.md` ("query it rather than restating it").
- Stale source identified and set aside: `docs/composable-beliefs-thesis.md`
  (deprecated type names primitive/compound/directive; missing edge rules and
  portability positioning).
- In-bundle: the [epistemic overlay plan](/meta/plans/epistemic-overlay.md); the
  [field-comparison](/meta/analysis/comparison-with-the-2026-second-brain-field.md),
  [eval-suitability](/meta/analysis/eval-suitability-of-the-corpus-maintenance-failure-space.md),
  and [vector-DB recall](/meta/analysis/vector-db-recall-for-the-scaling-bundle.md)
  analyses; the CB-comparison thread
  [2026-07-09](/meta/threads/2026-07-09-testing-methodology-types-and-cb-epistemic-overlay.md).
