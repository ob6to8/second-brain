---
id: sb:bf8a85
type: reference
title: "Context editing and the memory tool — productizing compaction and note-taking (Anthropic)"
description: Anthropic shipped a server-side Context Editing API (auto-clearing stale tool results, cache-friendly) and a file-based Memory Tool on the Claude Developer Platform the same day as its "effective context engineering" essay, turning two of that essay's recommended techniques into literal API primitives.
resource: https://claude.com/blog/context-management
provenance: "Distilled from Anthropic/Claude, 'Managing context on the Claude Developer Platform', 2025-09-29"
tags: [claude-code, context-engineering, memory, api-features, agentic-loop]
timestamp: 2026-07-06
---

# Context editing and the memory tool — productizing compaction and note-taking (Anthropic)

Anthropic, "Managing context on the Claude Developer Platform", 2025-09-29 —
released the **same day** as
[Effective context engineering for AI agents](/SWE/agentic-coding/agentic-loop/effective-context-engineering-for-agents.md).
*(Summarized; full announcement at the resource link.)*

## Summary

An earlier Anthropic essay argued that agents running in a loop need their
accumulated context actively managed — old, no-longer-useful information should
be cleared out, and important facts should be written down somewhere durable
rather than left to clutter the working conversation. This announcement is
where that advice became actual product features on the Claude Developer
Platform, rather than something a developer has to hand-build. The first
feature automatically strips out old tool calls and their results once a
conversation gets close to running out of room, done on Anthropic's servers in
a way that doesn't throw away the performance benefit of prompt caching. The
second feature gives the model a small set of file-management actions — create,
read, update, delete — pointed at a dedicated storage location that persists
between separate conversations, so the model can build up a durable notebook of
what it has learned over time instead of carrying everything in its working
context. Together, in Anthropic's own benchmarks, these two features let a
long-running agent use dramatically fewer tokens without losing capability.

## Key terms

- **Context editing** — the server-side feature that automatically removes
  stale tool-call/result pairs (and old reasoning blocks) from an agent's
  context once it nears its token limit, without requiring the developer to
  write custom trimming logic.
- **Prompt cache** — an optimization where unchanged portions of a prompt don't
  need to be reprocessed on every request; naive client-side context trimming
  breaks this by changing the prompt's prefix, whereas context editing is
  designed to preserve it.
- **Memory tool** — a set of file-operation actions (create, read, update,
  delete) that let the model manage its own persistent storage directory,
  functioning as long-term memory that survives across separate conversations
  and doesn't consume context-window space while idle.

## Technical summary

Context editing operates server-side, automatically clearing stale tool-use and
tool-result pairs (and old thinking blocks) as an agent approaches its context
limit, while preserving the prompt cache prefix that naive client-side trimming
would invalidate. The memory tool gives the model file-level CRUD operations
against a persistent, developer-hosted memory directory, letting an agent
maintain project state and prior learnings across sessions without keeping that
information resident in the context window. Anthropic reports context editing
alone yields a 29% performance improvement over baseline; combined with the
memory tool, 39%; and in a 100-turn web-search evaluation, the combination cuts
token consumption by 84% while completing the task. These features are
available in public beta (context editing) and generally available (memory
tool) on the Messages API, and via Bedrock and Vertex AI.

## Relation to other captures

These two features are literal implementations of two of the four techniques
recommended in [Effective context engineering for AI agents](/SWE/agentic-coding/agentic-loop/effective-context-engineering-for-agents.md):
context editing operationalizes **compaction**, and the memory tool
operationalizes **structured note-taking**. See that concept's currency-check
section for the fuller picture of how the essay's guidance has held up. Also
supported empirically by [Chroma's context rot research](/SWE/agentic-coding/context-engineering/context-rot-chroma-research.md).

# Citations

Anthropic, "Managing context on the Claude Developer Platform", 2025-09-29 —
<https://claude.com/blog/context-management>
