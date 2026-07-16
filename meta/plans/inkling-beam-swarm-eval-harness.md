---
type: plan
title: "Swarm-eval harness: an Inkling-backed OTP application for measuring agent-swarm dynamics and failure modes"
description: Build the eval harness the inkling-beam-swarm-eval-substrate analysis mapped — a separate modern-toolchain Elixir/OTP application driving deterministic self-hosted Inkling-Small inference through fault-scheduled swarm rollouts over the corpus-maintenance task domain — executed strictly rung by rung on the M0–M5 ladder, each rung falsifiable before the next is funded, with M0 (the determinism canary) as the only initially committed step.
status: proposed
provenance: "Claude Code session (Claude Fable), 2026-07-16 — operator directed graduating the harness from the inkling-beam-swarm-eval-substrate analysis's paused strand into a plan, linked to that analysis"
tags: [meta, plan, evals, agents, swarm, failure-modes, beam, otp, inkling, tinker, lora, determinism, harness]
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T12:45:00Z
  channel: agent-authored
  agent: "Claude Code agent, operator-directed plan graduation"
  why: "the swarm-eval harness was a paused routing-ledger strand ('graduate into a plan?') on the spike thread; the operator resolved it by commissioning this plan"
  from: [/meta/threads/2026-07-16-inkling-beam-swarm-eval-spike.md, /meta/analysis/inkling-beam-swarm-eval-substrate.md, /meta/threads/2026-07-16-graduate-swarm-eval-harness-plan.md]
---

# Swarm-eval harness: an Inkling-backed OTP application for measuring agent-swarm dynamics and failure modes

**Decision record.** All of the *why* lives in the
[inkling-beam-swarm-eval-substrate analysis](/meta/analysis/inkling-beam-swarm-eval-substrate.md)
(2026-07-16): the four model-side properties Inkling supplies (pinned
policy-under-test, batch-invariance reproducibility, LoRA population
construction, Tinker eval→train loop closure), the harness-side properties the
BEAM supplies (process-per-agent topology, native fault injection, supervision
as scaffold and subject, full-trace capture), the four-layer stack (§6), the
fine-tuning path (§7), the campaign anatomy (§8), and the risk register (§9).
This plan does not restate those findings; it commits a build order against
them. Where this plan and the analysis diverge, the plan is the current
intent and the analysis stays frozen as the judgment that motivated it.

## Problem

Agent-swarm failure modes — coordination collapse, error cascades, groupthink,
stale-belief propagation, Byzantine members, recovery pathologies — are today
anecdotes: emergent, non-reproducible, and unmeasured. The analysis found a
substrate on which they become replayable, ablatable experiments, and this
brain already owns a ground-truth task domain (the
[corpus-maintenance eval space](/meta/analysis/eval-suitability-of-the-corpus-maintenance-failure-space.md))
for the swarm to work against — including the concurrent-writers governance
question the
[dark-factory analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
named as the binding constraint. What's missing is the instrument.

## Shape of the artifact

Per analysis §6, held as constraints rather than re-argued:

- A **separate Elixir/OTP application** on a modern toolchain (Elixir
  1.17+/OTP 26+), free to take dependencies. The brain's zero-dependency
  verifier core is untouched; the harness may depend on the core's conventions,
  never the reverse (the layering rule of the
  [BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md)).
- **Model layer:** SGLang (or vLLM) in deterministic mode serving
  **Inkling-Small** with multi-LoRA hot-swap, self-hosted or single-tenant
  (Modal/Baseten class); full Inkling only as a rented spot-check tier.
  Determinism is asserted per run by a canary, never assumed.
- **Harness components:** campaign runner (bounded-concurrency rollout fan-out),
  topology supervisor, agent GenServers, fault-injecting router, append-only
  trace store, scorers as pure functions. HTTP via Req/Finch — no LLM-framework
  dependency; Jido optional and not assumed.
- **Training boundary:** Tinker (Python) exchanges JSONL trajectories/rewards
  outbound and PEFT adapters inbound — two file formats, no shared runtime.
- **Task domain:** synthesized corpora with injected defects, reusing the
  dedup-probe gold-set conventions
  ([dedup recall probe](/meta/plans/dedup-recall-probe.md), done) as the seed
  oracle family.

## Build order — the M0–M5 ladder

Each rung is falsifiable and gates the next; **only M0 is committed by this
plan's acceptance**. Later rungs are re-scoped (or the plan is closed) on each
rung's report.

1. **M0 — determinism canary.** Deploy Inkling-Small behind SGLang
   deterministic mode; run the same prompt k times per configuration and
   byte-compare; document the deployment recipe and the configurations under
   which bitwise replay holds. *Kill condition: if reproducibility cannot be
   demonstrated on attainable infrastructure, the thesis fails here, cheaply.*
2. **M1 — single-agent baseline.** One prompted stock agent against the
   corpus-maintenance tasks; calibrate against the existing single-writer
   probe numbers.
3. **M2 — concurrent writers, no faults.** First swarm-dynamics data:
   conflict rate, redundant-work ratio, agreement decay at n = 2..k.
4. **M3 — fault injection.** Scheduled kills, delays, partitions; the
   failure-mode catalog proper, each failure trace replayable.
5. **M4 — population and effort sweeps.** LoRA variants enter (first
   fine-tuning spend); heterogeneity and thinking-effort as axes.
6. **M5 — RL loop closure.** Train an adapter against a measured failure mode
   via Tinker; re-measure.

M0–M2 require no fine-tuning and no Tinker account — prompted stock
Inkling-Small suffices.

## Scope boundaries

- **Not a brain runtime.** The harness is an experiment instrument, not a
  resident service for this bundle; the standing BEAM/Jido "not now" for the
  brain's own workloads is unchanged.
- **Not this repo.** The harness is its own codebase (location: open question
  2); only its *governance* — this plan, findings filed as analyses, issues —
  lives here.
- **No frontier-swarm claims.** Findings are dynamics-level; capability-level
  transfer to frontier-model swarms is out of scope beyond spot-check
  calibration (analysis §9).

## Open questions (resolve by rung, not up front)

1. **M0 infrastructure**: rented GPU node vs. Modal-class dedicated
   deployment — decided by whichever can demonstrate the determinism recipe
   cheapest; needs a small budget ceiling from the operator before M0 runs.
2. **Where the harness code lives**: a new repository (cleanest, matches
   "not this repo") vs. an `apps/`-style directory here (closer to the
   governance). Default intent: new repo, ratified at M1 when code volume
   starts to matter.
3. **Oracle portability**: whether the dedup-probe gold-set format lifts
   directly into the harness's manifest format, or needs a translation layer
   (decide at M1).
4. **Benchmark re-verification**: Inkling's vendor-reported figures were one
   day old at analysis time; re-check third-party replications before M4
   commits fine-tuning spend.

## Deferred

Everything past M0 is deferred by construction (the ladder *is* the deferral
structure). Additionally deferred until a rung makes them live: campaign
manifest schema, trace-store format, dynamics-metric definitions (M2), and the
fault-schedule DSL (M3) — each specified in the rung that first needs it, not
speculatively here.
