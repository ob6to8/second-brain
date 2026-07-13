---
type: tutorial
title: The agent's branch lifecycle across merged PRs
description: Why a Claude Code session pins one designated branch name for its whole life, how a merged PR forces that branch to restart from the default branch under the same name (a new PR each cycle, never a reopen), and why auto-deleting the merged head branch makes the restart a clean create instead of a force-push over a stale tip.
attribution:
  when: 2026-07-10T00:00:00Z
  channel: agent-authored
  agent: "Claude Code agent, /create-pull-request session"
  why: "captures the harness branch-lifecycle model an operator asked about — same-name restart across merged PRs and how auto-delete interacts with it"
  from: [/meta/threads/2026-07-10-create-pull-request-skill-and-intake-delegation.md]
tags: [meta, git, workflow, branches, pull-requests, agent, harness]
timestamp: 2026-07-10
---

# The agent's branch lifecycle across merged PRs

A recurring question: if the repository auto-deletes a branch when its PR merges,
and you keep working with the agent in the same session that branch was started
for, does the agent create a *new* branch? The short answer is that it recreates
a branch with the **same designated name** — it does not mint a fresh, differently
-named branch — and auto-delete makes that recreation *cleaner*, not messier. This
note explains the model to hold: **same branch name, fresh base, new PR each
cycle.**

## The branch name is pinned for the session, not chosen per task

A Claude Code session in this environment is handed **one designated branch name**
up front and develops everything on it — for this repo's sessions that looks like
`claude/<slug>`. The agent does not invent a new branch per task or per PR; the
name is a fixed property of the session, not a decision it remakes each time.

That single fact is what makes the rest predictable. When a PR merges and work
continues, the interesting question is never "what will the new branch be called?"
(it's the same name) but "what does that same-named branch now point at?"

## A merged PR is terminal — so the branch restarts from the default branch

A merged pull request is finished. It cannot track new work, and new commits must
not be stacked on the already-merged history. So when the agent continues in a
session whose PR has merged, the rule is to **restart the designated branch from
the latest default branch, keeping the same name**:

```
git fetch origin main
git checkout -B claude/<slug> origin/main
```

`git checkout -B` recreates the ref locally from `main` **whether or not the old
branch still exists**. This is the crux: the name stays stable across
continuations; what changes is that the branch is re-pointed at a fresh base (the
default branch, now including the just-merged work). Any new commits go there, and
opening a PR for them produces a **brand-new PR** — not a reopen of the merged one.

If the restarted branch already carries unmerged commits beyond the merged
history, those are kept (rebased onto the new base) rather than discarded — only
already-merged history is safe to replace.

## What auto-delete changes: only the push, and for the better

Auto-delete (GitHub's *Settings → General → "Automatically delete head branches"*)
removes the remote head branch the moment its PR merges. It changes nothing about
the *name* the agent uses. It changes exactly one thing: the shape of the next
push.

- **Without auto-delete** — the old remote branch still holds the merged tip. When
  the agent restarts from `main` and pushes, it is writing over that stale ref.
  Sometimes that's a clean fast-forward (when the old tip is an ancestor of the new
  base); in the general case the restarted history diverges from the stale tip and
  the push needs `--force-with-lease`. A force-with-lease is safe here precisely
  because the branch contained only already-merged history.
- **With auto-delete** — the remote ref is gone, so the next push simply *creates*
  it fresh: a plain `git push -u origin claude/<slug>`, no force, no stale-tip
  reasoning at all.

So auto-delete removes the only awkward part of the cycle (force-pushing over a
stale merged tip) and costs nothing. Critically, the agent never gets "stuck" from
the branch being missing: it recreates the branch *by name* on the next write, so
a deleted remote branch is a non-event.

## The model to hold

Across a session that ships several PRs, the branch lifecycle is a loop:

1. Work on the designated branch → open PR **N**.
2. PR **N** merges (terminal). If auto-delete is on, the remote head branch
   vanishes.
3. Continue in the same session → `git checkout -B <same-name> origin/main`
   restarts the branch from the updated default.
4. New commits → push (a clean create if auto-deleted, else possibly a
   force-with-lease) → open PR **N+1**, a *new* PR.

This session was a live instance: PR #31 merged, the same branch restarted from
`main`, and the follow-up became PR #32 — a new PR, not a revival of #31.

## Caveat: this is a harness contract, not universal agent behavior

The "same name, restart from default" discipline is *this environment's* branching
contract, injected into the session — not something intrinsic to how any agent must
behave. A different setup that let an agent choose branch names freely could
instead generate a new name per task, in which case auto-delete is just as safe,
because each task's branch is created fresh anyway. Either way the conclusion for
auto-delete is the same: it is safe to turn on, and it slightly simplifies the
agent's git flow.

## See also

- [What makes a commit show as "Verified" on GitHub](/meta/tutorials/what-makes-a-commit-verified-on-github.md)
  — the companion git-mechanics tutorial, including the only-rewrite-unpushed-commits rule.
