---
type: source
source_type: article
title: "Basic Memory — Local-First Knowledge Management via MCP"
url: "https://github.com/basicmachines-co/basic-memory"
aliases: ["basic memory", "basic memory mcp"]
tags: [ai, agent-memory, knowledge-graph, mcp, markdown, sqlite, obsidian]
authors: ["basicmachines-co"]
date_published: ""
date_captured: "2026-03-03"
summary: >
  Open-source MCP server that uses markdown files as canonical knowledge store
  with SQLite as a derived index layer. Implements entity-observation-relation
  model for building traversable knowledge graphs. Bidirectional sync between
  files and database.
word_count: 800
related:
  - "[[openclaw-memory-architecture]]"
  - "[[llm-cli-logging-to-sqlite]]"
---

## What It Is

Basic Memory is an open-source, local-first knowledge management system that enables persistent AI conversations. The core innovation allows large language models to both read from and write to a personal knowledge base stored as Markdown files on your computer, creating bidirectional information flow rather than ephemeral chat interactions.

## Storage Model

- All knowledge persists as Markdown files in local directories (default: `~/basic-memory`)
- Files contain structured metadata through frontmatter (title, type, permalink, tags)
- SQLite database indexes and enables searching across files
- Everything remains under user control by default (no cloud requirement)

## Knowledge Structure

Files organize information into three semantic components:

1. **Entities**: Individual topics with metadata and unique permalinks
2. **Observations**: Categorized facts using bracket notation like `[method]` or `[tip]`
3. **Relations**: Wiki-style links connecting entities (e.g., `relates_to [[Coffee Bean Origins]]`)

This allows the system to build traversable knowledge graphs where AI can follow semantic connections.

## Integration Method

Implements the Model Context Protocol (MCP) for compatibility with Claude Desktop and VS Code:

```json
"command": "uvx",
"args": ["basic-memory", "mcp"]
```

Exposes tools like `write_note()`, `read_note()`, `search_notes()`, and `build_context()`.

## Key Features

- **Persistence**: LLMs load context from local files without copy-pasting; notes save in real-time as Markdown
- **Search & Navigation**: Full-text search, semantic navigation via knowledge graph relations, recent activity tracking
- **Cloud Extension** (optional): Bidirectional sync between local files and cloud, per-project routing, OAuth authentication
- **Developer Tools**: CLI for note creation/editing/deletion with operations like `append`, `find_replace`, `replace_section`; JSON output formatting

## Technical Implementation

- **Language**: Python 3.12+
- **Dependencies**: Loguru (structured logging), uv (package management), optional rclone integration
- **Data Flow**: Files parsed → Entity/Observation/Relation objects → SQLite indexing → MCP tools → JSON-RPC to AI clients
- **Logging**: File-based for CLI/MCP (prevents protocol corruption), stdout for API/Docker; configurable via `BASIC_MEMORY_LOG_LEVEL`; 10MB rotation with 10-day retention at `~/.basic-memory/basic-memory.log`

## Telemetry

Collects minimal anonymous data (cloud login impressions, promo banner interactions). Opt-out via `BASIC_MEMORY_NO_PROMOS=1`. Does NOT collect: file contents, note titles, PII, IP addresses, or per-command tracking. Uses Umami Cloud analytics.

## Usage Workflow

1. Install via `uv tool install basic-memory`
2. Configure MCP in Claude Desktop or VS Code
3. Converse naturally, asking AI to create or retrieve notes
4. Reference topics using simple Markdown linking syntax
5. AI traverses knowledge graph for rich context
6. Changes persist locally; optional cloud sync available

## Project Status

- 2.6k GitHub stars, 169 forks
- 1,195+ commits on main branch
- 38 open issues, 2 pull requests
- Licensed under AGPL v3
- Includes optional commercial cloud offering with 20% OSS discount code "BMFOSS"
