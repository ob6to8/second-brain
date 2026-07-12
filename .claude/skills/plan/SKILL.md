---
name: plan
description: List design/decision records (type plan) under meta/plans/, grouped by status. Use when the operator says "/plan", "/plan list", "what plans are active", "show me the open plans", or wants to review intended work on the brain.
---

# /plan — review intended work

List `type: plan` documents under [`meta/plans/`](/meta/plans/index.md). A
**plan** is a design/decision record for a proposed change to the brain or its
tooling — motivation, the shape of the change, scope boundaries, and open
questions — so a future session can execute against something concrete. It is
*not* an [`issue`](/meta/issues/index.md) (a problem to track) or a
[`todo`](/meta/todos/index.md) (a plain task). Follow the
[operating contract](/CLAUDE.md).

Plans live in the **governance namespace**, so — like `issues`, `todos`, and
`threads` — they carry **no `sb:` id** and are outside the identity registry.

This skill is **list-focused**: it surfaces active plans so they can be reviewed
and picked up. *Persisting* a new plan is governed by the contract's
[persist-plans policy](/CLAUDE.md) (the problem, the decisions and their
reasoning, the artifact shape, the build order, and a `status`) — do that inline
per the contract when the operator approves a plan of substance; this skill does
not create plans.

## Dispatch

`/plan [active|proposed|accepted|in-progress|done|superseded|all]` — the argument
filters by `status`. Default filter: **`active`** = `proposed` + `accepted` +
`in-progress` (the plans that still represent work; `done` and `superseded` are
history). If no argument is given, list active plans.

## List

1. **Read** every `meta/plans/*.md` (skip `index.md`), parsing each frontmatter's
   `title`, `description`, `status`, `priority` (if any), and `timestamp`.
2. **Filter** by the argument (`active` by default; `all` shows every status).
3. **Render** a concise grouped list to the operator — grouped by `status`
   (`in-progress`, then `accepted`, then `proposed` for the active view), newest
   `timestamp` first within each group. Each row: title, one-line description, a
   bundle-absolute link to the file, and the `priority:` flag when present. Note
   the total count. This is a **read-only** view; do not modify anything.

For a cross-cutting appraisal that ranks plans against issues, todos, and
dangling strands, use [`/priorities`](/.claude/skills/priorities/SKILL.md)
instead — it is the whole-brain view; this skill is the plans-only slice.

## Guardrails
- **Read-only.** Listing changes no files. To advance a plan's lifecycle, edit
  its doc (`status`, bump `timestamp`) and move its index entry — per the
  contract, inline.
- Governance namespace — never mint an `sb:` id for a plan.
- Never touch `deprecated/`.
