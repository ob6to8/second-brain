---
type: analysis
title: "Research spike: Inkling + Elixir/BEAM as an eval substrate for agent-swarm dynamics and failure modes"
description: Finds the pairing unusually complementary — Inkling (Thinking Machines' Apache-2.0 open-weights MoE, released 2026-07-15) supplies the four model-side properties swarm evals need (a pinned policy-under-test, reproducible rollouts via the batch-invariance lineage, cheap LoRA-built agent populations with a thinking-effort knob, and a Tinker RL loop that closes eval→train), while the BEAM supplies the harness-side ones (process-per-agent topology, native failure injection, supervision-as-subject, full-trace capture); locates the work as a separate tier-2-shaped app that finally gives the resident-BEAM path an owned model layer, without reversing the brain's own "not now."
provenance: "Claude Code session (Claude Fable), 2026-07-16 — operator commissioned a research spike on using Inkling with Elixir/BEAM to run evals on agent swarm dynamics and failure modes; Inkling facts fetched same day from thinkingmachines.ai (announcement, product page, model card) and web coverage"
tags: [meta, analysis, evals, agents, multi-agent, swarm, failure-modes, beam, otp, elixir, inkling, thinking-machines, tinker, open-weights, determinism, reproducibility, lora, rl]
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T00:00:00Z
  channel: agent-authored
  agent: "Claude Code agent, operator-commissioned research spike"
  why: "operator asked what advantages Inkling in conjunction with Elixir/BEAM might offer for running evals on agent swarm dynamics and failure modes; the spike's findings and their sources are persisted so the judgment survives the session"
---

# Research spike: Inkling + Elixir/BEAM as an eval substrate for agent-swarm dynamics and failure modes

**Question.** Thinking Machines Lab released
[Inkling](https://thinkingmachines.ai/news/introducing-inkling/) on 2026-07-15.
What advantages might using Inkling in conjunction with Elixir/BEAM offer for
running **evals on agent-swarm dynamics and failure modes** — the emergent,
multi-agent layer (coordination, cascades, contention) rather than single-agent
task success?

**Bottom line.** The pairing is unusually complementary, because each side
supplies exactly what the other layer of a swarm eval needs. Inkling contributes
four model-side properties closed APIs structurally cannot: a **pinned
policy-under-test** (Apache-2.0 open weights — the model can never be silently
updated or deprecated under a longitudinal eval), **reproducible rollouts**
(Thinking Machines' batch-invariance work makes bitwise-deterministic inference
attainable on a self-hosted stack, turning emergent swarm failures from
anecdotes into replayable traces), **cheap population construction** (LoRA
adapters on Tinker yield heterogeneous swarm members from one base model, with
controllable thinking effort as a per-role cost knob *and* an eval axis), and a
**closed eval→train loop** (Tinker's RL primitives let the same harness that
measures a failure mode train against it). The BEAM contributes the harness-side
properties: process-per-agent topology, **failure injection as a native
primitive** (kill, suspend, delay, partition), supervision trees as both
scaffold and *subject* of recovery experiments, and per-message trace capture
for scoring and replay. For this brain, the spike does **not** reverse the
[BEAM/Jido "not now"](/meta/analysis/beam-deployment-and-jido-2-evaluation.md)
— but a swarm-eval harness is a separate application in which the runtime *is*
the product, and Inkling removes the one economic objection (rented frontier
sessions at swarm scale) that made such a harness implausible. The main
counterweights: a capability gap versus frontier models limits transfer of
capability-level findings (dynamics-level findings transfer better), and the
determinism guarantee holds only where you control the inference stack.

## 1. What Inkling actually is (facts, one day old)

From the [announcement](https://thinkingmachines.ai/news/introducing-inkling/),
[product page](https://thinkingmachines.ai/inkling/), and
[model card](https://thinkingmachines.ai/model-card/inkling/), all fetched
2026-07-16:

- **Open-weights Mixture-of-Experts transformer**: 975B total / 41B active
  parameters (66 layers; each token routed to 6 of 256 experts plus 2 shared),
  trained on 45T tokens. A lighter **Inkling-Small** (12B active) targets
  latency/cost-sensitive use. **Apache 2.0**; weights on Hugging Face.
- **Multimodal in, text out** (text, images, audio natively; no separate
  encoders), context up to **1M tokens** (64K/256K options on Tinker).
- **Controllable thinking effort** — an explicit cost/performance knob; the
  announcement claims equivalent Terminal Bench scores at roughly one-third the
  token cost of comparable models.
- **Agentic emphasis**: SWEBench Verified 77.6%, Terminal Bench 2.1 63.8%, MCP
  Atlas 74.1% (self-reported; no third-party replication yet — the release is a
  day old).
- **Trained for epistemics/calibration** on probabilistic forecasting, via RL
  against reward models that verify claims by web search.
- **Runs everywhere the open stack runs**: vLLM, SGLang, llama.cpp;
  hosted on TogetherAI, Fireworks, Modal, Databricks, Baseten; fine-tunable on
  [Tinker](https://thinkingmachines.ai/tinker/), Thinking Machines' LoRA-based
  training API (primitives: `forward_backward`, `sample`; cookbook includes
  multi-agent RL examples). Self-hosting the full model needs ~2TB VRAM in BF16
  or ~600GB quantized (NVFP4); Inkling-Small is the realistic owned-hardware
  variant.

Positioning matters for the eval question: Thinking Machines explicitly frames
Inkling as a "broad, balanced foundation model" for **adaptation**, not a
frontier-benchmark leader — i.e. the vendor's own theory of the model is that
you specialize it, which is precisely what constructing eval populations
requires.

## 2. What Inkling supplies that a closed-API model cannot

**(a) A pinned policy-under-test.** An eval is a measurement instrument; its
first requirement is that the thing measured stays fixed. Closed APIs
deprecate, silently revise, and retire models — a longitudinal swarm eval
("did the coordination-collapse rate change after we altered the routing
protocol?") is confounded the moment the provider ships a new snapshot. Open
weights pin the policy byte-for-byte, forever. Every eval run records
`(weights hash, adapter hash, seed)` and remains comparable across years.

**(b) Reproducible rollouts — the deep synergy.** Thinking Machines' identity
predates Inkling: their September 2025
[Defeating Nondeterminism in LLM Inference](https://thinkingmachines.ai/blog/defeating-nondeterminism-in-llm-inference/)
showed that even temperature-0 inference is nondeterministic because kernels
lack **batch invariance** (a request's output depends on what it was batched
with), and published batch-invariant kernels achieving 1,000/1,000 identical
completions; SGLang followed with a deterministic mode plus seeded sampling
(`multinomial_with_seed`, Gumbel-noise from a hashed seed) extending determinism
past greedy decoding. Swarm failure modes are *emergent* — they arise from
interaction order, timing, and accumulated context — which makes
non-reproducibility the single worst property an eval substrate can have: a
failure you cannot replay you cannot ablate. An Inkling swarm on a self-hosted
deterministic stack inverts this: record each agent-process's seeds and message
order, and an entire swarm trajectory becomes **bitwise replayable**; change one
variable (a prompt, an adapter, a topology edge) and rerun, and the divergence
is *attributable*. The same property is what makes on-policy RL stable (sampler
≡ trainer ⇒ zero KL drift), which is why (d) below composes. Caveat carried to
§6: this holds only where you control the inference stack — generic hosted
endpoints reintroduce batch nondeterminism.

**(c) Cheap, controlled population construction.** Swarm-dynamics questions are
population questions: how do failure rates move with member heterogeneity,
capability mix, effort budget? Two Inkling affordances map directly:

- **LoRA adapters as swarm members.** Tinker's economics (small adapters over a
  shared frozen base) mean a *population* of role-specialized or
  deliberately-flawed agents — an overconfident variant, a sycophantic variant,
  a stale-knowledge variant — costs a training run each, not a model each.
  Single-variable ablation becomes clean: identical base, one adapter differs.
  A deliberately poisoned member for Byzantine-robustness evals is a fine-tune
  away, something no closed API will sell you.
- **Thinking effort as an eval axis.** Sweep effort across the swarm and
  measure where coordination quality degrades — is a swarm of many low-effort
  agents more or less failure-prone than fewer high-effort ones at equal token
  budget? The knob plus Inkling's claimed token efficiency (and current 50%
  launch discount, hosted) is also what makes thousand-rollout sweeps
  affordable at all; swarm evals multiply cost by (agents × turns × rollouts).

**(d) A closed eval→train loop.** The harness that measures a failure mode
generates exactly the rollout data RL needs to train against it. Tinker's
cookbook ships multi-agent RL reference loops, and Berkeley's SkyRL has already
run async off-policy multi-agent RL with multi-turn tool use on it — so
"eval harness" and "training environment" become one artifact with two read
modes. Measured groupthink becomes a training signal against groupthink; the
determinism from (b) is what keeps that loop on-policy and stable.

A fifth, softer affordance: Inkling's calibration training makes it an
interesting *subject* for epistemic swarm evals specifically — how do
confidence and miscalibration propagate through a network of agents that were
trained to be calibrated individually? That is the swarm version of a question
this brain already owns (below).

## 3. What the BEAM supplies that generic orchestrators do not

The framework fit follows the granularity rule from
[managed minds, owned machinery](/meta/analysis/claude-managed-agents-vs-beam-jido.md):
an eval harness is mechanical-plane work — constant, concurrent, deterministic
scheduling around stochastic LLM calls — and its unit of agency should be a
supervised process, not a rented session.

- **The swarm topology is the process topology.** One BEAM process per agent,
  mailboxes as the inter-agent channel, links/monitors as the dependency graph.
  The eval doesn't *simulate* a distributed agent system; it *is* one, with
  ~free processes (hundreds of thousands per node) and IO-bound LLM calls that
  are exactly the workload BEAM schedulers excel at.
- **Failure injection is a native primitive, not a mock.** The failure modes
  under study — agent death mid-protocol, delayed/dropped/reordered messages,
  a wedged member, a network partition — correspond one-to-one to things the
  BEAM lets a harness *do*: `Process.exit/2`, `:sys.suspend/1`, proxy processes
  that delay or drop, `:erlang.disconnect_node/1`. Chaos-engineering the swarm
  is a for-comprehension, and — combined with §2(b) — an *injected* fault plus
  recorded seeds yields a reproducible failure trace.
- **Supervision is both scaffold and subject.** OTP restart strategies keep
  thousand-rollout campaigns alive unattended (the night-shift-manager point
  from the [dark-factory analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md));
  and restart semantics are themselves an experimental variable — measure task
  degradation under `one_for_one` vs. `rest_for_one` recovery of a dead
  coordinator, i.e. eval the *recovery design*, not just the agents.
- **Total observability.** Every inter-agent message can be logged, timestamped,
  and attributed by construction (`:telemetry`, tracing) — the full-trajectory
  capture that scoring, replay, and route-cause analysis need, with no
  instrumentation bolted onto a black-box orchestrator.
- **Plain HTTP to the model layer.** vLLM/SGLang expose OpenAI-compatible
  endpoints, so the harness needs only an HTTP client — sidestepping, for this
  workload, the req_llm concentration risk flagged in the
  [Jido caveats analysis](/meta/analysis/jido-distribution-gap-and-req-llm-cognition-dependency.md).
  The node-local distribution gap flagged there binds only if a single swarm
  must span BEAM nodes; single-node harness + external GPU cluster is the
  natural first shape.

The strategic shift: the managed-minds analysis assigned the deliberative plane
to rented Claude sessions largely on capability and economics. Open weights on
owned inference move the deliberative plane *inside the owned boundary* for the
first time — at swarm scale (hundreds of concurrent members, thousands of
rollouts), rented frontier sessions were never economically or rate-limit
viable anyway, so Inkling doesn't just improve that plane's economics; it makes
the workload possible.

## 4. What such a harness would measure — and this brain's head start

The swarm failure-mode space the harness targets: coordination collapse and
deadlock; duplicated/contended work; error and hallucination cascades;
groupthink and premature consensus; stale-belief propagation; Byzantine or
poisoned members; message-storm amplification; degradation under partial outage
(kill k of n mid-task); recovery pathologies (restart storms, split-brain after
partition).

Swarm evals need a task domain with constructible ground truth, and this brain
already built one:
[the corpus-maintenance failure space](/meta/analysis/eval-suitability-of-the-corpus-maintenance-failure-space.md)
established that synthesized corpora with injected defects make dedup recall,
fan-out completeness, and filing consistency measurable. Run those same tasks
against a *swarm* of concurrent writers instead of one agent, and the
swarm-dynamics metrics (conflict rate, redundant-work ratio, agreement decay,
cascade depth) layer directly on top of an oracle that already exists. That is
also, precisely, the "epistemic governance under concurrent autonomous writers"
problem the [dark-factory analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
named as the binding constraint — made testable *before* any commitment to a
lights-out system. The eval harness is the cheap empirical probe of the
dark-factory scenario's hard problem.

## 5. Fit with the tiered path — what this changes and what it doesn't

Nothing here reverses the standing verdicts: the brain's Elixir layer stays a
zero-dependency batch toolchain, and no resident BEAM process is justified by
the bundle's own workloads today. A swarm-eval harness is a **separate
application** — exactly the layering the
[BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md)
designed for (the verifier core never depends on the runtime), on a modern
toolchain (Elixir 1.17+/OTP 26+), free to take dependencies. What the spike
changes is the *trigger landscape*: it identifies the first concrete workload
where the tier-2/tier-3 path has (i) a runtime that is genuinely the product,
(ii) an owned, pinnable, reproducible model layer to drive, and (iii) a
research question this brain has already staked out. If a swarm-eval project is
ever commissioned, it should start as its own plan; this analysis is its
decision record, not its start.

## 6. Risks and counterweights

- **Capability gap and transferability.** Inkling is positioned as an adaptable
  foundation, not a frontier leader. Failure modes observed in an
  Inkling swarm may not reproduce in frontier-model swarms. Mitigation, not
  dismissal: *dynamics-level* findings (topology, protocol, recovery design,
  effort/population trade-offs) transfer far better than capability-level ones,
  and the reproducibility + ablation affordances have no closed-model
  substitute at any capability. Frontier-swarm spot-checks can calibrate the
  gap.
- **Determinism is stack-conditional.** Bitwise reproducibility requires
  batch-invariant kernels or SGLang's deterministic mode on infrastructure you
  control (self-hosted or a dedicated deployment on e.g. Modal). Generic hosted
  endpoints — including, today, most Inkling providers — reintroduce batch
  nondeterminism. The harness design must treat determinism as a deployment
  property to assert per-run, not an assumption.
- **Hardware reality.** Full Inkling self-hosted is 600GB–2TB VRAM; the honest
  owned-hardware baseline is Inkling-Small or quantized deployments, with the
  full model rented. That splits the pinning/determinism guarantees across a
  cost line the eval design has to acknowledge.
- **One-day-old claims.** All benchmark and efficiency figures are
  vendor-reported as of 2026-07-16; no third-party replication exists yet.
  Terminal Bench/SWEBench numbers should be re-checked before any plan builds
  on them.
- **Scope discipline.** This brain's operating loop needs none of this to
  function; the spike answers an operator question about a possible project,
  and per the tiered path the default remains "not now" until a swarm-eval
  effort is explicitly commissioned.

## Citations

- [Introducing Inkling — Thinking Machines Lab](https://thinkingmachines.ai/news/introducing-inkling/) (2026-07-15)
- [Inkling product page](https://thinkingmachines.ai/inkling/)
- [Inkling model card](https://thinkingmachines.ai/model-card/inkling/)
- [Tinker](https://thinkingmachines.ai/tinker/) and [Tinker docs — LoRA primer](https://tinker-docs.thinkingmachines.ai/lora-primer)
- [Defeating Nondeterminism in LLM Inference — Thinking Machines Lab](https://thinkingmachines.ai/blog/defeating-nondeterminism-in-llm-inference/) (2025-09) · [batch_invariant_ops](https://github.com/thinking-machines-lab/batch_invariant_ops)
- [Towards Deterministic Inference in SGLang and Reproducible RL Training — LMSYS](https://www.lmsys.org/blog/2025-09-22-sglang-deterministic/)
- [TechCrunch coverage of the Inkling launch](https://techcrunch.com/2026/07/15/thinking-machines-amps-up-its-bet-against-one-size-fits-all-ai-with-its-first-open-model-inkling/)
- [Hugging Face: Welcome Inkling](https://huggingface.co/blog/thinkingmachines-inkling)
