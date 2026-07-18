---
id: em:35c992
type: concept
title: abstract syntax tree
description: The tree-shaped data structure a parser produces from source code — nodes for the program's constructs, stripped of surface syntax — which programs can then inspect, transform, and render back to source.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, ast, parsing, compilers, metaprogramming]
sense: common
timestamp: 2026-07-14
attribution:
  when: 2026-07-14T00:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-14 Elixir AST/macros and Loomkin thread"
---

# abstract syntax tree

The tree a parser builds from source code: each node represents a construct (a call, a literal, an operator), with the surface details of the text — whitespace, delimiters, comments — abstracted away. An AST is what makes code machine-manipulable: tools inspect it (linters, [tree-sitter](/beliefs/glossary/tree-sitter.md)-based editors), transform it ([macros](/beliefs/glossary/macro.md), refactoring engines), and render it back to source. Elixir is unusual in exposing its own AST as ordinary standard-library data — nested `{form, metadata, arguments}` tuples that `Code.string_to_quoted/1` produces and `Macro.to_string/1` renders back — so a harness can pattern-match structural policy over model-generated code with no external parser.

*Seen in:* [2026-07-14 Elixir AST/macros and Loomkin thread](/meta/threads/2026-07-14-elixir-ast-macros-and-loomkin-evaluation.md), [Elixir AST/macro analysis](/meta/analysis/elixir-ast-macros-for-llm-harnesses.md)
