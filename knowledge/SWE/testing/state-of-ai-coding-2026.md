---
id: sb:49eae4
type: reference
title: "State of AI Coding 2026 (New Relic) — the trust-vs-reliability gap"
description: A survey of 200 US technology leaders finding AI now writes most weekly code and is trusted enough to ship without line-by-line review (62%), even as it drives measurable production-incident spikes — the data case for testing features/behavior over reading every line.
resource: https://newrelic.com/blog/ai/state-of-ai-coding-2026
provenance: "Distilled from New Relic's State of AI Coding 2026 (Jim Young; research by Hanover Research), fetched 2026-07-11"
tags: [testing, ai-generated-code, verification, agentic-coding, survey, reliability]
timestamp: 2026-07-11
---

# State of AI Coding 2026 (New Relic) — the trust-vs-reliability gap

A first-party survey (New Relic, pub. 2026-06-10; 200 US manager+ technology
decision-makers, fielded by Hanover Research) documenting how far AI-generated code
has moved into production — and the verification gap that opened behind it.

## The findings

**Adoption is now the default.**

- 67% say AI generates or significantly refactors **51–75% of weekly code**.
- 95% of orgs authorize machine-generated code in production (87.5% formally).

**Trust outran verification.**

- 94% rate AI code as *higher* quality than human code during review, and **62% of
  leaders often/always ship it without line-by-line manual verification**.

**Reliability tells a different story.**

- 78% report **production-incident spikes** tied to AI code; 82% had ≥1 major
  AI-caused production failure in six months.
- AI code introduces **~1.7× more critical runtime issues** than peer-reviewed
  human code; 74% say ≥25% of AI code needs significant post-deployment rework.
- 78% now routinely prompt AI to emit logging/span/metric hooks up front —
  observability compensating for unread code.

## Why it matters for the brain

Hard data under
[test features, not code](/knowledge/SWE/testing/how-to-test-features-not-code.md): when the
author no longer reads every line, correctness has to be established by exercising
*behavior*, not by line-level review. The survey quantifies the regime that testing
philosophy assumes — high-volume, high-trust, under-verified AI code — and the cost
(runtime incidents, rework) of skipping the behavioral check.

# Citations

New Relic — State of AI Coding 2026 —
<https://newrelic.com/blog/ai/state-of-ai-coding-2026>

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="sb:49eae4">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-11-news-digest-intake-and-daily-read (2026-07-11)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:49eae4`]**  (co-feeds: `sb:532b22 sb:1cac23 sb:f02167 sb:c29a22 sb:8b9548`)

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
