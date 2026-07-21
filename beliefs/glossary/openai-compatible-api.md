---
id: em:c40dab
type: concept
title: OpenAI-compatible API
description: The de-facto request/response schema — OpenAI's `/v1/chat/completions` shape — that most model providers and gateways also implement, so a client written against it can target many different backends by changing only the base URL and API key.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, llm, api, interoperability]
sense: common
timestamp: 2026-07-21
attribution:
  when: 2026-07-21
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-21 multi-model dev environment thread (the basis for gateway-agnostic tooling)"
---

# OpenAI-compatible API

Its significance is interoperability: because the schema became a lowest common
denominator, provider swaps collapse to a config change rather than a client
rewrite, and it is the substrate that lets an
[LLM gateway](/beliefs/glossary/llm-gateway.md) present many backends behind one
interface. The trade-off is exactly that lowest-common-denominator character —
provider-specific features (extended reasoning modes, native caching controls,
bespoke tool-calling formats) may not map cleanly through the compatible surface,
so portability is bought against access to a provider's full capability set.

*Seen in:* [2026-07-21 multi-model dev environment thread](/meta/threads/2026-07-21-multi-model-dev-environment-and-cross-model-pr-review.md), [cross-model PR review GitHub Action](/knowledge/SWE/agentic/multi-model/cross-model-pr-review-github-action.md)

*See also:* [LLM gateway](/beliefs/glossary/llm-gateway.md), [function calling](/beliefs/glossary/function-calling.md)
