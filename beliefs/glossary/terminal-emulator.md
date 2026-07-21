---
id: em:d2fd32
type: concept
title: terminal emulator
description: The application that owns a terminal window — rendering text from escape sequences and forwarding keystrokes to the programs running inside it — e.g. iTerm2, Ghostty, Terminal.app, or Warp.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, terminal, tooling]
sense: common
timestamp: 2026-07-18
attribution:
  when: 2026-07-18T07:05:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-18 agent-drivable-apps thread"
---

# terminal emulator

One corner of a three-way distinction: the emulator owns the window and draws
cells; a [TUI](/beliefs/glossary/tui.md) is a program painted *inside* it; a
[terminal multiplexer](/beliefs/glossary/terminal-multiplexer.md) sits between the
two, hosting and controlling other terminal programs. Vendors differentiate by
bolting native GUI chrome onto the emulator (Warp's code-review panel), which
is why such features exist only inside that product.

*Seen in:* [2026-07-18 agent-drivable-apps thread](/meta/threads/2026-07-18-agent-drivable-apps-warp-hunk-nvim.md), [agent-drivable-apps analysis](/meta/analysis/agent-drivable-apps-shared-state-dual-interfaces.md)
