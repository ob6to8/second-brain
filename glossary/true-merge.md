---
id: sb:a10e18
type: concept
title: true merge
description: A merge that creates a two-parent merge commit wiring the branch's real history into the target's ancestry, keeping every original commit (and its SHA) permanently reachable after the branch is deleted.
provenance: "Agent-distilled glossary definition; pointer to the reachability tutorial"
verified: false
tags: [glossary, git, merge, provenance]
timestamp: 2026-07-11
---

# true merge

A merge that creates a two-parent merge commit, wiring the source branch's real
history into the target branch's ancestry — every original commit, message, and
SHA stays permanently reachable from `main` even after the branch ref is
deleted. Canonically explained in
[why a true merge keeps cited commits reachable](/meta/tutorials/why-a-true-merge-keeps-cited-commits-reachable.md);
mandated here by the [merge-strategy policy](/meta/policy/merge-strategy.md).
Contrast [squash merge](/glossary/squash-merge.md) and
[fast-forward merge](/glossary/fast-forward-merge.md).

*Seen in:* [2026-07-10 merge-tutorial thread](/meta/threads/2026-07-10-merge-commit-reachability-tutorial.md), [2026-07-11 session-init thread](/meta/threads/2026-07-11-session-init-digest-and-priorities.md)
