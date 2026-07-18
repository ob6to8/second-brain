---
id: em:c66f10
type: concept
title: Model Context Protocol (MCP)
description: An open client/server protocol standardizing how applications expose tools, resources, and context to LLM agents, so an agent calls a uniform interface instead of each integration being hand-wired.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, mcp, agentic, tools, protocol]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-11T18:01:58+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# Model Context Protocol (MCP)

Under the protocol, a server advertises a set of callable **tools** (and readable
**resources**) over a uniform interface, and an agent client invokes them, so
integrations plug in once rather than being wired bespoke into each agent. Code
knowledge-graph tools like GitNexus and Codebase-Memory expose their queries to
coding agents this way.

*Seen in:* [2026-07-11 news-digest thread](/meta/threads/2026-07-11-news-digest-intake-and-daily-read.md), [Codebase-Memory](/knowledge/SWE/agentic/code-context/codebase-memory-mcp.md), [GitNexus](/knowledge/SWE/agentic/code-context/gitnexus.md), [BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md)
