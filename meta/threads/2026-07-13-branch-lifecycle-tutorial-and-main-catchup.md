---
type: reference
title: 2026-07-13-branch-lifecycle-tutorial-and-main-catchup
description: Continuation of the create-pull-request session — merged PR #32, hit an environment block deleting the remote branch, answered how the agent's branch lifecycle works across merged PRs and wrote it up as a tutorial, then caught the long-diverged branch up to main and reconciled the new tutorial with main's existing git-workflow docs into a cross-linked triad.
provenance: "Claude Code session (Claude Opus 4.8, with a brief Sonnet 5 interlude), 2026-07-13; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, git, branches, pull-requests, tutorial, merge]
timestamp: 2026-07-13
---

# 2026-07-13-branch-lifecycle-tutorial-and-main-catchup

## Where this landed

The tail of the create-pull-request session, picking up after PR #32 merged. Four
strands: (1) merging PR #32 into `main`; (2) deleting the merged branch — the local
delete succeeded but the remote delete was blocked by a consistent HTTP 403 from the
environment's git proxy, so it was handed back to the operator; (3) an operator
question about how the agent's branch lifecycle works when a merged branch is
auto-deleted mid-session, answered as *same branch name, fresh base, new PR each
cycle* and then filed as the tutorial
[branch-lifecycle-across-merged-prs](/meta/tutorials/branch-lifecycle-across-merged-prs.md);
and (4) a "merge main into this branch" request that revealed `main` had advanced
~40 PRs (through #75) beyond where the branch was based — the merge pulled all of it
in (resolving two conflicts: the retired `meta/log.md`, and the tutorials index) and
surfaced that the branch held exactly one piece of original info, the tutorial. The
session closed by reconciling that tutorial with `main`'s existing git-branch-deletion
policy and true-merge-reachability tutorial into a bidirectionally cross-linked triad,
then shipping it all via `/create-pull-request`.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Merge PR #32 into main | closed | `unrouted` | - |
| Delete the merged branch (local ok; remote 403-blocked) | closed | [/meta/policy/git-branch-deletion.md](/meta/policy/git-branch-deletion.md) | - |
| How the agent's branch lifecycle works across merged PRs | closed | [/meta/tutorials/branch-lifecycle-across-merged-prs.md](/meta/tutorials/branch-lifecycle-across-merged-prs.md) | - |
| Catch the branch up to main (~40 PRs); is there info not on main? | closed | `unrouted` | - |
| Reconcile the three git-workflow docs into a cross-linked triad | closed | [/meta/tutorials/branch-lifecycle-across-merged-prs.md](/meta/tutorials/branch-lifecycle-across-merged-prs.md) | - |

## User

Merge into main

## Assistant

Merged. **PR #32 is now in `main`** (merge commit `8f375ab`).

Now live on `main`:
- `/create-pull-request` runs `/capture` end-to-end before committing (capture → survey → commit → push → open PR).
- This session's thread doc, `meta/threads/2026-07-10-create-pull-request-skill-and-intake-delegation.md`, with its routing ledger and route tags.
- The re-rendered `CLAUDE.md` and registry/index/log upkeep.

No CI checks configured, so nothing gated the merge; `mergeable_state` was `clean`.

The branch `claude/repo-skills-namespacing-htu3lc` is once again fully merged — any further work should restart it from the updated `main` rather than stacking on merged history. Want me to delete the merged branch, or leave it? And we're at a natural stopping point for this session if you're done.

## User

Delete the branch

## Assistant

Here's where this landed:

- **Local branch:** deleted ✅ (`claude/repo-skills-namespacing-htu3lc` removed; I'm now on `main` at the merged commit `8f375ab`).
- **Remote branch:** **could not delete** ❌ — the environment blocks it.

The remote delete gets a consistent **HTTP 403** from GitHub through the agent proxy (the proxy itself is healthy — no relay failures — so it's a permission/policy rejection, not a network blip). This environment's git access allows *pushing* refs but not *deleting* them, and the GitHub MCP toolset has `create_branch` but no delete-branch/delete-ref equivalent. So there's no path from here to remove `refs/heads/claude/repo-skills-namespacing-htu3lc` on the remote.

Two easy ways for you to finish it off:
- On the merged **PR #32** page, click **"Delete branch"** — GitHub offers that button after merge.
- Or from a machine with normal push rights: `git push origin --delete claude/repo-skills-namespacing-htu3lc`.
- Optionally, enable **Settings → General → "Automatically delete head branches"** so merged branches get cleaned up for you going forward.

Want me to do anything else here, or is this a good place to stop?

## User

If you auto delete a merged branch, and then you continue working with an agent in the thread it was started for, does the agent create a new branch?

## Assistant

<routes ref="meta/tutorials/branch-lifecycle-across-merged-prs.md">
Short answer: it recreates a branch with the **same designated name** — it doesn't mint a new, differently-named branch. And auto-delete actually makes that cleaner, not messier.

Here's the mechanism, and why:

**The branch name is pinned for the session, not chosen per-task.** My instructions fix one designated branch — `claude/repo-skills-namespacing-htu3lc` — for everything in this thread. When a PR for that branch merges and you keep working, the rule is explicitly *"restart your designated branch from the latest default branch, keep the same branch name"*:

```
git fetch origin main
git checkout -B claude/repo-skills-namespacing-htu3lc origin/main
```

`checkout -B` recreates the ref locally from `main` regardless of whether the old one still exists. So the *name* is stable across continuations; what changes is that it now points at a fresh base.

**What auto-delete changes:** only the push, and for the better.
- **Without** auto-delete (what happened this session): the old remote branch still held the merged tip, so restarting and pushing rode on top of it — here it happened to be a clean fast-forward (`7f1c882..60c8cc3`), but in the general case the restarted history can diverge from that stale tip and need a `--force-with-lease`.
- **With** auto-delete: the remote ref is gone, so the next push just *creates* it fresh — a plain `git push -u`, no force, no stale-tip reasoning.

**Either way it's a new PR, not a reopen.** A merged PR is terminal; the recreated same-named branch opens a brand-new PR against it. That's exactly the #31 → #32 progression you saw this session: #31 merged, I restarted the same branch from `main`, and the follow-up became #32 (a new PR), not a revival of #31.

So the model to hold: **same branch name, fresh base, new PR each cycle.** Auto-delete removes the only awkward part (force-pushing over a stale merged tip) and costs nothing — the agent never gets "stuck" from the branch being missing, because it recreates it by name on the next write.

One caveat worth naming: this is my *harness's* branching contract, not universal agent behavior. A different setup that let an agent pick branch names freely could instead generate a new name per task — in which case auto-delete is just as safe, since each task's branch is created fresh anyway.
</routes>

## User

Create a tutorial in meta/tutorials capturing this description

## Assistant

<routes ref="meta/tutorials/branch-lifecycle-across-merged-prs.md">
Done. The tutorial is filed and pushed to `claude/repo-skills-namespacing-htu3lc`.

**`meta/tutorials/branch-lifecycle-across-merged-prs.md`** captures the whole model:
- The branch name is pinned per session, not chosen per task.
- A merged PR is terminal → restart the same-named branch from the default branch (`git checkout -B <name> origin/main`), which recreates the ref whether or not the old one exists.
- Auto-delete changes only the *push*: a clean create instead of a possible force-with-lease over a stale merged tip — and the agent never gets stuck on a missing branch since it recreates by name.
- The loop (PR N merges → restart → PR N+1, a new PR), with this session's #31 → #32 as the worked example.
- The caveat that this is a harness contract, not universal agent behavior.

Reserved files maintained (tutorials index + log); `mix brain.verify` and `mix brain.route_tags` both clean.

And fittingly, writing it was itself an instance of the thing: since PR #32 had merged, I restarted the branch from `main` before committing — same name, fresh base — and this push fast-forwarded cleanly over the old tip (which is still present because we couldn't auto/manually delete the remote branch earlier). Want me to open a PR for this tutorial via `/create-pull-request`, or leave it on the branch?
</routes>

## User

Merge main into this branch, is there info here that is not on main yet?

## Assistant

Done — main is merged in and pushed.

## Answering your question directly

**Yes, but only one thing.** The branch had exactly **one commit** of original info not on main: the tutorial `meta/tutorials/branch-lifecycle-across-merged-prs.md`. Everything else here was already on main (this branch was based on an old `main`).

The imbalance was dramatic: **main was ~40 merged PRs ahead** (#33–#75, through 2026-07-13) — a root reorganization into `knowledge/` and `beliefs/`, a glossary, an attribution system, retired hand-kept logs, many new skills/flows/tutorials. So this "merge main in" was really main catching *this* branch up, plus preserving that one tutorial.

## What the merge required

Two conflicts, both resolved sensibly:
- **`meta/log.md`** — main *retired the hand-kept logs* ("git history is the provenance layer"). My log edits were moot, so I accepted main's deletion.
- **`meta/tutorials/index.md`** — kept all three entries (main's two + my branch-lifecycle one).

One post-merge gate failure, fixed: main added a mandatory **`attribution`** frontmatter block on governance docs; my tutorial predated it, so I added an `agent-authored` attribution entry pointing at this session's thread doc.

**Final state:** branch is 0 behind / 2 ahead of main; all gates green — `brain.verify` clean, `route_tags` clean, contract/registry `--check` up to date, `mix test` 156/0.

## One thing worth your attention

Main independently grew content that **overlaps my tutorial's topic**: a `git-branch-deletion` policy, the `why-a-true-merge-keeps-cited-commits-reachable` tutorial, and a branch-deletion-policy thread. My tutorial covers a distinct angle (the *same-name-restart lifecycle* and the *auto-delete interaction*), so it's not a straight duplicate — but you may want to cross-link them or fold them together. Want me to reconcile those, or leave the tutorial standalone?

## User

_(stop-hook feedback: the git-check hook reported uncommitted changes — the attribution block added during conflict resolution had missed the merge commit's index)_

## Assistant

All resolved. Working tree is clean and everything is pushed.

- The attribution edit I added during conflict resolution had missed the merge commit's index (I edited the file but the merge committed the staged version). I've now committed it (`c75be00`) and pushed.
- **`git status` is clean**, branch tip is on the remote, and `mix brain.verify` reports **"Bundle verifies"** — the branch tip is green. (The lone remaining line is a pre-existing advisory freshness warning about an `inbox/2026-07-11.md` link, which never fails the gate and isn't from my change.)

Branch `claude/repo-skills-namespacing-htu3lc` is now fully caught up with `main` (0 behind) plus the branch-lifecycle tutorial, all committed and pushed.

## User

So where does this leave us

## Assistant

Current state:

**Branch `claude/repo-skills-namespacing-htu3lc`** — clean, fully pushed, caught up with `main` (0 behind), plus one commit ahead: the new tutorial `meta/tutorials/branch-lifecycle-across-merged-prs.md`. All gates green (`brain.verify`, `brain.route_tags`, `mix test` 156/0).

**What's in that one commit of original work:**
- The tutorial documenting the harness's branch-lifecycle model (same-name restart after a merged PR, how auto-delete interacts with it) — written in response to your question earlier this session.

**Not yet done:**
- **No PR opened** for this tutorial commit yet. You asked me to merge main in and check for divergent info; I did that, but haven't run `/create-pull-request` for it.
- I flagged a possible overlap: main independently grew a `git-branch-deletion` policy and a `why-a-true-merge-keeps-cited-commits-reachable` tutorial covering related git-mechanics ground. I asked if you wanted them cross-linked or reconciled — no answer yet.

So the open questions are: **(1)** want me to open a PR for the tutorial now, and **(2)** do you want the overlap with main's existing branch-deletion/merge docs reconciled (cross-links, or merge the content) before or after that PR?

## User

Reconcile now
Then
/create-pull-request

## Assistant

<routes ref="meta/tutorials/branch-lifecycle-across-merged-prs.md meta/tutorials/why-a-true-merge-keeps-cited-commits-reachable.md meta/policy/git-branch-deletion.md">
The three git-workflow docs form one set — the rule, the reachability *why*, and this lifecycle *how*. The reconciliation wired them into a bidirectionally cross-linked triad: the branch-lifecycle tutorial now defers to the git-branch-deletion policy (the rule) and the true-merge tutorial (the reachability mechanics) for *whether* a merged branch is safe to delete, and picks up where they leave off — what the session's branch does next. The true-merge tutorial gained a reciprocal "See also" back to the lifecycle tutorial and the policy. Bundle verifies clean, all cross-links resolve.
</routes>
