---
id: sb:e7689f
type: concept
title: fast-forward merge
description: A git merge where the target branch's tip is an ancestor of the incoming branch, so the pointer simply advances with no new merge commit — leaving the branches identical.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, git]
sense: common
timestamp: 2026-07-10
attribution:
  when: 2026-07-11T08:41:24+02:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# fast-forward merge

A git merge where the target branch's tip is already an ancestor of the branch being merged, so the pointer simply advances to the incoming tip with no new merge commit and no divergence. A fast-forwarded branch ends up identical to its source — a zero-diff branch that cannot open a non-empty pull request.

*Seen in:* [2026-07-09 remove-email thread](/meta/threads/2026-07-09-remove-operator-email-from-contract.md)
