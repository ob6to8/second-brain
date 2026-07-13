---
id: sb:04b9a8
type: concept
title: Claude Managed Agents (CMA)
description: Anthropic's hosted agent service (beta) where the agent loop runs on Anthropic's orchestration layer and each session provisions a sandboxed container for tool execution — with versioned agent configs, scheduled deployments, rubric-graded outcomes, and egress-substituted credential vaults.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, managed-agents, anthropic, agents, hosted, beam]
sense: common
timestamp: 2026-07-12
---

# Claude Managed Agents (CMA)

Anthropic's hosted agent service (beta, `managed-agents-2026-04-01`): the one Anthropic surface that supplies *both* the agent harness and its deployment. The agent loop runs on Anthropic's orchestration layer; each **session** provisions a sandboxed container where the agent's tools (bash, file ops, code) execute. Agents are persisted, *versioned* configs (model, system prompt, tools, MCP servers, skills); sessions mount resources (files, GitHub repos, memory stores) and emit an event stream. Higher-level primitives include **scheduled deployments** (cron-fired sessions with audited runs), **outcomes** (a rubric-graded iterate loop), **permission policies** (`always_ask` pausing for human confirmation), and **[credential vaults](/beliefs/glossary/credential-vault.md)**. Its unit of agency is always a Claude session — a heavyweight, LLM-backed worker — which fits deliberative work and misfits high-frequency mechanical work, the split the [two-plane rule](/beliefs/glossary/two-plane-rule.md) draws.

*Seen in:* [Managed Agents vs. Jido/BEAM analysis](/meta/analysis/claude-managed-agents-vs-beam-jido.md)
