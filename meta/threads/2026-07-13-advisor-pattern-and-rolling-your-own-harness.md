---
type: reference
title: 2026-07-13-advisor-pattern-and-rolling-your-own-harness
description: Traced an Instagram post back to Anthropic's advisor/orchestrator benchmark, clarified that the advisor pattern is a native Messages API tool (not a Claude Managed Agents feature) reimplementable in any framework via raw HTTP, and distilled the benefits of a self-built harness into a filed analysis.
provenance: "Claude Code session (Claude Sonnet 5, then Claude Opus 4.8), 2026-07-13; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, anthropic, advisor-tool, orchestration, managed-agents, build-vs-buy, agents]
timestamp: 2026-07-13
session: https://claude.ai/code/session_011No6T6tQoaV17R76v38UZ9
pr: 79
---

# 2026-07-13-advisor-pattern-and-rolling-your-own-harness

## Where this landed

The operator brought an Instagram post (@evolving.ai) quoting Anthropic
benchmark numbers and asked for the underlying source; the agent traced it to
Anthropic's **advisor/orchestrator** cost-pattern material — the native
**advisor tool** (beta `advisor-tool-2026-03-01`) plus the Claude Managed Agents
"plan big, execute small" cookbook — announced via the Claude Devs X account.
The discussion then clarified a series of distinctions: the advisor pattern is a
**native Messages API tool** (a server-side sub-inference inside one request),
distinct from the heavier orchestrator pattern that lives under Claude Managed
Agents; it requires API/code access and is not available through the consumer app
or cloud Claude Code sessions; and it can be reimplemented in *any* framework
because the Messages API is plain HTTP/JSON (no language SDK required — Elixir has
no official SDK but that is a convenience gap, not a capability gap). A wording
inconsistency was resolved: hitting the real `advisor_20260301` tool over raw
HTTP gives full parity (modulo SDK sugar), while a hand-rolled two-call version
is a deliberate reimplementation that forfeits single-request efficiency,
pause/resume, and per-iteration cost accounting. The agent enumerated seven
controls a self-built harness buys and the business cases where they turn
decisive, and separated Claude Code / Agent SDK / Managed Agents by *who owns the
loop and execution environment* ("brain vs. hands"). The session's durable output
is the filed analysis
[when-to-roll-your-own-advisor-harness](/meta/analysis/when-to-roll-your-own-advisor-harness.md);
the operator directed it to omit any mention of Elixir.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Tracing the Instagram post to Anthropic's advisor/orchestrator source | closed | `unrouted` | - |
| Advisor pattern: native tool vs. CMA, API/app/framework requirements, parity of a raw-HTTP reimplementation | closed | [when-to-roll-your-own-advisor-harness](/meta/analysis/when-to-roll-your-own-advisor-harness.md) | - |
| Benefits of a self-built advisor harness and the business cases for it | closed | [when-to-roll-your-own-advisor-harness](/meta/analysis/when-to-roll-your-own-advisor-harness.md) | - |
| Claude Code vs. Agent SDK vs. Managed Agents positioning ("brain vs. hands") | closed | `unrouted` | - |

## User

Are you able to find the anthropic source post described here

https://www.instagram.com/p/Dau9xmYgC2A/?igsh=NTc4MTIwNjQ2YQ==

## Assistant

Yes — I traced it. Here's what the Instagram post is built on.

## The Instagram post
The post is from **@evolving.ai** (July 13, 2026). It's not itself an Anthropic source — it's a repackaging of Anthropic's own benchmark numbers for two cost-cutting multi-agent patterns pairing **Fable 5** (as planner/advisor) with the cheaper **Sonnet 5** (as executor). The figures it quotes:

- **Orchestrator pattern** (Fable 5 plans, Sonnet 5 workers execute): **86.8% on BrowseComp** vs. Fable 5 solo's **90.8%**, at **$18.53/problem** instead of **$40.56** → ~96% of the performance at ~46% of the cost.
- **Advisor pattern** (Sonnet 5 executes, Fable 5 advises): **~92% of Fable 5's SWE-bench Pro score at ~63% of the cost.**

