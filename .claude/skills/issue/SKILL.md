---
name: issue
description: List tracked operational problems (type issue) under meta/issues/, grouped by status. Use when the operator says "/issue", "/issue list", "what issues are open", "show me the open issues", or wants to review the brain's tracked problems.
---

# /issue — review tracked issues

List `type: issue` documents under [`meta/issues/`](/meta/issues/index.md). An
**issue** is a tracked operational problem, defect, or open concern about how the
brain or its tooling behaves — recorded for follow-up. It is *not* a
[`todo`](/meta/todos/index.md) (a plain task) or a
[`plan`](/meta/plans/index.md) (a design/decision record). Follow the
[operating contract](/CLAUDE.md).

Issues live in the **governance namespace**, so — like `todos`, `plans`, and
`threads` — they carry **no `sb:` id** and are outside the identity registry.

This skill is **list-focused**: it surfaces open issues so they can be reviewed
and acted on. *Filing* a new issue is a heavier act governed by the contract's
issue conventions (a distilled problem statement, a `status`, and index upkeep) —
do that inline per the contract when a problem warrants tracking; this skill does
not create issues.

## Dispatch

`/issue [open|resolved|wontfix|all]` — the argument filters by `status`. Default
filter: **`open`**. If no argument is given, list open issues.

## List

1. **Read** every `meta/issues/*.md` (skip `index.md`), parsing each
   frontmatter's `title`, `description`, `status`, `priority` (if any), and
   `timestamp`.
2. **Filter** by the argument (`open` by default; `all` shows everything).
3. **Render** a concise grouped list to the operator — grouped by `status`,
   newest `timestamp` first within each group. Each row: title, one-line
   description, a bundle-absolute link to the file, and the `priority:` flag when
   present. Note the total count. This is a **read-only** view; do not modify
   anything.

For a cross-cutting appraisal that ranks issues against todos, plans, and
dangling strands, use [`/priorities`](/.claude/skills/priorities/SKILL.md)
instead — it is the whole-brain view; this skill is the issues-only slice.

## Guardrails
- **Read-only.** Listing changes no files. To resolve an issue, edit its doc
  (`status: resolved`/`wontfix`, bump `timestamp`) and move its index entry —
  per the contract, inline.
- Governance namespace — never mint an `sb:` id for an issue.
- Never touch `deprecated/`.
