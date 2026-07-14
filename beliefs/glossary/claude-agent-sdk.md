---
id: em:bee09c
type: concept
title: Claude Agent SDK
description: Anthropic's Python/TypeScript library exposing the same agent engine as Claude Code — the agent loop, tool use, and context management — as an embeddable component you drive from your own process.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, agents, anthropic, sdk, harness]
sense: common
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T12:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-13 advisor-pattern thread's Claude Code / Agent SDK / Managed Agents distinction"
---

# Claude Agent SDK

Anthropic's Python/TypeScript library that exposes the same agent engine as Claude
Code — the agent loop, tool use, and context management — as an **embeddable
component** you drive from your own process, for building custom
[harnesses](/beliefs/glossary/harness.md) without Anthropic hosting the runtime. It sits in
the middle of a three-way split organized by *who owns the loop and the execution
environment*: Claude Code is an interactive product you drive from a terminal, the
Agent SDK is that same engine as a library embedded in your software, and
[Claude Managed Agents](/beliefs/glossary/claude-managed-agents.md) is the option where
Anthropic hosts both the loop and the execution sandbox for you.

*Seen in:* [2026-07-13 advisor-pattern thread](/meta/threads/2026-07-13-advisor-pattern-and-rolling-your-own-harness.md)
