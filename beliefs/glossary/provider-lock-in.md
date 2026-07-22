---
id: em:1341c6
type: concept
title: provider lock-in
description: The condition of being practically bound to a single model vendor because the surrounding tooling, workflow, or product is coupled to that vendor, making it costly to switch to — or mix in — other providers' models.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, llm, vendor, strategy, multi-model]
sense: common
timestamp: 2026-07-21
attribution:
  when: 2026-07-21
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "framing term of the 2026-07-21 multi-model dev environment thread"
---

# provider lock-in

A specialization of vendor lock-in to the model layer. What locks you is the
*coupling point*, not the model: an integrated product whose only surface is one
vendor's app, or a [harness](/beliefs/glossary/harness.md) whose
[tool-calling](/beliefs/glossary/function-calling.md) is tuned to one provider's
conventions. The escape is to move the coupling to a neutral surface — reach
models through an [OpenAI-compatible](/beliefs/glossary/openai-compatible-api.md)
[LLM gateway](/beliefs/glossary/llm-gateway.md), or route a workflow through a
provider-agnostic medium (e.g. cross-model code review conducted over GitHub pull
requests, where author and reviewer models never share a harness). The tension is
that the most seamless single-vendor experience is often the most locked-in,
because seamlessness comes precisely from the vendor controlling both the model
and the tooling around it.

*Seen in:* [2026-07-21 multi-model dev environment thread](/meta/threads/2026-07-21-multi-model-dev-environment-and-cross-model-pr-review.md), [provider-agnostic coding-agent tooling note](/knowledge/SWE/agentic/multi-model/provider-agnostic-coding-agent-tooling.md)

*See also:* [LLM gateway](/beliefs/glossary/llm-gateway.md), [commoditize your complement](/beliefs/glossary/commoditize-your-complement.md)
