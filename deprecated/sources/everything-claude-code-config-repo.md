---
type: source
source_type: article
title: "Everything Claude Code — Complete Configuration Repository"
url: "https://github.com/affaan-m/everything-claude-code"
aliases: ["everything claude code", "affaan claude code configs"]
tags: [ai, claude-code, agentic-coding, agent-config, coding-agents, mcp, hooks]
source: "GitHub"
authors: ["affaan-m"]
date_published: ""
date_captured: "2026-02-25"
summary: >
  Massive Claude Code plugin repo (50K+ stars) with 13 agents, 48+ skills,
  32+ slash commands, hooks, and rules. Production-ready configs for TDD,
  code review, security, multi-agent orchestration, and continuous learning.
  Created by an Anthropic hackathon winner.
word_count: 800
related:
  - "[[longform-guide-everything-claude-code]]"
  - "[[context-engineering-and-persistent-agent-memory]]"
  - "[[state-of-agentic-coding-ep3-armin-ben]]"
---

## Summary

A kitchen-sink Claude Code plugin repository — 50K+ stars, 6.5K forks — that bundles production-ready configurations for agents, skills, commands, rules, hooks, and MCP setups. Created by an Anthropic hackathon winner. It's essentially a reference architecture for how far you can push Claude Code's extensibility.

## Components

### Agents (13)
Specialized subagents for: planning, architecture, TDD, code review, security analysis, build error resolution, E2E testing, refactoring, documentation, Go/Python review, database evaluation.

### Skills (48+)
Domain-specific knowledge modules: coding standards, backend/frontend patterns, continuous learning, TDD workflows, security reviews, language-specific guidance (Go, Python, Java, C++, Django, Spring Boot), deployment patterns.

### Commands (32+)
Slash commands including:
- `/tdd`, `/plan`, `/e2e`, `/code-review`, `/build-fix`, `/refactor-clean`
- Learning management: `/instinct-status`, `/evolve`
- Multi-agent orchestration tools
- `/skill-create` — generates skills from git history analysis

### Rules
Language-agnostic and language-specific guidelines for `~/.claude/rules/`. Cover coding style, git workflows, testing, performance, security. Languages: TypeScript, Python, Go, Java, C++, Markdown.

### Hooks
Trigger-based automations for session lifecycle, memory persistence, and strategic compaction.

## Notable Features

**Continuous Learning v2** — instinct-based pattern extraction with confidence scoring, import/export, automatic skill generation. The agent learns from its own mistakes and successes across sessions.

**AgentShield** — security auditor with 1282 tests, 102 rules, adversarial reasoning via three Opus agents.

**Cross-platform** — full Windows/macOS/Linux support via Node.js rewrites. Auto-detects package manager (npm, pnpm, yarn, bun).

## Installation

```bash
/plugin marketplace add affaan-m/everything-claude-code
./install.sh typescript  # rules require manual install
/plan "your task"        # start using
```

Requires Claude Code CLI v2.1.0+, Git, Node.js.

## Companion Articles

- **Shorthand Guide** (Jan 16): setup guide — skills, commands, hooks, subagents, MCPs, plugins. The base infrastructure. [X article](https://x.com/affaanmustafa/status/2012378465664745795)
- **Longform Guide** (Jan 21): advanced techniques — token economics, memory persistence, verification loops, parallelization, sub-agent orchestration. See [[longform-guide-everything-claude-code]]. [X article](https://x.com/affaanmustafa/status/2014040193557471352)

## Relevance

This is the maximalist approach to Claude Code configuration — the opposite of the minimal, transparent, persistence-first architecture explored in [[context-engineering-and-persistent-agent-memory]]. Where that investigation asks "what if we strip the illusion and make every exchange atomic?", this repo asks "what if we make the illusion as rich and capable as possible?"

Both are valid. The interesting question: which patterns from this repo survive contact with the persistence-first model? The hooks for memory persistence and the continuous learning system seem most aligned — they're already trying to solve the same problem (context doesn't survive sessions) from within the existing paradigm.

The 13-agent architecture is also relevant to the multi-agent orchestration trend Armin predicted in [[state-of-agentic-coding-ep3-armin-ben]] — productized "Gas Town" patterns.
