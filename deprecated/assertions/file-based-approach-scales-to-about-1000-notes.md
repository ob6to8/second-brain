---
type: assertion
tier: primitive
claim: "File-based knowledge stores with grep/text search scale effectively to roughly 500-1000 notes before requiring a database index layer"
confidence: medium
evidence:
  - source: "[[ai-agent-memory-markdown-files]]"
    type: citation
  - source: "[[logseq-markdown-vs-sqlite-discussion]]"
    type: supporting
tags: [knowledge-management, markdown, sqlite, scalability]
date_asserted: "2026-03-03"
supersedes: ""
related: []
---

The DEV.to article identifies three search tiers: basic text search sufficient under 1,000 files, BM25 for 1,000-10,000, hybrid vector+BM25 for 10,000+. Logseq's migration to SQLite was partly motivated by performance with larger graphs. The threshold for needing a database layer is roughly where grep stops being fast enough.
