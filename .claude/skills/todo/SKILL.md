---
name: todo
description: Add and list lightweight task items (type todo) under meta/todos/. Use when the operator says "/todo", "/todo create <title>", "/todo list", "add a todo", "what's on my todo list", or otherwise wants to record or review a plain task to complete.
---

# /todo — track lightweight task items

Manage `type: todo` documents under [`meta/todos/`](/meta/todos/index.md). A **todo**
is a plain actionable task — a single thing to be done, tracked until finished. It is
*not* an [`issue`](/meta/issues/index.md) (a problem to diagnose) or a
[`plan`](/meta/plans/index.md) (a design/decision record); reach for those when the
work warrants them. Follow the [operating contract](/CLAUDE.md).

Todos live in the **governance namespace**, so — like `issues`, `plans`, and
`threads` — they carry **no `sb:` id** and are outside the identity registry.

## Dispatch

The first argument selects the operation. If no argument is given, infer from the
operator's phrasing (a task to record → **create**; a request to review → **list**);
if still ambiguous, ask.

- `/todo create <title / description of the task>` → **Create** (below).
- `/todo list [open|done|cancelled|all]` → **List** (below). Default filter: `open`.

---

## Create

1. **Derive the task.** Take the title/description from the argument. If nothing was
   provided, ask the operator what the task is.
2. **Dedup.** Grep `meta/todos/*.md` for an existing todo on the same task. If one
   exists and is still `open`, update it in place rather than filing a duplicate.
3. **Write the file** at `meta/todos/<kebab-slug-of-title>.md` (no date prefix — todos
   are topical, not journal entries), with this shape:
   ```
   ---
   type: todo
   title: "<short imperative title>"
   description: <one sentence saying what "done" means>
   status: open
   tags: [meta, todo]
   timestamp: <today, ISO 8601>
   ---

   # <title>

   <Optional body: context, acceptance criteria, and bundle-absolute links to any
   related concepts. Keep it short — a todo is a task, not a plan.>
   ```
   Add a `resource`/`provenance` field only when the task has an external anchor
   (a URL, a trigger id, a thread). Omit `verified` — a todo is not a statement.
4. **Maintain reserved files.**
   - Add a bulleted link under **Open** in [`meta/todos/index.md`](/meta/todos/index.md)
     with the one-line description and `status: open`.
5. **Verify & report.** Run `mix brain.verify` (a todo carries no `sb:` id, so no
   `mix brain.id`/`registry` step). Report the path written.

## List

1. **Read** every `meta/todos/*.md` (skip `index.md`), parsing each frontmatter's
   `title`, `description`, `status`, and `timestamp`.
2. **Filter** by the argument (`open` by default; `all` shows everything).
3. **Render** a concise grouped list to the operator — grouped by `status`, newest
   `timestamp` first within each group, each row: title, one-line description, and a
   bundle-absolute link to the file. Note the total count. This is a read-only view;
   do not modify anything.

## Completing / cancelling a todo

When the operator marks a todo done or cancelled: set its `status` to `done` or
`cancelled`, bump `timestamp`, and move its entry to the **Done / Cancelled** section
of the index. (A dedicated subcommand can be added later if this becomes frequent.)

## Guardrails
- A todo is a *task*, not a problem or a design — don't overload it; use `issue` or
  `plan` when those fit better.
- Keep it OKF-conformant: parseable frontmatter, non-empty `type: todo`.
- Governance namespace — never mint an `sb:` id for a todo.
- Never touch `deprecated/`.
