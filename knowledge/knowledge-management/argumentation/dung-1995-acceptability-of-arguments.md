---
id: em:148cd9
type: source
title: "Dung (1995), \"On the acceptability of arguments\" — abstract and core definitions"
description: "Primary-source capture of Dung's founding abstract-argumentation paper: the verbatim abstract, plus the standard formulations of its core definitions (framework, conflict-free, admissible, grounded/preferred/stable/complete extensions). NOTE: the definitions are standard formulations, not transcribed verbatim from the paper's body."
resource: https://doi.org/10.1016/0004-3702(94)00041-X
provenance: "Abstract quoted verbatim from the paper record at jmvidal.cse.sc.edu/lib/dung95a.html (fetched 2026-07-11). The definitions below are the standard textbook/encyclopedic formulations of Dung's notions (via the Wikipedia argumentation-framework article), NOT transcribed from the paper's own body — the full paper PDF was not accessed."
tags: [source, argumentation, dung, abstract-argumentation, primary-source, semantics]
timestamp: 2026-07-11
attribution:
  when: 2026-07-13T20:23:58+00:00
  channel: intake
  agent: "Claude Code agent, /intake"
  why: "operator-directed primary-source grounding of the belief-decomposition prior-art references"
---

# Dung (1995), "On the acceptability of arguments" — abstract and core definitions

Phan Minh Dung, "On the acceptability of arguments and its fundamental role in
nonmonotonic reasoning, logic programming and n-person games," *Artificial
Intelligence* 77(2): 321–357, 1995.

> **Note on fidelity.** The abstract below is verbatim. The definitions that
> follow are the *standard formulations* of Dung's notions as given in reference
> works, **not** passages transcribed from the paper's body — the full PDF was
> not accessed for this capture. They are faithful to the theory but should not
> be cited as the paper's exact wording.

## Abstract (verbatim)

> The purpose of this paper is to study the fundamental mechanism, humans use in
> argumentation, and to explore ways to implement this mechanism on computers.
> We do so by first developing a theory for argumentation whose central notion
> is the acceptability of arguments. Then we argue for the 'correctness' or
> 'appropriateness' of our theory with two strong arguments. The first one shows
> that most of the major approaches to nonmonotonic reasoning in AI and logic
> programming are special forms of our theory of argumentation. The second
> argument illustrates how our theory can be used to investigate the logical
> structure of many practical problems. This argument is based on a result
> showing that our theory captures naturally the solutions of the theory of
> n-person games and of the well-known stable marriage problem. By showing that
> argumentation can be viewed as a special form of logic programming with
> negation as failure, we introduce a general logic-programming-based method for
> generating meta-interpreters for argumentation systems, a method very much
> similar to the compiler-compiler idea in conventional programming.

## Core definitions (standard formulations — not verbatim)

- **Argumentation framework** — a pair ⟨A, R⟩ where A is a set of arguments and
  R ⊆ A×A is the attack relation; equivalently a directed graph.
- **Conflict-free** — a set E ⊆ A is conflict-free if no argument in E attacks
  an argument in E.
- **Acceptable / defends** — an argument a is acceptable with respect to E (E
  defends a) if every argument attacking a is itself attacked by some argument
  in E.
- **Admissible** — E is admissible if it is conflict-free and defends each of
  its members.
- **Complete extension** — an admissible set that contains every argument it
  defends.
- **Grounded extension** — the least (⊆-minimal) complete extension; unique and
  most skeptical.
- **Preferred extension** — a ⊆-maximal admissible set.
- **Stable extension** — a conflict-free set that attacks every argument not in
  it.

Hierarchy: every stable extension is preferred; every preferred extension is
complete; the grounded extension is the least complete extension.

## Why this capture exists

Grounds the [Dung abstract argumentation frameworks](/knowledge/knowledge-management/argumentation/dung-abstract-argumentation-frameworks.md)
reference and the analysis's conflict/consensus machinery — in particular the
[consensus core](/beliefs/glossary/consensus-core.md) (grounded extension) and the
claim that conflict is a separate, possibly-cyclic
[attack relation](/beliefs/glossary/argumentation-framework.md) resolved by semantics.

# Citations

- P. M. Dung, "On the acceptability of arguments and its fundamental role in
  nonmonotonic reasoning, logic programming and n-person games," *Artificial
  Intelligence* 77(2): 321–357, 1995:
  <https://doi.org/10.1016/0004-3702(94)00041-X>
- Abstract source: <https://jmvidal.cse.sc.edu/lib/dung95a.html>
- Definitions source: <https://en.wikipedia.org/wiki/Argumentation_framework>
