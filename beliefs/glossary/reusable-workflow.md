---
id: em:2bcd9a
type: concept
title: reusable workflow
description: A GitHub Actions workflow published with a workflow_call trigger so other repositories invoke it as a single `uses:` line, centralizing a shared CI pipeline in one place instead of duplicating it per repo.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, ci, github-actions, tooling]
sense: common
timestamp: 2026-07-17
attribution:
  when: 2026-07-17T18:10:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-17 library spin-out spec thread"
---

# reusable workflow

The
[spin-out plan](/meta/plans/library-spin-out-and-dependency-distribution.md)'s
preferred CI shape post-split: `composable-beliefs-3` publishes the gate
suite as a reusable workflow, and each knowledge-base repo's `ci.yml` shrinks
to a few lines referencing it — so gate-suite evolution ships with library
releases rather than requiring an edit sweep across N bundle repos.
`pages.yml` stays per-bundle (deploy target and cadence are bundle concerns)
while calling the same underlying `mix brain.*` tasks.

*Seen in:* [2026-07-17 library spin-out spec thread](/meta/threads/2026-07-17-library-spin-out-spec.md)
