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
