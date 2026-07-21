---
type: reference
title: 2026-07-17-vercel-eve-comparison-and-jido-host-plan
description: A session that examined Vercel's eve agent framework against this bundle — finding both converged on a directory of markdown under git with figure and ground inverted — then drilled into eve's skill scoping, cross-agent skill duplication, and tool registration, weighed building an owned host layer (in-repo vs. bespoke vs. Jido 2), and ended by filing the comparison as an analysis and graduating the "thin Jido host" recommendation into a proposed plan folded into the standing BEAM/Jido tiered path.
provenance: "Claude Code session (Claude Fable), 2026-07-17; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped; in-body ATX headers demoted to bold"
tags: [meta, thread, eve, vercel, jido, agents, skills, tools, architecture, runtime, host]
timestamp: 2026-07-17
pr: 117
---

# 2026-07-17-vercel-eve-comparison-and-jido-host-plan

## Where this landed

The session opened on `vercel.com/eve` — Vercel's June 2026 open-source agent
framework — asking where it and this repo overlap and differ, philosophically
and architecturally. The core finding: both systems converged on the same
substrate (a directory of markdown files under git as the definition of an
agentic system) with the figure and ground inverted — eve is an agent carrying
knowledge as an accessory; this bundle is knowledge hiring agents as transient
labor. Follow-ups drilled into why eve scopes skills per agent and loads them
contextually, how it manages skill duplication across agents (npm-style
copy-by-install against a canonical upstream), and how its tool registration
contrasts with conventional function calling (classic definition; filesystem
convention + durable exactly-once lifecycle around it). A parallel strand
weighed building the brain's own host layer — in-repo, bespoke, or on Jido 2 —
landing on "a thin, separate Jido-based host that treats the brain as its
world." The operator then directed persisting both: the comparison as
[vercel-eve-comparison](/meta/analysis/vercel-eve-comparison.md) and the host
shape as the [thin-jido-brain-host plan](/meta/plans/thin-jido-brain-host.md),
cross-linked and folded into the overlapping recent work (the four-analysis
BEAM/Jido family, the bundle/library separation plan from PR #100, the
swarm-eval harness plan from PR #105) rather than forked from it.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| eve vs. this bundle: philosophy and architecture comparison | closed | [vercel-eve-comparison](/meta/analysis/vercel-eve-comparison.md) | - |
| eve skill scoping (per-agent, contextual) and cross-agent skill duplication | closed | [vercel-eve-comparison](/meta/analysis/vercel-eve-comparison.md) (§4) | - |
| eve tool registration and lifecycle vs. conventional function calling | closed | [vercel-eve-comparison](/meta/analysis/vercel-eve-comparison.md) (§5) | - |
| An owned host layer: in elixir-mind, bespoke Elixir framework, or Jido 2 | paused | [thin-jido-brain-host](/meta/plans/thin-jido-brain-host.md) | Operator ratification: owned host vs. the CMA managed alternative; repo naming/placement; a standing trigger must fire before build |
| Reconciling the new plan with the standing BEAM/Jido verdict and recent PRs | closed | [thin-jido-brain-host](/meta/plans/thin-jido-brain-host.md) | - |

## User

examine https://vercel.com/eve in the context of this repo. where are there synergies, where are there differences? philosophically and architecturally, how do the approach differ and where are there overlaps?

## Assistant

<routes ref="meta/analysis/vercel-eve-comparison.md">
Here's my read after examining Eve (Vercel's agent framework, launched at Ship London in June 2026) against this repo.

**TL;DR:** Eve and elixir-mind independently converged on the same substrate — a directory of markdown files under git as the definition of an agentic system — but with the figure and ground inverted. Eve is an *agent* that carries knowledge as an accessory; elixir-mind is a *knowledge bundle* that hires agents as transient labor. Eve's durability is about execution (checkpoints, resumable sessions); elixir-mind's is epistemic (frozen thread docs, stable ids, evidence edges). They overlap heavily on mechanism and diverge almost completely on what the artifact *is for*.

**What Eve is**

