---
id: em:4f5372
type: reference
title: "Context Matters: Evaluating Context Strategies for Automated ADR Generation Using LLMs (2026)"
description: A 750-repository study of context strategies for LLM ADR generation finding that a small recency window of 3–5 related prior decision records is the optimal context, retrieval adds only marginal gains, and context engineering — not model scale — is the dominant factor in decision-record quality.
resource: https://arxiv.org/abs/2604.03826
provenance: "Distilled from the paper's abstract and findings (arXiv:2604.03826), fetched 2026-07-20"
tags: [adr, context-engineering, llm, design-rationale, empirical-study, retrieval]
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T21:05:00Z
  channel: intake
  agent: "Claude Code agent, decision-tree-dev-history session"
  why: "supplies the concrete design datum — a 3–5-record local neighborhood is the optimal decision context — cited by the decision-records analysis and the decision-graph plan"
---

# Context Matters: context strategies for automated ADR generation

arXiv:2604.03826 (2026). Evaluates five context-selection strategies for
generating Architecture Decision Records with LLMs — no context, all-history,
first-K, last-K, and RAFG (retrieval-augmented) — over a validated corpus drawn
from **750 open-source repositories**, across multiple LLM families.

## Findings

- **A small recency window (typically 3–5 prior decision records) is optimal.**
  This modest context substantially improves generation quality over the
  baseline; dumping all history or the earliest records does not.
- **Retrieval-based selection offers only marginal improvement** in typical
  workflows over the simple recency window; the paper recommends recency-based
  defaults with "targeted retrieval fallbacks for complex architectural
  settings."
- Headline conclusion: **"context engineering, rather than model scale alone,
  is the dominant factor in effective ADR automation."** Generated ADRs miss
  system-specific detail when system context is insufficient, regardless of
  model.

## Why it matters here

The result gives a decision *graph* its quantitative justification for agent
consumption: what an agent needs to work well on a decision is its **local
neighborhood** — a handful of related, distilled prior records — which is
exactly what edges over small decision records make cheap to fetch, and what
parsing verbatim session transcripts makes expensive.

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:4f5372">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-20-decision-records-as-history-abstraction (2026-07-20)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:4f5372`]**  (co-feeds: `em:ce51fc em:6d6425 em:7fa867`)

**2. LLMs and design rationale / ADRs (current).** Directly on your "would this aid the LLM" question:

- [Using LLMs in Generating Design Rationale for Software Architecture Decisions](https://arxiv.org/abs/2504.20781) (TOSEM 2025) measured how well LLMs *reconstruct* rationale post-hoc: recall 0.63–0.72 but **precision only ~0.27**, with 1.6–3.2% of generated arguments potentially misleading. This is the strongest empirical argument for your proposal: inferring the why after the fact is lossy and partly confabulated, so **rationale recorded at decision time is worth far more than rationale reconstructed later** — and it also warns that agent-authored rationale needs the operator's editorial pass (your existing `verified` ethos, applied to decisions).
- [Context Matters: Context Strategies for Automated ADR Generation](https://arxiv.org/abs/2604.03826) (2026, 750-repo corpus) found context engineering — not model scale — is the dominant factor, and that a **small window of 3–5 related prior decision records** is the optimal context. That's a concrete design datum: a decision node's value to an agent is mostly in its local neighborhood, which is exactly what a tree/graph structure makes cheap to fetch.
- [AgenticAKM](https://arxiv.org/abs/2602.04445) (2026) shows multi-agent workflows generating ADRs from repos beat naive prompting; [Architecture Without Architects](https://arxiv.org/abs/2604.04990) (2026) argues agents now make architectural decisions "almost no one reviews as such" — an operator-side argument for a decision view as an *audit surface*.
