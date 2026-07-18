---
id: em:19d8db
type: concept
title: macro
description: A compile-time function from code to code — in Elixir, from AST to AST — that lets a small declarative surface expand into full implementation, with errors raised during compilation.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, macro, metaprogramming, elixir, compile-time]
sense: common
timestamp: 2026-07-14
attribution:
  when: 2026-07-14T00:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-14 Elixir AST/macros and Loomkin thread"
---

# macro

A function that runs at compile time and transforms code itself — in the Lisp/Elixir tradition, a function from [abstract syntax tree](/beliefs/glossary/abstract-syntax-tree.md) to abstract syntax tree. Elixir macros are built with `quote`/`unquote` (constructing code as data) and invoked through constructs like `use`, which injects a whole scaffold into the calling module; hooks such as `@before_compile` let a module validate itself during compilation. Macros are how Elixir [domain-specific languages](/beliefs/glossary/domain-specific-language.md) exist (Ecto schemas, Phoenix routers, [Jido](/beliefs/glossary/jido.md) Actions): a small declaration expands into the real implementation, with mistakes caught as compile-time errors. The trade-off is legibility — the semantics live in the expansion, not on the page — which is friction for any reader, human or model, who sees only the declaration.

*Seen in:* [2026-07-14 Elixir AST/macros and Loomkin thread](/meta/threads/2026-07-14-elixir-ast-macros-and-loomkin-evaluation.md), [Elixir AST/macro analysis](/meta/analysis/elixir-ast-macros-for-llm-harnesses.md)
