---
type: reference
title: 2026-07-16-graduate-swarm-eval-harness-plan
description: The post-PR continuation of the Inkling/BEAM spike session — merged PR #104 (the spike, its capture, and seven glossary terms), then graduated the swarm-eval harness from the analysis's paused strand into the inkling-beam-swarm-eval-harness plan (status proposed, M0-only commitment), settling mid-graduation that this drafts a new plan citing the analysis rather than retyping the analysis itself.
provenance: "Claude Code session (Claude Fable), 2026-07-16; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, evals, agents, swarm, plans, graduation, inkling, beam, merge]
timestamp: 2026-07-16
session: https://claude.ai/code/session_01HPyhA5S6pA3cra7nHhxnB7
pr: 105
---

# 2026-07-16-graduate-swarm-eval-harness-plan

## Where this landed

The continuation slice of the Inkling/BEAM spike session, after its capture was
sealed into [the spike thread](/meta/threads/2026-07-16-inkling-beam-swarm-eval-spike.md)
(anchored to PR #104). Three motions: the operator opted in to the merge, and
PR #104 true-merged to `main` as `8541912` with the head branch auto-deleted;
the operator then directed graduating the harness into a plan linked to the
analysis, which — after an interrupt clarifying that this means *drafting a new
plan based off the analysis*, never retyping the analysis — landed as
[inkling-beam-swarm-eval-harness](/meta/plans/inkling-beam-swarm-eval-harness.md)
(`status: proposed`): a decision-record-first plan citing the
[analysis](/meta/analysis/inkling-beam-swarm-eval-substrate.md) for all
findings and committing only the M0–M5 ladder (M0, the determinism canary with
a kill condition, as the sole initially committed rung), scope boundaries, and
four rung-resolved open questions. The analysis's §5 and index entry now point
at the plan; the plan's `attribution.from` carries the spike thread and the
analysis; the designated branch was restarted from `main` per the
merged-PR branch policy. One dangling input: the operator owes a budget
ceiling before M0 runs.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Land PR #104 (spike analysis, capture, seven glossary terms) via true merge | closed | `unrouted` | - |
| Graduate the harness strand into a plan, linked both ways to the analysis | closed | [inkling-beam-swarm-eval-harness](/meta/plans/inkling-beam-swarm-eval-harness.md) | - |
| Analysis-vs-plan relationship (new doc citing the analysis, not a retype) | closed | [inkling-beam-swarm-eval-harness](/meta/plans/inkling-beam-swarm-eval-harness.md) | - |
| M0 funding | paused | [inkling-beam-swarm-eval-harness](/meta/plans/inkling-beam-swarm-eval-harness.md) | Operator to set the M0 budget ceiling (open question 1 of the plan) before the determinism canary runs |

## Assistant

The PR is open and handed back to you: **https://github.com/ob6to8/elixir-mind/pull/104** — *Research spike: Inkling + Elixir/BEAM as an agent-swarm eval substrate*. Per the default flow I have not merged it; say `/create-pull-request merge` (or merge it yourself) when ready.

What shipped, in order:

1. **Capture** — the session is frozen as `meta/threads/2026-07-16-inkling-beam-swarm-eval-spike.md`: both operator messages and the substantive assistant responses verbatim, a routing ledger with two closed strands routed to the analysis and one **paused** strand (whether to graduate the harness into a `type: plan` with the M0 determinism canary as the first funded step), and the threads index updated. No route tags were needed — both routed strands land in a governance doc, which carries no `em:` id.
2. **Glossary** — seven new terms from the thread: [Inkling](https://ob6to8.github.io/elixir-mind/beliefs/glossary/inkling.html) (`em:2015c6`), [Tinker](https://ob6to8.github.io/elixir-mind/beliefs/glossary/tinker.html) (`em:5b4fca`), [LoRA](https://ob6to8.github.io/elixir-mind/beliefs/glossary/lora.html) (`em:5554e8`), [batch invariance](https://ob6to8.github.io/elixir-mind/beliefs/glossary/batch-invariance.html) (`em:5787b0`), [open weights](https://ob6to8.github.io/elixir-mind/beliefs/glossary/open-weights.html) (`em:02dc95`), [fault injection](https://ob6to8.github.io/elixir-mind/beliefs/glossary/fault-injection.html) (`em:f518a7`), and [agent swarm](https://ob6to8.github.io/elixir-mind/beliefs/glossary/agent-swarm.html) (`em:76ccba`) — all `sense: common`, plus a citation merge into the existing mixture-of-experts entry. Registry and the glossary index's `## Terms` section regenerated. (Links go live on merge.)
3. **Attribution stamp** — the thread path was appended to the analysis doc's `attribution.from`, clearing the advisory warning from the earlier commits.
4. **PR opened and anchored** — `pr: 104` stamped into the thread's frontmatter and pushed, so the stamp ships inside the PR itself.

Everything went out green: full gate suite (`brain.verify`, `route_tags`, `glossary`, `contract --check`, `registry --check`) plus 168 tests, 0 failures.

Want me to watch the PR? I can subscribe to its CI and review activity and respond to failures or comments — just say so.

## User

Merge

## Assistant

Merged. PR #104 landed on `main` as a true merge commit, `8541912` (`85419127e86ed36e6cc7ee36a9a3c83c9bd0293e`), with both CI `verify` runs green beforehand. The head branch `claude/inkling-elixir-swarm-evals-22p0uh` is already deleted on the remote (auto-delete handled it), and its commits stay reachable through the merge per the merge-strategy policy.

Everything from this session is now durable on `main`:

- The analysis: [inkling-beam-swarm-eval-substrate](https://ob6to8.github.io/elixir-mind/meta/analysis/inkling-beam-swarm-eval-substrate.html)
- The session record: `meta/threads/2026-07-16-inkling-beam-swarm-eval-spike.md`, anchored to `pr: 104`
- Seven glossary terms (Inkling, Tinker, LoRA, batch invariance, open weights, fault injection, agent swarm) — the Pages deploy triggered by this push will make their live URLs resolve shortly

One loose end deliberately left open in the thread's routing ledger: whether to graduate the swarm-eval harness into a `type: plan` (with the M0 determinism canary as the first funded step). Say the word if you want that plan drafted in a future session.

## User

Graduate the harness into a plan and link it to the analysis

## User

Are you changing the analysis to a plan, or are you drafting a plan based off of the analysis?

## Assistant

Drafting a **new plan based off the analysis** — the analysis stays exactly as it is. They're different genres in the contract: the analysis is the settled *judgment* ("is this pairing worth anything? yes, and here's why"), while a plan is *intended work* with a build order and a status lifecycle. The analysis itself anticipated this split in §5: "it should start as its own plan; this analysis is its decision record, not its start." Retyping would also break the merged, cited doc for no gain. So the graduation is: a new `type: plan` under `meta/plans/` whose decisions cite the analysis, plus a pointer added to the analysis so the link runs both ways. Proceeding on that basis.

The plan is filed and pushed. To answer the question directly one more time: the analysis was left intact as the frozen decision record; the graduation produced a **new** doc, `meta/plans/inkling-beam-swarm-eval-harness.md` (`status: proposed`), with links running both ways.

What the plan commits — deliberately less than the analysis describes:

- **Decision-record-first.** It restates nothing; every finding (the four model-side properties, the stack, fine-tuning economics, campaign anatomy, risks) is cited from the analysis. The plan only adds what a plan owns: a build order, scope boundaries, and open questions.
- **The M0–M5 ladder is the commitment structure.** Only **M0 — the determinism canary** — is committed by acceptance, with an explicit kill condition: if bitwise reproducibility can't be demonstrated on attainable infrastructure, the thesis fails cheaply and the plan closes. Each later rung (single-agent baseline → concurrent writers → fault injection → population sweeps → RL closure) is re-scoped on the previous rung's report.
- **Scope boundaries** keep it honest: the harness is an experiment instrument, not a brain runtime (the BEAM/Jido "not now" stands); it's its own codebase, with only governance living here; and findings are dynamics-level, not frontier-swarm capability claims.
- **Four open questions** are deliberately deferred to the rung that makes each live: M0 infrastructure choice (needs a budget ceiling from you before M0 runs — the one input only you can give), harness repo location (default: new repo, ratified at M1), oracle portability from the dedup-probe gold sets, and re-verifying Inkling's vendor benchmarks before M4 spends on fine-tuning.

Cross-linking: the analysis's §5 and its index entry now point at the plan; the plan's `attribution.from` carries both the spike thread and the analysis, so the thread's paused strand is resolved. The plans index lists it at the top of Proposed.

Because PR #104 had merged, I restarted the designated branch fresh from `main` per the branch policy — this commit (`b9513ae`, gates green at 172 tests) is the only new work on it. Say `/create-pull-request` (or `/create-pull-request merge`) when you want it captured and landed; that run will also write a new thread doc for this post-merge continuation, since the previous one is sealed to PR #104.
