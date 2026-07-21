---
id: em:f3e4cb
type: concept
title: control plane
description: "The management layer of a system — the part that decides, configures, and supervises (budgets, grants, routing, health) — as distinct from the data plane or worker layer that performs the actual work."
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, architecture, orchestration, infrastructure]
sense: common
timestamp: 2026-07-21
attribution:
  when: 2026-07-21T00:01:43Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-21 ECS intake and agent-entity substitution thread"
---

# control plane

The vocabulary comes from networking (where the control plane computes routes and the data plane forwards packets) and generalizes to any split between supervision and execution. For agent fleets, the [agent-for-entity analysis](/meta/analysis/agent-for-entity-ecs-as-agent-fleet-control-plane.md) locates the control plane as the one place [entity–component–system](/beliefs/glossary/entity-component-system.md) architecture legitimately applies — the orchestrator's *record* of each agent is passive data even though the agent itself is an active [actor](/beliefs/glossary/actor-model.md).

*Seen in:* [agent-for-entity analysis](/meta/analysis/agent-for-entity-ecs-as-agent-fleet-control-plane.md), [2026-07-21 ECS intake thread](/meta/threads/2026-07-21-ecs-intake-and-agent-entity-substitution.md)
