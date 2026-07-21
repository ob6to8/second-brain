---
type: reference
title: 2026-07-16-code-tutorial-and-generated-code-map
description: Designing and building documentation for the elixir_mind tooling — a generated meta/code-map.md compiled from lib/ docstrings by a new mix brain.codemap task, plus a prose architecture-spine tutorial — including the model-split (Sonnet fan-out read, Opus synthesis) that produced it.
provenance: "Claude Code session (Claude Opus 4.8 driving; Claude Sonnet 5 fan-out readers), 2026-07-16; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, tooling, documentation, code-map, tutorial, workflow]
timestamp: 2026-07-16
session: https://claude.ai/code/session_01QzSoZSjsA29z2SkwrYeTBC
pr: 103
---

# 2026-07-16-code-tutorial-and-generated-code-map
## Where this landed

The operator asked for a "code tutorial" (prose walkthrough of the tooling's
services, functions, and architecture) plus a "code glossary" of function and
data-structure intent, and which model to use — worth subagent workflows?

A survey of `lib/` (27 files, ~6k LOC, `deps: []`, 30/30 `@moduledoc`, 85 `@doc`)
settled the design: **prose is authored, the glossary is compiled, and they meet
at the docstrings.** The code glossary became a *generated artifact* —
`mix brain.codemap` compiles `meta/code-map.md` from each module's
`@moduledoc`/`@doc`/`@typedoc` via `Code.fetch_docs/1` (stdlib, offline), on the
same `--check`-gated discipline as `CLAUDE.md`/`registry.md` — rather than ExDoc
(a dep, a second doc site) or hand-written prose (drifts). The prose became a
single architecture-spine `tutorial` that places every module in the
parse → scan → generate → publish pipeline and links the existing narrow
tutorials instead of restating them.

Model split, ratified against the outcome: **Sonnet 5** ran the 5-way parallel
read of `lib/` (extraction-to-schema); **Opus 4.8** did the synthesis, the
generator, the compile-metadata path fix for inline struct submodules, and the
prose. The plan was persisted (`meta/plans/code-tutorial-and-code-map.md`,
`status: done`), the new freshness gate folded into CI/Pages/pre-commit and the
gate-suite tutorial (eight → nine gates), and both deliverables shipped green
(160 tests, all gates, 510-page site). The session closed by opening this PR.
## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Design: generated code-map vs ExDoc vs prose; prose-authored / glossary-compiled split | closed | [code-tutorial-and-code-map plan](/meta/plans/code-tutorial-and-code-map.md) | - |
| `mix brain.codemap` + generated glossary artifact | closed | [meta/code-map.md](/meta/code-map.md) | - |
| Architecture-spine prose walkthrough of the tooling | closed | [the-tooling-architecture tutorial](/meta/tutorials/the-tooling-architecture.md) | - |
| New freshness gate folded into the documented gate suite | closed | [the-gate-suite tutorial](/meta/tutorials/the-gate-suite-and-where-it-runs.md) | - |
| Model choice (Opus vs Sonnet) and subagent-workflow fit for the doc build | closed | `unrouted` | - |
## Render

## User

I would like to create a code tutorial for this repo - a prose walkthrough of the services, functions, and architecture, and a "code glossary" of funtion and dats structure intent. What would be the best model for this? Worth looking as subagent workflows?

## Assistant

Now I've got what I need to give you a grounded recommendation. Two findings shape everything:

1. **The code is zero-dep by doctrine.** `deps: []` is deliberate — there's even a tutorial on *why the toolchain runs offline*. That rules ExDoc out (or at least makes it a doctrine violation, not a free choice).
2. **The intent is already half-captured in the code.** 30/30 modules carry `@moduledoc`, plus 85 `@doc` blocks. So a "code glossary of function/data-structure intent" isn't a from-scratch write — a lot of it exists as docstrings waiting to be surfaced.

Here's how I'd model it.

## The two deliverables map to two different mechanisms

**1. Prose walkthrough → `type: tutorial` under `meta/tutorials/`.** This is exactly what that namespace already is. You have 9 tutorials, but each is a *narrow slice* ("the gate suite", "the three scanners", "the session-init digest"). What's missing is the **spine**: one architecture-tour tutorial that gives the grand tour of the layers and links out to the existing slices —

