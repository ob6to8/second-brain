---
id: sb:e55bda
type: concept
title: run (canonical run)
description: A single end-to-end execution of a flow or task — the unit a flow doc narrates as its touch-sequence, and the unit a scheduled Routine produces on each firing.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, flows, workflow, tooling]
sense: dual
timestamp: 2026-07-13
attribution:
  when: 2026-07-12T09:43:37+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# run (canonical run)

A single end-to-end execution of a program, job, or workflow, from invocation to completion — an *instance* of the thing executing, as distinct from the thing itself.

**In this brain:** a single end-to-end execution of a flow, task, or scheduled job, from invocation to its last file touched. Two local senses: **(1)** the unit a flow doc narrates — its "touch-sequence of a canonical run" lists every file one representative execution touches, in order, which is also the unit a [scenario test](/beliefs/glossary/scenario-test.md) pins the deterministic spine of; **(2)** the unit a scheduled [Routine](/beliefs/glossary/routine.md) produces on each firing (as in the open issue about daily `/research` runs not landing). In both senses a run is an *instance*, distinct from the flow (the repeatable shape) and the skill (the procedure).

*Seen in:* [the intake flow](/meta/flows/intake.md), [the research-inbox flow](/meta/flows/research-inbox.md), [daily /research Routine runs not landing](/meta/issues/daily-news-routine-runs-not-landing.md), [2026-07-12 docs-audit thread](/meta/threads/2026-07-12-docs-audit-wiki-verdict-and-freshness-warnings.md)
