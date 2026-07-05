---
type: assertion
tier: compound
claim: "Markdown files should be the canonical persistence layer with database indexes derived on demand, scaling the query layer independently of the storage layer"
confidence: high
deps:
  - "[[industry-converged-on-markdown-canonical-sqlite-derived]]"
  - "[[file-based-approach-scales-to-about-1000-notes]]"
implication: "The migration path is markdown → markdown + JSON index → markdown + SQLite index → markdown + postgres + pgvector. The file layer stays constant; only the query layer scales up."
evidence:
  - source: "[[logseq-markdown-vs-sqlite-discussion]]"
    type: supporting
  - source: "Reasoning: if the industry converged on this pattern independently and file-based stores work up to ~1000 notes, the correct architecture starts with files and adds database layers only when retrieval outgrows text search. Making the database canonical (Logseq's path) triggers community backlash and loses portability."
    type: reasoning
tags: [knowledge-management, markdown, sqlite, architecture]
date_asserted: "2026-03-03"
related: []
---

The Logseq migration from markdown-canonical to SQLite-canonical drew community resistance precisely because it violated this principle. Users value the ability to sync, grep, git-diff, and edit with any tool. The database layer should be a performance optimization, not the source of truth.
