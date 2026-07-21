---
type: reference
title: 2026-07-21-multi-model-dev-environment-and-cross-model-pr-review
description: "Explored alternatives to the single-provider Claude app for multi-model software dev; landed on a PR-based cross-model review as the first move and filed a note plus a GitHub Action snippet under knowledge/SWE/agentic/multi-model/."
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-21; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, multi-model, coding-agents, code-review, provider-lock-in]
timestamp: 2026-07-21
session: https://claude.ai/code/session_01MTAzdLbAf5ha5SznLgPJWJ
pr: 126
---

# 2026-07-21-multi-model-dev-environment-and-cross-model-pr-review

## Where this landed

The operator uses the Anthropic Claude app for software dev and likes its
sandbox-per-session, mobile mirror, persisted/archivable threads, suppressed-noise
readability, and PR-review GUI — but is trapped at one provider. The session mapped
the alternative landscape, separating the app's two bundled surfaces (multi-model
*chat* vs. multi-model *coding agent*) and laying out three shapes: chat-first
(LibreChat/Open WebUI over OpenRouter), agent-first (OpenCode, claude-code-router),
and a GitHub/PR-based cross-model review workflow. The operator chose the **PR-based
route first** as the least-lock-in, highest-leverage move.

Two documents were filed into a new `knowledge/SWE/agentic/multi-model/`
subdirectory (autonomous, under the established `agentic` domain): a `note`
(`em:db4e6c`) recording the landscape and decision, and a `snippet` (`em:9b5d41`)
holding a drop-in cross-model PR-review GitHub Action that routes the reviewer model
through OpenRouter and posts inline diff-anchored comments with a summary-only
fallback. Bundle verifies clean. One strand remains open: whether to install the
workflow into a specific dev repo and which default reviewer model to use.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Multi-model dev tooling landscape; escaping single-provider lock-in; the PR-based decision | closed | [provider-agnostic-coding-agent-tooling](/knowledge/SWE/agentic/multi-model/provider-agnostic-coding-agent-tooling.md) | - |
| Cross-model PR review Action (Shape C artifact) | open | [cross-model-pr-review-github-action](/knowledge/SWE/agentic/multi-model/cross-model-pr-review-github-action.md) | Which dev repo to install `cross-model-review.yml` into, and which default reviewer model? |

## User

I use the anthropic claude app to do software dev. features i use and like:

* the fact that each new session opens in a sandbox
* the slick mobile mirrored functionality
* the persisted threads
* the readability (tool calls and thinking suppressed more than claude code)
* archived threads that can be saved for reference and recussitation
* the pr review gui integration

however, it traps me at one single provider's models

I am wondering what an alternative approach might look like that integrates some of these features

Ideally, I would like to go back and forth between models like Anthropic models, chat gpt/codex, kimi 3, GLM 5.2, and see each of their responses in the same thread. that said, if that's too difficult, to figure out a code review workflow - ie. say fable authors a pr and codex reviews it, would that look like codex adding comments within the code review?

## Assistant

Good — the landscape is clearer than my priors. Here's how I'd think about it.

<routes ref="em:db4e6c">
## First, untangle two things the Claude app bundles together

What you love is actually **two separate capabilities** that Anthropic happens to ship as one product:

1. **A multi-model *chat* surface** — several models answering in one readable, persisted, archivable thread.
2. **A multi-model *coding agent* surface** — the ephemeral sandbox-per-session, the mobile mirror, and the PR-review GUI.

No single open tool today gives you *all six* of your loved features **and** cross-provider models. So the real decision is **which layer you optimize for**, and accept a seam somewhere. Below are the three realistic shapes.
</routes>

## Shape A — "Many models in one thread, readable and persisted" (chat-first)

If the thing you'd miss most is the **readability + persisted/archived threads + flipping between models in one conversation**, the answer is a self-hosted chat frontend sitting on top of **[OpenRouter](https://openrouter.ai)** (one API key → Anthropic, OpenAI/GPT, Moonshot/Kimi, Zhipu/GLM, etc.).