Eve is an open-source, TypeScript-native framework where every agent is a directory: `instructions.md` (the system prompt), `skills/` (markdown playbooks loaded contextually), `tools/` (single TypeScript files with schema validation, picked up at build time), `channels/` (Slack, Discord, WhatsApp, cron, API…), and `connections/` (credential handling that keeps tokens out of the agent runtime). `vercel deploy` compiles the directory into a durable service on Vercel Functions, with checkpointed workflow steps, sandboxed compute, human-in-the-loop approvals that park execution without burning compute, subagents, OpenTelemetry tracing, and built-in evals. Their pitch is "Like Next.js for web apps, but for agents" — the framework owns the plumbing the way Next.js owns routing, and "a file's name and place in the tree are its definition." Vercel runs 100+ production agents on it internally.

**Where the philosophies genuinely overlap**

**The tree is the definition.** Eve's founding claim — a file's place in the tree *is* its meaning — is nearly a paraphrase of this repo's [tree-is-the-taxonomy policy](https://ob6to8.github.io/elixir-mind/meta/policy/tree-is-the-taxonomy.html). Both reject databases and config objects in favor of a legible, git-native, plain-text hierarchy where structure carries semantics.

**Markdown as the agent-facing primitive.** Eve's `instructions.md` + `skills/` is structurally identical to this repo's `CLAUDE.md` + `.claude/skills/*/SKILL.md`: prose documents that program agent behavior, loaded progressively rather than stuffed into every prompt. Eve's example skill — "revenue excludes trial accounts" — is exactly the kind of distilled operational knowledge this bundle would file as a `methodology` or `policy`.

