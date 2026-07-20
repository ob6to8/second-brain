---
type: reference
title: 2026-07-10-sync-branch-with-main-skill
description: Created the /sync-branch-with-main skill (fetch/pull origin/main and merge it into the current feature branch), registered it in the skills policy, recompiled CLAUDE.md, then renamed it from an initial /sync-main.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-10; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, skills, git, tooling]
timestamp: 2026-07-10
session: https://claude.ai/code/session_01MHv6q9awxJjAZvjAzCe2JK
---

# 2026-07-10-sync-branch-with-main-skill

> _Transplant note (2026-07-13): this record was rescued from the unmerged
> `git-fetch-merge-skill-ke7adg` branch, whose skill was ported to `main` in
> PR #82 but whose session record had never been captured to `main` (the branch
> opened no PR of its own). It lands here via the port cleanup so the skill's
> build session isn't lost when that branch is deleted. The body below is the
> frozen 2026-07-10 session, verbatim; the `meta/log.md` it mentions has since
> been retired in favor of the commit graph._

## Where this landed

A short governance/tooling session that added one skill. The operator asked for
a skill that fetches (or pulls) `origin/main` and merges it into the working
branch; the agent authored `.claude/skills/sync-branch-with-main/SKILL.md` — a
merge-into-feature-branch procedure with clean-tree checks, targeted-fetch +
exponential-backoff retries, three-way conflict handling, and a hard refusal to
run on `main` itself — then wired it through governance the way the operating
contract requires: registered in [`meta/policy/skills-registry.md`](/meta/policy/skills-registry.md),
`CLAUDE.md` recompiled via `mix brain.contract` (not hand-edited), `mix
brain.verify` green, and logged in `meta/log.md`. The skill was first built as
`/sync-main` and, on the operator's follow-up, renamed to
`/sync-branch-with-main` (directory `git mv`, name/heading/registry/log updated,
contract re-rendered). Committed and pushed to the feature branch; no PR opened.
Nothing left open.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| New `/sync-branch-with-main` skill (fetch/merge origin/main into the branch) | closed | `unrouted` (governance artifact: `.claude/skills/sync-branch-with-main/SKILL.md` + skills-registry policy; no `sb:` sink) | - |
| Rename `/sync-main` → `/sync-branch-with-main` | closed | `unrouted` | - |

## User

Create a skill that asks agent to fetch and/or pull origin/main and merge it into the branch

## Assistant

<routes ref=".claude/skills/sync-branch-with-main/SKILL.md">
Done. I created a `/sync-main` skill and wired it into the brain's governance the way the operating contract requires.

**What it does** — `.claude/skills/sync-main/SKILL.md` instructs the agent to fetch (or pull) `origin/main` and merge it into the current working branch. The procedure covers:

- Confirming the working branch and **refusing to run on `main`** itself (the merge flows *into* a feature branch).
- Checking for a clean tree and asking before stashing/committing dirty work.
- Targeted fetch (`git fetch origin main`) with 4-attempt exponential backoff (2s/4s/8s/16s) on network errors only.
- Merging `origin/main`, then handling all three outcomes: already-up-to-date, clean merge, or conflicts (list conflicted paths and surface to the operator; `git merge --abort` to undo).
- Optional push of the updated branch, with the same retry policy.
- Guardrails: merge (not rebase) by default, never touch `main`, don't discard uncommitted work.

**Governance follow-through** (since `CLAUDE.md` is a generated artifact):
- Registered the skill in `meta/policy/skills-registry.md` (the source policy), not by hand-editing `CLAUDE.md`.
- Recompiled the contract with `mix brain.contract` — `--check` reports up to date.
- `mix brain.verify` passes.
- Logged the addition in `meta/log.md`.

Committed and pushed to `claude/git-fetch-merge-skill-ke7adg`. No PR opened, per instructions — let me know if you'd like one.
</routes>

## User

Rename it /sync-branch-with-main

## Assistant

<routes ref=".claude/skills/sync-branch-with-main/SKILL.md">
Renamed to `/sync-branch-with-main` and pushed. The change covers:

- **Directory** `.claude/skills/sync-main/` → `.claude/skills/sync-branch-with-main/` (via `git mv`, so history is preserved).
- **Skill file** — `name:`, `description` trigger phrase, and the `# /sync-branch-with-main` heading all updated.
- **Policy** `meta/policy/skills-registry.md` and the regenerated `CLAUDE.md` entry.
- **Log** entry updated to note the rename.

Verified: `mix brain.contract --check` reports up to date, `mix brain.verify` passes, and no stale `sync-main` references remain. Committed and pushed to `claude/git-fetch-merge-skill-ke7adg`.
</routes>