## The actual Anthropic source
Those numbers originate from **Anthropic's official "Claude Managed Agents" material**, surfaced via the **Claude Devs (@ClaudeDevs) X thread** on July 11–12, 2026:

- **Claude Devs X thread** (the announcement the post is paraphrasing):
  - https://x.com/ClaudeDevs/status/2074606058128224365
  - https://x.com/ClaudeDevs/status/2074606059864625355
- **Cookbook notebook** (the "plan big, execute small" orchestrator benchmark, with the BrowseComp/SWE-bench Pro cost tables):
  - `github.com/anthropics/claude-cookbooks/blob/main/managed_agents/CMA_plan_big_execute_small.ipynb`
- **Platform docs — Advisor tool** (the advisor pattern):
  - https://platform.claude.com/docs/en/agents-and-tools/tool-use/advisor-tool

So the "Anthropic source" behind the post is the **Claude Managed Agents advisor/orchestrator benchmark** — published by Anthropic as a cookbook notebook + platform docs and announced through the Claude Devs X account. The Instagram post is a third-party summary of it, not a primary document.

One caveat: I confirmed the *numbers and the routing* through Anthropic's Claude Devs thread and the secondary coverage, but I couldn't independently open the cookbook notebook or the X posts in this session to verify them byte-for-byte — if you want, I can fetch the cookbook `.ipynb` directly and pull the exact benchmark tables to confirm the $18.53 / $40.56 / 86.8% / 90.8% figures against Anthropic's own numbers.

Want me to do that verification pass, and/or `/intake` this into the brain as a `reference`?

## User

That's fine. I'm more interested in learning more about the advisor pattern at this point. First question, is this only for cloud managed agents? In other words, do you need API access and the ability to work on the code level to develop this pattern? And what way are you creating a custom harness that allows for this? It seems less than turnkey. I assume that working in the Claude app, interfacing with cloud based cloud code agents, you could not set this up. What if you were to use a different library such as jido 2 in elixir? Would you be able to use the Advisor Pattern then? Lastly, is the adviser pattern something that is unique to Anthropic, or is this something that is prevalent across the AI industry, i. e, mixture of experts, etcetera?

## Assistant

<routes ref="/meta/analysis/when-to-roll-your-own-advisor-harness.md">
Good — I have the actual advisor-tool docs now. Here's the breakdown, addressing each question.

## 1. Is this only for Claude Managed Agents (CMA)?

No — and this is worth separating into two different things that got conflated in the Instagram post:

- **The advisor pattern** (Sonnet executes, Fable advises) is a **native Messages API tool**: `type: "advisor_20260301"`. You add it to the `tools` array of an ordinary `/v1/messages` call with a beta header (`advisor-tool-2026-03-01`). It is **not** a Claude Managed Agents feature — CMA just happens to be one place it gets demonstrated. The advisor sub-inference runs **server-side, inside the same request** — Anthropic calls Fable for you and hands the advice back to Sonnet. You don't build a multi-agent harness for this one; you just add a tool definition.
- **The orchestrator pattern** ("plan big, execute small" — Fable dispatching parallel Sonnet workers) is a genuinely different, heavier thing. That one does live under Claude Managed Agents / the Agent SDK, because it involves spinning up multiple concurrent sub-agents, not a single in-request tool call.

So: yes, you need API access either way (an API key, code-level requests) — this isn't available through a no-code UI. But the *advisor* pattern specifically is close to turnkey (one tool entry, one request); the *orchestrator* pattern is the one that actually requires building/using a multi-agent harness.

## 2. Can you do this from the Claude consumer app or cloud Claude Code agents?

Correct, you can't — not as a user-facing toggle. The advisor tool is a beta **API** feature gated behind an `anthropic-beta` header on raw Messages API calls. The consumer chat app (claude.ai) doesn't expose tool configuration to end users, and cloud-hosted Claude Code sessions (like this one) don't let you inject custom `tools` arrays into the underlying model calls either — that's controlled by the harness, not you. To use it you need to be the one writing code against `api.anthropic.com` (or a Claude Agent SDK integration that exposes tool configuration), with your own API key.

## 3. Could you replicate this with a different framework, e.g. Jido (Elixir)?

