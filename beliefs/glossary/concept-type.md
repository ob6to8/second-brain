---
id: em:4a590f
type: concept
title: concept (type)
description: Controlled type for a definition or mental model — but in practice two speech acts sharing a name (term definition vs accepted proposition), a tension recorded for redefinition.
provenance: "Agent-distilled glossary definition, pointer to the defining policy"
verified: false
tags: [glossary, types, vocabulary]
sense: repo
timestamp: 2026-07-15
attribution:
  when: 2026-07-15T00:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced while replicating the concept/document terminology split from PR 71"
---

# concept (type)

The controlled `type` for "a definition or mental model (established/accepted)",
defined by the
[controlled-type-vocabulary policy](/meta/policy/controlled-type-vocabulary.md).
It is one of the three [statement types](/beliefs/glossary/statement-type.md)
(`claim`/`note`/`concept`) that may carry a `verified` field, and the graduation
target a grounded [claim](/beliefs/glossary/statement-type.md) may reach.

In practice the type is **two speech acts under one name**: *term definition*
(what the glossary machinery mass-produces — one per term, source-independent,
almost always unverified) and *accepted proposition* (the graduation target of a
verified claim). The parenthetical "(established/accepted)" is enforced by
nothing and false for ~98% of the corpus. This tension — and the open questions
on resolving it — is recorded in the
[concept-terminology plan](/meta/plans/concept-terminology-and-type-redefinition.md).
Distinct from [document (OKF)](/beliefs/glossary/document-okf.md), the *unit* the
OKF spec calls a "concept document" (any frontmatter-plus-body file, regardless
of type).

*Seen in:* [concept-terminology plan](/meta/plans/concept-terminology-and-type-redefinition.md)