```
frontmatter/markdown parsing  →  the three scanners (Registry/Verifier/RouteTags)
   →  generators (Contract, Registry, Site, RouteTags materialize)
   →  the mix brain.* CLI surface
   →  cross-cutting: Attribution / Lineage / DevHistory
```

Hand-written prose, lives in the bundle, renders to the Pages site. No new namespace, no ratification needed.

**2. Code glossary → a *generated artifact*, not hand-written prose.** This is the real design call, and the repo already answers it. `CLAUDE.md` and `meta/registry.md` are both **compiled, zero-dep, CI-`--check`-gated** artifacts. A code glossary should be the same: a `mix brain.codemap` task that extracts module/function/`@type` docs (via `Code.fetch_docs/1` — stdlib, no deps) into a generated `meta/code-map.md`, checked in CI so it can't drift.

That beats the alternatives cleanly:
- **ExDoc** — idiomatic elsewhere, but breaks `deps: []` and spins up a *second* doc site next to Pages. Wrong for this repo's doctrine.
- **Hand-written prose code-map** — drifts from code with no mechanical oracle (same weakness as route-tag coverage). Avoid.
- **Generated-from-docstrings** — mirrors `registry.md`/`CLAUDE.md` exactly, stays offline, and can't go stale. The agent work becomes *improving the `@moduledoc`/`@doc`/`@typedoc` intent in the source* (where 4 `@type`s across 6k LOC is thin), and the glossary falls out mechanically.

So: **prose is authored, glossary is compiled.** They meet at the docstrings.

## Subagent workflow — yes for the prose, no for the glossary

- **Prose tour:** good fan-out fit. One reader per subsystem (parsing / scanners / generators / CLI / attribution-lineage) returning structured `{module, role, key functions, data shapes, intent}`, then one synthesis pass writes the spine and any new subsystem tutorials. It's ~6k LOC across 27 independent files — a *handful* of parallel readers + a synthesizer, not a big fleet. I'd run it as a `Workflow` (understand-phase fan-out → synthesize), which also lets the readers flag thin/missing docstrings for the glossary work.
- **Glossary:** that's *code* (`Code.fetch_docs/1` + a formatter), not a subagent job. A workflow only helps for the docstring-authoring pass that feeds it.

## The one call that's yours

Where the generated glossary lives is the only thing touching the *shape* of the brain:

- `meta/code-map.md` (a single generated file, like `meta/registry.md`) — **no ratification needed**, and my recommendation.
- a new `meta/code-map/` directory (per-module pages) — a new namespace, so that's an operator-ratified change.

I'd go single-file generated `meta/code-map.md` + one architecture-spine tutorial (+ maybe 2 subsystem tutorials), and treat enriching the source docstrings as the real content work.

