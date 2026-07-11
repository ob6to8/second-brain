---
id: sb:c0961a
type: reference
title: "Effective context engineering for AI agents (Anthropic)"
description: Anthropic frames an agent as an LLM autonomously using tools in a loop, where each turn accumulates context that must be continuously curated to preserve a finite attention budget.
resource: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
provenance: "Distilled from Anthropic Applied AI (Rajasekaran, Dixon, Ryan, Hadfield), 2025-09-29"
tags: [agentic-loop, ai-agents, context-engineering, tool-use, attention-budget, memory]
timestamp: 2026-07-06
---

# Effective context engineering for AI agents (Anthropic)

Anthropic defines agents simply as *"LLMs autonomously using tools in a loop,"*
making iterative tool use the central mechanism rather than naming discrete
reason–act–observe steps. Their key concern is what the loop does to context: *"An
agent running in a loop generates more and more data that could be relevant for the
next turn of inference, and this information must be cyclically refined."* Context
engineering — curating the optimal set of tokens across system prompt, tools,
message history, and external data — becomes the loop's core management function,
replacing static prompt-writing. Because attention is a finite budget, each turn's
growing output risks context pollution, so engineers must select what stays
relevant downstream. They advocate just-in-time retrieval (agents pull data via
tools rather than preloading), plus compaction, structured note-taking, and
sub-agent architectures to sustain coherent, goal-directed behavior across long
multi-turn agentic runs.

## 2026 currency check

Researched 2026-07-06, roughly nine months after publication. **Verdict: still
accurate, and reinforced rather than superseded.** No direct critique of the
essay's core framing (context as a finite, curated resource) turned up in
research — the surrounding discourse extends and confirms it rather than
contradicting it.

- **A same-day companion launch, not a later revision.** On the same date this
  essay published (2025-09-29), Anthropic also shipped a
  [Context Editing API and a Memory Tool](/knowledge/SWE/agentic-coding/context-engineering/claude-context-editing-and-memory-tool.md)
  on the Claude Developer Platform. These turn two of the essay's four named
  techniques into literal product primitives: context editing automates
  **compaction** (server-side, cache-preserving removal of stale tool
  calls/results), and the memory tool operationalizes **structured
  note-taking** (a persistent, file-based memory directory). Anthropic reports
  a 29% performance improvement from context editing alone, 39% combined with
  the memory tool, and an 84% token reduction in a 100-turn evaluation — direct
  empirical support for the essay's central claim that curating context (not
  maximizing it) is what improves agent performance.
- **Independent research reinforces the thesis.** Chroma's
  ["context rot" study](/knowledge/SWE/agentic-coding/context-engineering/context-rot-chroma-research.md)
  (2025-07-14, predating this essay) tested 18 frontier models and found
  performance degrades non-uniformly as input length grows — sometimes *worse*
  on long, coherent text than on the same content shuffled into incoherence —
  concluding that *"effective context engineering [is] essential for reliable
  performance."* That directly corroborates the attention-budget framing here:
  bigger context windows do not remove the need for curation.
- **Just-in-time retrieval has been refined, not reversed.** By 2026, industry
  discussion (engineering blogs from TrueFoundry, Sourcegraph, and others,
  synthesized via search rather than a single primary source) has converged on
  *hybrid* strategies — preload a small amount of high-value static context for
  speed and cache efficiency, then fetch the rest just-in-time via tool calls —
  rather than treating JIT retrieval as an absolute. This refines the essay's
  original guidance (which already distinguished "just-in-time" from full
  preloading) rather than contradicting it.
- **Sub-agent architectures remain current** — consistent with Claude Code's
  own subagent tooling (the Task tool; `.claude/agents/` definitions); no
  material change found.

# Citations

Anthropic, "Effective context engineering for AI agents", 2025-09-29 —
<https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents>
