---
id: em:e7c96f
type: concept
title: two-tier memory
description: An agent-memory architecture splitting a fast, private, per-agent working store from a slow, shared, curated canonical store, so agents write freely to their own tier and promote validated knowledge into the shared tier through a gatekeeper.
provenance: "Agent-distilled glossary definition, Claude Code session"
verified: false
sense: common
tags: [agent-memory, architecture, knowledge-management, swarm]
timestamp: 2026-07-17
attribution:
  when: 2026-07-17T18:52:15Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-17 GenServer-agent-minds thread as the load-bearing memory model"
---

# two-tier memory

The pattern mirrors how a human organization holds knowledge: individuals keep fast,
messy, private notes, and a curated shared wiki holds what has been validated and
deduplicated. The split is what makes a multi-agent system *learn as a whole* rather than
as isolated parts — the failure mode it avoids is a fleet of agents each with a private
silo, which re-derives the same knowledge and deduplicates nothing across agents.
Promotion from the private tier to the shared tier runs through a single gatekeeper (a
[librarian-write-broker](/beliefs/glossary/librarian-write-broker.md)) that enforces the
dedup, taxonomy, and provenance invariants, so one agent's discovery becomes the whole
fleet's. In this brain's proposed instantiation the shared tier is the canonical
[elixir-mind](/beliefs/glossary/elixir-mind.md) corpus and each agent's private tier is
its own working [agent-memory](/beliefs/glossary/agent-memory.md).

*Seen in:* [agents-as-genservers-with-per-agent-okf-mind](/meta/analysis/agents-as-genservers-with-per-agent-okf-mind.md), [2026-07-17 escape-rate plan and GenServer agent minds](/meta/threads/2026-07-17-escape-rate-plan-and-genserver-agent-minds.md)

*See also:* [agent-memory](/beliefs/glossary/agent-memory.md), [librarian-write-broker](/beliefs/glossary/librarian-write-broker.md), [GenServer](/beliefs/glossary/genserver.md)
