---
id: em:8255b8
type: reference
title: "FOL and OWL: fully formal knowledge representation"
description: First-order logic and the W3C Web Ontology Language (OWL 2) — the fully formal end of the knowledge-representation spectrum, with provable semantics, decidability trade-offs, and the authoring cost that motivates semiformal middle layers.
resource: https://www.w3.org/TR/owl2-overview/
provenance: "Distilled from the Wikipedia article on first-order logic and the W3C OWL 2 overview, fetched 2026-07-11; layered breakdown via /summarize-technical"
tags: [knowledge-representation, logic, first-order-logic, owl, description-logic, ontology, semantic-web, formal-methods]
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T09:07:29+00:00
  channel: intake
  agent: "Claude Code agent, /intake"
  why: "operator-directed prior-art capture for the belief-decomposition assessment; body later restructured via /summarize-technical"
---

# FOL and OWL: fully formal knowledge representation

## Summary

These are the two landmark systems for writing statements so precisely that a
machine can *prove* what follows from them — the fully formal end of the
knowledge-representation spectrum, against which any semiformal scheme
defines itself.

The first, developed in the 1880s and mature by 1929, is a general language
of objects, their properties, and the relations between them, with the two
quantities "for all" and "there exists." Its powers and limits are theorems.
Everything that genuinely follows from a set of statements can be found by
mechanical proof search (nothing valid is out of reach); but there is no
procedure that always *terminates* when asked whether something follows — if
the answer is no, the search may run forever. And no set of statements in the
language can pin down an infinite structure like the whole numbers uniquely;
unintended interpretations always sneak in.

The second (a web standard, 2009) is a deliberately weakened descendant built
for publishing machine-readable vocabularies — categories, relationships,
individuals — on the web. By restricting what can be said, it buys what the
general language cannot offer: reasoning that is guaranteed to terminate, and
in its most restricted variants, guaranteed to be *fast*. It comes in graded
strengths, each targeting a workload: huge medical-style vocabularies,
database-backed query answering, or rule engines.

Together they mark the trade the formal pole offers: provable consequence
and mechanical consistency checking, purchased with expressive restriction
and heavy authoring cost — real prose does not compile into either.

## Key terms

- **Term / formula / sentence** — the syntax hierarchy: terms name objects
  (variables, constants, function applications); formulas state propositions
  (predicates over terms, combined by connectives and quantifiers ∀/∃); a
  sentence is a formula with no free variables, so its truth needs no further
  context.
- **Signature** — the non-logical vocabulary a theory chooses: its predicate,
  function, and constant symbols. The formal analogue of "what this document
  is allowed to talk about."
- **Structure (interpretation)** — a domain of objects plus an assignment of
  the signature's symbols to actual relations and functions over it; the
  thing formulas are true *in*.
- **Satisfaction (Tarski truth)** — the inductive definition of "structure M
  makes formula φ true" (M ⊨ φ), the anchor for every other semantic notion.
- **Validity / logical consequence** — true in every structure / true in
  every structure satisfying the premises. Consequence is the formal
  counterpart of the entailment judgments a belief graph asks for per edge.
- **Soundness & completeness (Gödel 1929)** — proof systems for first-order
  logic derive exactly the valid formulas: syntactic derivability and
  semantic consequence coincide.
- **Semidecidability (Church–Turing)** — consequence can be *confirmed* by
  exhaustive proof search but not refuted in general: no algorithm decides
  arbitrary entailment. The fundamental ceiling on formal auditing.
- **Compactness / Löwenheim–Skolem** — a theory is satisfiable if every
  finite part is; and satisfiable theories have countable (hence unintended)
  models — no first-order theory uniquely characterizes an infinite
  structure.
- **Description logic** — decidable FOL fragments engineered for
  concept/role/individual reasoning; **SROIQ** is the one underlying OWL 2.
- **OWL 2 DL vs. OWL 2 Full** — the syntactically restricted species that
  translates into SROIQ (decidable, under *Direct Semantics*) versus the
  unrestricted reading over arbitrary RDF graphs (*RDF-Based Semantics*,
  expressive but undecidable); a correspondence theorem keeps the two
  readings consistent where they overlap.
- **Profiles (EL / QL / RL)** — OWL 2's graded sub-languages with
  computational guarantees: EL gives polynomial-time reasoning for very large
  ontologies; QL answers conjunctive queries inside relational-database
  complexity (AC⁰) over big instance sets; RL supports rule-engine
  implementation directly on RDF triples.
- **Reasoning tasks** — the standard machine services: consistency,
  class satisfiability, subsumption/classification, instance retrieval —
  i.e. mechanical detection of contradiction and hierarchy.

## Technical summary

First-order logic fixes a signature, builds terms and formulas over it, and
interprets them in structures via Tarskian satisfaction; validity and logical
consequence are quantification over all structures. Gödel completeness makes
consequence provable (sound + complete calculi: Hilbert systems, natural
deduction, sequent calculus, resolution), compactness and Löwenheim–Skolem
bound what theories can pin down, and Church–Turing semidecidability caps
mechanical audit: entailment is confirmable, non-entailment not generally so.
Categorical characterization of infinite structures requires second-order
quantification, which sacrifices the completeness theorem.

OWL 2 packages a description-logic fragment for the web: ontologies of
classes, object/data properties, individuals, and axioms, exchangeable as RDF
(RDF/XML mandatory; Functional, Manchester, Turtle, OWL/XML optional). OWL 2
DL's Direct Semantics is model-theoretically aligned with SROIQ, so
consistency, subsumption, classification, and instance retrieval are
decidable; OWL 2 Full's RDF-Based Semantics drops all syntactic restriction
and decidability, with a correspondence theorem linking the two. The EL/QL/RL
profiles trade expressiveness for complexity guarantees (PTIME / AC⁰ query
answering / PTIME rule-based, respectively).

For a semiformal belief layer the relevant readings are: (1) entailment,
consistency, and
[minimal inconsistent subsets](/beliefs/glossary/minimal-inconsistent-subset.md) are
crisply defined only at this pole — semiformal analogues inherit the *shape*
of these notions while replacing the oracle with LLM judgment; (2) even here,
full generality is undecidable — guaranteed audit always comes from
restriction; (3) the authoring cost of formal ontologies is the standing
argument for keeping belief content in natural language and formalizing only
the *structure* around it.

## Why it is in this brain

FOL/OWL mark the fully formal pole against which a semiformal epistemic
substrate defines itself — what full formalization buys, and the
brittleness/authoring costs that motivate keeping beliefs in natural language
with an LLM as the local entailment oracle. See the
[belief-decomposition analysis](/meta/analysis/belief-decomposition-derived-vs-authored.md).

# Citations

- First-order logic — Wikipedia: <https://en.wikipedia.org/wiki/First-order_logic>
- OWL 2 Web Ontology Language Document Overview (Second Edition) — W3C:
  <https://www.w3.org/TR/owl2-overview/>
