---
type: reference
title: 2026-07-13-execute-branch-transplant-ports
description: Clarified the branch-lifecycle mechanics of Option B (fresh base after the open PR merges, sequenced not parallel, because the session pins one branch name), merged PR #81, then executed the two remaining branch-transplant ports — the Chroma product intake and the /sync-branch-with-main skill — onto a branch restarted from main's tip.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-13; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, git, branches, transplant, ports]
timestamp: 2026-07-13
pr: 82
---

# 2026-07-13-execute-branch-transplant-ports

## Where this landed

The execution tail of the branch-cleanup work. The operator asked whether the
two remaining ports would go on a fresh branch off `main`'s current tip filed as
a new PR; the answer corrected a loose earlier phrasing — because a session pins
**one branch name** and pushing a differently-named branch needs explicit
permission, a genuinely parallel branch isn't free, so the clean "fresh base →
new PR" flow (Option B) has to be **sequenced after the open PR merges**, not run
alongside it. The operator chose Option B and to merge PR #81. PR #81 was
true-merged (after one more catch-up merge with a fast-moving `main`), the
designated branch was restarted from the new tip, and the two ports were
executed onto it: the **Chroma product intake** (`sb:ea15aa`) transplanted to
`knowledge/SWE/llm-engineering/` with links repointed to the reorganized tree and
cross-linked to `main`'s distinct Chroma *context-rot research* concept, and the
**`/sync-branch-with-main` skill** transplanted verbatim (still accurate) with a
hand-added skills-registry entry and a contract recompile. The transplant plan
moved to `in-progress`; the triage todo's remaining work is now operator-only
(delete two false orphans + two now-ported source branches).

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Option B branch-lifecycle mechanics (one pinned name; sequence, don't parallelize) | closed | [branch transplant](/beliefs/glossary/branch-transplant.md) | - |
| Execute the two ports | closed | [transplant plan](/meta/plans/transplant-surviving-unmerged-branches.md) · [triage todo](/meta/todos/triage-the-six-kept-unmerged-claude-branches.md) | - |
| Close the orphaned-branches cleanup | open | [issue](/meta/issues/orphaned-remote-branches-cleanup.md) | Operator: delete 4 branches + confirm auto-delete setting; then resolve |

## User

So you would execute the two ports on a fresh branch here which would start off of main's current tip, and then that would filed as a new pr?

## Assistant

Not quite — and it's worth correcting my earlier loose phrasing, because the mechanics have a real constraint I glossed over.

The catch is that **this session has one pinned branch name** (`claude/branch-deletion-policy-kvzm25`), and per your own git rules I shouldn't push to a *differently*-named branch without explicit permission. PR #81 is still open on that branch and holds unmerged commits. So a genuinely separate, parallel branch-and-PR isn't something I can cleanly spin up right now without you okaying a new branch name. What I actually have is two clean options:

**Option A — add the ports to the current branch (no new PR).** I do the two ports on `claude/branch-deletion-policy-kvzm25` right now; they join **PR #81**. Simple, nothing to wait for. Downside: #81 stops being a tidy "cleanup + plan" PR and becomes "cleanup + plan + two of the ports executed" — the plan and its execution ride together, which is a bit muddier for review.

**Option B — new PR, but sequenced after #81 merges.** Once #81 merges, I restart the designated branch from `main`'s new tip (the branch-lifecycle pattern: *same name, fresh base*), do the two ports there, and open a **new PR**. This is the clean "fresh branch off main's current tip → new PR" flow you're describing — it just can't start until #81 is merged, otherwise restarting the branch would strip #81's commits before it lands.

So your instinct is right about the *shape* (fresh base, new PR); the only correction is that it has to be **sequenced after #81**, not run in parallel — unless you explicitly want me to use a new branch name, in which case I can do it truly in parallel right now.

My recommendation: **Option B**, because the two ports are independent, individually-reviewable units and deserve their own PR rather than swelling the cleanup one — and #81 is small and ready, so the wait is short. If you'd rather not wait, Option A gets it all done in one pass now.

One footnote: "main's current tip" is a moving target this session — it's absorbed ~40 PRs from parallel sessions in a day — so whichever option, I'd re-verify the two ports are still absent from `main` right before doing them (the audit already caught two ports vanishing that way).

Which do you want — A (now, into #81), B (after #81 merges, new PR), or a parallel new-named branch?

## User

Option b
Merge 81

## Assistant

PR #81 is merged (true merge `42b65c6`), the designated branch is restarted from `main`'s new tip, and both ports are executed and gate-green. Re-verifying before porting caught nothing vanished this time — the sync skill was still absent, and the "2 files carrying `sb:ea15aa`" on `main` turned out to be my own plan/todo mentioning the id in prose, not the concept (the registry had no entry), so the Chroma intake was genuinely still missing.

- **Chroma product intake** → [`knowledge/SWE/llm-engineering/chroma-vector-database.md`](/knowledge/SWE/llm-engineering/chroma-vector-database.md) (`sb:ea15aa`), cross-links repointed to the reorganized `knowledge/` paths, an `attribution` block added, cross-linked to `main`'s distinct context-rot-research concept, index updated.
- **`/sync-branch-with-main` skill** → transplanted verbatim (still accurate), skills-registry entry hand-added (the compile plan hasn't run), contract recompiled.

The transplant plan is now `in-progress` and the triage todo's remainder is operator-only: delete the two false orphans and the two now-ported source branches, then the orphaned-branches issue resolves once the auto-delete setting is confirmed on.

## Assistant

*(This capture and the port PR are `/create-pull-request` executing.)*