**Change ships through git.** Eve agents deploy through ordinary git + CI/CD; each new capability is one file. Here, knowledge lands via PR, CI runs `mix brain.verify` / `mix brain.route_tags` / `mix brain.contract --check`, and the [merge-strategy policy](https://ob6to8.github.io/elixir-mind/meta/policy/merge-strategy.html) makes the commit graph itself the provenance layer. Both treat "review the diff" as the governance interface.

**Compiled artifacts from source files.** Eve compiles a directory into a running service; this repo compiles `CLAUDE.md` from `meta/policy/`, `meta/registry.md` from per-file ids, and the Pages site from the bundle — generated artifacts that are never hand-edited, checked in CI. Same instinct: the files are the source of truth, everything else is a build product.

**Scheduled autonomy.** Eve's cron channel is the same shape as this brain's daily `/research` Routine — an agent waking on a schedule to do bounded, attributed work.

**Where they diverge**

**Figure and ground are inverted.** In Eve, the agent is the durable product and knowledge (skills) exists to make the agent behave well. Here, the *documents* are the durable product and agents are explicitly ephemeral — sessions get reclaimed, branches get deleted, and the [session-capture policy](https://ob6to8.github.io/elixir-mind/meta/policy/session-capture.html) exists precisely because the agent's working memory is treated as disposable. Eve builds agents that happen to read files; elixir-mind builds files that happen to be operated by agents.

**Two different meanings of "durable."** Eve's durability is *execution* durability: checkpointed steps survive crashes, sessions park between messages and resume on delivery. This repo has no execution durability at all and doesn't want it — instead it has *epistemic* durability: `/capture` freezes sessions into verbatim thread docs, [stable `em:` ids](https://ob6to8.github.io/elixir-mind/meta/policy/stable-identity.html) survive refactors, `attribution` records the ingestion event immutably, and true-merge-only git keeps cited SHAs reachable forever. Eve remembers so the *process* can resume; elixir-mind remembers so the *record* can be read, cited, and verified years later.

**What gets typed and machine-verified.** Eve types execution: tools are TypeScript with schema-validated I/O, while its knowledge layer (skills markdown) is untyped free prose. Elixir-mind is the mirror image: execution is untyped (whatever Claude Code does in a session), while knowledge is rigorously typed — a [controlled `type` vocabulary](https://ob6to8.github.io/elixir-mind/meta/policy/controlled-type-vocabulary.html), a frontmatter schema, and typed evidence edges (`verified_by`) enforced by `mix brain.verify`. Eve validates that a tool call is well-formed; this repo validates that a *claim* is grounded.

**Human-in-the-loop means different things.** Eve's HITL is operational: pause an action, wait for approval, resume. This repo's is constitutional: the operator ratifies changes to the *shape* of the brain — new top-level directories, new types, new policies — while agents act autonomously within the ratified shape. Eve gates *actions*; the operating contract gates *structure*. Relatedly, Eve's governance story (Passport, credential isolation, OTel) is enterprise/security governance; this repo's governance (`meta/policy/`, doctrine above policy) is epistemic governance. Eve has no equivalent of `verified_by`, attribution, or the ratification protocol — that whole layer is simply outside its problem statement.

**Fixed schema vs. emergent taxonomy.** Eve imposes its directory schema the way Next.js imposes routing: `instructions.md`, `tools/`, `skills/` are framework-defined, and that opinionation is the product. Here the schema is deliberately *not* imposed — the taxonomy "emerges bottom-up" and evolves through proposal and ratification. Eve's tree describes a fixed anatomy; this tree *is* an open-ended ontology.

**Runtime coupling.** Eve is portable across *models* (swap Anthropic for OpenAI) but coupled to its runtime (Vercel Functions, Workflows, AI Gateway). Elixir-mind is the opposite: coupled to no runtime at all — the contract is prompt-level, so any agent that can read `CLAUDE.md` can operate the brain — with the Elixir code serving as verifier and compiler, never as the agent host.

**The interesting synthesis**

Both are instances of the same 2025–26 convergence — filesystem-native agent design — reached from opposite directions: Vercel arrived from infrastructure ("make agents deployable like web apps"), this repo arrived from knowledge management ("make a second brain operable by agents"). They meet in the middle so cleanly that each contains a miniature of the other: Eve's `skills/` directory is a small, untyped, ungoverned knowledge bundle; this repo's `.claude/skills/` + `CLAUDE.md` is effectively an agent definition minus the deploy target.

The practical synergy, if you ever wanted one: Eve is a plausible *host* for this brain's automation layer. The daily `/research` Routine, intake via chat channels (a WhatsApp message becoming an `/intake` run), and durable long-running captures map naturally onto Eve's cron/channels/workflow primitives — with the OKF bundle mounted as the agent's knowledge source. Conversely, what this repo has that Eve conspicuously lacks is exactly what production agent fleets will eventually need: typed knowledge with stable identity, evidence-backed verification, immutable attribution, and a ratification protocol for structural change. Eve solved "how do agents run"; this repo solved "how do agents *know*, and how do we trust what they've filed." The two problems are complementary, not competing.

Sources: [Introducing eve — Vercel](https://vercel.com/blog/introducing-eve) · [vercel/eve on GitHub](https://github.com/vercel/eve) · [The New Stack](https://thenewstack.io/vercel-launches-eve-an-open-source-framework-that-treats-agents-as-directories/) · [InfoQ](https://www.infoq.com/news/2026/06/vercel-eve-agents/) · [The Register](https://www.theregister.com/devops/2026/06/19/vercel-debuts-eve-open-source-agent-framework-tries-to-fix-shadow-ai-with-passport/5258726) · [TechTimes](https://www.techtimes.com/articles/318642/20260618/vercel-eve-launches-open-source-agent-framework-backed-its-own-production-fleet.htm)
</routes>

## User

in eve, why are skills loaded contextually per agent, vs global, or per repo? are tools being defined in the classic sense or is this a bespoke definition?
if eve could host elixir-mind, what if we were to build that host layer itself as part of elixir-mind? or build a new bespoke elixir framework to act as that host?
or is this what jido 2 offers?

## Assistant

<routes ref="meta/analysis/vercel-eve-comparison.md">
All three questions answered below, grounded in eve's docs, its GitHub repo, and Jido 2.0's release material.

**Why eve loads skills contextually, per agent**

**Per agent, because in eve the agent directory is the compilation unit.** Eve discovers everything under `agent/`, validates it, and compiles a manifest that becomes the deployed service. There is no "repo scope" distinct from "agent scope" because eve inverts the relationship you have here: an eve repo *is* an agent (plus optional `agent/subagents/*`, each with their own narrower config). There's nothing else in the repo for a skill to be global *to*. Contrast with elixir-mind, where skills live at the repo level (`.claude/skills/`) precisely because the repo is a shared workspace that many ephemeral agent sessions pass through — skills here attach to the *knowledge*, not to an agent identity. Claude Code actually supports all three scopes (global `~/.claude/skills`, project, plugin); eve collapsed them to one because its deployment model is one-agent-per-project. Subagents are eve's only scoping mechanism: a child agent with fresh history and a deliberately narrower toolset.

**Contextually, for context-window economics.** Eve's docs are explicit: `instructions.md` is "the always-on system prompt," while skills are "larger procedures or reference material that the model loads on demand… Keeping skills separate helps the model use the right context only when it is relevant." This is the same progressive-disclosure logic as this bundle's `index.md` hierarchy and Claude Code's skill system — advertise a one-line description cheaply, load the full body only when invoked, so the always-on prompt stays small and the model's attention isn't diluted by fifty playbooks it isn't using. Notably, eve's docs point to Vercel's shared "Agent Skills" resource and a skills CLI for installing them — they've adopted the emerging cross-vendor SKILL.md convention (the one this repo's skills already follow) rather than inventing their own format.

**Are eve's tools "classic" tool definitions?**

Yes — classic function calling with a filesystem-convention wrapper. A tool is one TypeScript file:

```ts
export default defineTool({
  description: "Return mock weather data for a city.",
  inputSchema: z.object({ city: z.string().min(1) }),
  async execute({ city }) { ... },
});
```

That's the standard LLM tool contract — name, description, JSON schema (derived from Zod), handler — the same shape as the Vercel AI SDK's `tool()` helper or an Anthropic/OpenAI tool definition. The only bespoke part is *packaging*: one file per tool, the filename becomes the tool name the model sees, and eve picks it up at build time with no registration step. Eve also ships framework tools (`bash`, `read_file`, `write_file`) that target the agent's sandbox. So: bespoke discovery convention, entirely conventional definition.
</routes>

<routes ref="meta/plans/thin-jido-brain-host.md">
**Building the host layer — in elixir-mind, bespoke, or Jido 2?**

First, what "the host layer" actually is: durable sessions, channels (Slack/HTTP/cron), scheduled runs like `/research`, an LLM client, tool execution, and credential handling. Today that host is Claude Code plus its remote environment and Routines — rented, not owned.

**Jido 2 is, to a close approximation, the thing you're describing.** [Jido 2.0](https://jido.run/blog/jido-2-0-is-here) (released February 2026) is "eve, but BEAM-native": agents are pure data structs (state + actions + tools) run inside supervised GenServers; everything flows through `cmd/2`, with side effects expressed as typed directives the runtime executes; capabilities are `Jido.Action`s — compile-time-validated, auto-converted to tool-calling format; LLM access goes through ReqLLM (11 providers, 665+ models, Anthropic included); and 2.0 adds durability via a storage/persistence layer, agentic memory, MCP, sensors, pluggable reasoning strategies (ReAct, CoT, ToT), and full-stack OTel. Its durability philosophy is interestingly different from eve's: eve replays an event log to reconstruct state after a crash (Vercel Workflows); Jido leans on OTP supervision — crash, restart clean, rehydrate from the persistence layer. Two caveats: Jido's "skills" are code-level Elixir modules, not markdown SKILL.md playbooks; and Jido is a framework you host yourself — it has no equivalent of eve's managed sandbox microVMs, credential vault, or one-command channel deployment.

**So my assessment of the three options:**

- **Don't build the host *into* elixir-mind.** The brain's deepest architectural commitment is that it is runtime-agnostic — the contract is prompt-level, so *any* agent that can read `CLAUDE.md` can operate it. That's what lets the host be swappable (Claude Code today, something else tomorrow). Folding a host runtime into the bundle would invert the figure/ground the brain deliberately chose — you'd be turning the knowledge-with-attached-agents back into an agent-with-attached-knowledge, which is eve's shape, not this repo's. The existing `lib/` code is a *verifier and compiler* for the bundle, and that boundary is worth keeping.

- **Don't build a bespoke framework from scratch** unless the building is the point. You'd be re-deriving supervision trees, session persistence, provider clients, and tool dispatch — all of which Jido 2 + ReqLLM now provide, production-hardened, in your language of choice. From-scratch is only justified as a learning project or if a doctrine-level objection to Jido emerges.

- **The pragmatic shape: a thin, separate Jido-based host that treats the brain as its world.** A small OTP app — sibling repo, not inside the bundle — where Jido supplies the chassis (supervised agent processes, sessions, ReqLLM, OTel) and the real work you'd do is the *harness semantics*: filesystem tools over a checkout of the bundle, a skill loader that reads `.claude/skills/*/SKILL.md`, an instruction loader that reads `CLAUDE.md`, tools that wrap `mix brain.verify` / `brain.registry` / `brain.route_tags`, and channels/cron for things like the daily `/research` run. That harness — making a Jido agent behave like a contract-obeying Claude Code session — is the genuinely novel piece; nobody ships it, and it's a well-bounded project. The brain wouldn't know or care that the host changed, which is exactly the property you want to preserve. (Bonus: `ash_jido` shipped with 2.0, so if the host ever needs real resources — queues, intake inboxes — Ash actions become agent-callable tools with authorization intact.)

One honest flag: this discussion is drifting toward a real design decision. If you want to pursue the Jido host, the persist-plans policy says the next step is a `type: plan` under `meta/plans/` capturing this reasoning (host-outside-the-bundle, Jido-as-chassis, harness-as-the-work) before any build starts — say the word and I'll draft it.

Sources: [eve Concepts — Vercel docs](https://vercel.com/docs/eve/concepts) · [vercel/eve on GitHub](https://github.com/vercel/eve) · [Jido 2.0 is now available](https://jido.run/blog/jido-2-0-is-here) · [Agent Jido](https://jido.run/) · [agentjido/jido on GitHub](https://github.com/agentjido/jido) · [Show HN: Jido 2.0](https://news.ycombinator.com/item?id=47263036) · [byteiota on Jido 2.0](https://byteiota.com/jido-2-0-build-fault-tolerant-ai-agents-in-elixir/)
</routes>

## User

how does eve deal with duplication across skills copied across agents?

## Assistant

<routes ref="meta/analysis/vercel-eve-comparison.md">
Eve's answer is essentially: **it doesn't solve duplication at the runtime level — it manages it at the ecosystem level, npm-style, by treating skills as vendored packages with a canonical upstream.**

Here's the actual mechanism. Skills are distributed as git repos, discoverable through the [skills.sh](https://skills.sh) registry, and installed with a CLI: `npx skills add <owner/repo>`. When you run that inside an eve project, it detects the project and **copies the skill files into that agent's `agent/skills/` directory**. Run it in ten agent projects and you have ten physical copies. There is no reference, symlink, import, or shared-library mechanism inside eve itself — the runtime only ever reads what's physically under `agent/`, because the agent directory is the self-contained compilation unit that gets deployed.

So deduplication happens one level up, the way package managers do it:

- **The canonical copy is the upstream repo.** A skill lives in one source-of-truth git repository; every agent that installs it holds a vendored snapshot. Fixing the skill means fixing it upstream, then re-installing in each consumer.
- **Update propagation is pull, not push.** The docs describe install but say nothing about automatic update propagation, version pinning, or lockfiles — the implication is you re-run the install (or wire it into CI) to refresh copies. Across a fleet like Vercel's 100+ internal agents, keeping copies in sync is an operational discipline, not a framework guarantee.
- **Monorepos are the informal escape hatch.** Since an agent is just a directory of files, teams can keep shared skills in one internal repo/package and install it into many agents — but that's a workflow pattern, not an eve feature.

The interesting contrast with this repo: eve and elixir-mind take opposite positions on duplication. Eve *accepts* copies and manages drift through a canonical upstream — the same trade npm made, optimizing for self-contained deployable units. Elixir-mind *forbids* copies structurally: the [update-in-place policy](https://ob6to8.github.io/elixir-mind/meta/policy/update-in-place.html) mandates one document per subject, [stable ids](https://ob6to8.github.io/elixir-mind/meta/policy/stable-identity.html) give every piece of knowledge exactly one identity, and where derived copies must exist (`CLAUDE.md`, the registry, route-tag logs) they're *generated* artifacts whose freshness CI verifies against the single source. Eve's model says "copies are fine as long as there's one upstream"; this repo's model says "there is no copy — there is the document, and there are compiled views of it, mechanically checked."

That difference follows directly from what each system optimizes for: eve needs an agent to be a hermetic, deployable artifact (a copy that can't drift *at runtime* is a feature — your deployed agent doesn't change under you when upstream does), while a knowledge bundle needs exactly the opposite — a single living version of the truth, because a stale copy of knowledge is a bug, not an isolation guarantee.

Sources: [Agent Skills — Vercel docs](https://vercel.com/docs/agent-resources/skills) · [eve Concepts — Vercel docs](https://vercel.com/docs/eve/concepts) · [skills.sh directory](https://skills.sh)
</routes>

## User

how does even's tool registration and usage contrast with conventional?

## Assistant

<routes ref="meta/analysis/vercel-eve-comparison.md">
Eve's tool *definition* is completely conventional; its *registration* and *execution lifecycle* are where it breaks from the norm. The contrast, layer by layer:

**Registration: convention over configuration, resolved at build time**

Conventionally, tool registration is runtime code you write. Against a raw provider API (Anthropic, OpenAI), you assemble a `tools` array of JSON schemas and pass it with every request, then hand-write the dispatch loop — check for a tool-use stop, run the matching function, append the result, call again. One level up, SDKs (Vercel's own AI SDK, LangChain, OpenAI's Agents SDK) hide the loop but keep registration explicit: you import each tool and wire it into a `tools: {...}` object or an agent constructor. Either way, the toolset is a property of your *code path* — it exists because some line of code assembled it.

Eve replaces that with filesystem convention: any `agent/tools/*.ts` file that default-exports a `defineTool` is discovered at build time, and **the filename becomes the tool name the model sees** (`get_weather.ts` → `get_weather`). No imports, no registry object, no per-request array assembly — the toolset is a property of the *directory*, compiled into the agent's manifest. Two consequences worth noticing: adding or removing a capability is a one-file git diff (reviewable, deployable, revertible like any code change, with no wiring edits elsewhere), and the toolset is validated and frozen at deploy rather than assembled dynamically — you can't conditionally construct a different toolset per request the way conventional loop code can.

**Definition: the classic contract, verbatim**

The tool object itself — `description`, `inputSchema` (Zod, inferred into `execute`'s types), `async execute(input, ctx)` — is exactly the standard function-calling contract, essentially the AI SDK's `tool()` helper. During discovery eve advertises only the descriptor (name, description, schema) to the model, never executes anything, and validates arguments against the schema on call. Nothing bespoke here. The one refinement is `toModelOutput()`: an optional separation between what a tool *returns* (structured data for your code) and what the *model sees* (a rendered summary) — conventional setups usually dump the raw return value into the context.

**Execution lifecycle: this is the real divergence**

Three things happen around `execute` that conventional tool loops don't give you:

1. **Exactly-once semantics per session.** Eve sessions run on a replayed event log (Vercel Workflows), and completed tool calls are checkpointed — "tools don't re-run once completed in a session." A conventional loop has at-least-once semantics: if your process dies mid-turn and you retry, any non-idempotent tool (send email, issue refund) may fire again. Eve memoizes the result into the durable log, so replay reconstructs state without re-executing side effects.

2. **Approvals as a declarative property, not loop surgery.** `needsApproval: always() | once() | ({toolInput}) => toolInput.amount > 1000` gates a tool, and a gated call "parks durably at `session.waiting` until a person answers, then picks back up exactly where it left off" — without consuming compute while parked. Conventionally, human-in-the-loop means intercepting your own dispatch loop, persisting pending state somewhere, and building the resume path yourself.

3. **Capability-scoped context injection.** `ctx` hands the tool `ctx.session`, `ctx.getSandbox()` (the isolated compute environment framework tools like `bash` also target), and `ctx.getSkill(id)` — while `connections/` keeps credentials out of both the prompt and, largely, the tool code. Conventional tools reach for whatever globals and env vars they want.

**Against the other two "conventional" poles**

Worth situating against two more comparators. **MCP** solves a different registration problem: cross-process, runtime discovery — tools live behind a server any number of agents can attach to, enumerated via protocol at connect time. Eve tools are in-process, build-time, single-agent; eve trades MCP's late binding and multi-consumer sharing for hermetic deployment (echoing the skills-duplication answer — the agent directory carries everything it needs).

And **Claude Code — the host this repo actually runs on** — sits at the opposite extreme: a handful of generic tools (Bash, Read, Edit, Grep) whose power is unbounded, governed *editorially* by prose (skills, `CLAUDE.md`) rather than *structurally* by schemas. That's the deeper philosophical split: eve narrows each capability into a typed, validated, individually approvable action — safety before the act, enforced by the runtime; the Claude Code/elixir-mind model keeps capabilities general and governs behavior by contract, with enforcement after the act (`mix brain.verify`, route-tag checks, CI, PR review). Typed tools scale to fleets of unattended production agents doing known operations; generic tools plus a prose contract scale to open-ended work no schema anticipated — which is precisely why a knowledge bundle chose the latter shape.

Sources: [How to add eve tools — Vercel KB](https://vercel.com/kb/guide/how-to-add-eve-tools) · [eve Concepts — Vercel docs](https://vercel.com/docs/eve/concepts)
</routes>

## User

create an analysis document that captures this
create a plan based off of "The pragmatic shape: a thin, separate Jido-based host that treats the brain as its world."
reference the last couple PRs - possibly overlapping
if so, cross link, or fold in

## Assistant

<routes ref="meta/analysis/vercel-eve-comparison.md meta/plans/thin-jido-brain-host.md">
Both documents are filed, verified, and pushed to `claude/vercel-eve-comparison-7jtud6` (commit `662fe3f`). Here's what landed and how I handled the overlap you flagged.

**The analysis** — `meta/analysis/vercel-eve-comparison.md` — captures the session's full arc: the verified eve baseline (agent-as-directory anatomy, replay durability, launch facts), the convergences (tree-as-definition, markdown primitives, git/CI as governance, compiled artifacts), the five divergences flowing from the figure/ground inversion, the skill-scoping and copy-by-install duplication answer, and the tool-registration contrast (classic definition, filesystem-convention registration, exactly-once lifecycle).

**The plan** — `meta/plans/thin-jido-brain-host.md`, `status: proposed` — commits the "thin Jido host" shape: a sibling modern-toolchain OTP app whose world is a checkout of the bundle; Jido as chassis; the five harness components as the real work (CLAUDE.md instruction loader, SKILL.md progressive-disclosure loader, bundle tools + `brain.*` verbs as Actions, PR-only write-gatekeeper, cron channel with `/research` as the first workload); a four-phase build order; and open ratification questions (owned host vs. the CMA managed alternative, cognition policy, repo placement).

**On the overlapping PRs — folded in, not forked.** The last few PRs turned out to matter a lot: the repo already carries a four-analysis BEAM/Jido family with a standing "not now, tiered path with triggers" verdict (PRs from 2026-07-12/16), the bundle/library separation plan (#100), and the swarm-eval harness plan (#105). Rather than contradict the standing verdict, the new plan explicitly updates it: building the host as a *separate sibling app* dissolves two of the three original blockers — the toolchain floor (precedent: #105's harness is already specified as a separate modern-toolchain app) and the zero-dependency constraint (it binds the verifier core, not consumers — the exact boundary #100 draws) — while the third blocker (a duplicate agent runtime with real ops cost) remains and stays the activation gate, with the same triggers as before. Both docs cross-link the whole family, and the analysis positions eve's contribution precisely: a *shape* for the owned host, not a timing change.

All gates pass (`brain.verify`, `route_tags`, `contract --check`, `registry --check`); the only warnings are the expected missing `attribution.from` entries, which `/create-pull-request` stamps once the thread is captured. Once merged, the docs will live at [vercel-eve-comparison](https://ob6to8.github.io/elixir-mind/meta/analysis/vercel-eve-comparison.html) and [thin-jido-brain-host](https://ob6to8.github.io/elixir-mind/meta/plans/thin-jido-brain-host.html) (URLs resolve after the PR lands). No PR opened — say `/create-pull-request` when you want the capture + PR motion.
</routes>
