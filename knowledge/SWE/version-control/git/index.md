# Git

Concepts, claims, and references about the git distributed version control system.

## Concepts

- [Git local branches don't auto-advance on fetch](/knowledge/SWE/version-control/git/git-local-branches-dont-auto-advance-on-fetch.md) — `fetch` only updates remote-tracking refs; local branches move only on pull/merge/reset/commit. `sb:4c9e1f` _(concept, verified)_
- [Git worktrees for parallel AI agents](/knowledge/SWE/version-control/git/git-worktrees-for-parallel-agents.md) — a linked working dir sharing one `.git` object store but with its own HEAD/index/tree; the primitive that isolates N parallel agents, pushing conflicts to visible merge time. `sb:8b9548` _(concept)_

## Subdirectories

- [sources](/knowledge/SWE/version-control/git/sources/index.md) — primary-source excerpts from official git documentation
