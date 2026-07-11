---
type: reference
title: 2026-07-11-session-init-digest-and-priorities
description: Built the session-init digest — SecondBrain.SessionInit + mix brain.session_init scan open issues, active plans, and dangling routing-ledger strands into a heuristic top-3 priority ranking — and wired it into the SessionStart hook so every fresh session opens against the brain's open work; closed via /create-pull-request.
provenance: "Claude Code session (Claude Fable 5), 2026-07-11; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, session-init, hooks, priorities, tooling]
timestamp: 2026-07-11
---

# 2026-07-11-session-init-digest-and-priorities

Verbatim render. Retained operator messages and agent responses are reproduced
**verbatim** (the delivered text); only tool calls, tool results, reasoning, and
short pre-tool narration are stripped. Rendered from context via `/capture`'s
render-from-context path.

## Where this landed

The operator asked for a session init log — "maybe connected to a session_start
hook" — that surfaces open issues, todos, and plans into the thread with a top-3
priority appraisal. The session mapped "todos" to what the brain already
maintains (dangling routing-ledger strands: `open`/`paused` rows, plus `closed`
rows that left a Dangling question) and built
[`SecondBrain.SessionInit`](/lib/second_brain/session_init.ex) +
`mix brain.session_init`: a scan of `meta/issues/` (status `open`),
`meta/plans/` (`proposed`/`accepted`/`in-progress`), and the `## Routing`
ledgers under `meta/threads/`, rendered as a markdown digest ending in a
heuristic top-3 ranking (issues > in-flight plans > open strands >
paused/dangling strands > proposed plans, newest first within a class, with
strands deduped against docs their ledger routed to). The
[SessionStart hook](/.claude/hooks/session-start.sh) now echoes the digest into
each fresh session's context, closing with an agent note to open the thread
with a *judged* appraisal — the script ranks, the agent judges. Covered by
three new ExUnit tests (suite 81/81 green); all bundle gates pass. The digest
fired live on this session's own resume. The session closed via
`/create-pull-request` (this capture, the glossary pass, and the PR).

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Session-init digest tooling — `SecondBrain.SessionInit` + `mix brain.session_init` (open issues, active plans, dangling ledger strands; heuristic top-3 with same-matter dedup) | closed | `unrouted` (tooling; back-linked to [session_init.ex](/lib/second_brain/session_init.ex)) | Soften the open-every-session agent note if the appraisal proves noisy |
| SessionStart hook wiring — digest echoed into fresh-session context; Elixir install stays gated on remote | closed | `unrouted` (back-linked to [session-start.sh](/.claude/hooks/session-start.sh)) | - |
| Session close via `/create-pull-request` — capture, glossary pass, commit/push, PR | closed | `unrouted` | - |

## User

Create a session init log, maybe connected to a session_start hook, which logs into the thread open issues, todos, and plans, with an appraisal of what should be the top 3 priorities

## User

Continue

## Assistant

<routes ref="lib/second_brain/session_init.ex lib/mix/tasks/brain.session_init.ex .claude/hooks/session-start.sh test/second_brain/session_init_test.exs">
The picture is complete. My design: a new `SecondBrain.SessionInit` module + `mix brain.session_init` task that scans open issues (`meta/issues`), active plans (`meta/plans`), and dangling strands from thread routing ledgers, emits a digest with a heuristic top-3 priority ranking, and gets called by the SessionStart hook so it lands in the session context. Let me check the test idiom first.

Done — pushed to `claude/session-init-log-priorities-vuvzo6`. Every fresh session will now open with a **session-init digest** injected into context by the SessionStart hook, ending in a top-3 priority appraisal.

**What was built**

* **`SecondBrain.SessionInit`** (`lib/second_brain/session_init.ex`) — scans the three places open work already lives under your existing policies, so nothing new needs to be maintained:
  * **Open issues**: `meta/issues/*.md` with `status: open`
  * **Active plans**: `meta/plans/*.md` with status `proposed`/`accepted`/`in-progress`
  * **Todos**: dangling strands from thread routing ledgers — rows in state `open`/`paused`, plus `closed` rows that still carry a Dangling question (e.g. the "Tier-1 not yet implemented" leftover in the vector-DB thread)
* **`mix brain.session_init`** — prints the digest; runnable any time, not just at startup.
* **Heuristic top-3 ranking** with a stated reason per pick: open issues > in-progress plans > accepted plans > open strands > paused strands > leftover dangling questions > proposed plans, newest first within a class. A strand whose ledger routed to an already-picked doc is skipped as the same matter (this mattered on your real data — the /news issue and its thread strand collapsed to one pick).
* **Hook wiring**: `.claude/hooks/session-start.sh` now echoes the digest after the Elixir setup, ending with an agent note to open the thread by stating a *judged* top-3 appraisal — the script ranks deterministically, the agent refines with judgment. The apt install stays gated on remote sessions; the digest runs wherever `mix` exists.
* **Logged** in `meta/log.md` under 2026-07-11.

On today's bundle the heuristic picks: (1) the open /news Routine issue, (2) the undecided "open a PR for the branch" strand, (3) the paused epistemic-overlay design question.

**Validation**

1. ✅ Hook execution — ran `CLAUDE_CODE_REMOTE=true ./.claude/hooks/session-start.sh` end-to-end; emits the ready line plus the full digest, exit 0.
2. ✅ Repo checks — `mix brain.verify`, `mix brain.route_tags`, `mix brain.contract --check`, `mix brain.registry --check` all pass (this repo's lint equivalent).
3. ✅ Tests — 3 new tests in `test/second_brain/session_init_test.exs`; full suite 81 tests, 0 failures.

The hook remains **synchronous**: the digest is guaranteed to be in context before the session's first turn (async would race it). Once this branch merges to `main`, all future sessions pick it up. One judgment call to flag: the digest instructs the agent to lead every session with the appraisal — if that gets noisy, we can soften the agent note to only surface it when relevant.
</routes>
