# Elaborations

Persisted expansions of technical phrases and short passages, produced by
[`/elaborate`](/.claude/skills/elaborate/SKILL.md). Each doc quotes its target
phrase, then unpacks it in three parts: a jargon-free restatement, definitions
of the terms it uses (linking [`/glossary/`](/glossary/index.md) files and
defining concepts rather than re-inventing them), and a less technical
walkthrough of the concepts and actions described.

Each elaboration is a `type: elaboration` doc in the governance namespace (no
`sb:` id). Once the session that prompted it is captured, the doc carries a
**`thread`** frontmatter field back-linking the persisted thread under
[`meta/threads/`](/meta/threads/index.md) — set by
[`/create-pull-request`](/.claude/skills/create-pull-request/SKILL.md) after
its `/capture` step, so every elaboration can be traced to the conversation
that needed it.

Distinct from the sibling genres: a [`glossary`](/glossary.md) entry defines
one *term*, source-independent; a [`tutorial`](/meta/tutorials/index.md)
explains a standalone subject long-form; an elaboration unpacks *one specific
mouthful in its context*.

## Contents

- [two-directional materialize with unconditional orphan-block removal](/meta/elaborations/two-directional-materialize.md) —
  unpacks the P1 work-package phrase from the code-review hardening plan:
  making the route-tag log materializer remove generated content whose source
  tags vanished, automatically and without a flag.