Yes, but with a caveat: what you'd build in Jido is a **client-side reimplementation** of the pattern, not the native tool.

The native `advisor_20260301` tool only exists inside Anthropic's own API surface — a Jido agent (or any other framework) can't invoke it directly unless the code underneath is literally making Anthropic Messages API calls with that tool type. But nothing stops you from implementing the *pattern* yourself in Jido:

- Your Jido executor agent runs normally (say, on Sonnet).
- At a decision point, it pauses and your own orchestration code fires a **separate** API call to Fable, passing the transcript so far, asking for a plan/critique.
- You inject Fable's response back into the executor's context and let it continue.

That's functionally the advisor pattern, just done as two ordinary API calls stitched together by your own control flow instead of one request where Anthropic does the stitching server-side. You'd lose some native conveniences: the `pause_turn`/resume mechanics, the encrypted `advisor_redacted_result` handling, the `usage.iterations` cost breakdown, and Anthropic's own optimized prompt caching for the advisor's view of the transcript — you'd have to build equivalents of all of that yourself. But the core idea (cheap model executes, strong model periodically advises) is framework-agnostic and works fine as a hand-rolled Jido action/agent.

## 4. Is this unique to Anthropic, or an industry-wide pattern?

The **specific implementation** (a first-class API tool that runs a second model server-side, mid-generation, inside one request) is Anthropic's own — I haven't seen another major provider ship it as a literal API primitive like this.

But the **underlying idea** — a fast/cheap model doing the bulk work while occasionally consulting a slower/smarter model for planning or correction — is well established industry-wide, under several related names:

- **Model cascades / routing** (e.g., FrugalGPT-style approaches): route each query to the cheapest model likely to succeed, escalate on failure.
- **Planner–executor / supervisor–worker multi-agent patterns**: common in frameworks like LangGraph, AutoGen, CrewAI — a coordinator model decomposes and delegates to cheaper worker models. This is closer to Anthropic's *orchestrator* pattern than to the advisor tool.
- **Speculative decoding**: a small model drafts tokens, a large model verifies/corrects — same "cheap does the work, expensive checks it" spirit, but a completely different mechanism (token-level, inside a single model's decoding loop, not two independent model calls).

It's worth explicitly distinguishing this from **mixture-of-experts (MoE)**, though — that's a different thing entirely. MoE is a *model architecture* choice: sparse routing between expert sub-networks happens inside a single forward pass, invisible at the API level, and isn't something you opt into as an application developer. The advisor/orchestrator patterns are *application-level* orchestration across two separate, complete model inferences that you (or Anthropic's server) explicitly wire together. Different layer of the stack, easy to conflate because both involve "routing to different capacity where needed."

So: the pattern itself is industry-standard practice; Anthropic's contribution here is packaging one flavor of it as a clean, native API primitive rather than something every team hand-rolls.
</routes>

## User

Why can't jido Make Anthropic Messages API calls with that tool type. Is it because Elixir is not supported as an API language?

## Assistant

I didn't mean to imply Elixir is unsupported — that's not actually the issue, and I should clarify since my last answer was a bit loose there.

**The Anthropic Messages API is a plain HTTP/JSON REST API.** Nothing about it requires a specific language SDK — any language that can make an HTTPS POST request and serialize JSON can call it directly. Elixir absolutely qualifies: `Req`, `Finch`, `Tesla`, or even `:httpc` can construct the request.

What I meant by "the code underneath" was narrower: the advisor tool only exists as a JSON shape you put in the `tools` array of a raw Messages API request —

```json
{
  "model": "claude-sonnet-5",
  "tools": [{"type": "advisor_20260301", "name": "advisor", "model": "claude-fable-5"}],
  ...
}
```

— plus the `anthropic-beta: advisor-tool-2026-03-01` header. There's nothing Elixir-specific to build; you just need something in your Jido stack that POSTs this exact body to `api.anthropic.com/v1/messages` and parses the response (including the `advisor_tool_result`/`server_tool_use` blocks, and the `pause_turn` resume mechanics if you hit those).

