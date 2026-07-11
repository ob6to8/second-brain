---
id: sb:601006
type: source
title: "Doyle (1979), \"A Truth Maintenance System\" — key passages"
description: "Primary-source capture of Jon Doyle's founding TMS paper (Artificial Intelligence 12:231–272): verbatim definitions of nodes and justifications, in/out statuses, SL-justifications, assumptions, well-founded support, and dependency-directed backtracking."
resource: https://doi.org/10.1016/0004-3702(79)90008-0
provenance: "Verbatim passages transcribed from the scanned reprint in Ginsberg (ed.), Readings in Nonmonotonic Reasoning, Morgan Kaufmann 1987, pp. 259–263 (fetched 2026-07-11); the open-access original is MIT AI Memo 521, https://dspace.mit.edu/handle/1721.1/5733"
tags: [source, truth-maintenance, doyle, jtms, belief-revision, classic-ai, primary-source]
timestamp: 2026-07-11
---

# Doyle (1979), "A Truth Maintenance System" — key passages

Jon Doyle, "A Truth Maintenance System," *Artificial Intelligence* 12(3):
231–272, 1979. The founding paper of justification-based truth maintenance.
Verbatim passages below; emphasis as in the original.

## The program and its purpose (abstract)

> To choose their actions, reasoning programs must be able to make assumptions
> and subsequently revise their beliefs when discoveries contradict these
> assumptions. The Truth Maintenance System (TMS) is a problem solver
> subsystem for performing these functions by recording and maintaining the
> reasons for program beliefs.

## Reasoning as recorded reasons, not derived truths (§1.1)

> Many treatments of formal and informal reasoning in mathematical logic and
> artificial intelligence have been shaped in large part by a seldom
> acknowledged view: the view that the process of reasoning is the process of
> deriving new knowledge from old, the process of discovering new truths
> contained in known truths.

> We use a program called the *Truth Maintenance System* (TMS) to determine
> the current set of beliefs from the current set of reasons, and to update
> the current set of beliefs in accord with new reasons in a (usually)
> incremental fashion.

## Nodes and justifications (§1.2)

> It manipulates two data structures: *nodes*, which represent beliefs, and
> *justifications*, which represent reasons for beliefs.

> Traditionally, a reason for a belief consists of a set of other beliefs,
> such that if each of these basis beliefs is held, so also is the reasoned
> belief.

Well-founded support (the anti-circularity condition):

> These non-circular arguments distinguish one justification as the
> *well-founded supporting justification* of each node representing a current
> belief.

## In and out; belief statuses (§2.1)

> The node is believed if and only if at least one of its justifications is
> valid. […] We say that a node which has at least one valid justification is
> *in* (the current set of beliefs), and that a node with no valid
> justifications is *out* (of the current set of beliefs).

> The distinction between *in* and *out* is not that between *true* and
> *false*.

## SL-justifications and assumptions (§2.3, §1.2)

> The SL-justification form has the form
> `(SL <inlist> <outlist>)`,
> and is valid if and only if each node in its *inlist* is *in*, and each node
> in its *outlist* is *out*.

> We define *assumptions* to be nodes whose supporting-justification has a
> nonempty *outlist*.

An earlier formulation of the same notion (§1.2):

> An *assumption* is a current belief one of whose valid reasons depends on a
> non-current belief, that is, has a non-empty second set of antecedent
> beliefs.

## Dependency-directed backtracking (§1.2)

> When this happens, another process of the TMS, *dependency-directed
> backtracking*, analyzes the well-founded argument of the contradiction node
> to locate the assumptions […] occurring in the argument.

## Why this capture exists

Primary grounding for the mechanics summarized in
[truth maintenance systems (TMS / RMS)](/knowledge-management/knowledge-representation/truth-maintenance-systems.md):
the node/justification split, IN/OUT non-monotonicity, well-founded support,
and dependency-directed backtracking are quoted here from the paper itself.

# Citations

- Jon Doyle, "A Truth Maintenance System," *Artificial Intelligence* 12(3),
  1979: <https://doi.org/10.1016/0004-3702(79)90008-0>
- Open-access memo version (MIT AIM-521):
  <https://dspace.mit.edu/handle/1721.1/5733>
- Scanned reprint used for transcription:
  <https://cse.buffalo.edu/~rapaport/Papers/Papers.by.Others/NONMONOTONIC/doyle79.pdf>