Do you want me to **persist this as a `type: plan`** and then run the fan-out workflow? Or would you rather I sketch the `mix brain.codemap` task first so you can see the glossary format before committing to the shape? And for the glossary home — single generated `meta/code-map.md`, or the per-module directory (which I'd need you to ratify)?

## User

Yes
Defer to you on shape
Single generated
Is opus 4.8 best model for this?

## Assistant

Quick answer on the model, then I'll get moving.

## Is Opus 4.8 the best model here?

For the parts that matter, yes — but not for all of it. The task splits cleanly:

- **Synthesis + prose writing** (the architecture tutorial, matching the existing tutorials' dense, precise voice) → **Opus 4.8.** This is high-judgment work: understanding a governance-heavy ~6k-LOC architecture and writing durable brain content that won't mislead. Worth the strongest model. This is the main-loop model I'm already on, so it's covered.
- **The `mix brain.codemap` task** (zero-dep `Code.fetch_docs/1` extractor + `--check` mode + tests, matching existing task conventions) → **Opus 4.8** too. Small but has to be exactly right and offline-safe.
- **The fan-out readers** (per-module: extract role, key functions, data shapes, intent into structured output) → **Sonnet 5.** This is the parallel bulk, and extraction-to-schema is squarely in Sonnet's wheelhouse — faster and cheaper across ~5–6 concurrent readers, with no quality loss on the synthesis because Opus does the actual writing from their output.

So the split is **Opus drives + writes + codes; Sonnet reads.** That's the cost/quality-right shape, and it's what I'll encode in the workflow.

Let me persist the plan first, then run the fan-out. Checking the existing conventions so the plan doc is shaped right:

## Assistant

Done so far, and what's running:

- **Plan persisted** → `meta/plans/code-tutorial-and-code-map.md` (`status: accepted`), added to the plans index under Accepted/In progress.
- **Read fan-out launched** — 5 Sonnet readers over the lib subsystems (parsing · scanners · site-and-contract · provenance · mix-tasks), returning structured module/function/data-shape intent. Running in background now; I'll continue once it lands.

On your model question — to restate the split I'm using: **Sonnet 5** is doing this parallel read (extraction-to-schema, no judgment lost), and **Opus 4.8** (this loop) will do everything downstream that's actually hard: writing `mix brain.codemap`, enriching the thin docstrings, and synthesizing the architecture tutorial. That's the right allocation — Opus isn't better at bulk extraction, just more expensive, so I'm not spending it there.

I'll pick back up when the readers finish and go straight into the `mix brain.codemap` task.

## Assistant

Full architecture in hand, and `ElixirMind.Registry` is the exact template to mirror (`output_path/0` · `render` · `write/1` · `check/1` returning `:ok | {:stale, path}` · a GENERATED banner). Before writing, let me confirm how I'll enumerate modules and that doc chunks are actually available at runtime:

## Assistant

`DedupProbe.Row` is an inline struct submodule with a real moduledoc — so it's correctly included (that's data-structure intent), but my name-based path derivation can't find inline submodules. I'll derive the path from compile metadata instead, which is correct for both separate-file and inline modules. Let me confirm what these submodules look like:

## Assistant

Done — both deliverables are built, gated, and pushed to `claude/code-tutorial-glossary-jmqw6e` (3 commits; no PR opened, since you haven't asked for one).

## What shipped

**1. Code glossary — generated, not hand-written.** A new `mix brain.codemap` task compiles [`meta/code-map.md`](https://ob6to8.github.io/elixir-mind/meta/code-map.html) from every `lib/` module's `@moduledoc`/`@doc`/`@typedoc` via `Code.fetch_docs/1` (stdlib — zero deps, offline). It mirrors `ElixirMind.Registry`'s `render`/`write`/`check` shape, splits output into a library section and a mix-tasks section, and skips `@moduledoc false` internals as ExDoc would. `mix brain.codemap --check` is now the 6th CI gate (also in the Pages build and pre-commit), so the glossary **cannot drift** from the code. Backed by `ElixirMind.CodeMapTest`.

**2. Prose walkthrough — one spine tutorial.** [The tooling architecture — a grand tour](https://ob6to8.github.io/elixir-mind/meta/tutorials/the-tooling-architecture.html) places every module in the `parse → scan → generate → publish` pipeline plus the cross-cutting provenance layer and CLI, and links out to your existing nine narrow tutorials rather than restating them. I went with a single spine doc (your "defer to you on shape") — the subsystem detail already lives in the narrow tutorials, so a second grand-tour would have overlapped them. Also folded the new gate into the gate-suite tutorial (eight → nine) and marked the plan `done`.

All gates green: 160 tests, all three freshness `--check`s, verify, route_tags, and a 510-page site build. (One advisory warning — the plan's `attribution.from` back-link — is the stamp `/create-pull-request` adds at PR time.)

## On the model question, in hindsight

The split held up well: **Sonnet 5** ran the 5-way parallel read of `lib/` (~374k tokens, 5.5 min, extraction-to-schema — no judgment lost), and **Opus 4.8** did everything that had to be exactly right — the generator, the compile-metadata path fix for inline struct submodules, the tutorial prose, and the gate-suite renumbering. Spending Opus on the bulk read would have cost more for no quality gain; spending Sonnet on the synthesis/task would have risked the parts that are now load-bearing in CI.

Want me to open a PR? I can run `/create-pull-request` (which also captures this session as a thread doc, glossaries it, and stamps that `from` back-link), or `/create-pull-request merge` to drive it to green and true-merge.