**What's actually true about Elixir**: Anthropic ships official SDKs for Python, TypeScript, Go, Java, C#, PHP, and Ruby (per the docs I pulled) — Elixir isn't among them. So there's no official `Anthropic.Client` you `mix deps.get` that gives you typed structs for `BetaAdvisorTool20260301` the way the Python/TS/Go SDKs do. But that's a **convenience gap, not a capability gap** — you'd write a thin HTTP client yourself (or there may be a community package like `anthropic_ex` — I haven't verified one exists) that just builds the JSON body and headers by hand. Since the advisor tool is brand new (beta, dated `2026-03-01`), even the official SDKs' support for it is just typed wrappers around the same JSON — nothing they do is unreachable from raw HTTP.

So a Jido agent hitting the advisor tool is entirely feasible: write an action that does the HTTP call with the right `tools` entry and beta header, parse the `advisor_tool_result`/`server_tool_use` blocks out of the response, and feed the advice back into your Jido agent's next step. No language barrier — just some manual JSON wiring you'd get for free in Python/TS.

## User

So why then were you saying that with jido that the option was to actually rebuild the functionality from scratch, missing some convenience features. It sounds like now you're saying that, actually, there's a hundred percent parity

## Assistant

Fair catch — I conflated two different approaches in my two answers. Let me untangle it properly, because you get genuinely different outcomes depending on which one you build.

**Approach A: Jido makes raw HTTP calls that include the actual `advisor_20260301` tool type.**

This is what I described in my last message. Here, you *are* invoking Anthropic's real server-side feature — your Elixir code is just the HTTP client; Anthropic's servers do the actual work (running the Fable sub-inference, producing the `advisor_tool_result`, handling `pause_turn`, returning `usage.iterations`, doing the encryption on `advisor_redacted_result`). Since it's the same API endpoint responding with the same JSON regardless of what language sent the request, this gets you **100% feature parity** with the Python/TS SDK. The only thing missing is *SDK convenience* — typed request/response structs, a helper method that automatically resends on `pause_turn`, etc. That's boilerplate you write once in Elixir (parse JSON, check `stop_reason`, loop if `pause_turn`) — real work, but not lost capability. Nothing about the feature itself degrades.

**Approach B: Jido doesn't touch the advisor tool at all — it just makes two independent ordinary Messages API calls** (call Sonnet, separately call Fable with the transcript, splice the advice back in as a message) to mimic the *concept*.

This is what my earlier answer was actually describing, and here the losses are real, because you're not using Anthropic's feature — you're rebuilding an approximation of it yourself:
- No single-request efficiency — two round trips instead of one server-side sub-call.
- No native `advisor_redacted_result` encryption semantics (moot anyway if you're calling Fable yourself, since you'd just see its raw output).
- No `usage.iterations` breakdown — you'd track cost bookkeeping yourself.
- No built-in `pause_turn`/resume protocol — you'd design your own loop control.

So the accurate statement is: **if you're willing to speak raw HTTP/JSON to `api.anthropic.com` with the correct `advisor_20260301` tool block, Jido gets you the real thing, full parity, modulo SDK sugar.** The degraded, "rebuilt from scratch" version only applies if you skip the native tool type entirely and hand-roll the two-call pattern instead — which you might still choose to do for simplicity, or if you want visibility into the advisor's raw reasoning rather than treating it as an opaque tool call, but it's a deliberate simplification, not a forced one.

## User

Sorry. Bad dictation. Is the only advantage to rolling it yourself the option to use models outside Anthropic?

## Assistant

<routes ref="/meta/analysis/when-to-roll-your-own-advisor-harness.md">
No — cross-provider flexibility is real but it's not the main one. Rolling it yourself trades the native tool's convenience for several kinds of control you don't get otherwise:

**1. Visibility into the advisor's reasoning.** With Fable or Mythos as the native advisor, you get `advisor_redacted_result` — an opaque encrypted blob you can't read; only the executor sees the plaintext server-side. DIY, you're calling the advisor model directly, so you always see its raw output. Useful for debugging, logging, auditing, or just understanding why the executor changed course.

**2. Control over the advisor's system prompt.** The native advisor "runs under its own Anthropic-supplied system prompt" — you don't get to customize how it's instructed to behave, what tone it takes, what it should prioritize. DIY, you write that prompt yourself.

