---
id: em:3a30cd
type: concept
title: terminal multiplexer
description: A layer between the terminal emulator and the programs it hosts that multiplexes several terminal sessions into panes and windows, and can inject input into or capture output from any hosted program — tmux being canonical.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, terminal, tooling, automation]
sense: common
timestamp: 2026-07-18
attribution:
  when: 2026-07-18T07:05:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-18 agent-drivable-apps thread"
---

# terminal multiplexer

`send-keys` and `capture-pane` make it the *universal adapter* for driving
arbitrary terminal programs: every such program has an input stream and a
screen, so impersonating a human at the keyboard always works — at the cost of
no return values and silent misfires when mode or focus is wrong. Programs that
expose a [remote procedure call](/beliefs/glossary/remote-procedure-call.md)
surface make this fallback unnecessary.

*Seen in:* [2026-07-18 agent-drivable-apps thread](/meta/threads/2026-07-18-agent-drivable-apps-warp-hunk-nvim.md), [agent-drivable-apps analysis](/meta/analysis/agent-drivable-apps-shared-state-dual-interfaces.md)
