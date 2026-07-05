---
type: assertion
tier: primitive
claim: "The LLM context window is a lossy viewport into an ongoing process, not a memory system"
confidence: high
evidence:
  - source: "[[context-engineering-and-persistent-agent-memory]]"
    type: citation
  - source: "[[longform-guide-everything-claude-code]]"
    type: supporting
  - source: "[[design-patterns-long-term-memory-llm-architectures]]"
    type: supporting
  - source: "[[state-of-agentic-coding-ep3-armin-ben]]"
    type: supporting
tags: [context-engineering, llm-architecture, agent-memory]
date_asserted: "2026-03-03"
supersedes: ""
related: []
---

The context window is treated as the unit of work, but it's a temporary, lossy view. The current pattern — build up context, hit a boundary, scramble to persist, start fresh — loses information by design. Persistence is reactive, not structural. Multiple sources confirm this independently: the longform Claude Code guide calls it "context rot," Armin/Ben note compaction improvements in Opus 4.6, and Serokell terms it "conversational amnesia."
