---
type: policy
title: Merge strategy — history is provenance
description: Pull requests land on main via a true merge commit only; squash and rebase merges are disallowed because the commit graph is a provenance layer — commits carry session trailers and are cited by SHA in durable docs.
section: filing
order: 8
status: active
tags: [meta, governance, git, merge, provenance, history]
timestamp: 2026-07-11
---
**Merge with a true merge commit; never squash or rebase.** The commit graph is
a **provenance layer**, not an implementation detail: every commit carries the
session trailer linking it to the agent session that produced it, durable docs
(plans, thread docs, logs) cite commits by SHA, and `git blame` is the answer to
"which session changed this and why". A squash-merge lands a brand-new commit
and abandons the originals — severing commit → session traceability and turning
cited SHAs into garbage once the branch is deleted; a rebase-merge rewrites them.
A true merge wires the branch's real history into `main`'s ancestry, so the
cited SHAs stay reachable forever and the branch is safe to delete (see
[why a true merge keeps cited commits reachable](/meta/tutorials/why-a-true-merge-keeps-cited-commits-reachable.md)).

- Agents merging a PR (UI, MCP tools, or API) must use the **merge** method —
  never `squash` or `rebase`, even when they are enabled in repo settings.
- Never rewrite shared history; the usual noise argument for squashing does not
  apply here — agent commits are already atomic and deliberately messaged.
- For a one-line-per-PR reading of `main`, use `git log --first-parent` instead
  of flattening history at the merge boundary.
