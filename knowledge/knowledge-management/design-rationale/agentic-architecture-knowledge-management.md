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
