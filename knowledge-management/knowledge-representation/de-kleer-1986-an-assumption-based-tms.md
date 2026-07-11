---
id: sb:d82615
type: source
title: "de Kleer (1986), \"An Assumption-based TMS\" — key passages"
description: "Primary-source capture of Johan de Kleer's ATMS paper (Artificial Intelligence 28:127–162): verbatim definitions of assumptions as primitive data, environments, labels (consistent/sound/complete/minimal), contexts, nogoods, and subset-test context membership."
resource: https://doi.org/10.1016/0004-3702(86)90080-9
provenance: "Verbatim passages extracted from the author's scanned copy at dekleer.org (Publications/An Assumption-Based TMS.pdf), fetched 2026-07-11"
tags: [source, truth-maintenance, atms, de-kleer, environments, labels, nogoods, classic-ai, primary-source]
timestamp: 2026-07-11
---

# de Kleer (1986), "An Assumption-based TMS" — key passages

Johan de Kleer, "An assumption-based TMS," *Artificial Intelligence* 28(2):
127–162, 1986. The paper that replaced the single-belief-state TMS with
assumption-set labels and multi-context reasoning. Verbatim passages below.

## The move beyond justifications (abstract)

> Unlike previous truth maintenance systems which were based on manipulating
> justifications, this truth maintenance system is, in addition, based on
> manipulating assumption sets. As a consequence it is possible to work
> effectively and efficiently with inconsistent information, context switching
> is free, and most backtracking (and all retraction) is avoided.

## Against the single consistent state (§1.1–1.2)

> In a justification-based TMS a status of *in* (believed) or *out* (not
> believed) is associated with every problem-solver datum. The entire set of
> *in* data define the current context.

> On the other hand, in an ATMS each datum is labeled with the sets of
> assumptions (representing the contexts) under which it holds. […] The idea
> is that the assumptions are the primitive data from which all other data are
> derived.

> In an assumption-based TMS, one can tell directly whether an assertion is
> affected or not, so demanding consistency is unnecessary.

## Doyle's system, as summarized by de Kleer (§3.1)

> A node is believed, or *in*, if it has a valid justification. A
> justification is valid, if each of the nodes of its inlist are *in* and each
> of the nodes of its outlist are *out*.

> An assumption is a node with a current supporting justification with a
> nonempty outlist.

## Environments, contexts, labels, nogoods (§4)

> An ATMS environment is a set of assumptions. Logically, an environment is a
> conjunction of assumptions.

> An environment is inconsistent if false […] is derivable propositionally.

> An ATMS context is the set formed by the assumptions of a consistent
> environment combined with all nodes derivable from those assumptions.

> An ATMS label is a set of environments associated with every node.

The four label properties (§4, condensed to the paper's own formulations): a
label is **consistent** "if all of its environments are consistent"; **sound**
if the node "is derivable from each E of the label"; **complete** if "every
consistent environment E for which J ⊢ E → n is a superset of some
environment E′ of n's label"; and **minimal** "if no environment of the label
is a superset of any other."

> The assumption set […] which caused the contradiction is recorded so that
> the set can be avoided in the future. These are called the *nogood* sets
> […] as they represent assumptions which are mutually contradictory.

> Context membership is a simple subset test in the ATMS.

## Orientation (§3)

> Conventional TMSs are oriented to finding one solution, and extra cost is
> incurred to control the TMS to find many solutions. The ATMS is oriented to
> finding all solutions, and extra cost is incurred to control the ATMS to
> find fewer solutions.

## Why this capture exists

Primary grounding for the ATMS mechanics summarized in
[truth maintenance systems (TMS / RMS)](/knowledge-management/knowledge-representation/truth-maintenance-systems.md)
— in particular the environment/label/nogood/context machinery cited by the
[belief-decomposition analysis](/meta/analysis/belief-decomposition-derived-vs-authored.md)
as the model for comparing internally-coherent, mutually-inconsistent belief
systems without merging them.

# Citations

- Johan de Kleer, "An assumption-based TMS," *Artificial Intelligence* 28(2),
  1986: <https://doi.org/10.1016/0004-3702(86)90080-9>
- Author's scanned copy:
  <https://dekleer.org/Publications/An%20Assumption-Based%20TMS.pdf>
