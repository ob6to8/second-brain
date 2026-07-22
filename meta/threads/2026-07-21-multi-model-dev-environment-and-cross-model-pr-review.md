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
fallback. Bundle verifies clean. A follow-up exchange corrected a category error:
the operator's "pi" (pi.dev) is a **coding-agent harness** (a Shape B peer of
OpenCode/claude-code-router), *not* an OpenRouter-style gateway — so the note's
Shape B and the snippet were amended, and the gateway-vs-harness distinction made
explicit. One strand remains open: whether to install the workflow into a specific
dev repo and which default reviewer model to use.

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

## User

would pi be an alternative possibility to openrouter here?

## Assistant

Quick answer to your mid-flight question, then I'll finish the PR.

**On "pi":** I couldn't pin down a mainstream multi-provider gateway named exactly *pi* — the closest match is **Inflection's Pi**, which is a different animal: it's Inflection's *own* model family with an enterprise API, not an aggregator. So it'd work as a *reviewer model source*, but it wouldn't give you the cross-family switching (GPT ↔ Kimi ↔ GLM) that's the whole point of the OpenRouter layer. If you meant something else by "pi," tell me and I'll place it exactly.

**The architecture-level answer, which is the useful part:** the Action isn't OpenRouter-specific. The reviewer call is just a standard **OpenAI-compatible `chat/completions` POST**, so *any* gateway with that shape is a drop-in — you change the base URL and the key, nothing else:

