---
id: sb:aa3e46
type: concept
title: dependency-free
description: A property of a program that relies only on its language/runtime standard library and pulls in no external packages, so it needs no package-fetch step and runs offline in restricted or ephemeral environments.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, tooling, ci]
sense: common
timestamp: 2026-07-12
attribution:
  when: 2026-07-11T08:41:24+02:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# dependency-free

A property of a program that relies only on its language/runtime standard library and pulls in no external packages, so it needs no package-fetch step and runs offline in restricted or ephemeral (e.g. no-egress, snapshot-booted) environments. This brain's Elixir tooling is deliberately dependency-free for exactly this reason — a constraint load-bearing enough that any resident runtime must live in a separate application depending on the core, never the reverse.

*Seen in:* [2026-07-09 GitHub Pages thread](/meta/threads/2026-07-09-github-pages-knowledge-base-site.md), [2026-07-09 live-render thread](/meta/threads/2026-07-09-live-render-appraisal-and-pages-hardening.md), [BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md)
