---
type: analysis
title: "Belief decomposition over artifacts: derive the graph, never author it"
description: An evaluation of the idea of decomposing artifacts into atomic-belief DAGs (attestations + inferences) for logical audit, cross-document consensus/conflict examination, and evals — finding it is the third iteration of this operator's own lineage, that the two prior iterations failed on authored-store maintenance debt, and that a derived, regenerable overlay escapes that failure mode.
provenance: "Claude Code session, 2026-07-11 — operator proposed a semiformal epistemic structure over documents and code and asked for an assessment"
tags: [meta, analysis, epistemics, belief-decomposition, dag, composable-beliefs, argumentation, evals, knowledge-representation]
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T09:07:29+00:00
  channel: agent-authored
  agent: "Claude Code agent, in-session authoring"
  why: "authored at operator request (\"commit both an analysis and a plan\") to persist the belief-decomposition assessment"
  from: [/meta/threads/2026-07-11-belief-decomposition-analysis-and-epistemic-prior-art.md]
---

# Belief decomposition over artifacts: derive the graph, never author it

**Question.** Is there a semiformal epistemic structure — artifacts decomposed
into atomic beliefs (*attestations* asserted from sources, *inferences* derived
from other beliefs) arranged in a directed acyclic graph — that an agentic
system can overlay on documents and code to audit their logical structure,
compare their belief systems, run consensus evaluation and conflict
examination, and support evals? And should this brain build toward it?

**Bottom line.** Yes — but only under one load-bearing commitment that neither
prior iteration of this idea made: **the belief graph must be a derived,
regenerable analysis artifact, never an authored store.** With that boundary
the idea is sound, well-precedented, and compatible with the
[epistemic-overlay plan](/meta/plans/epistemic-overlay.md)'s no-atomization
line rather than in conflict with it. A companion
[plan](/meta/plans/belief-decomposition-analysis-mode.md) proposes the concrete
shape.

## The lineage: this is iteration three

This proposal is not new to this operator; the brain's own records hold two
prior versions and a diagnosis of what went wrong:

1. **The assertion graph**
   ([deprecated plan 003](/deprecated/plans/003-assertion-dag-knowledge-architecture.md),
   executed 2026-03) — atomic `assertion` files in primitive/compound tiers,
   evidence edges to sources, `deps` + `implication` on compounds, a generated
   DAG index, `contested.sh` for conflict detection. Now archived under
   `deprecated/`.
2. **[Composable Beliefs](/beliefs/glossary/composable-beliefs.md) (CB)** — the
   four-operation ontology (attestation / aggregation / inference /
   prescription), stable ids, supersession. Per the epistemic-overlay plan's
   own post-mortem, CB "became overwhelming": ~400 atomized belief files and a
   `kind` field sprawled to 40+ values. Its atomization pull was "bottomless."
3. **This brain's bounded response** — the
   [epistemic-overlay plan](/meta/plans/epistemic-overlay.md) (proposed) keeps
   the four epistemic roles but at *concept* granularity, explicitly bounding
   out atomization.

Both failures share one cause: atomic beliefs were the **authored storage
substrate**. Every atomized claim became a file someone must keep true,
deduplicate, and re-link forever, and decomposition has no natural floor — so
the store grew without bound.

## Finding 1 — the load-bearing distinction: derived, not authored

The new articulation ("overlay over artifacts, audit, compare") does not
require beliefs to be stored at all. The graph can be a **derived intermediate
representation** — computed from the artifact when an audit or comparison is
wanted, cached or discarded afterward, regenerated at will — while the
artifact stays the sole source of truth. This is the same discipline the brain
already runs on ([compiled contract](/beliefs/glossary/compiled-contract.md), compiled
registry, route-tag logs re-derived by a verifier that fails on divergence).
Derivation converts the two killer problems into tolerable ones:

- **Maintenance debt** disappears — nothing hand-kept can rot.
- **Decomposition instability** (the same document atomizing differently
  across runs) becomes an analysis artifact, not corruption of a store.

## Finding 2 — the prior art validates the parts

Each pillar of the idea has an established literature, now captured in the
bundle:

- **[Truth maintenance systems](/knowledge/knowledge-management/knowledge-representation/truth-maintenance-systems.md)**
  (Doyle's JTMS, de Kleer's ATMS) are the direct ancestor: a
  [bipartite](/beliefs/glossary/bipartite-graph.md) graph of belief and justification
  nodes with dependency-directed revision. The ATMS *assumption environment*
  answers how two internally-coherent, mutually-contradictory documents are
  compared without merging them into one inconsistent soup: beliefs carry
  context labels; you compare belief *sets*.
- **[The Toulmin model](/knowledge/knowledge-management/argumentation/toulmin-model-of-argument.md)**
  establishes that the justification (premises → conclusion, licensed by a
  warrant) is the first-class object — which is why the graph must be
  bipartite: one conclusion under several independent justifications is
  epistemically stronger, and consensus evaluation needs to see them
  separately.
