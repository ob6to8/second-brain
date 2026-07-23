---
id: em:8d9b89
type: reference
title: "Guarding Against AI Drift (Mike Zornek)"
description: A solo-developer's playbook for holding code quality steady under AI-assisted development — a layer of automated Elixir guardrails that catch the mechanical, backed by deliberately non-delegated human review that catches the rest.
resource: https://mikezornek.com/posts/2026/7/guarding-against-ai-drift/
provenance: "Mike Zornek, mikezornek.com, 2026-07-22"
tags: [agentic-coding, code-quality, guardrails, drift, elixir, ci, static-analysis, review]
timestamp: 2026-07-23T00:00:00Z
attribution:
  when: 2026-07-23T00:00:00Z
  channel: intake
  agent: "operator via /intake, Claude Code session"
  why: "operator asked to intake the article and examine it for aspects this repo could absorb"
---

# Guarding Against AI Drift (Mike Zornek)

## The concept: AI drift

**AI drift** is the cumulative degradation of code quality that sets in when an
agent generates a large share of a project's code. The failure is not any single
bad change — it is *systemic*: an AI reaches for whatever pattern it has already
seen, so, left unchecked, it treats yesterday's merely-acceptable, low-quality
addition as the standard to copy tomorrow. Each such copy becomes precedent, and
the project silently diverges from its author's values. Zornek's framing of the
countermeasure: *"Review is me wrangling the code back toward the framing I want
before it hardens into the precedent I'm stuck with."*

This is the code-authorship analogue of the corpus-health failure this brain
already names — [invisible degradation](/beliefs/glossary/invisible-degradation.md)
(rot that emits no signal until retrieval visibly fails) — and the answer is the
same shape: convert as much of the standard as possible into *announcement*
mechanisms (gates that fail, checks that report), so a violation surfaces at the
moment it is introduced rather than after it has compounded.

## The remedy has two layers

Zornek is explicit that the two layers do different jobs and neither substitutes
for the other: *"The automation catches what's mechanical and repeatable. The
judgment is still on me."*

### Layer 1 — automated guardrails (the mechanical, made structural)

A catalogue of checks wired into the toolchain / CI so that drift on any
mechanical dimension turns a build red rather than merging quietly. Grouped by
what they guard (Elixir/Phoenix ecosystem):

| Category | Guardrails |
|----------|------------|
| **Compilation & formatting** | `mix compile --warnings-as-errors` (warnings non-negotiable); `mix format --check-formatted`; `mix deps.unlock --check-unused` (no orphaned deps); `mix xref graph --label compile-connected` (stop compile-time coupling creep) |
| **Linting & static analysis** | **Credo** with extended checks — plus Jump's test-quality checks (vacuous tests, missing assertions), Oeditus' concurrency rules (unmanaged tasks, blocking ops), and custom checks for common AI tells (e.g. `case` on a boolean); **Dialyzer** for type inference/consistency; **Boundary** for context-level privacy beyond module scoping |
| **Security** | **Sobelow** (Phoenix security scan); **mix_audit** + **hex.audit** (dependency-vulnerability detection) |
| **Documentation** | `mix docs --warnings-as-errors` (a broken doc link fails the build) |
| **Testing** | test warnings treated as build failures; **phoenix_test** for readable feature tests; coverage tracked locally, **not** CI-gated |
| **Workflow hygiene** | **actionlint** (validates GitHub Actions workflows); semantic PR titles (Conventional Commits); **Dependabot** (monthly grouped updates); **usage_rules** (surfaces library guidance to AI agents) |

**Intentional gaps** are part of the design, not oversights: no CI-gated code
coverage, no visual-regression testing, no Rust guardrails — each a deliberate
trade of signal value against maintenance burden. A guardrail earns its place
only when its signal beats its upkeep cost.

### Layer 2 — layered human review (the judgment, deliberately not delegated)

Automation is the floor, not the ceiling. Zornek's per-change review passes stack
multiple independent readers:

