---
id: sb:c12a2a
type: concept
title: hot code loading
description: The BEAM's ability to compile and load new module versions into a running system without restarting it, letting live processes migrate to the new code under supervision.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, beam, otp, erlang, elixir, deployment]
sense: common
timestamp: 2026-07-14
attribution:
  when: 2026-07-14T00:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-14 Elixir AST/macros and Loomkin thread"
---

# hot code loading

The [BEAM](/beliefs/glossary/beam.md)'s capacity to load a new version of a module into a *running* system — no restart, no dropped state — with live processes picking up the new code. Combined with Elixir's runtime compilation APIs (`Code.compile_string/1`, `Module.create/3`), it means compilation is a service the running system can invoke on itself: an agent harness can accept new capability definitions as text, compile them, load them under supervision, and roll them back. Distinct from [hot module reload](/beliefs/glossary/hot-module-reload.md), the frontend build-tool technique of swapping JavaScript modules into a browser session during development — same instinct, different substrate and guarantees.

*Seen in:* [2026-07-14 Elixir AST/macros and Loomkin thread](/meta/threads/2026-07-14-elixir-ast-macros-and-loomkin-evaluation.md), [Elixir AST/macro analysis](/meta/analysis/elixir-ast-macros-for-llm-harnesses.md)
