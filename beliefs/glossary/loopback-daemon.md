---
id: em:720742
type: concept
title: loopback daemon
description: A background broker process listening on a localhost-only socket, giving processes on the same machine a rendezvous point for structured communication that never leaves the host.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, ipc, architecture, security, agents]
sense: common
timestamp: 2026-07-18
attribution:
  when: 2026-07-18T07:05:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-18 agent-drivable-apps thread"
---

# loopback daemon

The two words decompose cleanly: a *daemon* is a long-running background process
with no UI of its own; *loopback* is the network interface (`127.0.0.1`) whose
packets are handed straight back to the local OS. The tmux server, `dockerd`,
and the hunk diff viewer's session broker all follow the shape: interactive
clients register with the daemon, other clients send commands, the daemon
relays. Because only same-host processes can connect, file permissions are
typically the *entire* access control — the [ambient authority](/beliefs/glossary/ambient-authority.md)
hazard when semi-trusted agents run on the same machine.

*Seen in:* [2026-07-18 agent-drivable-apps thread](/meta/threads/2026-07-18-agent-drivable-apps-warp-hunk-nvim.md), [agent-drivable-apps analysis](/meta/analysis/agent-drivable-apps-shared-state-dual-interfaces.md)
