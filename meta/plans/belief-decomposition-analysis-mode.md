---
type: plan
title: "Belief decomposition as a derived analysis mode"
description: A read-only tool that decomposes one or more artifacts into a derived, regenerable belief graph (attestations + inferences, bipartite with justification nodes), runs mechanical audits (groundedness, conflict, consensus) over LLM-judged edges, and reports — writing nothing into the bundle except an optional filed analysis doc.
status: proposed
provenance: "Claude Code session, 2026-07-11 — commissioned by the operator following the belief-decomposition assessment"
tags: [meta, plan, epistemics, belief-decomposition, dag, audit, evals, tooling]
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T09:07:29+00:00
  channel: agent-authored
  agent: "Claude Code agent, in-session authoring"
  why: "authored at operator request (\"commit both an analysis and a plan\") to persist the belief-decomposition assessment"
  from: [/meta/threads/2026-07-11-belief-decomposition-analysis-and-epistemic-prior-art.md]
---

# Belief decomposition as a derived analysis mode

## Status & provenance

**Proposed** — not yet accepted. This plan executes the recommendation of the
[belief-decomposition analysis](/meta/analysis/belief-decomposition-derived-vs-authored.md)
(read it first — it carries the lineage, the prior art, and the reasoning) and
is designed to be **compatible with, not competing against**, the
[epistemic-overlay plan](/meta/plans/epistemic-overlay.md): that plan governs
the *storage* layer (concept-granularity roles and edges, no atomization);
this one adds an *analysis* mode that atomizes freely because it never stores.

## Motivation

The operator wants a semiformal epistemic structure that can be overlaid on
artifacts (documents, threads, eventually claims-about-code) to:

- audit an artifact's logical structure — what is asserted from sources
  (attestations) vs. derived (inferences), and whether every inference is
  grounded;
- compare the belief systems of related artifacts — consensus and conflict
  examination;
- give agent–operator prose a structure that code can check while the LLM
  supplies the local interpretation;
- eventually back evals (the validated
  [decompose-then-verify](/knowledge/SWE/evals/decompose-then-verify-factuality.md)
  pattern).

Two prior iterations (the deprecated assertion graph; Composable Beliefs)
failed on authored-store maintenance debt. The governing boundary here is
therefore:

> **The belief graph is derived, cached at most, and regenerable — never an
> authored store. The artifact remains the sole source of truth.**

## Design

### The derived graph (in-memory / scratch artifact)

- **Nodes.** *Beliefs* — atomic natural-language statements, each carrying the
  artifact + span it was extracted from and a context label (the artifact is
  its ATMS-style assumption environment). Two roles: **attestation** (asserted
  by the artifact/source directly) and **inference** (derived from other
  beliefs).
- **Justification nodes.** The graph is
  [bipartite](/beliefs/glossary/bipartite-graph.md): an inference is connected to its
  premises through a justification node carrying the warrant (the license the
  LLM judged). One conclusion may carry several independent justifications.
- **Edges.** Support/derivation edges form a DAG. **Conflict** is a separate
  symmetric relation, allowed to be cyclic, resolved by semantics rather than
  prohibited by construction.

### The pipeline

