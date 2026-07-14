---
id: sb:4a235a
type: concept
title: squash merge
description: A merge that flattens a branch's commits into one brand-new commit on the target, abandoning the originals — linearizing history at the cost of per-commit provenance (messages, trailers, cited SHAs, blame granularity).
provenance: "Agent-distilled glossary definition; pointer to the reachability tutorial"
verified: false
tags: [glossary, git, merge, provenance]
sense: common
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T18:09:19+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# squash merge

A merge that combines all of a branch's commits into one brand-new commit on
the target branch, leaving the originals outside the target's ancestry. It
buys a linear one-commit-per-PR history at the cost of per-commit provenance:
original messages and trailers, SHAs cited in durable docs (garbage-collectible
once the branch is deleted), and `git blame` granularity. Canonically explained
in [why a true merge keeps cited commits reachable](/meta/tutorials/why-a-true-merge-keeps-cited-commits-reachable.md);
disallowed here by the [merge-strategy policy](/meta/policy/merge-strategy.md).
Contrast [true merge](/beliefs/glossary/true-merge.md).

*Seen in:* [2026-07-10 merge-tutorial thread](/meta/threads/2026-07-10-merge-commit-reachability-tutorial.md), [2026-07-11 session-init thread](/meta/threads/2026-07-11-session-init-digest-and-priorities.md)
