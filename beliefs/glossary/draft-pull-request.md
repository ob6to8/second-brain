---
id: sb:f5523f
type: concept
title: draft pull request
description: A GitHub pull request opened in draft state — visible and commentable but explicitly not ready to merge — used to stage review conversation on work in progress.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, git, github, pr-workflow]
sense: common
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T20:28:57+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-13 council-round-suitability-evaluation thread"
---

# draft pull request

A GitHub pull request opened in draft state: it carries the branch's full diff
and accepts review comments like any PR, but is explicitly marked not ready to
merge until its author flips it to "ready for review". A
[council round](/beliefs/glossary/council-round.md) uses one as its chamber — the
shared state that findings, dispositions, and the closing tally attach to —
so independent sessions can resume the round from the PR itself. Contrast the
ordinary ship-path PR opened by
[`/create-pull-request`](/.claude/skills/create-pull-request/SKILL.md), which
is created ready and merged with a [true merge](/beliefs/glossary/true-merge.md).

*Seen in:* [2026-07-13 council-round thread](/meta/threads/2026-07-13-council-round-suitability-evaluation.md), [council-round-suitability analysis](/meta/analysis/council-round-suitability.md)
