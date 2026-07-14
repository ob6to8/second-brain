---
id: sb:acf52e
type: concept
title: model cascade
description: A cost strategy that routes each request to the cheapest model likely to handle it and escalates to a more capable, costlier model only on failure or low confidence — trading a small quality risk for large average-cost savings.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, llm-orchestration, cost-optimization, routing, cascade]
sense: common
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T12:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-13 advisor-pattern thread as an industry parallel to the advisor pattern"
---

# model cascade

A cost-optimization strategy that routes each request to the cheapest model
likely to handle it and **escalates** to a more capable (and costlier) model only
on failure or low confidence — trading a small quality risk on individual
requests for large average-cost savings across a mixed request load. The approach
was popularized by FrugalGPT-style research on LLM API cost reduction. It is a
relative of the [advisor pattern](/beliefs/glossary/advisor-pattern.md) and
[orchestrator pattern](/beliefs/glossary/orchestrator-pattern.md): all three are
application-level orchestration across separate, complete inferences, as opposed
to the model-internal routing of [mixture-of-experts](/beliefs/glossary/mixture-of-experts.md).

*Seen in:* [2026-07-13 advisor-pattern thread](/meta/threads/2026-07-13-advisor-pattern-and-rolling-your-own-harness.md)
