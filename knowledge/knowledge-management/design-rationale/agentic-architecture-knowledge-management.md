---
id: em:6d6425
type: reference
title: "AgenticAKM: Enroute to Agentic Architecture Knowledge Management (2026)"
description: A multi-agent system that decomposes architecture-knowledge management into specialized Extraction, Retrieval, Generation, and Validation agents collaborating to generate ADRs from code repositories, outperforming naive single-prompt approaches that hit context limits and miss the distributed nature of architectural knowledge.
resource: https://arxiv.org/abs/2602.04445
provenance: "Distilled from the paper's abstract (arXiv:2602.04445), fetched 2026-07-20"
tags: [adr, architecture-knowledge-management, multi-agent, llm, design-rationale]
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T21:05:00Z
  channel: intake
  agent: "Claude Code agent, decision-tree-dev-history session"
  why: "shows decision-record generation is itself becoming an agentic workflow — the automation-side companion to the decision-records analysis"
---

# AgenticAKM: agentic architecture knowledge management

arXiv:2602.04445 (2026). Architecture Knowledge Management (AKM) — keeping a
project's architectural knowledge current and comprehensive — is "laborious"
and consequently neglected. AgenticAKM automates it with a **multi-agent
decomposition**: specialized agents for architecture **Extraction, Retrieval,
Generation, and Validation** collaborate in a structured workflow to produce
architecture knowledge, instantiated concretely as **generating ADRs from code
repositories**.

The decomposition targets the two failure modes of naive single-prompt
generation: **context limits** and "an inability to grasp the **distributed
nature** of architectural knowledge" — the relevant facts are scattered across
many files and histories, beyond one prompt's reach. The evaluation finds the
agentic approach "generates better ADRs, and is a promising and practical
approach for automating AKM."

## Why it matters here

Two transfers to this bundle: (1) decision-record authorship is tractable agent
work — consistent with minting decision records as a step of an existing agent
motion (capture) rather than an operator chore; and (2) the
extraction/validation split mirrors this bundle's asserted-then-ratified
stance — generation and verification are separate concerns even when both are
automated.

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:6d6425">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-20-decision-records-as-history-abstraction (2026-07-20)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:6d6425`]**  (co-feeds: `em:ce51fc em:4f5372 em:7fa867`)

**2. LLMs and design rationale / ADRs (current).** Directly on your "would this aid the LLM" question:

- [Using LLMs in Generating Design Rationale for Software Architecture Decisions](https://arxiv.org/abs/2504.20781) (TOSEM 2025) measured how well LLMs *reconstruct* rationale post-hoc: recall 0.63–0.72 but **precision only ~0.27**, with 1.6–3.2% of generated arguments potentially misleading. This is the strongest empirical argument for your proposal: inferring the why after the fact is lossy and partly confabulated, so **rationale recorded at decision time is worth far more than rationale reconstructed later** — and it also warns that agent-authored rationale needs the operator's editorial pass (your existing `verified` ethos, applied to decisions).
- [Context Matters: Context Strategies for Automated ADR Generation](https://arxiv.org/abs/2604.03826) (2026, 750-repo corpus) found context engineering — not model scale — is the dominant factor, and that a **small window of 3–5 related prior decision records** is the optimal context. That's a concrete design datum: a decision node's value to an agent is mostly in its local neighborhood, which is exactly what a tree/graph structure makes cheap to fetch.
- [AgenticAKM](https://arxiv.org/abs/2602.04445) (2026) shows multi-agent workflows generating ADRs from repos beat naive prompting; [Architecture Without Architects](https://arxiv.org/abs/2604.04990) (2026) argues agents now make architectural decisions "almost no one reviews as such" — an operator-side argument for a decision view as an *audit surface*.
