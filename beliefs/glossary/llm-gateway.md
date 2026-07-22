---
id: em:27ea1b
type: concept
title: LLM gateway
description: A service exposing a single, usually OpenAI-compatible API endpoint that fronts many model providers at once, routing each request to a chosen model and layering on cross-cutting concerns like failover, caching, key control, and usage logging.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, llm, api, infrastructure, multi-model]
sense: common
timestamp: 2026-07-21
attribution:
  when: 2026-07-21
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-21 multi-model dev environment thread (OpenRouter and its alternatives)"
---

# LLM gateway

Also called an AI gateway. A client integrates once — one key, one
[OpenAI-compatible](/beliefs/glossary/openai-compatible-api.md) schema — instead
of wiring each provider's SDK and billing separately. The label spans several
overlapping shapes that are worth distinguishing: a pure **router** picks the
best model per request; a **model aggregator** exposes many providers under one
API and one bill; a **gateway** proper adds production control (policy, logging,
key vaulting, rate limits) on top. OpenRouter is the aggregator most people mean;
LiteLLM is the canonical self-hosted option; Portkey and Cloudflare AI Gateway
lead with production controls. Because the interface is standardized, swapping the
underlying model — or the gateway itself — is typically a base-URL-and-key change,
which is what makes a gateway the pragmatic hedge against
[provider lock-in](/beliefs/glossary/provider-lock-in.md).

*Seen in:* [2026-07-21 multi-model dev environment thread](/meta/threads/2026-07-21-multi-model-dev-environment-and-cross-model-pr-review.md), [provider-agnostic coding-agent tooling note](/knowledge/SWE/agentic/multi-model/provider-agnostic-coding-agent-tooling.md), [cross-model PR review GitHub Action](/knowledge/SWE/agentic/multi-model/cross-model-pr-review-github-action.md)

*See also:* [OpenAI-compatible API](/beliefs/glossary/openai-compatible-api.md), [provider lock-in](/beliefs/glossary/provider-lock-in.md), [model cascade](/beliefs/glossary/model-cascade.md)
