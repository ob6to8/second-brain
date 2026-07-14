---
id: em:184bae
type: concept
title: git worktree
description: A linked working directory attached to one git repository — its own HEAD, index, and file tree over a shared .git object store — letting multiple branches (and agents) be checked out at once.
provenance: "Agent-distilled glossary definition, pointer to the defining doc"
verified: false
tags: [glossary, git, worktree, parallel-agents]
sense: common
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T18:01:58+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# git worktree

A linked working directory attached to a single git repository: it has its own
**HEAD**, staging index, and file tree, but shares the repo's one `.git` **object
store**, so several branches can be checked out simultaneously in separate
directories (git enforces one branch per worktree). The primitive that isolates
parallel coding agents — each on its own branch — pushing their conflicts to visible
merge time. Defined by [Git worktrees for parallel AI agents](/knowledge/SWE/version-control/git/git-worktrees-for-parallel-agents.md).

*Seen in:* [2026-07-11 news-digest thread](/meta/threads/2026-07-11-news-digest-intake-and-daily-read.md), [Git worktrees for parallel AI agents](/knowledge/SWE/version-control/git/git-worktrees-for-parallel-agents.md)
