---
name: sync-branch-with-main
description: Fetch (or pull) origin/main and merge it into the current working branch, keeping the branch up to date with upstream. Use when the operator says "sync branch with main", "merge main into this branch", "pull in the latest main", "catch up with main", or before opening/updating a PR so the branch is current. Handles the fetch, the merge, conflict surfacing, and network-failure retries.
---

# /sync-branch-with-main — bring the current branch up to date with origin/main

Update the branch you are working on so it contains everything on `origin/main`.
The mechanic is: **fetch the latest `origin/main`, then merge it into the current
branch.** This keeps a feature branch current so its diff against `main` reflects
only your own changes and a later PR merges cleanly.

Never run this on `main` itself — this skill merges *into* a feature branch. If the
current branch is `main` (or the repo's default branch), stop and tell the operator
there is nothing to sync into.

## When to use

- The operator asks to "sync main", "merge main in", "pull the latest main", or
  "catch up with main".
- Before opening or updating a pull request, so the branch is current with upstream
  and the PR is mergeable.
- After someone else's work lands on `main` and you need it in your branch to keep
  building or to resolve a conflict early.

## Procedure

1. **Confirm the working branch.** Note the current branch and refuse to proceed if
   it is `main` / the default branch:
   ```
   git rev-parse --abbrev-ref HEAD
   ```
   The rest of this procedure assumes a non-default feature branch.

2. **Check for a clean tree.** A merge needs a clean working tree.
   ```
   git status --short
   ```
   If there are uncommitted changes, stop and ask the operator whether to commit or
   stash them first — do **not** stash or discard their work silently.

3. **Fetch `origin/main`.** Prefer a targeted fetch:
   ```
   git fetch origin main
   ```
   On network failure, retry up to 4 times with exponential backoff (2s, 4s, 8s,
   16s). Only retry on network/transport errors — not on auth or ref errors.

4. **Merge `origin/main` into the current branch.**
   ```
   git merge origin/main
   ```
   - Prefer merging the fetched `origin/main` ref over `git pull origin main`, so the
     fetch and the merge are two observable steps. `git pull origin main` is an
     acceptable equivalent when a single step is wanted.
   - Let git write its default merge commit message; do not craft a custom one unless
     the operator asks.

5. **Handle the outcome.**
   - **Already up to date** — report that the branch already contains `origin/main`;
     nothing to do.
   - **Clean merge (fast-forward or a merge commit)** — report the result and the new
     `HEAD`. If tooling is present, run the bundle checks before pushing
     (`mix brain.verify`, and `mix brain.contract --check` if policy/`CLAUDE.md` may
     be affected) so the merge didn't leave the bundle inconsistent.
   - **Conflicts** — list the conflicted paths (`git status --short` /
     `git diff --name-only --diff-filter=U`) and stop. Resolve them only if the
     resolution is unambiguous and within the scope of the current task; otherwise
     surface the conflicts to the operator and ask how to proceed. Never resolve a
     conflict by blindly taking one side. If you must abort, `git merge --abort`
     returns the branch to its pre-merge state.

6. **Push the updated branch** (only when the operator wants the remote updated —
   e.g. an open PR that should reflect the sync):
   ```
   git push -u origin <current-branch>
   ```
   Retry on network failure with the same 4-attempt exponential backoff. Never push
   to a branch other than the current working branch without explicit permission.

## Guardrails

- **Merge, don't rebase, by default.** This skill merges `origin/main` into the
  branch. Only rebase (`git rebase origin/main`) if the operator explicitly asks —
  rebasing rewrites history and force-pushing is a separate, deliberate act.
- **Never touch `main`.** Do not check out, commit to, or push `main`. The merge
  flows *from* `origin/main` *into* the feature branch.
- **Don't discard uncommitted work.** If the tree is dirty, ask before stashing or
  committing. A failed merge that left conflicts can be undone with
  `git merge --abort`.
- **Fetch specifically, retry on network errors only.** Prefer `git fetch origin
  main` over a bare `git fetch`; back off (2s/4s/8s/16s) on transient network
  failures, but surface auth/ref errors immediately rather than retrying.