**3. Control over what context the advisor sees.** The native tool auto-constructs the advisor's view from "the full transcript" — system prompt, tool defs, prior turns, tool results, verbatim. You can't filter it, redact sensitive data, compress a long history, or inject extra context (e.g., retrieved docs) that wasn't in the executor's own transcript. DIY, you decide exactly what the advisor sees.

**4. Control over *when* it's consulted.** Natively, the executor model decides when to call the advisor, like any tool — you can nudge it or force it with `tool_choice`, but you're steering the executor's judgment, not directly triggering the call. DIY, your own orchestration logic can trigger the advisor on precise conditions (every N steps, on a detected error, on a low-confidence heuristic) with no reliance on the executor "deciding" to ask.

**5. Multiple advisors / ensembles.** The native tool is one advisor per call. DIY, nothing stops you from fanning out to two or three advisor models in parallel and voting or merging their input.

**6. Freedom from Anthropic's declared compatibility pairs.** The docs list specific valid executor/advisor pairings. DIY sidesteps that entirely — pair anything with anything.

**7. Not depending on a beta feature.** `advisor-tool-2026-03-01` is beta — subject to change or removal. DIY uses only the stable Messages API underneath, so it's not exposed to that churn.

Cross-vendor model mixing (Fable as advisor to a Llama or GPT executor, say) is on this list too, and for some teams it's the deciding factor — but it's one item among several, not the whole story. What you give up in exchange, as covered earlier, is the single-request efficiency, the built-in `pause_turn`/resume protocol, and the `usage.iterations` cost bookkeeping — all of which you'd reimplement yourself.
</routes>

## User

What are the scenarios where people are drawn to trade rhe convenience of a vendor built in functionality like this and undergo building their own harness? I can see there are many advanatages, but which are the business use cases where this tends to arise?

Also, is the primary difference between the claude code tui and claude managed agents for software dev vs deployed operational agents and workflows operating autonomously?

## Assistant

<routes ref="/meta/analysis/when-to-roll-your-own-advisor-harness.md">
## Business scenarios for building your own harness

The advantages I listed are real, but in practice teams don't adopt all of them speculatively — a few concrete pressures actually push people off the vendor-built path:

**1. Regulated / audit-heavy industries.** Finance, healthcare, legal, defense — anywhere a regulator or internal compliance team needs to see *why* a decision was made. An encrypted `advisor_redacted_result` blob is a non-starter if you need to produce a full decision trail on demand. This is probably the single biggest driver toward DIY.

**2. Multi-vendor product requirements.** SaaS companies selling to enterprise customers who already have contracts/data agreements with OpenAI, Azure, or Google. If your product has to say "bring your own model" or support a customer's existing vendor relationship, you can't hard-wire a single-vendor server-side tool into your core architecture — you build your own abstraction layer that can call any provider.

**3. Data residency / sovereignty.** The native advisor call routes through Anthropic's infrastructure for the sub-inference. Companies with strict data-locality requirements (EU data that can't leave region, government/defense workloads, healthcare PHI under specific BAAs) sometimes need to control exactly which infrastructure processes each hop — that's easier to guarantee when you own the orchestration.

**4. Existing orchestration investment.** Teams that already run Temporal, LangGraph, their own agent framework, or (in this case) Jido, with mature logging/tracing/guardrail/retry infrastructure built around it. Routing one piece of the pipeline through a vendor's opaque server-side tool call fragments observability — you lose the ability to see that step in your own tracing stack the same way you see everything else. Consistency of the architecture ends up mattering more than the convenience of one feature.

**5. Change-management / vendor-risk policy.** Some orgs simply won't ship production traffic through a beta API surface (`advisor-tool-2026-03-01`) — procurement or platform-engineering policy requires only GA, versioned APIs in the critical path. DIY on stable primitives sidesteps that review cycle entirely.

**6. Product-specific behavior requirements.** If the "advisor" needs a very specific persona, tone, or safety filtering that's core to your product experience (a tutoring app, a specific compliance reviewer, a brand voice), you often can't accept "Anthropic's own supplied system prompt" — you need full authorship of that prompt and the ability to insert custom moderation between the two calls.

