---
id: sb:334e60
type: concept
title: mounting point (harness)
description: The file path where a third-party harness expects content to appear (CLAUDE.md at session start, a skill's SKILL.md on invocation) — the harness's convention, distinct from the brain-defined role that fills it.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, governance, harness, claude-code]
sense: repo
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T20:15:23+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# mounting point (harness)

The file path where a third-party harness expects content to appear — Claude Code reads `/CLAUDE.md` at session start and a skill's `SKILL.md` on invocation. The path is the harness's convention, not the brain's: the *role* that fills it (the [operating contract](/beliefs/glossary/operating-contract.md); a skill's procedure) is defined by the brain and would survive a harness change with only the output path moving. Separating role from mounting point is what lets `CLAUDE.md` be a [rendered aggregation](/beliefs/glossary/rendered-aggregation.md) compiled from `meta/policy/` while each `SKILL.md` stays a hand-authored source of truth.

*Seen in:* [2026-07-11 branch-deletion/contract thread](/meta/threads/2026-07-11-branch-deletion-policy-and-contract-as-abstraction.md), [contracts-and-rendered-aggregations analysis](/meta/analysis/contracts-and-rendered-aggregations.md)
