---
id: em:a10e18
type: concept
title: true merge
description: A merge that creates a two-parent merge commit wiring the branch's real history into the target's ancestry, keeping every original commit (and its SHA) permanently reachable after the branch is deleted.
provenance: "Agent-distilled glossary definition; pointer to the reachability tutorial"
verified: false
tags: [glossary, git, merge, provenance]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-11T18:09:19+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# true merge

Canonically explained in
[why a true merge keeps cited commits reachable](/meta/tutorials/why-a-true-merge-keeps-cited-commits-reachable.md);
mandated here by the [merge-strategy policy](/meta/policy/merge-strategy.md).
Contrast [squash merge](/beliefs/glossary/squash-merge.md) and
[fast-forward merge](/beliefs/glossary/fast-forward-merge.md); the underlying
property is [reachability](/beliefs/glossary/reachability.md).

*Seen in:* [2026-07-10 merge-tutorial thread](/meta/threads/2026-07-10-merge-commit-reachability-tutorial.md), [2026-07-11 session-init thread](/meta/threads/2026-07-11-session-init-digest-and-priorities.md), [2026-07-13 branch-lifecycle tutorial and main catch-up](/meta/threads/2026-07-13-branch-lifecycle-tutorial-and-main-catchup.md)
