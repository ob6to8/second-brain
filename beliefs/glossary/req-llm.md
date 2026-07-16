---
id: em:b171b5
type: concept
title: req_llm
description: Jido's in-house Elixir LLM client library — built on Req — that owns provider adapters, the model catalog, streaming, and tool-call encoding, and through which the jido_ai layer routes every model call.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, req_llm, jido, elixir, llm, agents]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T07:00:26Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-16 Jido-caveats thread as the client all Jido cognition routes through"
---

# req_llm

The in-house Elixir LLM client that Jido's [`jido_ai`](/beliefs/glossary/jido.md)
reasoning layer is built on (it replaced LangChain in the Jido 2 rewrite). Sitting
on top of the `Req` HTTP client, `req_llm` provides the provider adapters, the
model catalog, streaming, and the tool-call encoding — so **every inference an
agent makes flows through it**. Because Jido's core reducer contains no LLM code by
design, `req_llm` becomes the single dependency under all of a Jido agent's
cognition: its provider coverage, retry/rate-limit semantics, and support for new
model features (prompt caching, extended thinking, changed tool-call formats)
define the reliability envelope of everything the agent thinks. That concentration
of dependency on the fastest-moving surface in the stack is a recurring caveat in
this brain's [BEAM/Jido evaluations](/meta/analysis/beam-deployment-and-jido-2-evaluation.md).

*Seen in:* [2026-07-16 Jido-caveats thread](/meta/threads/2026-07-16-jido-caveats-and-build-agent-linter-loop.md), [jido-distribution-gap-and-req-llm-cognition-dependency analysis](/meta/analysis/jido-distribution-gap-and-req-llm-cognition-dependency.md)

*See also:* [Jido](/beliefs/glossary/jido.md), [ReAct](/beliefs/glossary/react.md)
</content>
