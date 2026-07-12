---
id: sb:44f899
type: concept
title: Jido
description: An Elixir agent framework (2.x, 2026) that models agents as pure immutable data processed through a single cmd/2 reducer, with schema-validated Actions doubling as LLM tools, CloudEvents-based Signals, runtime-interpreted Directives, and GenServer-backed supervision; its jido_ai layer adds LLM reasoning strategies.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, jido, elixir, agents, multi-agent, beam]
timestamp: 2026-07-12
---

# Jido

An Elixir framework for autonomous agents and multi-agent systems (2.x stable since early 2026). Its core move is separating the agent from its runtime: an agent is **pure immutable data** — schema-validated state plus signal routes — processed through a single `cmd(agent, {Action, params}) → {updated_agent, directives}` reducer, so decision logic is replayable and testable without an LLM. Around that core: **Actions** (validated functions that double as LLM-callable tools), **Signals** ([CloudEvents](/beliefs/glossary/cloudevents.md)-compliant messages with trie-based routing), **Directives** (structs the runtime interprets for side effects like spawn/schedule/emit), and a GenServer-backed supervised runtime on the [BEAM](/beliefs/glossary/beam.md); the separate `jido_ai` layer adds LLM reasoning strategies ([ReAct](/beliefs/glossary/react.md) by default). Notable gap as of mid-2026: no cross-node distribution story.

*Seen in:* [BEAM/Jido evaluation](/meta/analysis/beam-deployment-and-jido-2-evaluation.md), [dark-factory scenario analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
