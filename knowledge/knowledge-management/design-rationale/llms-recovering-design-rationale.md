---
id: em:ce51fc
type: reference
title: "Using LLMs in Generating Design Rationale for Software Architecture Decisions (TOSEM 2025)"
description: Measures how well LLMs reconstruct design rationale post-hoc — recall 0.63–0.72 but precision only ~0.27 against expert ground truth, with 1.6–3.2% of generated arguments potentially misleading — the strongest empirical case that rationale recorded at decision time is worth far more than rationale inferred later.
resource: https://arxiv.org/abs/2504.20781
provenance: "Distilled from the paper's abstract and results (arXiv:2504.20781, Wuhan University / Central China Normal University / RMIT / Shenzhen Polytechnic), fetched 2026-07-20"
tags: [design-rationale, adr, llm, empirical-study, software-architecture, post-hoc-reconstruction]
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T21:05:00Z
  channel: intake
  agent: "Claude Code agent, decision-tree-dev-history session"
  why: "quantifies the loss when rationale must be inferred after the fact — the core empirical support for capturing decisions at decision time in the decision-records analysis"
---

# Using LLMs in Generating Design Rationale for Software Architecture Decisions

Published in ACM TOSEM (arXiv:2504.20781, 2025). The study evaluates whether
LLMs can *recover* design rationale (DR) — the reasoning underlying
architectural choices — when it was never documented, testing five LLMs under
three prompting strategies (zero-shot, chain-of-thought, and agent-based)
against expert-provided ground truth.

## Results

- **Precision 0.267–0.278, recall 0.627–0.715, F1 0.351–0.389.** The models
  surface most of the arguments experts identified (decent recall) but bury
  them in a much larger set of generated arguments (low precision).
- Of the arguments *not* in the expert ground truth, **64.5–69.4% were judged
  helpful anyway**, 4.1–4.9% of uncertain correctness, and **1.6–3.2%
  potentially misleading**.
- The paper's motivating premise: DR "provides valuable insights into the
  different phases of the architecting process" but is "often inadequately
  documented due to a lack of motivation and effort from developers."

## Why it matters here

Post-hoc reconstruction of the "why" is lossy and partly confabulated: roughly
three of four generated rationale-arguments are not the expert's, and a
non-trivial slice actively misleads. Two consequences for an agent-operated
knowledge system: (1) **rationale captured at decision time is structurally
more valuable** than anything an agent can re-derive later from artifacts; and
(2) agent-*authored* rationale should itself be treated as asserted-not-verified
until an operator's editorial pass — the same stance this bundle already takes
toward agent statements via the `verified` field.

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:ce51fc">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-20-decision-records-as-history-abstraction (2026-07-20)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:ce51fc`]**  (co-feeds: `em:4f5372 em:6d6425 em:7fa867`)

**2. LLMs and design rationale / ADRs (current).** Directly on your "would this aid the LLM" question:

- [Using LLMs in Generating Design Rationale for Software Architecture Decisions](https://arxiv.org/abs/2504.20781) (TOSEM 2025) measured how well LLMs *reconstruct* rationale post-hoc: recall 0.63–0.72 but **precision only ~0.27**, with 1.6–3.2% of generated arguments potentially misleading. This is the strongest empirical argument for your proposal: inferring the why after the fact is lossy and partly confabulated, so **rationale recorded at decision time is worth far more than rationale reconstructed later** — and it also warns that agent-authored rationale needs the operator's editorial pass (your existing `verified` ethos, applied to decisions).
- [Context Matters: Context Strategies for Automated ADR Generation](https://arxiv.org/abs/2604.03826) (2026, 750-repo corpus) found context engineering — not model scale — is the dominant factor, and that a **small window of 3–5 related prior decision records** is the optimal context. That's a concrete design datum: a decision node's value to an agent is mostly in its local neighborhood, which is exactly what a tree/graph structure makes cheap to fetch.
- [AgenticAKM](https://arxiv.org/abs/2602.04445) (2026) shows multi-agent workflows generating ADRs from repos beat naive prompting; [Architecture Without Architects](https://arxiv.org/abs/2604.04990) (2026) argues agents now make architectural decisions "almost no one reviews as such" — an operator-side argument for a decision view as an *audit surface*.
