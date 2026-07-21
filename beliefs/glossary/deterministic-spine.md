---
id: em:d18504
type: concept
title: deterministic spine
description: The subset of a workflow whose output is fully determined by its inputs — the mechanical tool transforms and checks — as opposed to the non-deterministic, judgment-driven parts; only the spine can be pinned by a conventional test.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, testing, flows]
sense: repo
timestamp: 2026-07-16
attribution:
  when: 2026-07-11T08:41:24+02:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# deterministic spine

A flow's scenario test targets exactly this spine, leaving the judgment-driven remainder outside what a conventional automated test can pin.

*Seen in:* [2026-07-09 flows-genre thread](/meta/threads/2026-07-09-flows-genre-and-scenario-testing.md), [Dynamic Workflows vs. BEAM/Jido 2 analysis](/meta/analysis/dynamic-workflows-vs-beam-jido.md)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:d18504">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-16-dynamic-workflows-vs-beam-jido (2026-07-16)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:d18504`]**  (co-feeds: `/meta/analysis/dynamic-workflows-vs-beam-jido.md`)

So: **recreating Dynamic Workflows on the BEAM as a replacement is low-value.** If all you need is a fan-out DAG runner for LLM calls within a task, you'd be reimplementing the orchestrator *plus* the caching/resume, the structured-output validation, the MCP-tool plumbing, and the whole Claude harness integration — to arrive at roughly the same ephemeral batch executor, in an ecosystem with thinner LLM tooling. OTP's superpowers (supervision, hot reload, distribution, durable state) are **wasted on an ephemeral fan-out** — nothing lives long enough to supervise or recover.