- **[Decompose-then-verify factuality evaluation](/knowledge/SWE/evals/decompose-then-verify-factuality.md)**
  (FActScore, SAFE) is the empirical validation of the evals use case: atomize
  → verify each fact locally → aggregate mechanically measurably beats
  holistic judging, at automated-estimator error under 2%. SAFE's
  revise-to-self-contained step is the canonical answer to decontextualization.
- **[Assurance cases / GSN](/knowledge/knowledge-management/argumentation/assurance-cases-and-gsn.md)**
  prove the artifact-facing application in safety-critical practice: claim
  trees over systems, mechanically checkable for shape while leaf judgments
  stay expert. They also carry the standing caution (Haddon-Cave): argument
  structure audits *coherence*, not *truth*.
- **[Dung's abstract argumentation frameworks](/knowledge/knowledge-management/argumentation/dung-abstract-argumentation-frameworks.md)**
  are the formal engine for "consensus evaluation and conflict examination" —
  the operator's original framing. Arguments plus an *attack* relation, with
  semantics (grounded, preferred, stable) that compute which sets rationally
  co-stand: the [grounded extension](/beliefs/glossary/grounded-extension.md) *is* a
  [consensus core](/beliefs/glossary/consensus-core.md), and the framework grounds the
  structural correction below (conflict is a separate, possibly-cyclic relation,
  not a DAG edge).
- **[FOL and OWL](/knowledge/knowledge-management/knowledge-representation/first-order-logic-and-owl.md)**
  mark the fully formal pole and its costs — semidecidability, ontology
  authoring expense, brittleness against real prose — which is the argument
  *for* the semiformal middle: natural-language beliefs, typed edges, an LLM
  as the local oracle.

## Finding 3 — the architecture principle

**LLM judgments stay local to edges; structure stays global and mechanical**
(now recorded in [future-beliefs](/beliefs/future-beliefs.md)). The LLM answers
small, cacheable questions — "does this passage assert this belief?", "do
these premises entail this conclusion?", "do these two beliefs conflict?" —
and deterministic graph algorithms compute the global properties:
[ungrounded inferences](/beliefs/glossary/ungrounded-inference.md),
[minimal inconsistent subsets](/beliefs/glossary/minimal-inconsistent-subset.md),
[consensus cores](/beliefs/glossary/consensus-core.md) across artifacts, and the
[blast radius of a retracted premise](/beliefs/glossary/blast-radius.md). This is what
makes the structure *semiformal in a useful way*: local judgments compose into
global audits with a per-edge audit trail, and only the dirty subgraph needs
re-judging on change.

Two structural corrections to the raw proposal:

- **The DAG holds for derivation only.** Support/inference edges can be kept
  acyclic; conflict is a separate, symmetric relation that cannot be forced
  acyclic (mutual attack is normal;
  [Dung-style semantics](/knowledge/knowledge-management/argumentation/dung-abstract-argumentation-frameworks.md)
  resolve it).
- **Attestation/inference is the right cut, but the edge is the unit.** The
  justification node (Toulmin's warranted step), not the belief pair, is what
  the LLM judges and the audit cites.

## Finding 4 — the hard problem is belief identity

Cross-document comparison only works if "apples are fruits" (doc A) and "an
apple is a kind of fruit" (doc B) unify to one node. That is entity resolution
for propositions: fuzzy, LLM-mediated, and the single largest design cost —
larger than the graph machinery itself. It is the same lesson this brain
already learned twice: cross-context joins must key on canonical identities,
not free-text phrasings ([stable ids](/beliefs/glossary/stable-id.md); route tags
keyed on `em:` ids). Expect canonicalization plus decontextualization to
dominate the decomposer's design.

## Finding 5 — application ranking

1. **Evals** — strongest; the decompose-then-verify literature has already
   validated the pattern at scale.
2. **Cross-corpus consensus/conflict audit** — high value, genuinely
   underserved; contradiction detection across a large knowledge base has no
   good mechanical story today.
3. **Formalizing operator–agent prose** — promising as a *lens* (derive the
   belief graph of a thread; surface what was asserted vs. inferred vs. left
   dangling), a natural extension of the routing ledger's dispatch view.
4. **Code** — weakest as semantics-of-code (types and tests already audit that
   with real oracles); strong as audit of the *claims about* code — design
   docs, ADRs, comments versus implementation — which is assurance-case-shaped.

## Recommendation

Adopt **derived-not-authored** as the governing boundary for any belief-graph
work in this brain, alongside the epistemic-overlay plan's no-atomization line
(the two are the same rule seen from storage and from analysis). Concretely:
pursue the
[belief-decomposition analysis-mode plan](/meta/plans/belief-decomposition-analysis-mode.md)
— a read-only decomposition/audit tool whose only bundle output is a filed
`analysis` doc — and defer any thought of storing belief nodes until a
committed purpose demands it (the epistemic-overlay plan's own bar).
