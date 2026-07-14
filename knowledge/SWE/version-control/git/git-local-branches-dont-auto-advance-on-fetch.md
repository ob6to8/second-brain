---
id: sb:4c9e1f
type: concept
title: Git local branches don't auto-advance on fetch
description: A git fetch only updates remote-tracking refs; your local branch moves only when you pull, merge, reset, or commit — the two refs are decoupled by design.
tags: [git, version-control, branches, refs, fetch]
provenance: "Claude Opus 4.8 — pasted from a chat thread"
verified: true
verified_by: [sb:a3d27b, sb:f08c54]
timestamp: 2026-07-05
attribution:
  when: 2026-07-05T11:10:01+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# Git local branches don't auto-advance on fetch

Git never auto-advances a local branch.

- A **`git fetch`** only updates **remote-tracking refs** (e.g. `origin/main`).
- Your **local `main`** moves only when you **pull, merge, reset, or commit** on it.

The two refs are **decoupled by design**: `origin/main` tracks the state on GitHub,
while local `main` is a label *you own and must move deliberately*.

## Why it matters

After `git fetch`, `main` and `origin/main` can point at different commits. `git status`
reporting "behind origin/main" is describing that gap — nothing has actually moved your
work. Advancing local `main` is always an explicit act.