- **[LibreChat](https://www.librechat.ai)** or **Open WebUI** — both let you switch the model mid-thread, regenerate a given turn with a *different* model (so you literally see Fable's answer and GPT's answer side by side in the same thread), persist and archive conversations, and they're mobile-web friendly. LibreChat also has an agents/MCP layer now.
- **What you give up:** these are chat UIs, *not* coding agents. No sandbox, no git-native PR flow. You'd be back to copy-paste for real dev work.

This nails features 3, 4, 5 (persisted, readable, archived) and multi-provider — but **not** the sandbox or PR-review GUI.

## Shape B — "Keep the coding-agent power, escape the provider lock" (agent-first)

This is closer to what you actually do all day. Two sub-options:

**B1 — [OpenCode](https://opencode.ai)** is the closest single tool to "the Claude app, but any model." It's provider-agnostic by design: `/models` switches the model **mid-session**, and — this is the key part for you — you assign **different models to different agents** in config: a builder on GPT/Codex, a reviewer on GLM, a planner on Claude, with no code changes. It's a client/server architecture, so there's a real path to the mobile-mirror feel, and the TUI is clean (closer to the app's suppressed-noise readability than raw Claude Code). ([overview](https://opencode.ai/docs/models/), [multi-agent write-up](https://medium.com/@saurabbhatia/how-i-coordinate-19-ai-agents-across-4-model-families-with-opencode-and-recallium-00bc14fb8ccb))

**B2 — [claude-code-router](https://github.com/musistudio/claude-code-router)** if you want to keep *Claude Code's exact ergonomics* (which you already use) but point it at other providers. It's a local control plane that routes Claude Code's requests to OpenAI, Gemini, OpenRouter, DeepSeek, Moonshot/Kimi, Z.AI/GLM, etc., with per-task routing and auto-failover. ([Kimi-with-Claude-Code guide](https://huggingface.co/blog/francesca-petracci/kimi-k2-claude-code))

**The one caveat you must know before betting on either** — it's the honest catch, straight from OpenRouter's own docs: **agentic harnesses emit tool calls in a format the harness's native model was trained against.** Claude Code's tool-calling is tuned for Anthropic models; GLM, Kimi, DeepSeek, Qwen are tuned for *their own* conventions. Simple tool calls work everywhere; **long, complex tool chains degrade on non-native models** (partial tool-call support, occasional broken chains). OpenCode's neutral integration layer handles this better than routing Anthropic-shaped calls to a foreign model, which is why for genuine multi-provider *agentic* work I'd lean **B1 (OpenCode)** over B2. Use B2 mainly for "swap the brain, keep the cockpit" on models with strong tool-calling.

**Sandbox-per-session** here comes from the environment, not the agent: run OpenCode inside a devcontainer / GitHub Codespace / [OpenHands](https://github.com/All-Hands-AI/OpenHands)-style Docker sandbox. OpenHands is worth a specific look — it's multi-model, runs each session in an isolated sandbox, has a cloud/browser offering and PR integration, so it's arguably the single product closest to "Claude app but bring-your-own-model," at the cost of being heavier and less polished.

<routes ref="em:db4e6c em:9b5d41">
## Shape C — The code-review workflow (your fallback — and honestly the strongest near-term answer)

Your instinct here is right, and **yes — a cross-model review looks exactly like you pictured.** When Codex (or GLM, or Kimi) reviews a PR that Fable authored, it shows up on the PR as:

- a **top-level summary review**, plus
- **inline comments anchored to specific diff lines**, and
- optionally **`suggestion` blocks** that GitHub renders with an "Apply suggestion" button.

That's the standard shape, and it's the *most* decoupled-from-provider pattern of everything here, because **GitHub is the shared surface** — the author and the reviewer never need to live in the same harness, they just need to touch the same PR. Off-the-shelf Actions already do this: [tag1consulting/ai-pr-review](https://github.com/tag1consulting/ai-pr-review) (multi-agent, posts summary + inline suggestion blocks), the multi-provider [LLM Code Reviewer](https://github.com/tusgino/llm-code-reviewer/) (GPT / Gemini / Claude selectable), and the [gh-pr-review](https://github.com/agynio/gh-pr-review) CLI extension built specifically to give automated agents full inline-comment support.

Two ways to wire it:

- **CI-driven (simplest):** Fable/Claude Code authors and pushes a PR. A GitHub Action triggered `on: pull_request` calls a *different* provider's API with the diff + a review prompt and posts the review back via the GitHub API. Fully cross-model, zero shared harness, and it survives whatever you change about your authoring tool.
- **Interactive:** OpenCode with a "reviewer" agent pinned to a different model family, or two terminals, handing off through the PR.

And note — **you're already half-way to this pattern.** The harness you're in right now subscribes to PR activity (`subscribe_pr_activity`) and drives reviews through the GitHub MCP tools (`add_comment_to_pending_review`, `pull_request_review_write`). Today the author and reviewer are both Anthropic (you *can* already split roles across Fable/Opus/Sonnet via subagents). Swapping the reviewer step to Codex or GLM is a **change of API endpoint in an Action, not a re-architecture.**
</routes>

## What I'd actually do

<routes ref="em:db4e6c">
If I had to name one starting move: **stand up the cross-model PR reviewer (Shape C) first.** It's a weekend of YAML, it's provider-agnostic by construction, it plugs into the PR-review GUI you already love, and it doesn't force you to abandon Claude Code as your authoring cockpit. Then, if you want the *interactive* multi-model feel, add OpenCode alongside.

One structural point worth internalizing: the Claude app's magic is that Anthropic controls the harness *and* the model, so tool-calling is flawless. The moment you go multi-provider, **the harness↔model tool-calling seam is where quality leaks** — which is exactly why routing reviews through GitHub (a neutral, text-based surface) is more robust than routing foreign models through an Anthropic-shaped agent loop.
</routes>

## User

ok i lean towards going github/pr based first. create this as a system note and the shape c gh action

## Assistant

Good — `agentic` is an established top-level domain, so I can create a subdirectory under it autonomously. This material (provider-agnostic coding-agent tooling + the cross-model review pattern) fits a new `multi-model/` subdir. Let me look at a real document for the exact frontmatter shape and check the ID-minting tooling.

<routes ref="em:9b5d41">
Done. Both are filed in the brain and pushed to `claude/multi-model-dev-environment-pbxdv7`.

**How the Action works, briefly** — on every PR open/update it fetches the diff, sends it to a reviewer model of a *different* family than the author (routed through OpenRouter so `openai/gpt-5.2` → `moonshotai/kimi-k2` → `z-ai/glm-4.6` is a one-line change), and posts a review with **inline comments anchored to diff lines** plus a summary. The one real failure mode — GitHub rejecting the whole review if a comment points at a line not in the diff — is handled with a summary-only fallback. To use it you just add an `OPENROUTER_API_KEY` secret and pick `REVIEWER_MODEL`.
</routes>
