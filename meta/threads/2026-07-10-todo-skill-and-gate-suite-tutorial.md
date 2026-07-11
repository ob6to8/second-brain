---
type: reference
title: 2026-07-10-todo-skill-and-gate-suite-tutorial
description: Added a lightweight `todo` type with a `meta/todos/` genre and a subcommand-dispatching `/todo` skill (create/list), then wrote a `meta/tutorials/` note explaining the repository gate suite — the eight CI checks in four kinds and the three surfaces they run on.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-10; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, todo, skills, types, tutorial, gates, ci]
timestamp: 2026-07-10
---

# 2026-07-10-todo-skill-and-gate-suite-tutorial

## Where this landed

Two governance-namespace additions, both shipped on
`claude/meta-todos-skill-j42my8`. First, a new **`todo` type** — a lightweight
actionable task item carrying a `status` (`open`/`done`/`cancelled`), distinct from
an `issue` (a problem) and a `plan` (a design record) — added to the controlled type
vocabulary, with a `meta/todos/` directory (no `sb:` ids, like `issues`/`plans`) and
a **`/todo` skill** that dispatches on a subcommand argument: `create <title>` files
a new open todo and maintains the index + `log.md`, `list` shows todos grouped by
`status`. The operator's request was treated as ratification of the new type and
directory. Second, a **tutorial** on the repository gate suite — framing the
integrity checks as an enforcement surface: the eight CI gates in four kinds (build;
generated-artifact freshness via `--check`; bundle validation via `mix brain.verify`
/ `mix brain.route_tags`; the `mix brain.site` render), what turns each red and its
fix, and the three widening scopes they run at (an agent's scoped manual pass, the
opt-in pre-commit hook, the authoritative CI job) — cross-linking the existing
three-bundle-scanners note rather than duplicating it. The session closed with a
`/create-pull-request` run (this capture is its first step).

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| New `todo` type + `meta/todos/` genre | closed | [/meta/policy/controlled-type-vocabulary.md](/meta/policy/controlled-type-vocabulary.md) | - |
| `/todo` skill (create/list subcommand dispatch) | closed | [/.claude/skills/todo/SKILL.md](/.claude/skills/todo/SKILL.md) | - |
| One dispatching skill vs. separate `/todo-create` + `/todo-list` | closed | [/.claude/skills/todo/SKILL.md](/.claude/skills/todo/SKILL.md) | - |
| Tutorial on the repository gate suite | closed | [/meta/tutorials/the-gate-suite-and-where-it-runs.md](/meta/tutorials/the-gate-suite-and-where-it-runs.md) | - |
| Avoid fragmenting vs. the three-bundle-scanners tutorial | closed | [/meta/tutorials/the-gate-suite-and-where-it-runs.md](/meta/tutorials/the-gate-suite-and-where-it-runs.md) | - |
| `/create-pull-request` run for this session | closed | `unrouted` | - |

## User

Create meta/todos, which will hold files of type todo. New todos can be added with a /todo skill we should author. Operations would be create and list - either as arguments to the skill or as separate skills ie. /toodo-create or /todo-list

## Assistant

<routes ref=".claude/skills/todo/SKILL.md meta/policy/controlled-type-vocabulary.md">
No hardcoded type list — types are open (tolerant consumer), governed only by the policy vocabulary. Everything is clear. Here's my plan:

1. Add `todo` to the controlled type vocabulary policy, then re-render `CLAUDE.md`.
2. Create `meta/todos/` with an `index.md`, register it in `meta/index.md`.
3. Author a `/todo` skill (dispatches on `create` / `list` subcommand argument).
4. Update `meta/log.md`.

The operator's request itself ratifies the new `todo` type and `meta/todos/` directory. Let me start with the policy.
</routes>

## Assistant

<routes ref=".claude/skills/todo/SKILL.md meta/policy/controlled-type-vocabulary.md">
Done. Committed and pushed to `claude/meta-todos-skill-j42my8`.

## What I built

