---
type: plan
title: "A thin Jido-based host that treats the brain as its world"
status: proposed
description: Build the owned automation host the runtime-evaluation analyses have been circling — a separate, modern-toolchain Elixir/OTP application (sibling to this repo, never inside it) where Jido supplies the chassis (supervised agent processes, durable cron, req_llm) and the genuinely novel work is the harness semantics that make a hosted agent behave like a contract-obeying session: a CLAUDE.md instruction loader, a SKILL.md progressive-disclosure skill loader, filesystem tools over a bundle checkout, the brain.* verbs as Actions, and a write-gatekeeper that only ever proposes PRs — with eve's host anatomy as the shape, activation still gated on the standing triggers, and the first workload the broken daily /research run.
provenance: "Claude Code session, 2026-07-17 — operator, following the vercel-eve comparison, directed creating a plan from the session's 'pragmatic shape: a thin, separate Jido-based host that treats the brain as its world' recommendation, cross-linked or folded into the overlapping recent work (BEAM/Jido analysis family, bundle/library separation plan, inkling swarm-eval harness plan)"
tags: [meta, plan, architecture, runtime, host, jido, beam, otp, eve, harness, agents, automation]
timestamp: 2026-07-17
attribution:
  when: 2026-07-17T20:00:00Z
  channel: agent-authored
  agent: "Claude Code agent, interactive session"
  why: "persists the operator-commissioned host-layer design surfaced by the eve comparison per the persist-plans policy, folding it into the standing tiered BEAM/Jido path rather than forking a parallel direction"
  from: [/meta/threads/2026-07-17-vercel-eve-comparison-and-jido-host-plan.md, /meta/analysis/vercel-eve-comparison.md]
---

# A thin Jido-based host that treats the brain as its world

**Decision record.** The *why* lives in the analyses this plan folds together:
the [vercel-eve comparison](/meta/analysis/vercel-eve-comparison.md) (2026-07-17)
supplies the host anatomy — instructions + skills + tools + channels + cron
over a durable runtime — and the insight that the harness semantics, not the
chassis, are the real work; the
[BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md)
(2026-07-12) supplies the tiered path, the adoption triggers, and the verified
Jido baseline; [managed minds, owned machinery](/meta/analysis/claude-managed-agents-vs-beam-jido.md)
supplies the two-plane division of labor and the write-gatekeeper;
the [caveats analysis](/meta/analysis/jido-distribution-gap-and-req-llm-cognition-dependency.md)
prices the single-node and `req_llm` concentrations; and
[Loomkin](/meta/analysis/loomkin-as-existence-proof.md) records the tier-2
buy/adopt alternative. This plan does not restate those findings; it commits a
concrete shape and build order against them.

## Problem

The brain's automation host is rented. Scheduled and unattended work runs on
Claude Code sessions, Routines, and CI — machinery this repo does not own or
supervise — and the one live operational failure, the
[daily /research Routine that never lands](/meta/issues/daily-news-routine-runs-not-landing.md),
is precisely a "no resident runtime we control" failure. The BEAM/Jido
evaluation mapped a tiered path toward an owned resident runtime but left its
design abstract ("a small resident daemon", "Jido agents on that daemon"). The
eve comparison made the design concrete: what an owned host minimally *is* has
now been named by a shipped system, and the part no one ships — making a hosted
agent behave like a **contract-obeying session** of this brain — is
well-bounded work.

## The standing verdict, updated — not overturned

The base evaluation's "not now" rested on three blockers. Building the host as
a **separate sibling application** dissolves two of them outright:

1. **Toolchain floor — dissolved.** A sibling app runs Elixir 1.17+/OTP 26+
   natively; this repo's 1.14 floor is untouched. Precedent already set by the
   [swarm-eval harness plan](/meta/plans/inkling-beam-swarm-eval-harness.md)
   ("a separate modern-toolchain Elixir/OTP application").
2. **Zero-dependency constraint — dissolved.** The constraint binds
   `elixir_mind` (the verifier core), not a consumer of it. The host depends
   on the brain's tooling and on the Jido tree; the core never depends on the
   host. This is the same boundary the
   [bundle/library separation plan](/meta/plans/separate-okf-bundle-and-elixir-mind-library.md)
   draws — the host is a third concern, downstream of the library.
3. **Duplicate agent runtime — remains, and remains the gate.** The host is a
   second harness beside Claude Code, with its own credentials, hosting, and
   ops. This is the real cost, so **activation stays gated on the standing
   triggers**: the /research Routine proving structurally unfixable inside
   Claude Code's machinery, or the dedup probe's tier-2 threshold demanding a
   resident index — plus Jido 2.x seasoning (the base evaluation asked for
   6–12 months past 2026-02; mid-2026 is inside that window). Until a trigger
   fires, this plan is a design record, not a work order.

