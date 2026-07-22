---
id: em:eec645
type: concept
title: function calling
description: The LLM-provider contract by which a model is shown a set of tool descriptors — name, description, input schema — and responds with a structured request to invoke one, which the host application executes before returning the result for the model's next turn.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, llm, tools, agents, api]
sense: common
timestamp: 2026-07-17
attribution:
  when: 2026-07-17T20:30:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-17 vercel-eve comparison thread"
---

# function calling

Also called tool calling or tool use. The model never runs code; it emits a
validated argument payload against the advertised schema, and the surrounding
loop — hand-written against a raw provider API, or supplied by an SDK or
framework — dispatches, executes, and feeds back. Frameworks differ mainly in
*registration* (how descriptors are assembled: per-request arrays, constructor
objects, filesystem discovery as in [eve](/beliefs/glossary/vercel-eve.md), or
runtime protocol enumeration as in
[MCP](/beliefs/glossary/model-context-protocol.md)) and in the execution
lifecycle around the call, while the descriptor contract itself stays uniform
across providers. That uniform *descriptor* contract hides a fidelity seam,
though: each model is trained to emit calls in its own provider's conventions, so
a harness whose call format is tuned to one model family (Claude Code to
Anthropic's) can see complex, multi-step tool chains degrade when the same loop
drives a non-native model — the reason provider-neutral agent work favors a
neutral integration layer over routing one provider's call shape to another's
model.

*Seen in:* [2026-07-17 vercel-eve comparison thread](/meta/threads/2026-07-17-vercel-eve-comparison-and-jido-host-plan.md), [vercel-eve-comparison analysis](/meta/analysis/vercel-eve-comparison.md), [2026-07-21 multi-model dev environment thread](/meta/threads/2026-07-21-multi-model-dev-environment-and-cross-model-pr-review.md) (the harness↔model tool-calling seam as the quality leak in multi-provider agentic work)
