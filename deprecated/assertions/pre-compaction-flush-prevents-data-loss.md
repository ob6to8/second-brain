---
type: assertion
tier: primitive
claim: "Pre-compaction flush converts context overflow from data loss into a checkpoint by persisting memories before summarization"
confidence: high
evidence:
  - source: "[[openclaw-memory-architecture]]"
    type: citation
  - source: "[[longform-guide-everything-claude-code]]"
    type: supporting
tags: [context-engineering, agent-memory, compaction]
date_asserted: "2026-03-03"
supersedes: ""
related: []
---

OpenClaw triggers automatic memory save when tokens approach compaction threshold (context window minus reserve floor minus 4,000 token soft buffer). The longform Claude Code guide describes the same pattern: PreCompact hooks save state before compaction summarizes it away. Both treat compaction as a destructive operation that requires a checkpoint.
