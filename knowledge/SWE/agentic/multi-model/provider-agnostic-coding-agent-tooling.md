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
  providers. [Pi](https://pi.dev) is a third: a deliberately minimal, extensible
  agent harness (15+ providers, mid-session model switching) that adds features
  (MCP, sub-agents, plan mode) as TypeScript/npm extensions rather than
  out-of-the-box — and whose **tree-structured, branchable session history** maps
  closely to the persisted/archivable-threads feature the operator values. These
  are *harnesses* (the cockpit), not [LLM gateways](/beliefs/glossary/llm-gateway.md)
  (the model-access layer) — they still reach models through a provider key or a
  gateway. Sandbox-per-session comes from the *environment* (devcontainer,
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

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:db4e6c">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-21-multi-model-dev-environment-and-cross-model-pr-review (2026-07-21)

4 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:db4e6c`]**

**First, untangle two things the Claude app bundles together**

What you love is actually **two separate capabilities** that Anthropic happens to ship as one product:

1. **A multi-model *chat* surface** — several models answering in one readable, persisted, archivable thread.
2. **A multi-model *coding agent* surface** — the ephemeral sandbox-per-session, the mobile mirror, and the PR-review GUI.

No single open tool today gives you *all six* of your loved features **and** cross-provider models. So the real decision is **which layer you optimize for**, and accept a seam somewhere. Below are the three realistic shapes.

---

**[`em:db4e6c`]**  (co-feeds: `em:9b5d41`)

**Shape C — The code-review workflow (your fallback — and honestly the strongest near-term answer)**

Your instinct here is right, and **yes — a cross-model review looks exactly like you pictured.** When Codex (or GLM, or Kimi) reviews a PR that Fable authored, it shows up on the PR as:

- a **top-level summary review**, plus
- **inline comments anchored to specific diff lines**, and
- optionally **`suggestion` blocks** that GitHub renders with an "Apply suggestion" button.

That's the standard shape, and it's the *most* decoupled-from-provider pattern of everything here, because **GitHub is the shared surface** — the author and the reviewer never need to live in the same harness, they just need to touch the same PR. Off-the-shelf Actions already do this: [tag1consulting/ai-pr-review](https://github.com/tag1consulting/ai-pr-review) (multi-agent, posts summary + inline suggestion blocks), the multi-provider [LLM Code Reviewer](https://github.com/tusgino/llm-code-reviewer/) (GPT / Gemini / Claude selectable), and the [gh-pr-review](https://github.com/agynio/gh-pr-review) CLI extension built specifically to give automated agents full inline-comment support.

Two ways to wire it:

- **CI-driven (simplest):** Fable/Claude Code authors and pushes a PR. A GitHub Action triggered `on: pull_request` calls a *different* provider's API with the diff + a review prompt and posts the review back via the GitHub API. Fully cross-model, zero shared harness, and it survives whatever you change about your authoring tool.
- **Interactive:** OpenCode with a "reviewer" agent pinned to a different model family, or two terminals, handing off through the PR.

And note — **you're already half-way to this pattern.** The harness you're in right now subscribes to PR activity (`subscribe_pr_activity`) and drives reviews through the GitHub MCP tools (`add_comment_to_pending_review`, `pull_request_review_write`). Today the author and reviewer are both Anthropic (you *can* already split roles across Fable/Opus/Sonnet via subagents). Swapping the reviewer step to Codex or GLM is a **change of API endpoint in an Action, not a re-architecture.**

---

**[`em:db4e6c`]**

If I had to name one starting move: **stand up the cross-model PR reviewer (Shape C) first.** It's a weekend of YAML, it's provider-agnostic by construction, it plugs into the PR-review GUI you already love, and it doesn't force you to abandon Claude Code as your authoring cockpit. Then, if you want the *interactive* multi-model feel, add OpenCode alongside.

One structural point worth internalizing: the Claude app's magic is that Anthropic controls the harness *and* the model, so tool-calling is flawless. The moment you go multi-provider, **the harness↔model tool-calling seam is where quality leaks** — which is exactly why routing reviews through GitHub (a neutral, text-based surface) is more robust than routing foreign models through an Anthropic-shaped agent loop.

---

**[`em:db4e6c`]**

- **pi.dev is a coding-agent harness — a Shape B tool, not a gateway.** It sits exactly where OpenCode and claude-code-router sit (the *cockpit*), not where OpenRouter sits (the *model-access layer*). So it doesn't replace the OpenRouter role in the review Action; it's an alternative to the *agent* you'd author with.
- And it's a genuinely strong Shape B option for you specifically: **15+ providers with mid-session model switching**, and — the part that maps to what you love about the Claude app — **tree-structured session history with branching/export**, which is essentially your "persisted + archivable threads + resuscitation" feature. It's deliberately minimal (no MCP/sub-agents/plan-mode out of the box; you add them as TypeScript/npm extensions), with TUI + print/JSON + RPC + SDK modes.
- One neat consequence: because it has **print/JSON and RPC modes**, pi *could* be scripted as the reviewer inside the Shape C Action (invoke it headless with a review prompt) — but that's heavier than a plain `chat/completions` POST, so for the CI reviewer the gateway call is still simpler. pi's real value to you is as an authoring cockpit.