- **[LiteLLM](https://github.com/BerriAI/litellm)** (self-hosted proxy) — the canonical open-source OpenRouter alternative, 100+ providers, you own the keys.
- **[Portkey](https://portkey.ai)** / **Cloudflare AI Gateway** — managed gateways adding logging, caching, key control on top.
- **A provider's native endpoint** — if you only ever want one reviewer family, skip the gateway entirely.

So whatever "pi" is: **if it exposes an OpenAI-compatible endpoint over multiple providers, yes — it drops in.** If it's single-family (like Inflection's Pi), it works but you lose the switch-the-reviewer-in-one-line benefit.

## User

here is pi https://pi.dev/

## Assistant

That's the missing piece — thanks. **pi.dev is not an OpenRouter alternative at all** — I had the wrong "Pi," and it's the wrong *category*. Here's the correction:

<routes ref="em:db4e6c">
- **pi.dev is a coding-agent harness — a Shape B tool, not a gateway.** It sits exactly where OpenCode and claude-code-router sit (the *cockpit*), not where OpenRouter sits (the *model-access layer*). So it doesn't replace the OpenRouter role in the review Action; it's an alternative to the *agent* you'd author with.
- And it's a genuinely strong Shape B option for you specifically: **15+ providers with mid-session model switching**, and — the part that maps to what you love about the Claude app — **tree-structured session history with branching/export**, which is essentially your "persisted + archivable threads + resuscitation" feature. It's deliberately minimal (no MCP/sub-agents/plan-mode out of the box; you add them as TypeScript/npm extensions), with TUI + print/JSON + RPC + SDK modes.
- One neat consequence: because it has **print/JSON and RPC modes**, pi *could* be scripted as the reviewer inside the Shape C Action (invoke it headless with a review prompt) — but that's heavier than a plain `chat/completions` POST, so for the CI reviewer the gateway call is still simpler. pi's real value to you is as an authoring cockpit.
</routes>

## User

is function-calling.md a glossary entry?

## Assistant

Yes. It's at `beliefs/glossary/function-calling.md` — a `type: concept` glossary entry (`em:eec645`, title "function calling"), created 2026-07-17 from the vercel-eve thread. That's exactly why I didn't create a new "tool calling" entry in this session: tool calling / tool use is the same concept (its body even says "Also called tool calling or tool use"), so per the one-term-one-file rule I extended that existing entry instead — adding the harness↔model tool-calling-seam nuance and a citation to this session's thread.

## User

are all glossary entries type: concept?

## Assistant

Yes — all 342 term files under `beliefs/glossary/` are `type: concept`, with zero exceptions (`index.md` is excluded — it's the generated listing, no frontmatter).

That's by design in the `/add-to-glossary` skill: a glossary entry is always a `concept` (a definition/mental model), each with its own `em:` id. Two edge cases still hold to it:

- **Pointer entries** (a one-line gloss that defers to a canonically-defined doc elsewhere) are still `type: concept` files — they just link out instead of redefining.
- **Graduation** moves a term *out* of the glossary into the domain tree when it outgrows a definition; the file keeps its id and leaves a `concept` pointer stub behind at the glossary path. So the glossary directory stays uniformly `concept` even after a term graduates.

## User

should the glossary be renamed "concept glossary", or the type be changed to "glossary"?

## Assistant

**My recommendation: neither.** The current state isn't a mismatch to fix — it's the intended design, and both proposed changes would break something.

**Why not change the type to `glossary`:** `type` and location are *orthogonal axes* — `type` says what a document **is** (its epistemic nature); the directory says **where it sits** in the taxonomy. A glossary entry *is* a definition/mental model, which is exactly what `concept` means. "Glossary-ness" is conferred by the `beliefs/glossary/` path, not by the document's nature, so encoding it in `type` would be redundant with location. Worse, it breaks two things: graduation (a graduated term stays a definition — if its type were `glossary` it would need retyping on move) and the bundle-wide `concept` type (~51 concept docs already live in the tree; they can't all become `glossary`).

**On the apparent precedent** — `policy`, `tutorial`, `plan`, `issue` etc. *are* types that correlate with directories. But each carries genuinely distinct semantics or a status lifecycle (a policy is a rule; a plan is proposed→done; an issue is open→resolved). `glossary` would be the *first* type whose only distinction from an existing type is location — the anti-pattern to avoid.

**Why not rename the directory to `concept-glossary`:** it's redundant (a glossary is definitions by nature), and the cost is real — rewriting hundreds of bundle-absolute cross-links, the `/add-to-glossary` skill, `mix brain.glossary`, and index references, plus a directory rename is a shape change needing ratification. Big churn, negligible gain over the universally-understood word "glossary."

The one-liner: the type is right (`concept` = definition, wherever it lives), the name is right (`glossary` = the location that collects them), and the reason all 342 are concepts is that the glossary is the canonical *home* of concepts — not that concept and glossary should be the same thing.

## User

ok makes sense. last thought, should any of the concepts at directory paths be in fact folded into the glossary? what determines "graduation"?

## Assistant

Concrete answer, and it's clean: **none of the six should be folded in.** Each is either a developed subject with a real home in the tree, or — instructively — *not a term at all*. Every one already has the healthy arrangement: the concept lives in the tree, and the glossary carries a **pointer entry** that defers to it. So the split isn't an accident to clean up; it's the intended pattern, already working.

<routes ref="em:0c8532">
**Should any tree concepts fold into the glossary?** No — for these, and rarely in general. Two reasons: (1) the tree *is* the taxonomy — a domain concept belongs in its branch, related to its siblings; folding it into the flat glossary would strip it of its taxonomic home. (2) When a tree concept is *also* a term you want to link by name, the tool is a glossary **pointer**, not relocation — you get linkability without duplication or displacement. The only real fold-in candidate would be a tree doc that's a *bare cross-cutting term-definition with no domain-node role* — misfiled vocabulary. None of the six qualify; the most instructive is `git-local-branches-dont-auto-advance-on-fetch` (31 lines, `verified: true`): short, but it's a **verified proposition**, not a term — the glossary holds terms you look up, not claims.

**What determines graduation:** the discriminator is **role, not size**. A glossary entry answers "what does this word *mean*?" (a cross-cutting term you look up, a 1–3 sentence definition + citations); a tree concept answers "tell me *about* X" (a subject you study, a node in a domain, with mechanism/senses/claims/sections). A term **graduates** (glossary → tree) when it stops being a lookup and becomes a subject — concretely, when it accumulates **verified claims** (`verified_by` evidence), grows **multiple senses or real exposition** that want headings, becomes a **hub** other terms point at, and has a **natural taxonomic home**. The tell-tale sign: the entry *wants sections*. Move the file into the tree (its `em:` id travels), leave a pointer stub, and the two homes stay in sync rather than competing.
</routes>
