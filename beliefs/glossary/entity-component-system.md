---
id: em:560ae2
type: concept
title: entity–component–system
description: "A software architecture, native to game engines, that models a domain as entities (bare IDs), components (pure data attached to entities), and systems (behavior that sweeps all components of a given kind each tick) — composition over inheritance taken to an architectural extreme."
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, ecs, software-design, architecture, game-development]
sense: common
timestamp: 2026-07-21
attribution:
  when: 2026-07-21T00:01:43Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-21 ECS intake and agent-entity substitution thread"
---

# entity–component–system

The split is total: an entity has no behavior, a component has no methods, and a system has no state of its own. Because capability lives in which components an entity currently carries, capability sets can change at runtime without any taxonomy — the property that distinguishes ECS from milder [composition-over-inheritance](/beliefs/glossary/composition-over-inheritance.md) designs. In compiled engines the pattern also buys cache-local memory layout (components of one type packed contiguously); that half does not survive translation to the BEAM, where Elixir frameworks (ECSx, ECSpanse) store components in ETS tables instead. Canonical capture: [Entity Component Systems in Elixir](/knowledge/SWE/software-design/entity-component-systems-in-elixir.md); applicability verdicts: [beyond gaming](/meta/analysis/ecs-beyond-gaming-in-elixir.md) and [agent fleets](/meta/analysis/agent-for-entity-ecs-as-agent-fleet-control-plane.md).

*Seen in:* [Entity Component Systems in Elixir (Riady capture)](/knowledge/SWE/software-design/entity-component-systems-in-elixir.md), [ECS beyond gaming analysis](/meta/analysis/ecs-beyond-gaming-in-elixir.md), [agent-for-entity analysis](/meta/analysis/agent-for-entity-ecs-as-agent-fleet-control-plane.md), [2026-07-21 ECS intake thread](/meta/threads/2026-07-21-ecs-intake-and-agent-entity-substitution.md)
