---
id: em:25711c
type: concept
title: compile-time coupling
description: A dependency where one module must recompile whenever another changes — created by compile-time references such as macros or struct expansion — which compounds into slow, cascading rebuilds as a codebase grows.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, elixir, tooling, code-quality, ci]
sense: common
timestamp: 2026-07-23
attribution:
  when: 2026-07-23T18:15:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-23 ai-drift intake thread"
---

# compile-time coupling

In Elixir the compiler tracks these edges and `mix xref graph` surfaces them;
the `compile-connected` label selects the transitive form, where a
compile-time reference fans out through a module's own runtime dependencies
and one edit triggers a rebuild cascade. This repo bans the class outright:
`mix xref graph --label compile-connected --fail-above 0` is a build gate (per
the [elixir-coding-standards policy](/meta/policy/elixir-coding-standards.md))
— the count is zero and any new edge turns CI red rather than accreting
silently.

*Seen in:* [2026-07-23 ai-drift intake thread](/meta/threads/2026-07-23-ai-drift-intake-and-coding-standards-ratification.md), [Guarding Against AI Drift (Mike Zornek)](/knowledge/SWE/agentic/code-quality/guarding-against-ai-drift.md)
