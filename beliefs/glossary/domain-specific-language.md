---
id: sb:8b3e30
type: concept
title: domain-specific language
description: A small language purpose-built for one problem domain, trading generality for concision and checkability; in Elixir, typically implemented as a macro layer that expands declarations into full code.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, dsl, languages, metaprogramming, elixir]
sense: common
timestamp: 2026-07-14
attribution:
  when: 2026-07-14T00:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-14 Elixir AST/macros and Loomkin thread"
---

# domain-specific language

A language deliberately narrowed to one problem domain — a router table, a schema declaration, a build script — trading general-purpose power for concision, readability, and machine checkability within its niche. DSLs come *external* (their own parser, like SQL) or *embedded* (hosted inside a general language's syntax); Elixir's embedded DSLs are built from [macros](/beliefs/glossary/macro.md) that expand declarations into full implementations with compile-time validation. For LLM-facing systems a DSL doubles as a *constrained generation target*: shrinking the language a model must emit raises the reliability of what it emits, with the compiler serving as the validator — the same insight as schema-constrained structured output, one level up.

*Seen in:* [2026-07-14 Elixir AST/macros and Loomkin thread](/meta/threads/2026-07-14-elixir-ast-macros-and-loomkin-evaluation.md), [Elixir AST/macro analysis](/meta/analysis/elixir-ast-macros-for-llm-harnesses.md)