1. A local Claude code-review skill.
2. Copilot's PR review.
3. His own reading and critique.
4. Back to Claude for refinement.

The point of stacking passes is that automated checks *prevent drift*, but only
intentional human oversight *prevents degradation into mediocrity* — the class of
problem no linter has an oracle for.

## The feedback loop: misses update the standard, not just the PR

The most transferable practice: when review keeps catching the *same* AI miss,
the fix does not stop at the individual PR. The recurring miss is promoted into
the **standing standards documents** the agent reads — `AGENTS.md`,
`CODING_STANDARDS.md` — so the next generation starts from the corrected framing.
Standards evolve through feedback; a miss that only ever gets fixed in-line is a
miss you will re-fix forever.

## Relevance to this bundle

This repository is itself an Elixir project whose entire governance philosophy is
the article's thesis, arrived at independently: convert discipline into structure
so drift announces itself. See
[the gate suite](/meta/tutorials/the-gate-suite-and-where-it-runs.md) — the
bundle already runs `mix compile --warnings-as-errors`, `mix format
--check-formatted`, and `mix test` as build gates, and adds its own
domain-specific validators on top. The article's "recurring miss → update the
standards doc" loop is this brain's compiled-contract move: rules live in
`meta/policy/*.md`, compile into `CLAUDE.md`, and a freshness gate keeps the
agent-read contract from drifting out of sync with them. The overlap is close
enough that most of the article's *specific* Elixir tooling is either already
present or deliberately declined here (this repo runs
[dependency-free and offline](/meta/tutorials/the-tooling-architecture.md), so
dep-based scanners like Credo/Dialyzer/Sobelow are a design tension, not a drop-in).

Related bundle concepts:
[drift class](/beliefs/glossary/drift-class.md) (a category of staleness sharing
one detector),
[invisible degradation](/beliefs/glossary/invisible-degradation.md),
[probabilistic enforcement](/beliefs/glossary/probabilistic-enforcement.md), and
[Goodhart's law](/beliefs/glossary/goodharts-law.md) (the ever-present risk when
guardrails become targets).

# Citations

- Mike Zornek, "Guarding Against AI Drift: Automated Elixir Quality Checks",
  mikezornek.com, 2026-07-22.
  <https://mikezornek.com/posts/2026/7/guarding-against-ai-drift/>

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:8d9b89">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-23-ai-drift-intake-and-coding-standards-ratification (2026-07-23)

3 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:8d9b89`]**  (co-feeds: `em:1ec778`)

The full standards file is now captured. Notably, `local_cents` is Zornek's own repo — so this `CODING_STANDARDS.md` is literally the "standards doc the agent reads" that the AI-drift article's feedback loop feeds into. The two intakes are directly connected.

---

**[`em:8d9b89`]**

- **[Guarding Against AI Drift (Mike Zornek)](https://github.com/ob6to8/elixir-mind/blob/claude/ai-drift-article-review-l04pr2/knowledge/SWE/agentic/code-quality/guarding-against-ai-drift.md)** (`em:8d9b89`) — the AI-drift concept + the two-layer remedy (automated guardrails / non-delegated layered review) + the misses-update-the-standards-doc loop.

---

**[`em:8d9b89`]**

**From the AI-drift article — mostly already covered or in tension:**
- Already running: `mix compile --warnings-as-errors`, `mix format --check-formatted`, `mix test`, plus the brain-specific validators.
- Design tension, not a drop-in: Credo/Dialyzer/Sobelow/mix_audit are dependency-based scanners; this repo is deliberately **dependency-free and offline**, and it has no Phoenix/deps to scan. Adopting them would break that stance for little signal.
- **Genuinely worth considering** (all operator-ratifiable, none autonomous): `actionlint` on `.github/workflows/ci.yml`; test-warnings-as-errors (`mix test --warnings-as-errors`); `mix xref graph --label compile-connected` as a coupling check on `lib/`. `mix docs --warnings-as-errors`, coverage, Dependabot, usage_rules don't apply (no ExDoc, no deps).
