---
id: sb:59895a
type: reference
title: Assurance cases and Goal Structuring Notation (GSN)
description: The safety-engineering practice of arguing a system property as an explicit claim tree — goals decomposed via strategies down to evidence — standardized as GSN (University of York, Tim Kelly; Community Standard 2011) and used across aviation, automotive, rail, nuclear, and clinical domains.
resource: https://en.wikipedia.org/wiki/Goal_structuring_notation
provenance: "Distilled from the Wikipedia article on Goal Structuring Notation (fetched 2026-07-11), with element/relationship detail from the GSN Community Standard; layered breakdown via /summarize-technical"
tags: [argumentation, assurance-case, safety-case, gsn, safety-critical, epistemics, evidence]
timestamp: 2026-07-11
---

# Assurance cases and Goal Structuring Notation (GSN)

## Summary

Industries where failure kills people — aviation, rail, nuclear, medical
devices — typically must convince a regulator that a system is acceptably
safe *before* it operates. The traditional vehicle was a long prose report,
and prose has a known failure mode: the reasoning hides. A hundred pages can
gesture at safety without anyone being able to point to which claim rests on
which test result, or notice that some claim rests on nothing.

The remedy, developed at the University of York in the early 1990s and
refined in Tim Kelly's doctoral work, is to draw the argument instead of
narrating it: a diagram whose top node is the overall claim ("the system is
acceptably safe to operate in this environment"), broken down level by level
— each breakdown step stated explicitly — until every branch bottoms out in a
concrete piece of evidence: a test report, an analysis, an inspection record.
Side annotations state the operating context, the assumptions being made, and
the rationale for arguing this way rather than another. The result reads as a
tree you can audit: every leaf is evidence or visibly marked "not yet
developed," and every gap is a visible hole rather than a buried sentence.

The notation was standardized by a community of industry and academic users
in 2011 and is now routine across the safety-critical sector, with spillover
uses in security, patents, and legal argument. Its sharpest criticism came
from the Nimrod aircraft-loss review: an argument diagram built to justify a
predetermined "safe" verdict can *launder* overconfidence — structure audits
coherence, not truth.

## Key terms

- **Assurance case / safety case** — a structured argument, supported by
  evidence, that a system satisfies a property (safety, security) in a given
  context; the deliverable regulators assess.
- **Goal** — a claim to be substantiated; drawn as a rectangle. The top goal
  is the property being argued; subgoals are its decomposition.
- **Strategy** — the stated reasoning move that decomposes a goal into
  subgoals ("argue over each identified hazard"); drawn as a parallelogram.
  Making the decomposition rationale an explicit node is GSN's version of
  Toulmin's warrant.
- **Solution (evidence)** — the artifact that terminates a branch: test
  result, analysis, inspection; drawn as a circle.
- **Context / Assumption / Justification** — side nodes scoping the argument:
  the environment a goal applies in, the propositions taken without argument,
  the rationale for a goal or strategy being appropriate.
- **Undeveloped entity** — an explicit marker (hollow diamond) that a goal or
  strategy is not yet supported; the notation's way of making gaps visible
  rather than implicit.
- **SupportedBy / InContextOf** — the two relationship types: inferential or
  evidential support (solid arrow) versus contextual scoping (hollow arrow).
- **Modular extension (modules, away goals)** — packaging a subtree as a
  module whose goals other parts of the case cite from a distance, letting
  large cases compose from parts.
- **Argument pattern** — a reusable argument template with the
  system-specifics abstracted out; introduced by Kelly's construction method.
- **GSN Community Standard** — the community-maintained definition of the
  notation (2011; version 3 in 2022, under the Safety-Critical Systems Club's
  Assurance Case Working Group).
- **Claims-Arguments-Evidence (CAE)** — the main alternative notation, built
  on the same claim → argument → evidence triad.

## Technical summary

An assurance case in GSN is a directed acyclic graph of goals decomposed via
explicit strategies into subgoals, terminating in solutions, with context,
assumption, and justification nodes scoping each step via InContextOf
relations and all support flowing through SupportedBy relations. Undeveloped
entities mark unsupported goals, so the argument's completeness is a
*syntactic* property: a case is structurally complete iff every leaf is a
solution and no undeveloped markers remain — checkable mechanically, while
the adequacy of each solution and strategy stays a matter of expert
judgment. Modules and away goals give the notation compositionality; argument
patterns give it reuse; CAE occupies the same design space with a smaller
vocabulary.

Epistemically, GSN is a Toulmin-descended justification graph deployed at
industrial scale: strategies are warrants promoted to nodes, solutions are
grounds, context/assumption nodes carry what ATMS-style systems would call
the environment. The structural-completeness check is precisely a
groundedness floor — an
[ungrounded inference](/glossary/ungrounded-inference.md) mid-tree
invalidates everything above it — and the Haddon-Cave "self-fulfilling
prophesy" critique is the permanent caveat on all such machinery: a
mechanically well-formed argument can still be built backwards from its
conclusion, so structure checking must never be sold as truth checking.

## Why it is in this brain

Assurance cases are the code-facing proof-of-concept for overlaying an
epistemic structure on engineering artifacts: a claim tree over a system,
mechanically checkable for shape while the leaf judgments stay human/expert.
That is the shape of auditing the *claims about* code — design docs, ADRs,
comments — against the artifact itself. See the
[belief-decomposition analysis](/meta/analysis/belief-decomposition-derived-vs-authored.md)
and the [Toulmin model](/knowledge-management/argumentation/toulmin-model-of-argument.md),
GSN's intellectual ancestor.

# Citations

- Goal structuring notation — Wikipedia:
  <https://en.wikipedia.org/wiki/Goal_structuring_notation>
- GSN Community Standard (Assurance Case Working Group, Safety-Critical
  Systems Club): <https://scsc.uk/gsn> —
  [captured passages from Version 1](/knowledge-management/argumentation/gsn-community-standard.md).
