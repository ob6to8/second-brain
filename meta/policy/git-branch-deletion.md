---
type: policy
title: Git branch deletion
description: Merged PR head branches are deleted on merge; the default branch and any branch with unmerged commits are never deleted without operator approval.
section: git-workflow
order: 1
status: active
tags: [meta, governance, git, branches]
timestamp: 2026-07-11
---
- **Session branches are ephemeral; the default branch is durable.** Work enters
  the repo on a short-lived head branch (e.g. `claude/<slug>`) and lands in the
  default branch via a pull request. The branch is scaffolding, not history — the
  merge is the record.
- **Delete the head branch when its PR merges.** A merged branch is fully contained
  in the default branch's history, so deleting it loses nothing (its commits stay
  reachable through the merge, and GitHub can restore the branch). Deletion is part
  of the merge motion: prefer the repository's **"Automatically delete head
  branches"** setting; failing that, delete the branch manually right after
  merging. A merged branch discovered lingering later is deleted on sight.
- **Never delete without the operator:** the default branch (never), and any branch
  carrying **unmerged** commits — including branches whose PR was closed without
  merging. Those hold work with no other home; propose deletion and wait for the
  operator to ratify, as with any destructive change.
