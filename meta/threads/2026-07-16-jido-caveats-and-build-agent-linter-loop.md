---
type: reference
title: 2026-07-16-jido-caveats-and-build-agent-linter-loop
description: A session that started by asking whether the repo has a closed build-agent→linter→fix→rerun loop (it doesn't — the pieces exist but no automated cycle is wired), walked through how hook failure-injection works mechanically, whether routing lint failures to a cheap model in a dedicated context implies deploying to the BEAM (no — it's a harness concern), and ended by expanding Jido's two structural caveats (no distribution story; req_llm load-bearing for all cognition) into a new analysis doc.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-16; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, beam, jido, req_llm, distribution, agents, linter-loop, hooks, architecture]
timestamp: 2026-07-16
pr: 96
---

# 2026-07-16-jido-caveats-and-build-agent-linter-loop

## Where this landed

The session opened on the repo's own dev lifecycle: is there a closed loop where a
build agent writes code, a linter runs, and on failure the agent is alerted, fixes,
and the linter re-runs? The answer, after a read-only sweep of CI, hooks, mix
gates, and skills, was **no** — the repo has a strong verifier gate suite at three
surfaces and a green-gated merge, but no automated agent-in-the-loop lint/fix
cycle; the only Claude hook is `SessionStart` (toolchain provisioning), and the
merge skill stops-on-red rather than autofixing.