**New `todo` type** — a lightweight actionable task item carrying a `status` (`open`/`done`/`cancelled`), added to the [controlled type vocabulary](meta/policy/controlled-type-vocabulary.md). It's deliberately distinct from an `issue` (a problem to diagnose) and a `plan` (a design/decision record) — a todo is just a task to complete.

**`meta/todos/` genre** — a governance-namespace directory (like `issues`/`plans`/`threads`, so **no `sb:` ids**), with an `index.md` that groups todos into Open vs. Done/Cancelled. Registered it in `meta/index.md`.

**`/todo` skill** (`.claude/skills/todo/SKILL.md`) — a single skill that dispatches on a subcommand argument, matching your "arguments to the skill" option:
- `/todo create <title>` — files a new `type: todo` doc (frontmatter with `status: open`), and maintains the index + `log.md`.
- `/todo list [open|done|cancelled|all]` — read-only view, todos grouped by `status`, newest first.

I went with **one dispatching skill** rather than separate `/todo-create` + `/todo-list` skills — it keeps the registry tidy and the two operations discoverable under one entry. Easy to split later if you'd prefer distinct commands.

Two notes on choices I made, since they touch the *shape* of the brain:
- Per the contract, a new `type` and a new directory normally need operator ratification — I treated your request as that ratification. Say the word if you'd rather I'd have proposed first.
- I filed todos with plain kebab-case slugs (no `YYYY-MM-DD-` prefix), consistent with the sibling `issues`/`plans` genres, since todos are topical tasks rather than journal entries.
</routes>

## User

Great. Create a tutorial in meta/tutorials around how gates work in this repo, ie. "All three gates pass: mix brain.verify, mix brain.contract --check, and mix brain.route_tags."

## Assistant

<routes ref="meta/tutorials/the-gate-suite-and-where-it-runs.md">
This is genuinely new material — the existing `the-three-bundle-scanners` tutorial covers the *internal scanner architecture*, not the **gate system** as an enforcement surface (what a gate is, the full suite, and the three places gates run). I'll write a gate-focused tutorial and cross-link the scanners one rather than duplicate it.
</routes>

## Assistant

<routes ref="meta/tutorials/the-gate-suite-and-where-it-runs.md">
Done. Committed and pushed to `claude/meta-todos-skill-j42my8`.

## What I wrote

[`meta/tutorials/the-gate-suite-and-where-it-runs.md`](meta/tutorials/the-gate-suite-and-where-it-runs.md) — a `type: tutorial` explaining the repo's gates as an **enforcement surface**, which is what your quoted line ("all three gates pass…") is a report of. It covers:

- **A gate defined** — a `mix` task that exits 0 when the bundle is good; nothing merges to `main` red.
- **The full suite** — the eight CI checks in a table (compile, format, test, `contract --check`, `registry --check`, `verify`, `route_tags`, `site`).
- **Four kinds** — build gates, generated-artifact *freshness* gates (the `--check` pair, where the fix is to regenerate not hand-edit), *validation* gates (`verify`/`route_tags`, with exactly what turns each red), and the site build-artifact gate.
- **Three surfaces** — the agent's scoped manual pass (why the common subset is `verify` + `contract --check` + `route_tags` — those are what content edits move), the opt-in pre-commit hook, and the authoritative CI job that runs the full superset.
- **Reading a red gate** — a fix keyed to each gate's kind.

### Avoiding fragmentation
There's an existing `the-three-bundle-scanners.md` tutorial, but it's about the *internal scanner architecture* (the shared `Registry.scan/1` crawler and its consumers) — not the gate/enforcement model. Rather than duplicate the mechanics, the new note **cross-links** it and stays focused on "what the checks prove and where they run." I also cross-linked the offline-toolchain and Pages-gating tutorials where relevant.

### Housekeeping
Registered it in the tutorials index, logged it in `meta/log.md`, and dogfooded the three content gates (all green) before committing.
</routes>

## User

_(operator invoked `/create-pull-request`)_

## Assistant

_(this capture — freezing the session into this thread doc — is the first step of that `/create-pull-request` run, followed by the commit, push, and PR.)_