**7. Ensemble / multi-critic patterns beyond what the tool models.** Products that want two or three distinct specialist reviewers (a security-focused critic, a style critic, a correctness critic) rather than one generic "advisor" — the native tool is a single named advisor per call, so anything more elaborate is DIY territory anyway.

Cross-vendor model mixing is real, but it tends to show up as one clause inside reason #2 (a broader "we can't be single-vendor" business constraint), not as a standalone reason on its own.

## Claude Code vs. Claude Managed Agents

Your framing is close, and Anthropic's own engineering blog confirms it with a "brain vs. hands" split, though it's worth being precise about the three-way distinction rather than two:

- **Claude Code** is a specific, opinionated **harness** — the interactive CLI/IDE experience, wired for a developer driving software-engineering work turn by turn (what this very session is running on).
- **Claude Agent SDK** is that *same underlying engine* (agent loop, tools, context management) packaged as a Python/TypeScript library you embed in your own code — for when you want to build a custom harness but still drive it yourself, in your own process.
- **Claude Managed Agents** is a step further out: Anthropic hosts the agent loop *and* the execution sandbox for you — the "brain" (Claude's reasoning/inference loop) is decoupled from the "hands" (sandboxes, containers, tools, external systems), with a durable session log tying it together. It's built for long-running, potentially unattended, potentially multi-environment work — scheduled jobs, autonomous pipelines, workloads that outlive a single interactive session.

The important nuance from that blog post: Managed Agents isn't positioned as *replacing* Claude Code for a different use case — it's positioned as infrastructure that can *host* Claude Code (or any other harness) as one of many "hands." So the real axis isn't "dev tool vs. ops tool," it's **who owns the loop and the execution environment**: you drive it interactively (Claude Code), you own the process but embed the engine (Agent SDK), or Anthropic owns and runs the whole thing for you (Managed Agents) — and that last option is what makes it the natural fit for deployed, autonomous, long-horizon workflows, same reasoning as your instinct.
</routes>

## User

Create an analysis about the benefits of rolling it yourself - no mention of elixir - drawing from your last two responses

## Assistant

Done. The analysis is filed and the bundle verifies clean.

**Created:** `meta/analysis/when-to-roll-your-own-advisor-harness.md` (`type: analysis`, governance namespace — no `sb:` id, as with all analysis docs)

**What it captures**, distilled from the last two turns:
- **§1** — the two implementations of one pattern (native server-side advisor tool vs. self-built two-call orchestration), framed around *who runs the second inference*.
- **§2** — the seven controls rolling your own buys, ordered by how often they drive the decision (advice visibility → advisor system prompt → advisor context → call timing → multi-critic ensembles → model-pairing freedom → GA-only stability).
- **§3** — the business cases that convert those latent controls into requirements (regulated/audit-heavy, multi-vendor, data residency, existing-orchestration investment, vendor-risk policy, product-defining behavior, elaborate multi-critic), with **cross-vendor model mixing placed as a facet of the multi-vendor case, not a standalone reason** — exactly the point you pressed on.
- **§4** — what you give up (single-request efficiency, native pause/resume, per-iteration cost accounting, optimized caching).
- **§5** — the recommendation: native tool by default, self-build only against a *named constraint*; plus the two orthogonal clarifications (application-layer choice ≠ mixture-of-experts; the pattern is industry-standard, the packaging is Anthropic's).

I also added its entry to `meta/analysis/index.md`.

**One verifier note:** `mix brain.verify` passes all gates. It emits one *advisory* warning — the doc's `attribution` has no `from` yet. That's expected and correct: `from` back-links the analysis to the session thread that produced it, and that thread doc doesn't exist until the session is captured. Per the contract, `/create-pull-request` stamps `from` automatically after `/capture` writes the thread. So it resolves itself if/when you PR this — nothing to fix by hand.

Per the contract, no Elixir was mentioned, and this stayed on the designated branch (`claude/anthropic-source-post-7inkwm`) without committing — say the word if you'd like me to `/create-pull-request` (which would run capture, glossary, stamp the `from`, and open the PR).
