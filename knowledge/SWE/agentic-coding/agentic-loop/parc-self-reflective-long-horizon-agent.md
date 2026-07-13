---
id: sb:f02167
type: reference
title: "PARC — a self-reflective agent for long-horizon autonomous execution"
description: A hierarchical multi-agent coding system that adds an independent self-assessment/self-feedback agent to catch high-level strategic errors, sustaining autonomous progress across multi-day scientific and data-science workflows.
resource: https://arxiv.org/abs/2512.03549
provenance: "Distilled from the PARC paper (arXiv:2512.03549, Orimo et al.), fetched 2026-07-11"
tags: [agentic-loop, long-horizon, self-reflection, multi-agent, autonomy, reliability]
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T17:29:20+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# PARC — a self-reflective agent for long-horizon autonomous execution

PARC (Yuki Orimo, Iori Kurata, Hodaka Mori, Ryuhei Okuno, Ryohto Sawada, Daisuke
Okanohara; arXiv:2512.03549, submitted 2025-12-03) targets the dominant failure of
the [agent execution loop](/knowledge/SWE/agentic-coding/agentic-loop/the-agent-execution-loop.md)
at scale: reliability decays as tasks lengthen, and a plain reason→act→observe loop
drifts off-strategy over hours or days with no mechanism to notice.

## The mechanism

PARC adds an **independent evaluation agent** that runs *self-assessment and
self-feedback* over the executor's actions and outcomes — not line-level linting,
but detection of **high-level strategic errors** — so the system can re-plan and
correct course without a human in the loop. It sits in a **hierarchical
multi-agent architecture** separating task planning, execution, and independent
assessment. This is the reflect/recover step that
[designing agentic loops](/knowledge/SWE/agentic-coding/agentic-loop/designing-agentic-loops.md)
argues long-running agents need, made a first-class component.

## Results

Demonstrated on genuinely long-horizon work rather than short benchmarks:

- Autonomously **reproduced materials-science findings** (lithium-ion conduction,
  alloy segregation), orchestrating dozens of parallel simulations — each ~43 hours
  of computation — with end-to-end monitoring and error correction.
- Produced **Kaggle solutions competitive with human-engineered baselines** from
  minimal natural-language instructions.

## Why it matters for the brain

Concrete architecture for the reliability-over-time problem the
[time-horizon data](/knowledge/SWE/agentic-coding/agentic-loop/agent-task-time-horizons.md)
quantifies: an explicit, *independent* self-reflection layer is one answer to why
"doubling task duration more than doubles failure," extending the loop lexicon this
folder tracks with a supervise-and-recover tier.

# Citations

PARC (arXiv:2512.03549) — <https://arxiv.org/abs/2512.03549>

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="sb:f02167">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-11-news-digest-intake-and-daily-read (2026-07-11)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:f02167`]**  (co-feeds: `sb:532b22 sb:1cac23 sb:c29a22 sb:8b9548 sb:49eae4`)

Both jobs are done and pushed to `claude/news-feature-w5dsgl`.

**1. Intaked all 6 candidates**

Each is now a permanent bundle concept — ids minted, registry recompiled, indexes and root log updated, digest lines marked `✓ intaken`. All fit existing directories, so no taxonomy ratification was needed. Bundle verifies clean.

| Concept | id | Filed under | Extends |
|---|---|---|---|
| Codebase-Memory (paper + repo) | `sb:532b22` | code-context | GitNexus `sb:b89ea1` |
| VeriCache — lossless KV cache | `sb:1cac23` | llm-engineering | KV-cache history `sb:266c5e` |
| PARC — self-reflective long-horizon agent | `sb:f02167` | agentic-loop | — |
| METR agent time-horizons | `sb:c29a22` | agentic-loop | — |
| Git worktrees for parallel agents | `sb:8b9548` | version-control/git | branches note `sb:4c9e1f` |
| State of AI Coding 2026 (New Relic) | `sb:49eae4` | testing | test-features `sb:a5ea86` |

One judgment call worth flagging: I captured **Codebase-Memory the paper and its repo as one concept** (resource = the GitHub repo, arXiv cited in the body) rather than two files — the anti-fragmentation policy says one project = one concept, matching how GitNexus was filed. PARC and time-horizons landed under a new **"Reliability & long-horizon"** section of the agentic-loop index. Say the word if you'd rather split Codebase-Memory into a separate paper `source` + tool `reference`.
