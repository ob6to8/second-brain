---
id: em:45fda5
type: concept
title: AI drift
description: The cumulative degradation of code quality under AI-assisted development — an agent reaches for whatever pattern it has already seen, so yesterday's substandard addition becomes tomorrow's precedent and the project silently diverges from its author's standards.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, agentic-coding, code-quality, failure-modes, drift]
sense: common
timestamp: 2026-07-23
attribution:
  when: 2026-07-23T18:15:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-23 ai-drift intake thread"
---

# AI drift

The term is Zornek's, from the filed capture
[Guarding Against AI Drift](/knowledge/SWE/agentic/code-quality/guarding-against-ai-drift.md),
which holds the full two-layer countermeasure: automated guardrails for what is
mechanical, deliberately non-delegated human review for what is not, and a
feedback loop that promotes recurring misses into the standards docs the agent
reads. It is the code-authorship analogue of
[invisible degradation](/beliefs/glossary/invisible-degradation.md) — both
compound without emitting a signal until something visibly fails, and both are
answered by announcement mechanisms rather than vigilance. Distinct from a
[drift class](/beliefs/glossary/drift-class.md), which categorizes *corpus*
staleness by its detector; AI drift names the quality trajectory of
agent-authored *code*.

*Seen in:* [Guarding Against AI Drift (Mike Zornek)](/knowledge/SWE/agentic/code-quality/guarding-against-ai-drift.md), [2026-07-23 ai-drift intake thread](/meta/threads/2026-07-23-ai-drift-intake-and-coding-standards-ratification.md)
