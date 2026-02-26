---
title: "The Longform Guide to Everything Claude Code"
url: "https://x.com/affaanmustafa/status/2014040193557471352"
aliases: ["everything claude code longform", "affaan claude code guide"]
tags: [ai, claude-code, context-engineering, agent-memory, token-optimization, agentic-coding, hooks, subagents, evals]
source: "X (article)"
authors: ["affaan-m (cogsec)"]
date_published: "2026-01-21"
date_captured: "2026-02-25"
summary: >
  Deep guide to advanced Claude Code patterns from 10+ months of daily use.
  Covers context/memory management (session files, hooks, strategic compaction),
  token optimization (subagent model selection, modular codebases), verification
  loops (checkpoint vs continuous evals), parallelization (worktrees, cascade
  method), and sub-agent orchestration (iterative retrieval, sequential phases).
content_type: article
word_count: 4500
related:
  - "[[everything-claude-code-config-repo]]"
  - "[[context-engineering-and-persistent-agent-memory]]"
  - "[[state-of-agentic-coding-ep3-armin-ben]]"
---

## Summary

Companion to the "Shorthand Guide" (setup/config). This longform guide covers the *techniques* — the patterns that separate productive sessions from wasteful ones. Core themes: token economics, memory persistence, verification patterns, parallelization strategies, and compound effects of reusable workflows.

The author (Anthropic hackathon winner, 10+ months daily Claude Code use) frames the central problem as **context rot** — sessions degrade over time as compaction lossy-summarizes your working state. Every technique here is ultimately a mitigation strategy for that.

## Context & Memory Management

### Session Files
Save session state to `.tmp` files in `.claude/sessions/`. Each session gets its own file containing: what worked (with evidence), what didn't, what's untried, what's left. Next session loads the file as context. Prune old sessions periodically.

Pattern: `~/.claude/sessions/YYYY-MM-DD-topic.tmp`

### Strategic Compaction
Disable auto-compact. Compact manually at logical boundaries (after exploration, before execution; after milestone, before next). A `PreToolUse` hook counts tool calls and suggests compaction after a threshold (default 50).

Key insight: auto-compact fires at arbitrary points, often mid-task. Strategic compaction preserves context through logical phases.

### Dynamic System Prompt Injection
```bash
claude --system-prompt "$(cat memory.md)"
```
`--system-prompt` injects into the actual system prompt (higher authority than tool results from `@file` references or `.claude/rules/`). Marginal difference for most work, but matters for strict behavioral rules.

Practical: create aliases per workflow mode:
```bash
alias claude-dev='claude --system-prompt "$(cat ~/.claude/contexts/dev.md)"'
alias claude-review='claude --system-prompt "$(cat ~/.claude/contexts/review.md)"'
```

### Memory Persistence Hooks
Three hooks for continuous memory across sessions:
- **PreCompact** → saves state before compaction summarizes it away
- **Stop (session-end)** → persists learnings to `~/.claude/sessions/`
- **SessionStart** → loads previous session context automatically

This creates a lifecycle: work → pre-compact saves → compaction → stop persists → next session loads.

### Continuous Learning
Stop hook analyzes session for extractable patterns (error resolutions, debugging techniques, workarounds). Saves as reusable skills in `~/.claude/skills/learned/`. Mid-session extraction via `/learn` command.

Why Stop hook over UserPromptSubmit: Stop runs once at session end (lightweight), evaluates complete session. UserPromptSubmit runs every message (overhead, latency, overkill).

**Other self-improving patterns:**
- @RLanceMartin: reflection agent distills user preferences into a "diary" loaded in subsequent sessions
- @alexhillman: proactive improvement suggestions every 15 minutes, agent learns from approval patterns

## Token Optimization

### Subagent Model Selection
- **Haiku**: repetitive tasks, clear instructions, worker agents (cheapest, 5x less than Opus)
- **Sonnet**: 90% of coding tasks (default)
- **Opus**: multi-file tasks, architectural decisions, security-critical code, after first attempt failed

Haiku + Opus combo makes more sense than Sonnet + Opus (5x cost difference vs 1.67x).

### Tool Optimization
Replace grep with `mgrep` (mixedbread-ai) — ~50% token reduction on average vs ripgrep.

### Background Processes
Run builds/tests in tmux outside Claude. Feed only the relevant output back. Saves input tokens (majority of cost at $5/M for Opus).

### Modular Codebases
Files in hundreds of lines, not thousands. Long files = multiple Read tool calls = lost information + extra tokens. Modular code correlates with getting tasks right on first try.

### System Prompt Slimming
Claude Code's system prompt is ~18k tokens. Can be reduced to ~10k with patches (41% reduction of static overhead). See YK's system-prompt-patches. Author doesn't personally do this.