From there the discussion moved to mechanism (how a hook "injects" a failure back
into the session — it literally appends text to the model's context on the next
turn, via a `PostToolUse`/`Stop` hook's exit code + stdout/stderr), then to a
cheaper-model, dedicated-context lint-fixer (achievable in the harness with a
Haiku-pinned subagent or an out-of-band API call — no BEAM required), and finally
to expanding the two Jido caveats the prior BEAM/Jido analyses name in passing.
That expansion was compiled into a new analysis,
[jido-distribution-gap-and-req-llm-cognition-dependency](/meta/analysis/jido-distribution-gap-and-req-llm-cognition-dependency.md),
and shipped via this PR.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Is there a closed build-agent→lint→fix→rerun loop in the repo? | closed | [jido-distribution-gap-and-req-llm-cognition-dependency](/meta/analysis/jido-distribution-gap-and-req-llm-cognition-dependency.md) (§4) | - |
| How hook failure-injection works mechanically (context = thread) | closed | `unrouted` | - |
| Cheap-model dedicated-context lint-fixer; does it need the BEAM? | closed | [jido-distribution-gap-and-req-llm-cognition-dependency](/meta/analysis/jido-distribution-gap-and-req-llm-cognition-dependency.md) (§4) | - |
| Expand Jido's two caveats: no distribution story; req_llm load-bearing | closed | [jido-distribution-gap-and-req-llm-cognition-dependency](/meta/analysis/jido-distribution-gap-and-req-llm-cognition-dependency.md) | - |

## User

Is there a loop integrated into the dev lifecycle of this repo where a build agent writes code, a linter is run, and if it fails, the build agent is alerted of what failed, fixes the problem, and the linter is re-run?

## Assistant

**Short answer: No — not as a closed, automated loop.** The repo has all the *pieces* of one (a strong linter/verifier suite, run at three surfaces), and an agent does read-and-fix lint failures in practice, but the "agent is *automatically* alerted → fixes → linter *auto* re-runs" cycle isn't wired up anywhere. It's a human-supervised, agent-executed gate suite, not an event-driven agent-in-the-loop.

Here's the concrete picture.

**The linter/verifier layer exists and is real**

An eight-gate suite of `mix brain.*` tasks plus build checks, run in `mix compile --warnings-as-errors` → `mix format --check` → `mix test` → `brain.contract --check` → `brain.registry --check` → `brain.verify` → `brain.route_tags` → `brain.lineage --check` → `brain.dev_history --check` order. Each gate exits non-zero with a **self-describing error message** — deliberately designed so an agent reading the failure can act on it. Documented in `meta/tutorials/the-gate-suite-and-where-it-runs.md`.

It runs at three surfaces:
1. **Manual** — the agent runs the scoped subset by hand mid-session (instructed by CLAUDE.md + the tutorial).
2. **Pre-commit** — `.githooks/pre-commit` mirrors CI locally, but it's **opt-in** (must `git config core.hooksPath .githooks`) and **non-blocking** (exits 0 if `mix` is absent).
3. **CI** — `.github/workflows/ci.yml`, the authoritative backstop on every push/PR.

**Why it's not the loop you're describing**

The "build agent writes code → linter runs → **agent auto-alerted of failure** → fixes → linter **auto re-runs**" cycle is missing its automation at every seam:

- **No post-edit / Stop / PostToolUse hook.** The only Claude Code hook is `SessionStart` (`.claude/hooks/session-start.sh`), and it just provisions the Elixir toolchain — it does *not* run a linter after edits or feed results back. So nothing auto-runs a verifier when the agent writes code.
- **The merge skill gates but doesn't autofix.** `/create-pull-request merge` polls CI checks until green — but its rule is *"If a check fails, stop and surface it — do not merge a red PR."* It halts and hands back to the operator rather than fixing and re-pushing.
- **CI has no callback to an agent.** No autofix workflow, no issue-open, no dispatch. Feedback to an agent only happens if the operator explicitly asks the agent to `subscribe_pr_activity` (off by default).

So the re-run is always the agent *choosing* to re-invoke the task after a fix, or CI re-running on the next push — never an automated cycle triggered by the failure itself.

**Where the fully-autonomous version is acknowledged**

`meta/analysis/dark-factory-epistemic-base-beam-jido.md` discusses a lights-out, self-supervising agent network explicitly as a **hypothetical future**, contrasting it with today's regime: *"episodic sessions, effectively one writer at a time, an operator ratifying shape changes, CI as the gate between sessions and main."* That confirms the closed loop is aspirational, not implemented.

Worth noting: your working branch is `claude/build-agent-linter-loop-koewpl` — the name suggests you may be intending to *build* exactly this loop. If that's the goal, the natural missing piece is a **`Stop` or `PostToolUse` hook** in `.claude/settings.json` that runs the scoped gate subset and injects failures back into the session (the mechanism that would close the loop locally), and/or a merge-path change from "stop on red" to "diagnose-and-re-push." Want me to sketch a plan for that?

## User

When you say "inject failures back in the session", how mechanically does this hapoen? Is the "session" the thread context? It it that failures are literally logged into the thread and submitted to the llm?

## Assistant

Yes — you've got the right mental model. Let me make it mechanically precise.

**"Session" = the thread context = the conversation the LLM sees**

A Claude Code "session" is exactly the running conversation: the ordered list of messages (system prompt, user turns, assistant turns, tool calls, tool results) that gets sent to the model on each inference. "Injecting into the session" means **appending text to that message list so it's part of the next prompt the LLM receives.** There's no separate side-channel — the model only ever knows what's in that context window.

**How a hook actually gets text into the context**

Hooks are shell commands the harness runs at defined lifecycle points (`PostToolUse`, `Stop`, `SessionStart`, etc.), configured in `.claude/settings.json`. The mechanical flow for a lint-on-edit loop would be:

1. The agent calls `Edit`/`Write` on a file.
2. The harness fires the **`PostToolUse`** hook after that tool completes. The hook is just a script — say, one that runs `mix format --check-formatted && mix brain.verify` on the changed file.
3. The script's **exit code + stdout/stderr are what the harness reads back**. This is the key part: a hook doesn't magically talk to the model — it communicates through its process output. Specifically:
   - **Exit code 2** (by convention in Claude Code hooks) means "block / there's a problem." The harness takes the hook's **stderr** and feeds it back to the model as a tool-result-like message.
   - Or the hook prints **JSON on stdout** (e.g. `{"decision": "block", "reason": "..."}` or a `PostToolUse` `additionalContext` field), which the harness parses and turns into a context message.
4. That text — literally the linter's failure output — becomes a new entry in the message list, framed as a system/tool message like *"PostToolUse hook reported: mix brain.verify failed: em:4c9e1f missing verified_by …"*.
5. On the next inference the model sees that message, and because it reads as a fresh problem in its context, it responds by editing the file to fix it.
6. The fix triggers `PostToolUse` again → linter re-runs → if green, the hook exits 0 and stays silent; if still red, another failure message lands. That's the loop closing.

So, to your literal question: **yes — the failure text is literally written into the thread and submitted to the LLM on the next turn.** The "alert" is not a signal or an interrupt; it's just more tokens in the prompt. The model "fixes it" because responding to problems described in its context is what it does.

**The two things that make it a *loop* rather than a one-shot**

- **Re-entrancy**: the hook fires on *every* qualifying tool call, so the agent's fix-edit re-triggers the check. Nobody has to re-run anything by hand — the lifecycle event does it.
- **A stop condition**: `Stop` hooks can also `block`, meaning "don't end the turn yet — here's why." That's how you prevent the agent from declaring victory while the linter is still red: the `Stop` hook runs the gates, and if they fail it injects the failure and forces another turn instead of yielding control back to the operator.

**Important caveats about this mechanism**

- **It's context, not ground truth.** The model can, in principle, ignore or rationalize an injected failure the same way it can ignore any instruction — it's not a hard gate. The *hard* gate is still CI (exit-non-zero blocks the merge regardless of what the model does). The hook loop is a convenience that catches problems early and cheaply; it doesn't replace CI.
- **It costs context.** Every injected failure is tokens that stay in the window. A noisy linter or a fix that oscillates can bloat the thread — one reason you'd scope the `PostToolUse` check narrowly (only the changed file, fast gates) rather than running the whole eight-gate suite on every edit.
- **Loop-guard.** Hooks can recurse (fix triggers check triggers fix). Claude Code guards against infinite hook recursion, but the *agent-level* loop (edit → fail → edit → fail forever on something it can't fix) is real and needs a bound — a max-iteration count or a "give up and surface to operator" escape, which is exactly the judgment the current `merge` skill encodes as "stop on red."

This repo has **none of that wired today** — there's no `PostToolUse` or `Stop` hook, only `SessionStart` (which just provisions the toolchain). Building the loop on your branch would mean adding a `PostToolUse`/`Stop` hook entry to `.claude/settings.json` pointing at a script that runs the scoped gates and exits 2 (or emits `block` JSON) with the failure on stderr. Want me to draft that hook + script concretely against this repo's `mix brain.*` gates?

## User

What about a hook routing the failure log to a cheaper model suitable for say linting, and subsequently a dedicated agent/context only for that task? What would that look like? In this case, would that mean deploying elixir-mind to the beam and possibly running a jido 2 agent dedicated to linting?

## Assistant

This is a great question because it actually splits into two very different architectural claims that are worth pulling apart: **(a) routing a failure to a cheaper model in a dedicated context** is an *orchestration/harness* concern, and **(b) deploying to the BEAM with a resident Jido linting agent** is a *runtime* concern. The first does not require the second. Your brain has already reasoned about exactly where the line falls, so let me ground the answer there.

**Part 1 — The cheap-model, dedicated-context lint-fixer (no BEAM needed)**

The key realization: a hook doesn't have to inject the failure into the *main* session at all. "Dedicated context for that task" just means **a separate LLM invocation whose message list is seeded with only the lint failure + the offending file** — nothing else from the main thread. There are two ways to build that inside the Claude Code harness today:

**Variant A — hook delegates, main agent spawns a subagent.**
The `PostToolUse` hook returns `additionalContext` that says, in effect, *"lint failed; delegate the fix to the linting subagent."* The main agent then calls the `Agent` tool with `subagent_type` pointed at a lint agent whose definition pins `model: haiku`. That subagent runs in its **own context window** — it sees the failure and the file, edits, re-runs the gate, and returns only a terminal summary ("fixed" / "couldn't fix: X") to the main thread. The main session's context stays clean; the expensive model never sees the lint churn.

**Variant B — the hook itself calls the cheap model out-of-band.**
The hook is just a shell script, so it can `curl` the Anthropic Messages API directly with `claude-haiku-4-5`, passing `{failure_text, file_contents}` as the entire prompt. It applies the returned patch, re-runs `mix format --check` / `mix brain.verify`, and loops N times *without ever touching the main session*. Only if it exhausts its retry budget does it exit 2 and surface the residual failure to the main agent. This is the purest "dedicated context" — a fresh, single-purpose API call with no thread history, on a model priced for the task.

Either way, "routing to a cheaper model" is achieved by **where you send the tokens**, not by what runtime you're on. The dispatch, the model choice, and the isolated context are all things the harness (or a shell script) already gives you. This is the version I'd actually build for your branch — it's a `.claude/settings.json` hook entry plus a script, and it closes the loop cheaply.

**Part 2 — Why this does *not* imply the BEAM**

Your brain's own verdict is blunt about this. From the BEAM/Jido dark-factory analysis:

> The prior verdict rested on one structural fact: *the runtime is elsewhere* (Claude Code sessions + CI), so a resident BEAM system had nothing to grip.

A single lint-fix task is the definition of "nothing to grip." It's episodic, single-writer, short-lived, and stateless between runs — the workload the analysis found the BEAM *does not* serve. Deploying elixir-mind to the BEAM to run one linting agent would be paying the full runtime tax (an Elixir 1.17+/OTP 26+ migration "toolchain floor," a resident supervised app, `req_llm` as a core dependency) to buy supervision and concurrency that a one-shot lint loop simply doesn't consume. That's over-engineering, and the brain says so.

**Part 3 — Where a Jido linting *agent* actually earns its place**

The BEAM version stops being over-engineering exactly when linting stops being a per-edit gate and becomes a **continuous, concurrent workload**. The analysis names this inversion directly:

> **Verification inverts from gate to workload.** Today verification is a per-commit CI gate. In the factory it is a **continuous immune system**: sweep agents re-checking grounding, staleness propagation… dedup patrols.

That's the regime where a dedicated Jido linting agent is the right shape, not a subagent. Concretely, IF you were there, it would look like:

- A **supervised Jido agent** (process-per-agent isolation, let-it-crash restart) subscribed via Jido's trie-based CloudEvents routing to a signal like `verify/failed` emitted whenever a submission fails a gate.
- Its `cmd/2` reducer takes `(state, {:lint_failed, file, output})` → calls a `jido_ai` strategy backed by `req_llm` on a **cheap model** → emits a patch directive and a `verify/rerun` signal. Because the reducer is a pure `(state, action) → (state′, directives)` function, every fix is replayable and auditable without an LLM in the loop — which is the property the analysis prizes: an end-to-end audit trail from belief to decision.
- It runs as one process among a fleet, restartable independently, with backpressure/mailboxes handling "400 files changed, provider allows 40 concurrent inferences."

But note what that presupposes: many concurrent submissions, a long-lived process worth supervising, and a signal bus to subscribe to — i.e. the **librarian / write-broker** architecture the same analysis flags as *"the first genuinely new artifact this scenario demands."* A linting agent isn't a standalone reason to adopt Jido; it's one worker inside the resident-fleet runtime that the dark-factory scenario justifies as a whole. And the analysis's caveats ride along: Jido is young (stable 2026-02), has **no distribution story** (single-node; `jido_cluster` unpublished), and makes `req_llm` load-bearing for all cognition.

**Bottom line**

| Question | Answer |
|---|---|
| Can a hook route the lint failure to a cheaper model in a dedicated context? | **Yes** — subagent pinned to Haiku, or a hook script that calls the cheap model out-of-band. Pure harness/orchestration. |
| Does that require deploying to the BEAM? | **No.** The runtime is elsewhere; a one-shot lint loop has nothing for a resident BEAM to grip. |
| When does a Jido-2 linting *agent* make sense? | Only under the inversion — when verification becomes a **continuous fleet workload**, at which point the linting agent is one supervised worker inside the librarian/signal-bus runtime, not a standalone deployment. |

So for the loop on your `build-agent-linter-loop` branch: build the cheap-model subagent/hook — that's the 90% solution and it's a config-plus-script change. Reserve the BEAM/Jido answer for when you're actually building the dark-factory runtime, where linting rides in as one process among many.

Want me to draft the concrete Variant-A setup — a `lint-fixer` subagent definition on Haiku plus the `PostToolUse` hook that delegates to it against this repo's `mix brain.*` gates?

## User

Can you expand on why/how jido "has no distribution story (single-node; jido_cluster unpublished), and makes req_llm load-bearing for all cognition"?

Then compile all of this as an analysis document, commit, push, then pull main and merge, /create-pull-request , merge

## Assistant

<routes ref="em:44f899">
Here's the expansion, which I'll also compile into the analysis doc.

**1. "No distribution story (single-node; `jido_cluster` unpublished)"**

The subtlety: the **BEAM has world-class distribution primitives** (transparent inter-node message passing, `:global`, `:pg`), but a *framework* only becomes distribution-aware if it makes deliberate choices on top of them. Jido makes the single-node choices:

- **Agent identity is node-local.** A Jido agent is a GenServer registered under an instance-scoped supervisor (`{Jido, name: MyApp.Jido}`) via a local Registry. That name resolves on *one* node. There's no cluster-wide registry that lets "agent Foo" be addressed from any node — so you can't transparently route to an agent that happens to live on a different machine.
- **Recovery is single-node crash recovery, not cross-node failover.** Jido's durability model is "rehydrate from persisted state" (Redis adapter since 2.1.0). That handles *a process crashing and its supervisor restarting it on the same node*. It does **not** handle *a node dying and its agents coming back up elsewhere* — there's no handoff/migration orchestrator watching for a dead node and re-spawning its fleet on survivors.
- **The signal bus is in-node.** Signals are trie-routed pub/sub over a per-node bus. Cluster-wide routing would need that bus to span nodes (via `:pg`, `phoenix_pubsub`, or `partisan`) — Jido doesn't ship it.
- **`jido_cluster` is the intended answer, but it's vapor for now.** A repo exists in the agentjido org, but it's *unpublished on hex* — you can't `mix deps.get` it, and the brain flagged its maturity as unconfirmed. So the distribution layer is gestating, not shippable.

**Why this matters (and why it mostly doesn't, until it does):** one BEAM node holds *millions* of lightweight processes, so "single-node" is a very high ceiling — vertical scaling alone carries a big fleet. What you *give up* is (a) horizontal scale across machines, (b) HA — that one node is a single point of failure for the whole fleet; no HA across machines, and (c) geographic distribution. For a dark factory that "eventually spans nodes," you'd be **building the distribution layer yourself** on raw BEAM primitives: `libcluster` for node discovery, `Horde` (or a hand-rolled `:global`/CRDT registry) for distributed process registration + handoff, and a distributed pubsub for the signal bus. That's exactly the "that layer would be ours to build" caveat — and distribution is genuinely hard (split-brain/netsplit handling, CAP tradeoffs on the registry, state-handoff races), which is *why* a young framework reasonably punts on it.

**2. "Makes `req_llm` load-bearing for all cognition"**

The architecture: Jido deliberately splits core `jido` (zero LLM code — the pure `cmd/2` reducer, agent-as-data) from `jido_ai` (the reasoning layer: ReAct/CoT/ToT strategies, tool-calling loops, structured output). `jido_ai` is built on `req_llm`, Jido's own in-house LLM client (they dropped LangChain). `req_llm` sits on `Req` (HTTP) and owns the provider adapters, the model catalog, streaming, and tool-call encoding.

"Load-bearing for all cognition" means: the reducer core is LLM-free *by design* (that's the replayable-without-a-model auditability win) — but the instant an agent actually **thinks** (any inference, any reasoning strategy, any structured extraction, any tool-selection decision), it goes through `jido_ai` → `req_llm`. There is no first-class alternate cognition path in the framework. Consequences:

- **One throat for every inference.** `req_llm`'s provider coverage, streaming correctness, tool-call encoding, retry/rate-limit semantics, and error handling *become your cognition's reliability envelope*. The single most volatile, most external, most expensive part of the system — model calls — has exactly one library standing under it.
- **Coupling to a young, in-house library.** `req_llm` was written during the ~18-month Jido 2 rewrite; the brain flagged even its "665+ models" claim as unconfirmed. When a new model, param, or feature lands (prompt caching, extended thinking, a changed tool-call format), you wait on `req_llm` to support it or you patch it — versus calling the Anthropic SDK directly, where you own the request shape.
- **It entangles with elixir-mind's zero-dep and duplicate-runtime blockers.** Adopting Jido's cognition pulls `req_llm` *and* a provider credential into the runtime tier — which is exactly why the verifier core must never depend on it and cognition must live in a separate mix project (blocker #2), and why a Jido deployment is "a second agent runtime with its own LLM credentials" (blocker #3).
- **The flip side — it's a reasonable design.** Isolating cognition behind a swappable client is *good* architecture: it's what keeps LLM code out of the reducer and makes decisions testable without a model, and in principle the client is replaceable. "Load-bearing" is a caveat about **concentration of dependency**, not a design flaw.

**Tie-back to the linting loop from earlier:** a Jido lint-fixer calling a cheap model would route that call *through* `req_llm` — so your ability to pin `claude-haiku-4-5`, set `max_tokens`, etc., is bounded by what `req_llm` exposes. And the single-node ceiling is irrelevant to a lint-fixer specifically; it only bites once linting becomes a fleet-scale continuous workload.
</routes>
</content>
