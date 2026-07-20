---
id: em:eacc3f
type: concept
title: shared state, dual interfaces
description: An application architecture in which a human-facing UI and an agent-facing structured API operate as two clients of the same live process state — the human gets pixels, the agent gets JSON, and neither scrapes the other.
provenance: "Agent-distilled glossary definition — coined in the agent-drivable-apps analysis"
verified: false
tags: [glossary, agents, architecture, ipc, review]
sense: repo
timestamp: 2026-07-18
attribution:
  when: 2026-07-18T07:05:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-18 agent-drivable-apps thread"
---

# shared state, dual interfaces

Existing instances predate the name: Neovim's GUI-plus-RPC-socket architecture,
Chrome plus the DevTools Protocol, the hunk diff viewer's TUI plus session
daemon. The shape beats both alternatives for agent access — the
[terminal multiplexer](/beliefs/glossary/terminal-multiplexer.md)'s keystroke
injection and [computer use](/beliefs/glossary/computer-use.md)'s pixel driving —
because the agent addresses the app's own semantics and gets values back.
Its unresolved edge is the trust model: local sockets carry no auth, so the
safe form routes agent reach through a capability-scoped broker (this bundle's
[librarian write-broker](/beliefs/glossary/librarian-write-broker.md) shape).

*Seen in:* [2026-07-18 agent-drivable-apps thread](/meta/threads/2026-07-18-agent-drivable-apps-warp-hunk-nvim.md), [agent-drivable-apps analysis](/meta/analysis/agent-drivable-apps-shared-state-dual-interfaces.md)