## Verification & Evals

### Two Eval Patterns

**Checkpoint-based**: explicit verification gates at milestones. If verification fails, fix before proceeding. Best for linear workflows with clear stages.

**Continuous**: run every N minutes or after major changes. Full test suite, build, lint. Report regressions immediately. Best for long-running exploratory sessions.

### Benchmarking Skills
Fork conversation into two worktrees — one with skill, one without. Run same task. Compare via git diff, token usage, test results. Validates whether your skills actually improve output.

### Key Metrics
- **pass@k**: at least ONE of k attempts succeeds (k=1: 70%, k=5: 97%)
- **pass^k**: ALL k attempts must succeed (k=1: 70%, k=5: 17%)

Use pass@k when any success works. Use pass^k when consistency is essential.

### Grader Types (from Anthropic)
- **Code-based**: string match, binary tests, static analysis. Fast/cheap/objective but brittle.
- **Model-based**: rubric scoring, natural language assertions. Flexible but non-deterministic.
- **Human**: SME review, spot-check. Gold standard but expensive/slow.

## Parallelization

### Principles
- Tasks must be orthogonal (minimal code overlap)
- Use git worktrees when instances touch overlapping code
- `/rename` all chats to avoid confusion
- **Most people only need 2-3 instances.** Don't set arbitrary terminal counts.

### Author's Preferred Pattern
Main chat: code changes. Forks: codebase questions, external research, documentation lookup. Keeps code changes serialized, research parallelized.

### The Cascade Method
- New tasks open in tabs to the right
- Sweep left-to-right (oldest to newest)
- Focus on max 3-4 tasks — beyond that, mental overhead > productivity

### Two-Instance Kickoff (New Projects)
- **Instance 1 (Scaffolding)**: project structure, configs, CLAUDE.md, conventions
- **Instance 2 (Research)**: PRD, architecture diagrams, documentation compilation

## Sub-Agent Orchestration

### The Context Problem
Sub-agents lack the orchestrator's semantic context. They only know the literal query, not the purpose. Summaries miss key details — like sending someone to a meeting without telling them what you need from it.

### Fix: Iterative Retrieval
1. Dispatch with query + broader objective
2. Evaluate return — is it sufficient?
3. If no: ask follow-up questions (max 3 cycles)
4. Sub-agent fetches answers, returns enriched summary

### Sequential Phase Pattern
```
Research (Explore) → Plan (planner) → Implement (tdd-guide) → Review (code-reviewer) → Verify (build-error-resolver)
```
Each agent: ONE clear input → ONE clear output. Outputs become next agent's input. Store intermediate outputs in files, not just memory. Use `/clear` between agents.

### Agent Abstraction Tiers (from @menhguin)

**Tier 1 — Direct Buffs (easy to use):**
- Subagents: prevent context rot, ad-hoc specialization
- Metaprompting: "3 minutes to prompt a 20-minute task"
- Asking user questions upfront

**Tier 2 — High Skill Floor (hard to use well):**
- Long-running agents: need to understand 15min vs 1.5hr vs 4hr task tradeoffs
- Parallel multi-agent: high variance, only for complex or well-segmented tasks
- Role-based multi-agent: models evolve too fast for hard-coded heuristics
- Computer use agents: very early paradigm

Takeaway: master Tier 1 before graduating to Tier 2.

## Tips

### MCPs → CLI + Skills
Most MCPs wrap existing CLIs (GitHub, Supabase, Vercel). Replace with skills/commands that call the CLI directly. Same functionality, freed context window, lower token usage. With lazy loading this matters less for context, but CLI approach still saves tokens.

### llms.txt
Many docs sites expose `/llms.txt` — LLM-optimized documentation. Feed directly to Claude instead of scraping. Example: `https://www.helius.dev/docs/llms.txt`

### Philosophy: Build Reusable Patterns
From @omarsar0: "Early on, I spent time building reusable workflows/patterns. Tedious to build, but this had a wild compounding effect as models and agent harnesses improved." Patterns are transferable across agents (Claude Code, Codex, etc.) and survive model upgrades.

## Relevance to Second Brain

This article is the practitioner's manual for the exact problems discussed in [[context-engineering-and-persistent-agent-memory]]. The session files, memory persistence hooks, and continuous learning system are all workarounds for the fundamental issue: **the context window is ephemeral and persistence is an afterthought.**

The author's approach (PreCompact → Stop → SessionStart hook chain) is the current best-practice within Claude Code's architecture. The `llm` CLI + SQLite approach from our conversation thread would replace this entire hook chain with atomic persistence as the default — no hooks needed because every exchange is persisted at creation time.

The sub-agent orchestration patterns and eval frameworks are independently valuable regardless of persistence architecture.
