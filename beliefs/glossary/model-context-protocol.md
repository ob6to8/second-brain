---
id: sb:c66f10
type: concept
title: Model Context Protocol (MCP)
description: An open client/server protocol standardizing how applications expose tools, resources, and context to LLM agents, so an agent calls a uniform interface instead of each integration being hand-wired.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, mcp, agentic-coding, tools, protocol]
timestamp: 2026-07-12
---

# Model Context Protocol (MCP)

An open protocol that standardizes how a host application supplies **tools,
resources, and context** to an LLM: a server advertises a set of callable tools
(and readable resources) over a uniform interface, and an agent client invokes them,
so integrations plug in once rather than being wired bespoke into each agent. Code
knowledge-graph tools like GitNexus and Codebase-Memory expose their queries to
coding agents this way.

*Seen in:* [2026-07-11 news-digest thread](/meta/threads/2026-07-11-news-digest-intake-and-daily-read.md), [Codebase-Memory](/knowledge/SWE/agentic-coding/code-context/codebase-memory-mcp.md), [GitNexus](/knowledge/SWE/agentic-coding/code-context/gitnexus.md), [BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md)
