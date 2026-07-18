---
id: em:4aa4da
type: concept
title: ambient authority
description: Access a process holds simply by virtue of where and as whom it runs — every same-user resource reachable with no explicit grant — rather than through a capability it was deliberately handed.
provenance: "Agent-distilled glossary definition (capability-security term of art)"
verified: false
tags: [glossary, security, capability, trust-model, agents]
sense: common
timestamp: 2026-07-18
attribution:
  when: 2026-07-18T07:05:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-18 agent-drivable-apps thread"
---

# ambient authority

The term comes from capability-security literature, where it names the failure
mode capabilities exist to prevent. It turns hazardous when semi-trusted
autonomous processes run as the user all day: an agent (or a compromised
package postinstall) can reach every unauthenticated
[loopback daemon](/beliefs/glossary/loopback-daemon.md) and editor socket the user's
own tools left listening. Sandboxed execution removes it wholesale — the agent
is no longer the same user on the same kernel — at the price of an explicit,
scopeable channel back in.

*Seen in:* [2026-07-18 agent-drivable-apps thread](/meta/threads/2026-07-18-agent-drivable-apps-warp-hunk-nvim.md), [agent-drivable-apps analysis](/meta/analysis/agent-drivable-apps-shared-state-dual-interfaces.md)
