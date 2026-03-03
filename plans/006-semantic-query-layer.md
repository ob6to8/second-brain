# Plan 006: Semantic Query Layer (SQLite + Embeddings)

## Context

The second brain currently uses `build-index.sh` to derive `index.json` from markdown frontmatter. Queries go through `query.sh` which does text matching against this index. This works at current scale (~12 sources, ~9 assertions) but has two limitations:

1. **No semantic search.** You can only find assertions by exact tag/keyword match, not by meaning. Searching "career transitions" won't find an assertion about "people leaving jobs to start consulting" unless the words overlap.
2. **No cross-tool access.** The brain is Claude Code-only. No other AI client can query it.

This plan adds a derived SQLite database with vector embeddings alongside the existing markdown files. Markdown stays canonical. The database is a disposable compiled artifact — delete it, re-run the build script, it regenerates.

### Reference: "Open Brain" architecture

Video: [Nate's Open Brain — Agent-Readable Memory Architecture](https://www.youtube.com/watch?v=2JiMmye2ezg)

The video proposes a Postgres + pgvector + MCP server architecture for cross-tool AI memory. Key ideas:

- **Database-first storage** with vector embeddings for semantic search
- **MCP server** exposing search/list/stats to any AI client
- **Low-friction capture** via Slack → Supabase edge function → auto-classify
- **Cross-tool access** — one brain, every AI

### Where we agree with the video

- Memory is the bottleneck, not model selection
- You should own your data with no SaaS lock-in
- MCP is the right protocol for cross-tool access
- Storage and retrieval should be separate layers

### Where we diverge

| Dimension | Open Brain | This Repo |
|---|---|---|
| Canonical store | Postgres rows | Markdown files |
| Search | Vector embeddings (semantic) | Grep/text + frontmatter queries |
| Structure | Flat thoughts with auto-extracted metadata | Typed content (source vs assertion) with explicit DAG |
| Knowledge model | Bag of thoughts | Assertion graph with provenance chains |
| Capture | Low-friction (type anything, LLM classifies) | High-friction, high-fidelity (human decomposes claims) |
| Multi-tool access | Yes, via MCP | No — Claude Code only |
| Portability | Postgres dump | `git clone` |

The video's system is an **operational log** — a stream of raw thoughts optimized for capture velocity. This repo is a **curated knowledge store** optimized for epistemic rigor. These are complementary, not competing (see assertion `[[operational-log-and-knowledge-store-serve-different-purposes]]`).

### What we're taking from the video

1. **Semantic search via embeddings** — find assertions by meaning, not just keywords
2. **Cross-tool access via MCP** — let any AI client query the brain
3. **Low-friction capture path** — quick thoughts into `intake/` without full structure

### What the video is missing that we already have

- **Provenance** — evidence edges trace claims back to sources
- **Contradiction detection** — `contested.sh` finds conflicting assertions
- **Composability** — compound assertions with explicit deps enable reasoning chains
- **Source fidelity** — original sources preserved, not auto-summarized

## Design Principles

- **Files are truth, database is cache.** Same relationship as source code to compiled binary. Never edit the database directly.
- **Shell-first.** `build-index.sh` gains an embedding step. No new runtime dependencies beyond SQLite.
- **Deletable database.** `rm brain.db && ./scripts/build-index.sh` must fully regenerate everything.
- **Existing assertion `[[markdown-canonical-with-derived-query-layer-is-optimal-path]]`** is the governing design decision (confidence: high).

## Architecture

```
Markdown files (canonical)
       │
       ▼
build-index.sh
       │
       ├──► index.json  (existing — frontmatter extract, DAG edges)
       │
       └──► brain.db    (new — SQLite + sqlite-vec)
              ├── sources table
              ├── assertions table
              ├── edges table
              └── embeddings (via sqlite-vec)
```

### SQLite schema (sketch)

```sql
CREATE TABLE sources (
  id TEXT PRIMARY KEY,
  title TEXT,
  source_type TEXT,
  tags TEXT,  -- JSON array
  content TEXT,
  file TEXT
);

CREATE TABLE assertions (
  id TEXT PRIMARY KEY,
  tier TEXT,
  claim TEXT,
  confidence TEXT,
  tags TEXT,  -- JSON array
  deps TEXT,  -- JSON array
  content TEXT,
  file TEXT
);

CREATE TABLE edges (
  from_id TEXT,
  to_id TEXT,
  type TEXT,  -- evidence | dependency | supersedes
  PRIMARY KEY (from_id, to_id, type)
);

-- sqlite-vec virtual table for embeddings
CREATE VIRTUAL TABLE embeddings USING vec0(
  id TEXT PRIMARY KEY,
  embedding FLOAT[1536]
);
```

### Embedding generation

Options (evaluate during implementation):
1. **Local model** (e.g., `sentence-transformers` via Python one-liner) — free, no API key, slower
2. **OpenAI `text-embedding-3-small`** — cheap (~$0.02/M tokens), fast, requires API key
3. **`llm embed` via Simon Willison's `llm` CLI** — already in the ecosystem, supports multiple backends

Preference: option that requires fewest new dependencies and works offline.

### MCP exposure

Once `brain.db` exists, a thin MCP server exposes:
- `semantic_search(query, limit)` — vector similarity search
- `query(tags, type, tier, confidence)` — structured query (replaces query.sh for MCP clients)
- `deps(id)` — walk DAG from assertion
- `stats()` — counts, tag distribution, confidence breakdown

This follows the CLI-MCP convention from plan 004 — the shell scripts are primary, MCP server is a thin wrapper.

## Phases

### Phase 1: SQLite build step
- Extend `build-index.sh` to emit `brain.db` alongside `index.json`
- Populate sources, assertions, edges tables from frontmatter
- Full-text search via SQLite FTS5 (no embeddings yet — already better than grep)

### Phase 2: Embeddings
- Add vector embeddings for claims and source content
- Evaluate embedding provider (local vs API)
- Add `semantic-search.sh` script
- Add `sqlite-vec` extension

### Phase 3: MCP server
- Thin server wrapping the shell scripts / SQLite queries
- Register via `claude mcp add`
- Test from Claude Code + at least one other MCP client

### Phase 4: Intake pipeline
- Low-friction capture: quick thoughts → `intake/` as unstructured markdown
- Periodic triage: review intake, promote to sources/assertions or discard

## Dependencies

- `sqlite3` (already on macOS)
- `sqlite-vec` extension (Phase 2)
- Embedding model TBD (Phase 2)

## Open Questions

- Should `index.json` be retired once `brain.db` exists, or keep both? (Leaning: keep both — JSON is human-readable, SQLite is machine-queryable)
- Embedding dimensionality — 1536 (OpenAI) vs 384 (MiniLM) vs other?
- Should the MCP server live in this repo or in a separate repo following plan 004's convention?

## Status

Pending.
