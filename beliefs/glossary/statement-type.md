---
id: em:0fd614
type: concept
title: statement type
description: The class of document types (claim, note, concept) that carry agent-authored assertions and so may bear a `verified` field — as opposed to captures and every other type.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, types, verification]
sense: repo
timestamp: 2026-07-15
attribution:
  when: 2026-07-15T00:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced while replicating the concept/document terminology split from PR 71"
---

# statement type

The three controlled types — `claim`, `note`, and
[`concept`](/beliefs/glossary/concept-type.md) — whose documents are
*agent-authored assertions* that can be checked against evidence, and are
therefore the only types allowed to carry a
[`verified`](/beliefs/glossary/verified-by.md) field. `ElixirMind.Verifier`
encodes this as `@statement_types ~w(claim note concept)` and rejects a
`verified` field on any other type. The complement is a **capture** — a document
that stores a link (`resource`), for which verification is not possible.
Notably the verifier draws *no* distinction among the three statement types
themselves: the only enforceable difference between a `claim` and a `concept` is
the word in the frontmatter.

*Seen in:* [2026-07-15 concept→document replication thread](/meta/threads/2026-07-15-replicate-concept-document-terminology-from-pr-71.md), [concept-terminology plan](/meta/plans/concept-terminology-and-type-redefinition.md)

*See also:* [verification grounding](/beliefs/glossary/verification-grounding.md), [verified_by](/beliefs/glossary/verified-by.md), [provenance](/beliefs/glossary/provenance.md)
