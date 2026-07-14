---
id: em:894631
type: concept
title: first-parent history
description: The git log traversal (git log --first-parent) that follows only each merge commit's first parent, reading a branch's history as one entry per merge — on a PR-driven default branch, one line per landed pull request.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, git, merge, history]
sense: common
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T17:18:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-13 derived-dev-history thread"
---

# first-parent history

The view of a branch's history produced by `git log --first-parent`: at every
merge commit, the traversal follows only the *first* parent (the branch being
merged into), skipping the merged-in side branch's individual commits. On a
default branch where every change lands as a
[true merge](/beliefs/glossary/true-merge.md), this reads as exactly one entry
per pull request — which is what makes the merge graph directly usable as a
per-PR change record (`mix brain.dev_history` derives
[`meta/dev-history.md`](/meta/dev-history.md) from it). The skipped side
commits stay reachable through each merge's second parent.

*Seen in:* [2026-07-13 derived-dev-history thread](/meta/threads/2026-07-13-derived-dev-history-from-merge-graph.md), [merge-strategy policy](/meta/policy/merge-strategy.md)
