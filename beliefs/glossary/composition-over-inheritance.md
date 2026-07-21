---
id: em:4e4719
type: concept
title: composition over inheritance
description: "The design principle of building a thing's capabilities by aggregating independent parts (has-a) rather than deriving from ancestor classes (is-a), so capability sets can vary per instance and change at runtime instead of being fixed by a taxonomy."
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, software-design, oop, composition]
sense: common
timestamp: 2026-07-21
attribution:
  when: 2026-07-21T00:01:43Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-21 ECS intake and agent-entity substitution thread"
---

# composition over inheritance

The principle exists because deep class hierarchies fail in two characteristic ways — the [diamond problem](/beliefs/glossary/diamond-problem.md) when an ability must come from two parents, and the blob antipattern when shared abilities are pushed up to a bloating base class. [Entity–component–system](/beliefs/glossary/entity-component-system.md) architecture is the principle taken to an extreme; in Elixir, which has no inheritance at all, protocols and behaviours provide polymorphism compositionally by default, and the [Jido](/beliefs/glossary/jido.md) agent framework applies the same move to agents (composable Actions, Skills, and Sensors instead of role hierarchies).

*Seen in:* [Entity Component Systems in Elixir (Riady capture)](/knowledge/SWE/software-design/entity-component-systems-in-elixir.md), [2026-07-21 ECS intake thread](/meta/threads/2026-07-21-ecs-intake-and-agent-entity-substitution.md)
