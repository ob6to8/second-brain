---
type: reference
title: 2026-07-16-inkling-beam-swarm-eval-spike
description: An operator-commissioned research spike on pairing Thinking Machines' day-old open-weights Inkling model with Elixir/BEAM as an eval substrate for agent-swarm dynamics and failure modes — filed as the inkling-beam-swarm-eval-substrate analysis, then expanded on request with the four-layer implementation stack, the Tinker fine-tuning path, and the campaign anatomy with an M0–M5 build order.
provenance: "Claude Code session (Claude Fable), 2026-07-16; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, evals, agents, swarm, failure-modes, beam, otp, inkling, thinking-machines, tinker, lora, determinism]
timestamp: 2026-07-16
session: https://claude.ai/code/session_01HPyhA5S6pA3cra7nHhxnB7
pr: 104
---

# 2026-07-16-inkling-beam-swarm-eval-spike

## Where this landed

The operator commissioned a research spike: what advantages might Thinking
Machines' just-released Inkling model offer, paired with Elixir/BEAM, for
running evals on agent-swarm dynamics and failure modes? The spike established
that Inkling is an Apache-2.0 open-weights MoE (975B total / 41B active,
released 2026-07-15) fine-tunable on Tinker and self-hostable on
vLLM/SGLang, and found the pairing unusually complementary: Inkling supplies
the model-side properties swarm evals need (pinned policy-under-test,
reproducible rollouts via the batch-invariance lineage, LoRA-built agent
populations, a Tinker RL eval→train loop) while the BEAM supplies the
harness side (process-per-agent topology, native failure injection,
supervision as scaffold and subject, full-trace capture). The findings were
filed as
[inkling-beam-swarm-eval-substrate](/meta/analysis/inkling-beam-swarm-eval-substrate.md)
— explicitly a decision record, not a project start; the standing BEAM/Jido
"not now" is unchanged. On the operator's follow-up, the analysis was expanded
with three implementation sections: the four-layer stack (Tinker training /
OTP harness / deterministic inference / synthesized-corpus data), the
fine-tuning path (PEFT role adapters at ~$20–25 a variant, RL against the
harness's own oracles, prompting before adapters), and the eval-campaign
anatomy (manifest → determinism gate → fault-scheduled rollouts → two-layer
scoring → bitwise replay) with an M0–M5 build order whose first three rungs
need no fine-tuning. Both passes committed and pushed on the session branch.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Inkling × Elixir/BEAM as a swarm-eval substrate: advantages, synergies, risks | closed | [inkling-beam-swarm-eval-substrate](/meta/analysis/inkling-beam-swarm-eval-substrate.md) | - |
| Implementation detail: stack, fine-tuning path, eval-run anatomy (M0–M5) | closed | [inkling-beam-swarm-eval-substrate](/meta/analysis/inkling-beam-swarm-eval-substrate.md) | - |
| Commissioning a swarm-eval harness as actual work | paused | `unrouted` | Does the operator want to graduate the harness into a `type: plan` (M0 determinism canary as the first funded step)? |

## User

Do a research spike into what advantages using https://thinkingmachines.ai/news/introducing-inkling/ in conjunction with elixir/beam in order to run evals on agent swarm dynamics and failure modes might look like

## Assistant

Inkling turns out to be Thinking Machines Lab's open-weights MoE model (975B total / 41B active, released yesterday, 2026-07-15) — available on Tinker for fine-tuning and self-hostable via vLLM/SGLang. That framing matters a lot for the spike. Let me pull the model card and Tinker details, and check what the brain already holds on Thinking Machines, swarms, and evals.

The spike is done and filed. The analysis is committed and pushed to `claude/inkling-elixir-swarm-evals-22p0uh` as [meta/analysis/inkling-beam-swarm-eval-substrate.md](https://github.com/ob6to8/elixir-mind/blob/claude/inkling-elixir-swarm-evals-22p0uh/meta/analysis/inkling-beam-swarm-eval-substrate.md) (it will render at `https://ob6to8.github.io/elixir-mind/meta/analysis/inkling-beam-swarm-eval-substrate.html` once merged), with `meta/analysis/index.md` updated. All verifiers pass. Here's the TLDR.

**First, what Inkling actually is** — this matters because the name suggests a product, but it's a model: Thinking Machines Lab's first open-weights release (July 15, 2026 — yesterday). A 975B-total/41B-active Mixture-of-Experts transformer, Apache 2.0, multimodal in / text out, 1M context, with a controllable thinking-effort knob and strong self-reported agentic scores (77.6% SWEBench Verified). It runs on vLLM/SGLang/llama.cpp, is hosted by Together/Fireworks/Modal/etc., and is fine-tunable via their Tinker LoRA API.

**The verdict: unusually complementary, because each side covers a different layer of what a swarm eval needs.**

Inkling supplies four model-side properties a closed API structurally can't:

1. **A pinned policy-under-test.** Open weights mean the model under measurement can never be silently updated or deprecated — longitudinal swarm evals stay comparable across years, keyed on `(weights hash, adapter hash, seed)`.
2. **Reproducible rollouts — the deepest synergy.** Thinking Machines' own batch-invariant-kernels research (their famous "Defeating Nondeterminism" work) plus SGLang's deterministic mode make bitwise-identical inference attainable on a self-hosted stack. Swarm failure modes are emergent and normally unreproducible; with deterministic inference and logged seeds/message order, an entire swarm failure trace becomes replayable and single-variable ablatable.
3. **Cheap population construction.** LoRA adapters on Tinker give you a *population* of heterogeneous swarm members from one frozen base — including deliberately flawed or poisoned members for Byzantine-robustness evals, which no closed API will sell you. Thinking effort doubles as a per-role cost knob and an eval axis (sweep effort vs. coordination collapse).
4. **A closed eval→train loop.** Tinker's RL primitives (with SkyRL's multi-agent precedent) mean the harness that measures a failure mode can train against it — and the determinism from (2) is what keeps that loop on-policy.

The BEAM supplies the harness side: one process per agent so the swarm topology *is* the process topology; failure injection as a native primitive (`Process.exit`, `:sys.suspend`, message-dropping proxies, node disconnects) rather than mocks; supervision trees as both scaffold for unattended thousand-rollout campaigns and *subject* (eval the recovery strategy itself); and per-message trace capture for scoring and replay. Since vLLM/SGLang speak OpenAI-compatible HTTP, the harness needs only a plain HTTP client — sidestepping the req_llm dependency concern from the earlier Jido caveats analysis.

**Two brain-specific findings.** The corpus-maintenance eval domain you already established (constructible ground truth, injected defects) gives a swarm a ready workload — run those tasks against concurrent writers and you get an empirical probe of exactly the "epistemic governance under concurrent autonomous writers" problem the dark-factory analysis named as the binding constraint. And Inkling removes the one economic objection (rented frontier sessions at swarm scale) that made an owned deliberative plane implausible — the first concrete workload where the tier-2 resident-BEAM path gains an owned model layer. This does **not** reverse the standing "not now": a harness would be a separate modern-toolchain app, and the analysis is a decision record, not a project start.

**Main caveats:** dynamics-level findings transfer to frontier-model swarms better than capability-level ones (Inkling isn't frontier-class); bitwise determinism only holds on inference you control, not generic hosted endpoints; full-model self-hosting needs 600GB–2TB VRAM (Inkling-Small at 12B active is the realistic owned-hardware member); and all benchmark figures are one-day-old vendor claims.

Sources: [Introducing Inkling](https://thinkingmachines.ai/news/introducing-inkling/), [Inkling model card](https://thinkingmachines.ai/model-card/inkling/), [Inkling product page](https://thinkingmachines.ai/inkling/), [Tinker](https://thinkingmachines.ai/tinker/), [Defeating Nondeterminism in LLM Inference](https://thinkingmachines.ai/blog/defeating-nondeterminism-in-llm-inference/), [SGLang deterministic inference](https://www.lmsys.org/blog/2025-09-22-sglang-deterministic/), [TechCrunch launch coverage](https://techcrunch.com/2026/07/15/thinking-machines-amps-up-its-bet-against-one-size-fits-all-ai-with-its-first-open-model-inkling/), [Hugging Face: Welcome Inkling](https://huggingface.co/blog/thinkingmachines-inkling).

If you want this to go further, natural next steps are a `/create-pull-request` to land it, or graduating the harness idea into a `type: plan` with a scoped first experiment (e.g. concurrent-writer dedup under injected agent death).

## User

Save this as an analysis. Include what the stack to implement would look like. Detail what it would take to fine tune, and what running evals would look like

## Assistant

Done — the analysis now carries the full implementation detail, committed and pushed to `claude/inkling-elixir-swarm-evals-22p0uh` ([meta/analysis/inkling-beam-swarm-eval-substrate.md](https://github.com/ob6to8/elixir-mind/blob/claude/inkling-elixir-swarm-evals-22p0uh/meta/analysis/inkling-beam-swarm-eval-substrate.md), rendering at `https://ob6to8.github.io/elixir-mind/meta/analysis/inkling-beam-swarm-eval-substrate.html` once merged). All verifiers pass; the only advisory is the expected missing `attribution.from`, which `/create-pull-request` stamps when the session is captured. Here's what the three new sections say:

**The stack (§6)** is four layers with one deliberate language boundary. Training lives in Python on the Tinker SDK; orchestration lives in Elixir/OTP as a separate modern-toolchain app (the brain's zero-dep verifier core is untouched). They meet through two file formats, not a shared runtime: the harness exports trajectories and rewards as JSONL, and training returns LoRA adapters as artifacts. Below the harness sits one SGLang or vLLM deployment in deterministic mode serving Inkling-Small with multi-LoRA hot-swapping — the whole agent population shares one base model in VRAM, and each request picks its member by adapter name. The harness itself is plain OTP: a campaign runner with bounded concurrency as backpressure to the GPUs, a topology supervisor that builds the swarm graph as a supervision tree, one GenServer per agent, a router process every message traverses (the seam where faults get injected), an append-only trace store, and scorers as pure functions. HTTP is Req/Finch — no LLM framework, sidestepping the req_llm concern from the Jido caveats analysis.

**Fine-tuning (§7)** turns out to be the cheap part. The Tinker workflow is a `TrainingClient` + `LoraConfig` (default rank 32), a `forward_backward`/`optim_step` loop, then export as a standard PEFT adapter that vLLM/SGLang hot-swap. An SFT role variant (a critic, an overconfident member, a Byzantine member) on ~2k examples costs roughly **$20–25 in training tokens at launch pricing** — a dozen controlled population variants is lunch money. The RL path closes the loop: the eval oracles double as reward functions, and the cookbook's multi-agent RL loops (SkyRL precedent) train adapters against measured failure modes — this is where deterministic inference stops being nice-to-have and becomes load-bearing, since on-policy RL needs sampler and trainer to agree. The section's discipline rule: variants start as system prompts; adapters are minted only when a prompted variant can't hold its assigned flaw stably.

**Running evals (§8)** is a six-step campaign anatomy: a versioned declarative manifest (task, topology, population, effort levels, fault schedule, seed block) → a **determinism gate** (same prompt k times, byte-compared; the campaign refuses to start if outputs diverge) → fault-scheduled rollouts with every message and seed traced → two metric layers (task metrics from the brain's existing constructible-ground-truth oracles, dynamics metrics like cascade depth and time-to-consensus computed from the message graph) → **bitwise replay and single-variable ablation**, which is the actual product — the thing no closed-API swarm setup can offer → a report keyed on the full reproducibility tuple. Cost envelope: a 10-agent × 20-turn rollout is a few dollars hosted, so a 1,000-rollout campaign lands in the low thousands of dollars, with self-hosted Inkling-Small the cheaper steady state that also carries the determinism guarantee. The build order is M0–M5, each rung falsifiable before the next is funded — and M0 through M2 (determinism canary, single-agent baseline, concurrent writers) need no fine-tuning at all, so the thesis proves or fails cheaply on stock Inkling-Small.

Sources added to the doc: [Tinker docs](https://tinker-docs.thinkingmachines.ai/) ([weights management](https://tinker-docs.thinkingmachines.ai/tutorials/core-concepts/weights/), [LoRA adapter deployment](https://tinker-docs.thinkingmachines.ai/tutorials/deployment/lora-adapter/), [HF export](https://tinker-docs.thinkingmachines.ai/tutorials/deployment/export-hf/)), the [tinker-cookbook](https://github.com/thinking-machines-lab/tinker-cookbook), and a [third-party pricing summary](https://www.beam.cloud/blog/tinker-model-pricing) ($1.87/M prefill, $4.68/M sampling, $5.61/M training at the launch discount).

When you're ready to land it, `/create-pull-request` will capture the session, stamp the thread into `attribution.from`, and open the PR.
