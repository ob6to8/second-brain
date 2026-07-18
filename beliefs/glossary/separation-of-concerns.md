---
id: em:425356
type: concept
title: separation of concerns
description: The design principle that a system should be divided so each part addresses one distinct concern — one responsibility or axis of change — with the boundaries between parts made explicit, so parts can evolve, be versioned, and be reused independently.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, architecture, design]
sense: common
timestamp: 2026-07-15
attribution:
  when: 2026-07-15T09:40:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-15 bundle-library separation planning thread"
---

# separation of concerns

A "concern" is anything that changes for its own reasons: mixing two in one
artifact couples their change cadences, consumers, and review surfaces, so a
delivery-focused edit and a knowledge-filing edit end up competing for the same
history. In this repo the principle names the split between the knowledge
bundle (an opinionated OKF collection) and the Elixir Mind library (the tooling
and the metadata schema it enforces) — cohabiting one root today, delineated by
the [separation plan](/meta/plans/separate-okf-bundle-and-elixir-mind-library.md).

*Seen in:* [2026-07-15 bundle-library separation thread](/meta/threads/2026-07-15-bundle-library-separation-plan.md)
