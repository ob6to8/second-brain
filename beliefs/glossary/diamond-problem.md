---
id: em:610415
type: concept
title: diamond problem
description: "The multiple-inheritance ambiguity in which a class with two parents sharing a common ancestor (or defining the same method) inherits conflicting definitions, leaving undefined which implementation applies."
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, oop, inheritance, software-design]
sense: common
timestamp: 2026-07-21
attribution:
  when: 2026-07-21T00:01:43Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-21 ECS intake and agent-entity substitution thread"
---

# diamond problem

Named for the diamond shape of the inheritance diagram (one ancestor, two parents, one child). It is a standard motivation for [composition over inheritance](/beliefs/glossary/composition-over-inheritance.md), and why many languages forbid multiple class inheritance outright, offering interfaces, traits, or protocols instead.

*Seen in:* [Entity Component Systems in Elixir (Riady capture)](/knowledge/SWE/software-design/entity-component-systems-in-elixir.md), [2026-07-21 ECS intake thread](/meta/threads/2026-07-21-ecs-intake-and-agent-entity-substitution.md)
