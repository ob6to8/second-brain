---
id: sb:f5eafa
type: concept
title: gate suite
description: The full set of blocking verification checks a change must pass before landing — in this brain, compile/format, the tests, and the mix brain.* checks, run manually, by the pre-commit hook, and in CI.
provenance: "Agent-distilled glossary definition, pointer to the defining tutorial"
verified: false
tags: [glossary, enforcement, ci, tooling]
sense: repo
timestamp: 2026-07-12
---

# gate suite

The full set of blocking verification checks a change must pass before landing —
in this brain: compile and format checks, the ExUnit tests, and the `mix brain.*`
gates (`contract --check`, `registry --check`, `verify`, `route_tags`, and the
site build), run on three surfaces (a manual pass, the pre-commit hook, CI).
Contrast a [warn pass](/beliefs/glossary/warn-pass.md), which reports without
blocking. Canonically defined by
[the gate-suite tutorial](/meta/tutorials/the-gate-suite-and-where-it-runs.md).

*Seen in:* [2026-07-12 root-reorganization thread](/meta/threads/2026-07-12-root-reorganization-knowledge-and-beliefs.md), [2026-07-10 /todo-and-gate-suite thread](/meta/threads/2026-07-10-todo-skill-and-gate-suite-tutorial.md)
