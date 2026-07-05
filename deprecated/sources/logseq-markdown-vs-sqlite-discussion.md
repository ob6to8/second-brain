---
type: source
source_type: article
title: "Logseq OG (Markdown) vs Logseq (DB:SQLite) — Community Discussion"
url: "https://discuss.logseq.com/t/logseq-og-markdown-vs-logseq-db-sqlite/34608"
aliases: ["logseq db vs markdown", "logseq sqlite migration"]
tags: [knowledge-management, markdown, sqlite, logseq, file-portability]
authors: ["danzu", "Logseq community"]
date_published: "2025-12-30"
date_captured: "2026-03-03"
summary: >
  Community discussion about Logseq's migration from markdown-first to SQLite-first
  storage. Users raise concerns about Syncthing incompatibility, loss of markdown
  portability, and whether Logseq will remain a "markdown note taking software."
  Cautionary tale for the markdown-vs-database decision.
word_count: 500
related:
  - "[[ai-agent-memory-markdown-files]]"
---

## Original Post by danzu (December 30, 2025)

### Feature Comparison: DB-based vs Markdown Mode

Database-based improvements listed:
- Enhanced data presentation with Gallery View, Kanban View, and Calendar View (coming soon)
- Advanced Properties and Collection/Attributes functionality
- Tag/Class capabilities
- Superior performance with larger graphs
- Improved UX with better Design System and Accessibility
- More reliable sync capabilities

Platform availability for DB mode:
- Web, iOS, iPadOS
- Desktop (macOS, Windows, Linux)
- Android support listed as coming soon
- Web/mobile platforms already have DB mode available

Pending features for DB mode:
- Android support
- Whiteboard
- Publishing capabilities

## Discussion Thread Points

### Image Accessibility Issue
- DjeeAr reported that embedded images were illegible when saved
- Filippo_Salustri clarified that users needed to click through multiple times to access the full-resolution version

### Migration Timing Question
- Jomi asked whether users without DB-specific needs should migrate immediately

### Sync Concerns
- prollymolly inquired about Syncthing compatibility with the database approach
- PhilWolff responded: "syncthing won't sync the DB but any md files...and other assets will sync"
- This highlights a key limitation: Syncthing cannot directly sync SQLite databases, only markdown files and assets

### Long-term Markdown Support
- fragefrank raised concerns about markdown compatibility, questioning whether "LogSeq effectively no longer be a markdown note taking software" post-transition
- danzu's response: "If you do not need the improvements on DB, then you can continue using the MD version"
- This suggests Logseq plans to maintain both markdown and database modes for the foreseeable future

## Key Takeaway

Users can choose to remain on markdown mode if they don't need the DB-specific improvements, but the platform is clearly moving toward SQLite-based storage with enhanced features. The community reaction reveals a deep attachment to file-based portability — the ability to sync with any tool, grep through files, and version with git.
