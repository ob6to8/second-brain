---
type: reference
title: 2026-07-12-priorities-skill-and-persistence-listers
description: Moved the session-init open-work appraisal off the SessionStart hook into an on-demand /priorities skill, slimmed the hook to toolchain bootstrapping only, and added list-focused /issue and /plan skills alongside the existing /todo — updating the skills-registry policy, recompiling the contract, and correcting the tutorial, glossary, and README in place.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-12; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, priorities, skills, hooks, session-init, tooling]
timestamp: 2026-07-12
session: https://claude.ai/code/session_01LLFfnKXnCGFDUnA5vakBJk
pr: 57
---

# 2026-07-12-priorities-skill-and-persistence-listers

Verbatim render. Retained operator messages and agent responses are reproduced
**verbatim** (the delivered text); only tool calls, tool results, reasoning, and
short pre-tool narration are stripped. The two design decisions below arrived via
the `AskUserQuestion` tool (a tool result, so dropped from the render) and are
recorded in *Where this landed*. Rendered from context via `/capture`'s
render-from-context path.

## Where this landed

The operator asked to **move the priorities work off the SessionStart hook into
a `/priorities` skill**, and to add skills for the persistence types — todos,
plans, and issues — where invoking each skill lists all open artifacts of its
type. `/todo` already existed (create + list), so the new work was `/priorities`,
`/issue`, and `/plan`.

Two design questions were put to the operator before building. **Hook behavior:**
the SessionStart hook auto-injected the full digest (open issues/todos/plans/
dangling strands + heuristic top-3 + an "open with a priority appraisal" agent
note) into every session — should it keep doing that? The operator chose *"Delet
the hook, skill only"* — priorities become skill-only. **Issue/plan scope:**
should `/issue` and `/plan` match `/todo`'s create+list, or list only? The
operator chose *"List-focused"*.

The build:

- **Three new skills** under `.claude/skills/`: `/priorities` (runs
  `mix brain.session_init` and relays the digest with the agent's own top-3
  appraisal — the on-demand successor to the hook digest), and the list-focused
  `/issue` and `/plan` (each lists its `meta/` genre by `status`, default `open`
  for issues and `active` for plans; read-only slices of `/priorities`, with
  creation left inline per the contract).
- **The hook was slimmed, not deleted.** The SessionStart hook did *two* jobs —
  emit the digest *and* install/warm Elixir in Claude-on-web sandboxes so
  `mix brain.*` (including the new skill) works. Deleting it wholesale would
  break the very skill being built, so the digest emission was removed and the
  toolchain bootstrap kept, with a one-line `run /priorities` pointer. This
  deviation from the literal "delete the hook" answer was flagged to the operator
  with an offer to delete the file entirely if they don't need remote toolchain
  bootstrapping.
- **The engine kept its name.** `SecondBrain.SessionInit` / `mix brain.session_init`
  stays as-is (renaming would ripple through the glossary term, tutorial, README,
  and analysis docs that name "session-init digest"); only its moduledoc and the
  closing agent note were reworded for on-demand invocation. Logic, weights, and
  the `priority:` escape hatch are unchanged; suite 108/108 green.
- **Policy + contract + docs:** the skills-registry policy gained the three
  entries and `CLAUDE.md` was recompiled; the-session-init-digest tutorial, the
  session-init-digest glossary term, and the README were corrected in place to
  describe on-demand `/priorities` rather than auto-injection.

All gates pass: format, tests (108/108), `contract --check`, `registry --check`,
`verify`, `route_tags`. Shipped on branch
`claude/priorities-skill-persistence-vmp9tn`.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| `/priorities` skill — on-demand successor to the auto-injected session-init digest | closed | [session-init-digest](/glossary/session-init-digest.md) | - |
| SessionStart hook slimmed to toolchain-only — digest emission removed, Elixir bootstrap kept | closed | [SessionStart hook](/glossary/sessionstart-hook.md) | Operator may still want the hook file deleted entirely (agent kept toolchain bootstrap) |
| List-focused `/issue` and `/plan` skills — read-only slices of `/priorities` | closed | `unrouted` (skills; back-linked to [issue](/.claude/skills/issue/SKILL.md) and [plan](/.claude/skills/plan/SKILL.md)) | - |

## User

Currently each sessions work to be done according to a Prioritize list via a session start hook. Let's move this work to a new skill called priorities, which will list the prioritized items to be done.

Let's also create skills if they don't already exist for various persistence types for work to be done. I believe this is to dos and plans, though there may... oh, and issues. So if We could make each of these a skill, and entering that skill would list all open, uh, artifacts of the type relating to the skill invoked.

## Assistant

<routes ref="em:6f2442 lib/elixir_mind/session_init.ex">
Done. Pushed to `claude/priorities-skill-persistence-vmp9tn`.

**`/priorities` skill** — the on-demand successor to the session-start digest. It runs the existing `mix brain.session_init` (open issues, todos, active plans, dangling ledger strands + heuristic top-3) and has the agent relay it with its own judged appraisal. The ranking engine, class weights, and `priority:` escape hatch are unchanged — only *how it reaches a session* moved.
</routes>

**`/issue` and `/plan` skills** — list-focused, as you asked. Each lists open artifacts of its type grouped by status (`/issue` defaults to `open`; `/plan` defaults to `active` = proposed/accepted/in-progress). They're read-only slices of `/priorities`; creation stays inline per the contract. `/todo` already covered todos (create + list), so I left it as-is.

<routes ref="em:71f38a .claude/hooks/session-start.sh">
**The hook** — one caveat worth flagging: you said "delete the hook," but the SessionStart hook did *two* jobs — emit the digest *and* install/warm Elixir in remote (Claude-on-web) sandboxes. That toolchain bootstrap is what makes `mix brain.*` — including the new `/priorities` skill itself — work at all in a fresh remote session. Deleting it entirely would break the very skill I was building. So I **removed the digest emission** (the "priorities work" is now skill-only, as you wanted) and **kept the toolchain bootstrap**, with a one-line `run /priorities` pointer. If you'd rather the file be gone completely and are fine expecting Elixir to be pre-present, say so and I'll delete it.
</routes>

**Supporting updates**, all in one commit:
- `SecondBrain.SessionInit` moduledoc + agent note reworded for on-demand use (logic untouched)
- `skills-registry` policy updated → `CLAUDE.md` recompiled
- Docs corrected in place: the session-init tutorial, the `session-init-digest` glossary term, and the README (which now points at `/priorities`, `/issue`, `/plan`, `/todo`)

All gates green: format, **108/108 tests**, `contract --check`, `registry --check`, `verify`, `route_tags`.

Want me to open a PR?
