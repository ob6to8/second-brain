---
id: sb:41a1e3
type: reference
title: "AI agent memory management — when markdown files are all you need (dev.to)"
description: Survey arguing that file-based markdown memory beats database frameworks for local AI agents, citing the independent convergence of Manus, OpenClaw, and Claude Code on plain-text memory, with a search-strategy progression (grep → BM25 → hybrid vector) as the memory corpus grows.
resource: https://dev.to/imaginex/ai-agent-memory-management-when-markdown-files-are-all-you-need-5ekk
provenance: "Migrated from the legacy assertion-graph bundle (deprecated/sources/ai-agent-memory-markdown-files.md, captured 2026-03-03); re-fetched and re-distilled from the dev.to article 2026-07-11"
tags: [agent-memory, context-engineering, markdown, file-based-persistence, agentic]
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T17:05:21+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# AI agent memory management — when markdown files are all you need (dev.to)

Yaohua Chen ("imaginex"), DEV Community, 2026-02-18.
*(Summarized; full article at the resource link.)*

## Summary

The article's core observation is a convergence argument: three prominent,
independently built agent projects — Manus (acquired by Meta for $2B in
December 2025), OpenClaw (145K+ GitHub stars), and Anthropic's Claude Code —
all settled on plain markdown files for agent memory rather than database
frameworks. Files decouple memory from the process lifecycle (surviving
restarts and crashes), are human-readable and hand-editable in any text
editor, version naturally under git, avoid vendor lock-in, and cost orders of
magnitude less than managed vector stores ($0.02/GB/month local disk vs.
$50–200/GB/month managed vector databases). The trade-off is scale: markdown
suits *local* agents whose context is finite and structured; database
frameworks remain the fit for *enterprise* agents managing memory across
millions of user profiles.

## Key terms

- **Memory types** — the article's four categories: **short-term** (the live
  context window, minutes), **long-term** (persistent facts and preferences
  across sessions), **procedural** (learned workflows, permanent once
  codified), and **working** (a scratchpad for in-task reasoning, seconds to
  minutes).
- **Remembrance layer** — the what-happened files: a curated `MEMORY.md`
  loaded into every conversation, daily logs at `memory/YYYY-MM-DD.md`, and a
  `task_plan.md` for current goals and progress.
- **Personalization layer** — the who-am-I files: `SOUL.md` (core values and
  behavioral guidelines), `IDENTITY.md` (public identity and communication
  style), `USER.md` (user profile and preferences), plus modular on-demand
  skill files.
- **Search progression** — the scaling story for file-based memory: plain
  text search (grep) below ~1,000 files; BM25 full-text ranking for
  1,000–10,000; hybrid vector + BM25 beyond 10,000 (OpenClaw: 70:30
  vector-to-BM25 weighting with a 0.35 minimum-score threshold, reported at
  89% recall).

## Technical summary

Each cited project instantiates the same pattern differently: Manus used a
three-file loop (`task_plan.md`, `notes.md`, and deliverable files) for
long-running agents; OpenClaw layers `MEMORY.md` (curated) over dated daily
logs plus `SOUL.md`; Claude Code uses the `CLAUDE.md` hierarchy for project
context, an auto-captured `.claude/MEMORY.md`, and skills for on-demand
capability loading. The remembrance/personalization split separates
accumulating operational state from stable identity configuration. Retrieval
is deliberately staged rather than vector-first: exact text search is free and
deterministic at small scale, and semantic search is added only when corpus
size demands it — inverting the framework-default assumption that agent
memory starts with an embedding store.

## Relation to other captures

This is the survey-level counterpart to
[Anthropic's context editing and memory tool](/knowledge/SWE/agentic/context-engineering/claude-context-editing-and-memory-tool.md),
which productizes file-based note-taking as an API primitive, and to the
structured note-taking technique in
[Effective context engineering for AI agents](/knowledge/SWE/agentic/agentic-loop/effective-context-engineering-for-agents.md).
It is also a fair description of this very repository: the second brain is a
git-versioned markdown bundle searched by exact text (grep), sitting squarely
in the article's under-1,000-file tier — see
[vector-db recall for the scaling bundle](/meta/analysis/vector-db-recall-for-the-scaling-bundle.md)
for this brain's own analysis of when that stops sufficing.

# Citations

Yaohua Chen, "AI Agent Memory Management: When Markdown Files Are All You
Need", DEV Community, 2026-02-18 —
<https://dev.to/imaginex/ai-agent-memory-management-when-markdown-files-are-all-you-need-5ekk>

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="sb:41a1e3">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-11-deprecated-directory-triage-and-machinery-deletion (2026-07-11)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:41a1e3`]**

**Intake result.** `deprecated/sources/ai-agent-memory-markdown-files.md` is now migrated into the bundle as [`SWE/agentic-coding/context-engineering/ai-agent-memory-management-markdown-files.md`](/SWE/agentic-coding/context-engineering/ai-agent-memory-management-markdown-files.md) (`sb:41a1e3`, `type: reference`). I re-fetched the dev.to article rather than just copying the legacy capture, which added detail the old summary lacked (the author's name, Manus's `task_plan.md`/`notes.md`/deliverables pattern, and OpenClaw's 70:30 vector-to-BM25 weighting at 89% recall). It's cross-linked to the Anthropic memory-tool reference and the context-engineering essay, and the provenance records the migration from the legacy bundle. Directory `index.md`, root `log.md`, and `meta/registry.md` are updated; `mix brain.verify`, `brain.route_tags`, and `brain.contract --check` all pass. Committed and pushed to `claude/deprecated-directory-deletion-myusjh` (no PR opened — say the word or run `/create-pull-request` when you want one).