## The shape

A thin OTP application — working name `brain_host` — in its own repository,
whose entire world is a git checkout of this bundle. Jido is the chassis;
the harness is the work.

**The chassis (adopted, not built).** Jido `AgentServer` supervision, durable
cron (2.1.0+), signals, persistence adapters, and `jido_ai`/`req_llm` for
model calls. Per the caveats analysis, single-node is accepted (no
distribution need at this scale) and `req_llm` concentration is a watched
risk, not a blocker. Whether phase 1 starts on plain OTP and adopts Jido at
the second autonomous loop (the base evaluation's tier 1→2 sequencing) is an
execution choice; the design below is Jido-shaped either way — capabilities as
schema-validated Actions, side effects as directives — so adoption is a
library swap, not a redesign.

**The harness (the novel work) — five components:**

1. **Instruction loader.** `CLAUDE.md` from the checkout is the hosted agent's
   system prompt — the compiled contract, not a hand-written copy of it. The
   host thereby inherits every ratified policy automatically on `git pull`,
   and the contract stays the single behavioral source across both harnesses.
2. **Skill loader.** `.claude/skills/*/SKILL.md` loaded by progressive
   disclosure: frontmatter descriptions advertised always, bodies on demand —
   eve's skills model, which this repo's skills already satisfy (the SKILL.md
   convention is cross-agent by design). No skill duplication: the checkout is
   the single source; the host never vendors copies.
3. **Bundle tools.** Read/search tools over the checkout, and each `brain.*`
   verb wrapped as an Action — one definition serving as supervised job,
   signal handler, and LLM-callable tool (the mapping §4 of the base
   evaluation records; the
   [AST/macros analysis](/meta/analysis/elixir-ast-macros-for-llm-harnesses.md)'s
   `defverb` sketch is the eventual zero-drift way to emit these from the
   library itself).
4. **Write-gatekeeper.** The host never pushes to `main`. All writes leave as
   session-style branches and PRs, opened with credentials only the
   gatekeeper process holds — credential custody exactly as the two-plane
   analysis prescribes, and the operator's editorial/ratification surface
   (PR review) is preserved unchanged. The hosted agent is subject to the
   contract like any other agent; nothing about hosting exempts it.
5. **Channels.** Cron first — the daily `/research` run end-to-end (fetch,
   match taxonomy, write `inbox/`, auto-intake featured items, branch, PR) is
   the first and justifying workload. HTTP/chat channels are explicitly
   deferred.

## Build order

- **Phase 0 — prerequisites (before any code).** A trigger from the gate above
  has fired; operator ratifies this plan and the host repo's creation (a new
  repo is a shape change); re-verify the Jido baseline against hex.pm at
  execution time (the 2026-07-12 baseline will be stale).
- **Phase 1 — the harness spine, one workload.** Checkout manager (clone,
  pull, branch), instruction + skill loaders, read-only bundle tools, one
  scheduled agent running `/research` per its SKILL.md, gatekeeper opening the
  PR. Success: a morning PR with a digest and intaken items, produced with no
  Claude Code session involved, passing all CI gates unmodified.
- **Phase 2 — verbs as Actions.** Wrap the `brain.*` suite; the hosted agent
  gains verify/route-tags/registry as tools; failed gates loop back into the
  agent's turn instead of failing in CI.
- **Phase 3 — second loop, Jido proper.** When a second autonomous loop lands
  (intake triage, verification sweeps, or the dedup index home), consolidate
  on Jido supervision/signals per tier 2 — re-checking Loomkin as the
  buy/adopt alternative at that point.

## Deferred

- The **mechanical plane** (staleness cascades, resident dedup/embedding
  index, signal-driven incremental verification) — designed for in the
  two-plane analysis, activated by its own triggers.
- **MCP exposure** of the `brain.*` verbs so *any* agent session calls them
  without shelling out (tier-1 option in the base evaluation).
- **Chat channels** (Slack/HTTP intake), **sensors** (RSS/arXiv push), and
  any multi-node story.

## Open questions for ratification

1. **Alternative host.** The two-plane analysis found the /research workload
   also has a *managed* structural fix (a CMA scheduled deployment). Owned
   host vs. managed deployment is an operator judgment about sovereignty and
   ops appetite; this plan records the owned shape, not a verdict against the
   managed one.
2. **Cognition policy.** Which models the host's `req_llm` calls use, and
   whether deliberative steps (distillation, filing judgment) stay delegated
   to Claude-class models per the two-plane division.
3. **Repo naming and placement** of `brain_host`, and whether it should
   instead live as a directory in the future spun-out library repo.
