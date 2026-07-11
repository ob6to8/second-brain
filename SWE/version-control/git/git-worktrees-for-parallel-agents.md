---
id: sb:8b9548
type: concept
title: "Git worktrees for parallel AI agents"
description: A git worktree is a linked working directory sharing one .git object store but with its own HEAD, index, and file tree — the primitive that lets N coding agents each edit an isolated branch, pushing conflicts to visible merge time instead of silent overwrites.
provenance: "Distilled from practitioner guides (Augment Code, others) and git documentation, chat thread 2026-07-11"
verified: false
tags: [git, worktree, parallel-agents, agentic-coding, branching, isolation]
timestamp: 2026-07-11
---

# Git worktrees for parallel AI agents

A **git worktree** is a linked working directory attached to one repository. All
worktrees share a single `.git` **object store** (commit history, refs, remotes),
but each gets its own **HEAD**, **staging index**, working directory, and logs.
The design constraint: git refuses to check out the same branch in two worktrees at
once (each HEAD must point to a distinct branch ref), so branch ↔ worktree is 1:1.

This is the git primitive underneath the 2026 shift to running **multiple coding
agents in parallel on one repo**. It extends the branch model already noted in
[git branches don't auto-advance on fetch](/SWE/version-control/git/git-local-branches-dont-auto-advance-on-fetch.md):
branches organize *history* but don't give you parallel *workspaces* — you can't
have one folder checked out on two branches. Worktrees fill exactly that gap.

## Why it suits multi-agent work

Without isolation, N agents on one working tree hit four failure modes: silent file
overwrites, context contamination (an agent reasoning over another's half-written
code), race conditions on shared build caches / test DBs, and `.git/index.lock`
contention stalling everyone. Worktrees convert these into **visible merge-time
conflicts** that ordinary git tooling detects — the failure moves from "silent,
during work" to "explicit, at merge."

## Practical shape

```bash
git worktree add -b agent/TASK-123 .trees/TASK-123 origin/main   # isolated branch+dir
git worktree lock --reason "Agent running" .trees/TASK-123        # optional
git worktree remove .trees/TASK-123 && git worktree prune         # clean up
```

Gotchas: submodules and node deps multiply disk per worktree (re-init/install in
each); `.git/hooks/` are shared and run in every worktree; git gives **no warning**
when two worktrees touch the same files on different branches.

## Ecosystem (2026)

Worktree isolation went first-class in agent tooling this year — e.g. Augment Code's
"Intent" workspace maps one Space per worktree to a specialist agent, Dagger's
Container-Use pairs worktrees with container isolation for ports/DBs, and merge-queue
frameworks (Overstory) sequence larger agent fleets. IDE support arrived recently:
JetBrains in 2026.1 (March 2026), VS Code in July 2025. (This very agent runs in a
worktree when isolating parallel edits.)

# Citations

- Augment Code — Git Worktrees for Parallel AI Agent Execution —
  <https://www.augmentcode.com/guides/git-worktrees-parallel-ai-agent-execution>
- `git worktree` — official git documentation — <https://git-scm.com/docs/git-worktree>
