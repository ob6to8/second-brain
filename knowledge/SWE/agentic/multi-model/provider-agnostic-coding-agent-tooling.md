---
id: em:db4e6c
type: note
title: "Escaping single-provider lock-in in agentic coding tooling"
description: "Options for a multi-model coding-agent workflow that preserves the Claude app's dev ergonomics (sandbox, mobile, persisted threads, PR-review GUI), and why a GitHub/PR-based cross-model review is the highest-leverage first move."
verified: false
tags: [agentic, multi-model, coding-agents, provider-lock-in, code-review, openrouter, opencode, github-actions]
timestamp: 2026-07-21
attribution:
  when: 2026-07-21
  channel: agent-authored
  agent: "Claude Code agent, operator chat session on multi-model dev environments"
  why: "operator wants to work across Anthropic/OpenAI/Kimi/GLM models without abandoning the Claude app's dev features; distilled the landscape and the chosen direction"
---

# Escaping single-provider lock-in in agentic coding tooling

**The problem.** The Claude app bundles a very good dev experience — an ephemeral
**sandbox per session**, a **mobile mirror**, **persisted + archivable threads**,
**suppressed tool-call/thinking noise** (high readability), and a **PR-review GUI
integration** — but it traps you at one provider's models. The goal is to keep as
much of that experience as possible while flipping freely between model families
(Anthropic/Fable, OpenAI/Codex, Kimi, GLM, …).

## The key distinction: two surfaces, bundled

The app fuses two capabilities that are separable in the open-tool world:

1. A multi-model **chat** surface — several models answering in one readable,
   persisted thread.
2. A multi-model **coding agent** surface — the sandbox, mobile mirror, and PR flow.

No single open tool gives *all* of those features **and** cross-provider models
today. The real decision is **which surface to optimize**, accepting a seam.

## Three shapes

- **Shape A — chat-first (many models in one thread).** A self-hosted frontend
  (LibreChat, Open WebUI) over [OpenRouter](https://openrouter.ai) (one key →
  Anthropic, GPT, Kimi/Moonshot, GLM/Zhipu, …). Switch or *regenerate a turn* with
  a different model, so competing answers sit in one thread. Great readability +
  persisted/archived threads; **no sandbox, no git-native PR flow.**
- **Shape B — agent-first (keep the coding power, unlock the model).**
  [OpenCode](https://opencode.ai) is the closest single tool to "the Claude app,
  any model": provider-agnostic, `/models` switches mid-session, and you assign
  **different models to different agents** (builder on GPT, reviewer on GLM) in
  config. [claude-code-router](https://github.com/musistudio/claude-code-router)
  instead keeps Claude Code's exact ergonomics and routes its requests to other
  providers. Sandbox-per-session comes from the *environment* (devcontainer,
  Codespace) or a heavier all-in-one like OpenHands.
- **Shape C — the code-review workflow (author with one model, review with
  another).** GitHub is the neutral shared surface: the author and reviewer never
  share a harness, they just touch the same PR. A cross-model review lands exactly
  as expected — a **summary review plus inline comments anchored to diff lines**,
  optionally with `suggestion` blocks that render an "Apply" button. Realized here
  as the [cross-model PR review GitHub Action](/knowledge/SWE/agentic/multi-model/cross-model-pr-review-github-action.md).

## The seam that leaks quality

Agentic harnesses emit tool calls in the format their **native** model was trained
against. Claude Code's tool-calling is tuned for Anthropic models; GLM, Kimi,
DeepSeek, Qwen are tuned for their own conventions. Simple tool calls work
everywhere, but **long/complex tool chains degrade on non-native models**. This is
why, for genuine multi-provider *agentic* work, a neutral integration layer
(OpenCode) beats routing Anthropic-shaped calls to a foreign model — and why
routing **review** through GitHub (a text-based, harness-neutral surface) is the
most robust cross-model pattern.

## Decision: PR-based first

The operator leans **Shape C first**. Rationale:

- **Least lock-in by construction** — the shared surface is GitHub, not a harness,
  so it survives whatever changes about the authoring cockpit.
- **Reuses the PR-review GUI** the operator already values.
- **Cheap to stand up** (a GitHub Action) and doesn't force abandoning Claude Code
  as the authoring tool.
- **Already half-built** into the operator's workflow: this brain's own harness
  subscribes to PR activity and drives reviews through the GitHub MCP tools —
  today author and reviewer are both Anthropic; Shape C swaps the reviewer step to
  a different provider's API endpoint, not a re-architecture.

Follow-on (deferred): add OpenCode alongside for the *interactive* multi-model
feel once the review loop is in place.

# Citations

- Claude Code + OpenRouter setup — <https://codersera.com/blog/how-to-use-claude-code-with-openrouter-2026/>
- claude-code-router — <https://github.com/musistudio/claude-code-router>
- OpenCode models / provider-agnostic design — <https://opencode.ai/docs/models/>
- Coordinating agents across model families with OpenCode — <https://medium.com/@saurabbhatia/how-i-coordinate-19-ai-agents-across-4-model-families-with-opencode-and-recallium-00bc14fb8ccb>
- Multi-agent AI PR review Action (summary + inline suggestions) — <https://github.com/tag1consulting/ai-pr-review>
- Multi-provider LLM code reviewer (GPT/Gemini/Claude) — <https://github.com/tusgino/llm-code-reviewer/>
- gh-pr-review CLI (inline review support for automated agents) — <https://github.com/agynio/gh-pr-review>
