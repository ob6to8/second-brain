---
id: em:3c44a8
type: concept
title: hunk
description: A contiguous run of changed lines in a diff, delimited by an `@@` range header — the unit at which diff tooling displays, stages, reverts, or comments on a change.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, git, diff, review]
sense: common
timestamp: 2026-07-18
attribution:
  when: 2026-07-18T07:05:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-18 agent-drivable-apps thread"
---

# hunk

Granularity is what makes the unit matter: `git add -p` stages per hunk, review
UIs accept or revert per hunk, and an agent can be navigated to "file X, hunk 2"
as a stable address inside a changeset. The modem-dev **hunk** terminal diff
viewer is named for the unit; its session API addresses live diffs by file and
hunk index.

*Seen in:* [2026-07-18 agent-drivable-apps thread](/meta/threads/2026-07-18-agent-drivable-apps-warp-hunk-nvim.md), [agent-drivable-apps analysis](/meta/analysis/agent-drivable-apps-shared-state-dual-interfaces.md)