1. **Decompose** — extract candidate beliefs from the artifact(s), revising
   each to be self-contained (SAFE's decontextualization step).
2. **Canonicalize** — unify equivalent beliefs across artifacts (embedding
   similarity shortlist + LLM equivalence judgment). This is the hard problem;
   see open questions.
3. **Judge edges** — per-edge LLM calls: assertion ("does the span assert
   this?"), entailment ("do these premises license this conclusion?"),
   conflict ("can these both hold?"). Judgments are local, cacheable, and
   auditable.
4. **Audit mechanically** — pure graph algorithms over the judged graph:
   - [ungrounded inferences](/beliefs/glossary/ungrounded-inference.md) (groundedness
     floor, per artifact);
   - [minimal inconsistent subsets](/beliefs/glossary/minimal-inconsistent-subset.md)
     (conflict localized to its smallest witness);
   - [consensus core](/beliefs/glossary/consensus-core.md) across the compared
     artifacts (supported by all, attacked by none);
   - [blast radius](/beliefs/glossary/blast-radius.md) of any belief (what would need
     re-examination if it fell).
5. **Report** — a human-readable audit. If the operator wants it kept, it is
   filed as a normal `type: analysis` doc; otherwise it is scratch output.

**The principle throughout** (recorded in
[future-beliefs](/beliefs/future-beliefs.md)): *LLM judgments stay local to
edges; structure stays global and mechanical.*

### Likely first surface

A `mix brain.beliefs <path> [<path>…]` task mirroring `mix brain.evidence`'s
derive-on-demand pattern: read-only over the bundle, textual report to stdout.
LLM-dependent steps make it unlike the pure verifiers, so it is **not** a CI
gate — it is an operator-invoked audit. (A stub/backends split like the
deprecated repo's `llm-call.sh` may apply; decide at build time.)

## Scope boundaries (deliberate exclusions)

- **No stored belief nodes.** Nothing under the bundle gains an `sb:` id from
  this tool. The only committable output is a filed `analysis` doc. This *is*
  the epistemic-overlay plan's no-atomization line, restated for the analysis
  layer.
- **No truth scores.** Groundedness, conflict membership, and consensus
  membership are floor predicates and set memberships; degree/blast-radius is
  an importance/staleness signal, never "strength" or "confidence"
  (inheriting the strength-as-count exclusion).
- **No new `type` or frontmatter surface.** The bundle schema does not change.
- **No code-semantics auditing.** Code enters only as *claims about code*
  (docs/ADRs/comments vs. implementation), and only after prose-vs-prose
  comparison works.

## Machine-checkable properties (precise statements)

- *Groundedness:* every inference in the derived graph reaches ≥1 attestation
  transitively through justification nodes; failures named with artifact+span.
- *Conflict:* every reported contradiction is exhibited as a minimal
  inconsistent subset, each member cited to its span.
- *Consensus:* the consensus core is exactly the set supported in every input
  artifact's graph and attacked in none.
- *Determinism boundary:* given a frozen set of cached edge judgments, the
  audit output is a pure function of the inputs (only the judgments themselves
  are model-dependent).

## Dependencies & interactions

- **[Epistemic-overlay plan](/meta/plans/epistemic-overlay.md)** — orthogonal
  layers; if its `mix brain.graph` walker lands first, the audit algorithms
  (reachability, groundedness floor) should be shared library code, with this
  tool supplying derived nodes instead of concepts.
- **Route tags / capture** — threads are prime input artifacts; the routing
  ledger already names each thread's matters, a ready-made segmentation hint.
- **The [recall/dedup analysis](/meta/analysis/vector-db-recall-for-the-scaling-bundle.md)**
  — belief canonicalization is the same semantic-match problem intake dedup
  has; solutions should be shared, not parallel.

## Open questions (for the operator / next session)

1. **Cache policy.** Are edge judgments cached at all in v1 (scratch JSON,
   git-ignored?) or recomputed per run? Committed caches reintroduce a store
   through the back door — default answer is *not committed*.
2. **Canonicalization strategy.** Embedding shortlist + LLM equivalence, or
   LLM-only at small scale? At what corpus size does this need the vector
   tooling the recall analysis deferred?
3. **First corpus.** Two related filed concepts? A captured thread vs. the
   concepts it routed to (does the routed doc actually absorb the thread's
   beliefs)? The latter doubles as an audit of the capture/routing system
   itself.
4. **Eval harness.** Does v1 include a self-check (decompose the same artifact
   twice, measure belief-set stability) so decomposition instability is
   *measured* rather than assumed tolerable?

## Suggested first slice (if accepted)

1. Decide Q1–Q3.
2. Build decompose + canonicalize + groundedness only, over exactly two
   related bundle concepts; no conflict semantics yet.
3. Run the stability self-check (Q4) and file the result as an `analysis`.
4. Only if stability and cost are acceptable, add conflict/consensus and the
   thread-vs-routed-concept audit.

# Citations

- [Belief-decomposition analysis (derived vs. authored)](/meta/analysis/belief-decomposition-derived-vs-authored.md) — the commissioning assessment.
- Prior art captured 2026-07-11:
  [TMS/ATMS](/knowledge/knowledge-management/knowledge-representation/truth-maintenance-systems.md),
  [Toulmin](/knowledge/knowledge-management/argumentation/toulmin-model-of-argument.md),
  [assurance cases/GSN](/knowledge/knowledge-management/argumentation/assurance-cases-and-gsn.md),
  [FOL/OWL](/knowledge/knowledge-management/knowledge-representation/first-order-logic-and-owl.md),
  [FActScore/SAFE](/knowledge/SWE/evals/decompose-then-verify-factuality.md).
- Lineage: [deprecated plan 003](/deprecated/plans/003-assertion-dag-knowledge-architecture.md),
  [Composable Beliefs](/beliefs/glossary/composable-beliefs.md),
  [epistemic-overlay plan](/meta/plans/epistemic-overlay.md).
