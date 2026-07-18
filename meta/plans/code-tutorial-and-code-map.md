---
type: plan
title: "Code tutorial and generated code-map: a prose architecture tour plus a compiled function/struct glossary"
description: Document the elixir_mind tooling with two coupled artifacts — a hand-written architecture-spine tutorial (with subsystem tours) under meta/tutorials/, and a single generated meta/code-map.md compiled from the source docstrings by a new zero-dep `mix brain.codemap` task, CI-gated with `--check` exactly like CLAUDE.md and registry.md.
status: done
provenance: "Claude Code session, 2026-07-16 — operator request for a code tutorial (prose walkthrough of services/functions/architecture) plus a code glossary of function and data-structure intent; agent surveyed lib/ (27 files, ~6k LOC, 30/30 @moduledoc, 85 @doc, deps: []) and recommended the compiled-artifact model; operator ratified (persist plan, single generated code-map, agent's discretion on tutorial shape)."
tags: [meta, plan, tooling, documentation, tutorial, code-map, codegen]
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T10:11:10Z
  channel: agent-authored
  agent: "Claude Code agent, code-tutorial-glossary session"
  why: "operator ratified persisting the code-tutorial + generated-code-map design as a plan before executing the fan-out"
  from: [/meta/threads/2026-07-16-code-tutorial-and-generated-code-map.md]
---

# Plan — code tutorial and generated code-map

**Status:** `done`. Operator ratified the shape (2026-07-16): a hand-written
prose tour plus a *single generated* code glossary, with tutorial count left to
agent discretion. Built in the same session: `mix brain.codemap` +
[`meta/code-map.md`](/meta/code-map.md) (gated in CI/pre-commit) and the
[tooling-architecture tutorial](/meta/tutorials/the-tooling-architecture.md)
(one spine doc linking the existing narrow tutorials), with the gate-suite
tutorial updated for the new freshness gate.

## Problem

The `elixir_mind` tooling (`lib/`, `test/`, the `mix brain.*` tasks) has no
top-down documentation. Two gaps:

1. **No architecture spine.** There are nine `meta/tutorials/` docs, but each is
   a narrow slice ("the gate suite", "the three scanners", "the session-init
   digest"). Nothing gives the grand tour — the layers and how a document flows
   from parse → scan → generate → publish — or ties the slices together.
2. **No code glossary.** There is no function/data-structure intent reference.
   The intent is *half-captured already*: 30/30 modules carry `@moduledoc` and
   there are 85 `@doc` blocks, but only 4 `@type`/`@typedoc` across ~6k LOC, and
   nothing surfaces any of it as a browsable reference.

The code is **not part of the OKF bundle** (the site excludes `lib/`, `test/`)
and is **zero-dependency by doctrine** (`deps: []`; see
[why-the-toolchain-runs-offline](/meta/tutorials/why-the-toolchain-runs-offline.md)).
Any solution must respect both.

## The decisions

**Prose is authored; the glossary is compiled. They meet at the docstrings.**

### 1. Prose walkthrough → `type: tutorial` under `meta/tutorials/`

The established home and voice. Deliverable: an **architecture-spine** tutorial
giving the grand tour —

```
frontmatter/markdown parsing  →  the three scanners (Registry/Verifier/RouteTags)
   →  generators (Contract, Registry, Site, RouteTags materialize)
   →  the mix brain.* CLI surface
   →  cross-cutting: Attribution / Lineage / DevHistory
```

— and linking out to the existing narrow tutorials rather than restating them.
Whether it ships as one spine doc or a spine + one or two subsystem tours is left
to agent discretion at write time (operator deferred). Hand-written, lives in the
bundle, renders to Pages. **No new namespace, no ratification** (filing into an
existing directory).

### 2. Code glossary → a *generated artifact*, single file `meta/code-map.md`

Mirrors how `CLAUDE.md` and `meta/registry.md` already work: a compiled,
zero-dep, CI-`--check`-gated artifact. A new **`mix brain.codemap`** task extracts
module / function / `@type` docs via `Code.fetch_docs/1` (stdlib — no dep, stays
offline) and renders a single `meta/code-map.md`: one section per module with its
`@moduledoc` intent, its public functions with `@doc` summaries, and its declared
types. Checked in CI with `--check` so it **cannot drift**.

Rejected alternatives:
- **ExDoc** — idiomatic elsewhere, but breaks `deps: []` and stands up a second
  doc site beside Pages. Doctrine violation, not a free choice.
- **Hand-written prose code-map** — drifts from code with no mechanical oracle
  (the route-tag-coverage weakness). Avoided.

The real *content* work this exposes: enriching the source `@moduledoc` /
`@doc` / `@typedoc` intent (esp. the thin type coverage) so the compiled map is
worth reading. That editing is where agent judgment goes; the map falls out
mechanically.

## Build order

1. **Fan-out read** (Sonnet readers) — one structured summary per subsystem:
   role, key functions, data shapes, intent, and any thin/missing docstrings.
2. **`mix brain.codemap`** (Opus) — the extractor + renderer + `--check` mode +
   test, matching existing `mix brain.*` + `Contract`/`Registry` conventions;
   wire `--check` into the CI gate suite alongside contract/registry.
3. **Docstring enrichment** (Opus) — fill the gaps the readers flagged so the
   generated map reads well.
4. **Architecture-spine tutorial(s)** (Opus synthesis) — written from the
   readers' output; update `meta/tutorials/index.md`.
5. **Generate + commit `meta/code-map.md`**; add its home to the tree
   (`meta/index.md` / relevant index) and confirm the gate suite is green.

## Model split

Opus 4.8 drives, writes, and codes (synthesis and the task are high-judgment and
must be offline-exact); Sonnet 5 runs the parallel per-module readers
(extraction-to-schema, no quality loss because Opus writes the prose from their
output).

## Scope boundaries

- Single generated `meta/code-map.md` — **not** a per-module `meta/code-map/`
  directory (that would be a new namespace needing ratification; explicitly out).
- Documents the code; does **not** refactor it (beyond additive docstring
  enrichment).
- No new runtime dependency — `Code.fetch_docs/1` and the standard library only.
