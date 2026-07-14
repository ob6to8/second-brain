---
id: sb:60220a
type: concept
title: sense (glossary sense)
description: The frontmatter field classifying where a glossary term's usage lives — common (portable), repo (this brain's own vocabulary), or dual (both senses, defined common-first) — required on every glossary entry and gated by mix brain.verify.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, terminology, frontmatter]
sense: repo
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T10:49:49+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# sense (glossary sense)

The frontmatter field every glossary term file carries, classifying **where
the term's usage lives**: `common` (portable — industry, field, or ecosystem
vocabulary that means the same outside this repo), `repo` (this brain's own
vocabulary — coined here or naming local machinery), or `dual` (an established
common technical sense *plus* a specific repo referent). Dual entries define
the common sense first, then the local one in an **In this brain:** passage,
so local jargon never displaces the portable meaning; an everyday-English
second meaning does not make a term dual — only a technical common sense does.
The field is required on every entry under `/beliefs/glossary/` (verifier rule 7,
`mix brain.verify`) and not policed elsewhere; the conventions live in the
[`/add-to-glossary` skill](/.claude/skills/add-to-glossary/SKILL.md), the decision
record in the
[glossary sense-disambiguation plan](/meta/plans/glossary-sense-disambiguation.md).

*Seen in:* [2026-07-13 glossary sense-disambiguation thread](/meta/threads/2026-07-13-glossary-sense-disambiguation.md)
