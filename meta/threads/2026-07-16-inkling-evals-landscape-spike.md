---
type: reference
title: 2026-07-16-inkling-evals-landscape-spike
description: The third slice of the Inkling session — merged PR #105 (the harness-plan graduation), then ran the second operator-commissioned spike (Inkling's effect on the evals world, its place in the mid-2026 open-weights landscape, the adoption case, and the Thinking Machines bet), filed as the inkling-open-weights-eval-landscape analysis; closed with a persistence audit confirming all findings were in documents with the landscape analysis one merge from durable.
provenance: "Claude Code session (Claude Fable), 2026-07-16; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, evals, inkling, open-weights, landscape, llm-as-judge, thinking-machines, industry]
timestamp: 2026-07-16
pr: 124
---

# 2026-07-16-inkling-evals-landscape-spike

## Where this landed

The third slice of the 2026-07-16 Inkling session, following
[the spike thread](/meta/threads/2026-07-16-inkling-beam-swarm-eval-spike.md)
(PR #104) and [the graduation thread](/meta/threads/2026-07-16-graduate-swarm-eval-harness-plan.md)
(PR #105). After PR #105 true-merged (`94376fb`), the operator commissioned a
second research spike — Inkling's effect on the evals world and industry, its
position among current open-weight models, the adoption case, what is new
about it, and the Thinking Machines bet — filed as
[inkling-open-weights-eval-landscape](/meta/analysis/inkling-open-weights-eval-landscape.md):
five eval-impact channels (pinnable subjects, judge/reward economics via
Tinker, lineage diversity against correlated judge error, eval-as-environment
convergence, cost-normalized and contamination-skeptical scoring), the
leading-US-open-weights-but-flanking landscape position (AA Index 41; GLM-5.2
and DeepSeek V4 keep coding), conditional adoption logic (adapt/measure/comply
vs. raw capability), and the vendor's three stacked wagers — with the day-one
AA-vs-vendor calibration split (positive Omniscience, 63% hallucination rate)
recorded as a live example of the eval scrutiny the analysis predicts. A
closing persistence audit found all findings in documents, this slice's
session record pending (this capture), and the landscape analysis pushed but
unmerged — resolved by the operator's `/create-pull-request merge`.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Land PR #105 (harness-plan graduation) via true merge | closed | `unrouted` | - |
| Inkling's eval-industry impact, landscape position, adoption case, and the Thinking Machines bet | closed | [inkling-open-weights-eval-landscape](/meta/analysis/inkling-open-weights-eval-landscape.md) | - |
| Persistence audit of the session's outputs | closed | `unrouted` | - |
| M0 funding for the harness plan | paused | [inkling-beam-swarm-eval-harness](/meta/plans/inkling-beam-swarm-eval-harness.md) | Operator still owes the M0 budget ceiling (tracked in the plan and the graduation thread; repeated here for reconciliation visibility) |

## Assistant

Done — the full flow ran to completion, including the merge you opted into.

**PR #105** — https://github.com/ob6to8/elixir-mind/pull/105 — true-merged to `main` as **`94376fb`** (`94376fb797a6cf36a0daeabbc13b66a87b4a831a`) with both CI `verify` checks green beforehand. The head branch `claude/inkling-elixir-swarm-evals-22p0uh` was auto-deleted on merge; its commits stay reachable through the merge commit.

**The captured thread doc's assigned name:** `meta/threads/2026-07-16-graduate-swarm-eval-harness-plan.md` (anchored to `pr: 105`). It records this continuation slice — the #104 merge, your graduation directive, and the analysis-vs-plan clarification — with one paused strand in its routing ledger: **you owe an M0 budget ceiling** before the determinism canary can run (open question 1 of the plan).

What landed on `main`, now all live on the Pages site once the deploy finishes:

- The plan: [inkling-beam-swarm-eval-harness](https://ob6to8.github.io/elixir-mind/meta/plans/inkling-beam-swarm-eval-harness.html) (`status: proposed`, M0-only commitment), linked both ways with the [analysis](https://ob6to8.github.io/elixir-mind/meta/analysis/inkling-beam-swarm-eval-substrate.html)
- The thread doc and its index entry
- One glossary merge: [graduation](https://ob6to8.github.io/elixir-mind/beliefs/glossary/graduation.html) gained sense 3 (*strand → plan promotion*), with this thread cited — no other terms cleared the selection bar, so no padding

The whole Inkling arc is now durable: spike analysis (PR #104) → harness plan (PR #105), with the plan waiting on your budget ceiling to fund M0.

## User

What is thread doc name

## Assistant

This session produced two thread docs (one per PR):

- **`meta/threads/2026-07-16-graduate-swarm-eval-harness-plan.md`** — the most recent one, from PR #105 (the plan graduation slice). Live at https://ob6to8.github.io/elixir-mind/meta/threads/2026-07-16-graduate-swarm-eval-harness-plan.html
- `meta/threads/2026-07-16-inkling-beam-swarm-eval-spike.md` — the earlier one, from PR #104 (the original research spike and its expansion).

## User

Do a research spike into the effect that inkling may have on the world of eVals. How does having an open weight model of this type affect opportunities for eVals and how might it affect the industry? also contextualize the arrival of this model in the current selection of open weight models. How does it compare? Why might someone adopt inkling? What is it about inkling that is new or different? And what is the bet by thinking machines?

## Assistant

The spike is done, filed as [meta/analysis/inkling-open-weights-eval-landscape.md](https://github.com/ob6to8/elixir-mind/blob/claude/inkling-elixir-swarm-evals-22p0uh/meta/analysis/inkling-open-weights-eval-landscape.md) (gates green, pushed on the restarted branch — say `/create-pull-request merge` when you want it landed). Here are the findings, taking your questions in order.

**The landscape it arrives into.** By usage, mid-2026 open weights is a **Chinese field**: Chinese models went from negligible to ~61% of all OpenRouter tokens by May 2026, four of the five most-used models are Chinese, and the inflection was DeepSeek-R1 (Jan 2025) proving frontier reasoning could ship with weights. Qwen is now the biggest open-model franchise in the world (1B+ downloads, more derivatives than Google's and Meta's base families combined); Meta hasn't shipped an open Llama since April 2025. The open-to-frontier gap has collapsed to ~3 months (Epoch AI), and workloads shifted hard toward code — exactly where Chinese models are strongest and cheapest. Into that: a US lab shipping an Apache-2.0 multimodal MoE that explicitly does *not* claim the frontier.

**How it compares.** Third-party day-one numbers (Artificial Analysis): Inkling debuts at **Intelligence Index 41 — the new leading US open-weights model** (past Nemotron 3 Ultra's 38), but it does **not** beat the Chinese leaders where demand lives: GLM-5.2 wins coding/agentic (SWEBench Pro 62.1% vs 54.3%, Terminal Bench 82.7 vs 63.8), DeepSeek V4 Pro wins SWEBench Verified. Inkling *flanks* instead: best-in-class **token efficiency** (~25K output tokens per task vs 37–43K for rivals), the top **agentic Elo** on GDPval-AA, leads open weights on adversarial robustness (FORTRESS 78%), the only open model with **native image+audio input**, and the only one with a *positive* AA-Omniscience (calibration) score — though with a sobering corrective: 40% raw accuracy and a **63% hallucination rate**, so the calibration training changed knowing-when-it-doesn't-know more than correctness.

**What's actually new, and why adopt it.** Four genuine novelties, in order: **the ecosystem is the product** (no other open release ships weights + a training platform (Tinker) + the published research that de-risks both — batch invariance for reproducible inference, LoRA-parity for cheap adaptation); **multimodal-in open weights**; **effort as a trained, first-class dial** (which is where the token economics come from); and **calibration as an explicit training target**, v1-grade but directionally unique. Plus the boring-but-decisive one: **provenance** — a US-governed, red-teamed, Apache-2.0 model answers the enterprise/government objection to Chinese weights. So the adoption logic is conditional: pick Inkling to **adapt, measure, or comply**; pick GLM/DeepSeek to code cheaply at maximum raw capability. It wins segments, not the leaderboard.

**The effect on the world of evals — the core of the spike.** Five channels, mechanical to structural:

1. **Subjects you can pin.** Evals need the measured thing to hold still; open weights make the policy-under-test permanent, and Inkling adds the deterministic-inference lineage plus a sweepable effort axis — longitudinal, bitwise-replayable, cost-resolved measurement becomes commodity practice instead of a research project.
2. **Judge and reward-model economics.** The industry increasingly runs on fine-tuned judges (Prometheus/Selene lineage) and reward models; a cheap, US-licensed, calibration-oriented base with a managed fine-tuning path is exactly the input those products need. Tinker turns "train a judge on our rubric" into a workflow.
3. **Judge diversity against correlated error.** The "great models think alike" problem quietly undermines LLM-as-judge ensembles built from the same few lineages. Inkling is a genuinely new pretraining lineage, so it adds real family diversity to multi-judge panels — which best practice already prescribes.
4. **Evals converge with training.** Tinker's RL loop makes any eval oracle one export away from being a reward function — evals drift from static benchmark to *environment*. That makes them more valuable (they become the supervision signal) and more contested (Goodhart pressure arrives with the workflow).
5. **Cost-normalized and adversarial scoring pressure.** The effort knob forces intelligence-per-token reporting (AA already headline-reports it), and open weights structurally invite contamination skepticism (anyone can train on test sets) — expect more private holdouts, verifiable gold sets, and day-one third-party audits. The AA-vs-vendor calibration split on this very release is the live example.

Net industry effect: Inkling doesn't extend what evals *can show*; it collapses the cost and reproducibility barriers around who can run serious ones, while raising the design bar eval builders must clear.

**The Thinking Machines bet.** Three stacked wagers, each necessary: **(1) specialization beats scale** for enterprise value — they openly concede Inkling is "not the strongest overall model available today, open or closed" and sell it as a starting point, with Bridgewater-style results (fine-tuned open model beating proprietary frontier on domain reasoning at ~1/14th run cost) as the proof pattern; **(2) open weights is the distribution wedge, not the revenue** — downloaders owe them nothing; the weights seed the ecosystem and plant the US flag against the Chinese field; **(3) the margin lives in the customization layer** — revenue is Tinker fees plus a cut of the hosting ecosystem, with the published research as credibility collateral. The exposure: Chinese labs iterate faster and cheaper at raw capability, platform monetization of open weights is unproven, and frontier labs are attacking wager 1 from above with their own fine-tuning. The through-line for your purposes: a lab optimizing for *reproducibility, calibration, and adaptation* is optimizing for what evaluators buy — the evals world is a natural constituency of this bet.

## User

Is all important info in this thread persisted in documents?

## Assistant

Mostly yes — every substantive *finding* is in a document, but two things are still in flight:

**Fully persisted and merged to `main`:**
- Spike 1 (Inkling + BEAM as swarm-eval substrate, incl. stack / fine-tuning / campaign anatomy) → the [substrate analysis](https://ob6to8.github.io/elixir-mind/meta/analysis/inkling-beam-swarm-eval-substrate.html) (PR #104)
- The harness graduation → the [harness plan](https://ob6to8.github.io/elixir-mind/meta/plans/inkling-beam-swarm-eval-harness.html), linked both ways with the analysis (PR #105)
- Both session records so far → thread docs `2026-07-16-inkling-beam-swarm-eval-spike.md` (`pr: 104`) and `2026-07-16-graduate-swarm-eval-harness-plan.md` (`pr: 105`), including the analysis-vs-plan clarification exchange
- Vocabulary → seven glossary terms plus the mixture-of-experts and graduation merges
- The one open decision — you owe an **M0 budget ceiling** — is recorded twice: as the paused strand in thread #2's routing ledger and as open question 1 of the plan

**Persisted but not yet landed:** Spike 2 (evals-industry impact, open-weights landscape, the Thinking Machines bet) is filed as the [landscape analysis](https://github.com/ob6to8/elixir-mind/blob/claude/inkling-elixir-swarm-evals-22p0uh/meta/analysis/inkling-open-weights-eval-landscape.md), committed and **pushed to the branch — but not merged**, so it isn't on `main` or the live site yet. Its content is complete (everything in my chat summary is in the doc, with citations), so nothing would be lost, but it's one merge away from durable.

**Not yet persisted (by design):** the session record of this third slice — the second spike exchange and these follow-ups — has no thread doc yet. Capture runs once at close, so it gets written by the next `/create-pull-request`, which will also glossary the new thread and stamp it into the landscape analysis's `attribution.from` (currently carrying the expected "lacks `from`" advisory).

So: no knowledge exists only in chat, but say `/create-pull-request merge` and I'll close both gaps — capture this slice, stamp attribution, and land the landscape analysis on `main`.

## User

Commit. Push, /create-pull-request  merge
