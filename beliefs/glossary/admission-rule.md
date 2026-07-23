---
id: em:27e6ac
type: concept
title: admission rule
description: This brain's gate-adoption criterion — a quality check earns a place in the gate suite only when its signal beats its upkeep cost and it runs offline as a plain mix task, with a carve-out for checks on CI's own configuration, whose subject exists only there.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, governance, gates, tooling, ci]
sense: repo
timestamp: 2026-07-23
attribution:
  when: 2026-07-23T18:15:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-23 ai-drift intake thread"
---

# admission rule

Defined by the
[elixir-coding-standards policy](/meta/policy/elixir-coding-standards.md),
which also records the deliberate rejections the rule produces — no Credo,
Dialyzer, Sobelow, or CI-gated coverage — as intentional gaps rather than
oversights, mirroring the signal-versus-upkeep trade in
[Guarding Against AI Drift](/knowledge/SWE/agentic/code-quality/guarding-against-ai-drift.md).
The offline-plain-mix half exists so every gate runs identically in CI, the
pre-commit hook, and any sandbox (see
[the gate suite](/meta/tutorials/the-gate-suite-and-where-it-runs.md)).

*Seen in:* [elixir-coding-standards policy](/meta/policy/elixir-coding-standards.md), [2026-07-23 ai-drift intake thread](/meta/threads/2026-07-23-ai-drift-intake-and-coding-standards-ratification.md)
