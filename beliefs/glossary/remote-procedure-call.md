---
id: em:7247f3
type: concept
title: remote procedure call (RPC)
description: A pattern in which one process invokes a function in another as if it were local, with arguments and return values serialized across a transport such as a socket.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, ipc, protocol, architecture]
sense: common
timestamp: 2026-07-18
attribution:
  when: 2026-07-18T07:05:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-18 agent-drivable-apps thread"
---

# remote procedure call (RPC)

What distinguishes it from input injection or screen scraping is the round
trip: calls return typed values and errors come back as errors, so a caller can
*ask* a program for exact state instead of parsing its rendered output. Neovim
exposes its full editor surface over MessagePack-RPC on an auto-created socket
(every GUI is just an RPC client), and the
[Model Context Protocol](/beliefs/glossary/model-context-protocol.md) is JSON-RPC
under the hood.

*Seen in:* [2026-07-18 agent-drivable-apps thread](/meta/threads/2026-07-18-agent-drivable-apps-warp-hunk-nvim.md), [agent-drivable-apps analysis](/meta/analysis/agent-drivable-apps-shared-state-dual-interfaces.md)
