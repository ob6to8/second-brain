---
id: em:eeb2bb
type: reference
title: "sagents — agent orchestration framework for Elixir (built on LangChain)"
description: An Elixir library providing AgentServer process management, a middleware system, and state management for building and orchestrating LLM agents on top of the Elixir LangChain library.
resource: https://hex.pm/packages/sagents
provenance: "Distilled from the Hex.pm package page (author brainlid), fetched 2026-07-06"
tags: [agentic, elixir, langchain, agent-framework, orchestration]
timestamp: 2026-07-06
attribution:
  when: 2026-07-07T03:41:02+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# sagents — agent orchestration framework for Elixir (built on LangChain)

Package description (verbatim): *"Agent orchestration framework for Elixir, built
on top of LangChain. Provides AgentServer, middleware system, state management,
and more."*

Sagents gives Elixir developers pre-built building blocks for multi-agent systems
rather than assembling them from scratch on top of Elixir's LangChain bindings:

- **AgentServer** — process-based agent lifecycle/management (idiomatic to
  Elixir's OTP process model).
- **Middleware system** — customizable hooks around agent behavior.
- **State management** — built-in handling of agent state across a run.

**Author:** brainlid. **License:** Apache-2.0. At time of capture: v0.9.0, 28
released versions, actively maintained.

Relevant to this repo's own tooling — this second brain's Elixir tasks
(`mix brain.*`) are unrelated to sagents, but the two sit in the same Elixir/OTP
ecosystem for anyone building Elixir-native agent infrastructure.

# Citations

Hex.pm package page — <https://hex.pm/packages/sagents>
