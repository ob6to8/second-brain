---
id: sb:6e9584
type: concept
title: reachability
description: In git, the property that a commit can be found by starting at some ref (branch, tag, or HEAD) and walking parent pointers back to it; reachable commits are safe from garbage collection, unreachable ones are eventually pruned.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, git]
sense: common
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T00:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the branch-lifecycle tutorial and main-catchup thread"
---

# reachability

Git's object store is garbage-collected, and what protects a commit from collection is not importance but **reachability**: whether you can start at some *ref* — a branch, a tag, or `HEAD` — and walk parent pointers back to that commit. Two consequences follow. A branch is just a movable ref, so deleting it removes a pointer, never the commits — those are only at risk if that branch was the last ref reaching them. And ancestry is permanent: once a commit is an ancestor of the default branch's tip, it stays reachable for as long as that branch exists. This is why a [true merge](/beliefs/glossary/true-merge.md) makes a branch safe to delete (its second parent wires the branch's history into the default branch's ancestry) while a [squash merge](/beliefs/glossary/squash-merge.md) does not (the originals stay reachable only through the soon-deleted branch).

*Seen in:* [2026-07-13 branch-lifecycle tutorial and main catch-up](/meta/threads/2026-07-13-branch-lifecycle-tutorial-and-main-catchup.md), [why a true merge keeps cited commits reachable](/meta/tutorials/why-a-true-merge-keeps-cited-commits-reachable.md)
