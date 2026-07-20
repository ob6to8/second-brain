---
id: em:dbaf55
type: concept
title: agent-as-presenter
description: A workflow inversion in which the agent renders its output inside the human's own tools — navigating their editor to the change, floating rationale beside the code, driving their live browser — instead of into a chat transcript.
provenance: "Agent-distilled glossary definition — coined in the agent-drivable-apps analysis"
verified: false
tags: [glossary, agents, review, workflow, ux]
sense: repo
timestamp: 2026-07-18
attribution:
  when: 2026-07-18T07:05:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-18 agent-drivable-apps thread"
---

# agent-as-presenter

The motivating bottleneck is review: agents produce changes at machine speed,
and a scrolling transcript makes the human reconstruct each change from prose —
"show me" replaces "tell me". Mechanically it rides on
[shared state, dual interfaces](/beliefs/glossary/shared-state-dual-interfaces.md):
the agent addresses the human's live tool through its API while the human keeps
their muscle memory, context, and focus. Warp's interactive review is the same
loop mirrored (human comments toward the agent).

*Seen in:* [2026-07-18 agent-drivable-apps thread](/meta/threads/2026-07-18-agent-drivable-apps-warp-hunk-nvim.md), [agent-drivable-apps analysis](/meta/analysis/agent-drivable-apps-shared-state-dual-interfaces.md)
