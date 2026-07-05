# Plan 002: Persistent Conversation Architecture

**Status: EXECUTED 2026-03-03 (via Plan 007 — Shellclaw Integration)**

## Problem

LLM conversations are ephemeral by default. The context window is treated as the source of truth, but it's actually a lossy viewport. Persistence is an afterthought — summaries written at session end, memories the user never inspects, context lost at boundaries.

## Goal

Architect a persistence-first conversation system where:
1. Every exchange (prompt + tool calls + response) is atomically persisted before the next turn
2. The context window is a cache, not the source of truth
3. Conversations are inspectable, searchable, and exportable
4. A fresh agent can reconstruct any conversation by loading from the store
5. Finished threads export to the assertion-graph as source files or assertions

## Key Insight

Simon Willison's `llm` CLI already provides the storage primitive: every exchange is logged to SQLite. The missing piece is a **context loader** that replaces the context window's role as memory.

## Architecture

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│  User input  │────▶│ context-load │────▶│  llm call   │
└─────────────┘     │              │     │             │
                    │ 1. thread DB │     │ prompt +    │
                    │ 2. index.json│     │ loaded ctx  │
                    │ 3. relevance │     │             │
                    └──────────────┘     └──────┬──────┘
                                                │
                                         ┌──────▼──────┐
                                         │  SQLite log │ (automatic)
                                         └──────┬──────┘
                                                │
                                         ┌──────▼──────┐
                                         │  Response   │
                                         └─────────────┘
```

### Components

#### 1. `llm` as the exchange layer
- Install: `brew install llm` / `pipx install llm`
- Every prompt/response is atomically logged to `~/.local/share/io.datasette.llm/logs.db`
- Conversation threading via `llm -c` (continue) or explicit conversation IDs
- Model-agnostic — can use Claude, GPT, local models

#### 2. `scripts/context-load.sh` — the context assembler
Replaces the context window's role as memory. Before each exchange:
1. Query SQLite for the current thread's prior turns (last N, or by relevance)
2. Load `index.json` to find related assertion-graph notes
3. Optionally read referenced notes for deeper context
4. Format as a system prompt or context block
5. Output to stdout for piping into `llm -s`

#### 3. `scripts/thread.sh` — conversation wrapper
Wraps `llm` to enforce the persistence-first protocol:
```bash
# Start a new thread
./scripts/thread.sh new "Why is the context window the unit of work?"

# Continue a thread (loads context automatically)
./scripts/thread.sh continue <thread-id> "How would you architect this?"

# Export a finished thread to assertion-graph
./scripts/thread.sh export <thread-id>
```

#### 4. `scripts/export-conversation.sh` — thread → assertion-graph
Queries `llm logs` for a conversation, then either:
- Writes a source file to `sources/<kebab-title>.md` with `type: source`, `source_type: conversation`
- Or invokes `/conclude` logic to extract assertions from the thread directly into the DAG

The second path is more aligned with Plan 003's architecture — conversations are a means to assertions, not artifacts themselves.

### Context loading strategies

Start simple, evolve:

**v1 — Recency window**
Load the last N exchanges from the thread. Simple, predictable.

**v2 — Recency + related notes**
Last N exchanges + any assertion-graph notes whose tags overlap with the thread's topic.

**v3 — Embedding similarity** (future)
Use `llm embed` to find the most relevant prior turns and notes. Requires pgvector or similar.

## Dependencies

- `llm` — `pipx install llm` or `brew install llm`
- `llm-claude` plugin — `llm install llm-claude-3` (for Claude models via llm)
- `sqlite3` — already available on macOS
- Existing: `jq`, `yq`

## Execution Order

1. Install `llm` and configure with Claude API key
2. Write `scripts/context-load.sh` — SQLite query + index.json lookup
3. Write `scripts/thread.sh` — conversation wrapper
4. Write `scripts/export-conversation.sh` — thread → .md note
5. Test: run a multi-turn thread, export it, verify it appears in index.json
7. Shellcheck all scripts

## Open Questions

- **Tool call logging** — `llm` doesn't log intermediate tool calls. Do we need a wrapper that captures these, or is prompt+response sufficient for the archive?
- **Context budget** — how many prior turns to load? Fixed window? Token-counted? Configurable per thread?
- **Thread discovery** — how does the context loader know which assertion-graph notes are relevant? Tag matching? Full-text search? Embeddings?
- **Editing** — should exported conversations be editable? If so, do edits propagate back to SQLite or is the .md the final form?
- **Claude Code integration** — can this coexist with Claude Code sessions, or is it a parallel workflow? Plan 003's `/conclude` skill is the natural bridge — export triggers assertion extraction.

## Persistence Architecture Decision: Markdown-Canonical, SQLite-Derived

### The question

Plan 002 introduces SQLite (via `llm`) alongside the markdown-based knowledge store from Plan 003. This raises a domain-crossing problem: if assertions and sources live in markdown but conversation turns live in SQLite, linking across domains is awkward. Two clean options exist — everything markdown, or everything SQLite. Research (March 2026) shows the industry has converged on a third answer.

### Industry convergence: markdown-canonical + SQLite-derived

Multiple projects arrived independently at the same pattern:

**Basic Memory** (MCP server for Claude/Obsidian): Markdown files with structured frontmatter are the source of truth. SQLite indexes the knowledge graph for search and traversal. Bidirectional sync — file edits trigger re-indexing, LLM tool calls write files that get indexed. If the database is lost, rebuild from files.

**OpenClaw** (145K+ stars): `MEMORY.md` files are canonical. SQLite at `~/.openclaw/memory/{agentId}.sqlite` stores chunked embeddings for hybrid search. Retrieval uses 70% vector similarity + 30% BM25 keyword matching (89% recall vs 76% pure vector or 68% pure BM25). Pre-compaction flush checkpoints memories to markdown before context overflow.

**Simon Willison's `llm`**: Pure SQLite — `conversations`, `responses`, `responses_fts` (FTS5) tables. Rich schema with tool calls, attachments, token counts. Great for machines, bad for humans (not browsable, not git-diffable).

**Logseq DB**: Migrating from markdown-first to SQLite-first. Community backlash over losing portability, file sync, and the "it's just markdown" promise. Cautionary tale.

**Manus** (acquired by Meta, $2B): Pure markdown — three files per agent session (`task_plan.md`, `notes.md`, deliverable). Works under ~1,000 files. No semantic search, no relational queries.

### Trade-offs

| Factor | Markdown-only | SQLite-only | Markdown + SQLite |
|---|---|---|---|
| Debuggability | Excellent | Poor (need SQL client) | Good |
| Semantic search | None (grep) | FTS5 / embeddings | Full hybrid |
| Git-friendliness | Excellent | Terrible (binary diffs) | Markdown diffs, DB is ephemeral |
| Portability | Universal | Requires SQLite tooling | Files are portable, DB is rebuildable |
| Editor integration | Native | None | Via markdown layer |
| Scalability | Degrades >1K files | Millions of rows | File count for writes, DB for reads |
| Rebuild from scratch | N/A | Must export | Delete DB, re-derive from files |

### Decision for this project

**Markdown-canonical, SQLite-derived.** Aligned with Plan 003's design principles (shell-first, agent-agnostic, files on disk).

- `llm`'s SQLite log persists naturally (it's `llm`'s internal storage — we don't fight it)
- The SQLite log is a **persistent operational record** — the raw reasoning chain, dead ends, full derivation history. Valuable evidence for why you believe something.
- Export converts threads to markdown (sources and/or assertions via `/conclude`)
- `index.json` is the current derived query layer. It happens to be JSON, not SQLite.
- **Upgrade path when corpus demands it:** replace `index.json` with a SQLite index derived from the same markdown files. Same `build-index.sh` concept, different output format. Add FTS5 for full-text, embeddings for semantic search.

The migration path: `markdown → markdown + JSON index → markdown + SQLite index → markdown + postgres + pgvector`. The file layer stays constant; the query layer scales up.

### How conversation turns fit

Two persistence layers, different purposes:

| Layer | Store | Purpose | Example |
|---|---|---|---|
| **Operational log** | `llm` SQLite | Process — how you got there, full reasoning, dead ends | "I searched for X, found Y, concluded Z" |
| **Knowledge store** | Markdown files | Product — curated claims with provenance | `assertions/context-window-is-viewport.md` |

Export is the bridge: `thread.sh export` reads from SQLite, writes to markdown. The SQLite log is never the source of truth for knowledge — only for conversation history.

### Sources

- [Basic Memory — GitHub](https://github.com/basicmachines-co/basic-memory)
- [AI Agent Memory Management: When Markdown Files Are All You Need — DEV Community](https://dev.to/imaginex/ai-agent-memory-management-when-markdown-files-are-all-you-need-5ekk)
- [OpenClaw Memory Architecture — MMNTM](https://www.mmntm.net/articles/openclaw-memory-architecture)
- [Design Patterns for Long-Term Memory in LLM-Powered Architectures — Serokell](https://serokell.io/blog/design-patterns-for-long-term-memory-in-llm-powered-architectures)
- [Logseq OG (markdown) vs Logseq (DB:sqlite) — Logseq Forum](https://discuss.logseq.com/t/logseq-og-markdown-vs-logseq-db-sqlite/34608)
- [LLM CLI — Logging to SQLite](https://llm.datasette.io/en/stable/logging.html)

## Non-Goals (for now)

- Real-time streaming (batch is fine)
- Multi-user threads
- Web UI (CLI-first)
- Replacing Claude Code (complementing it)
- Moving the knowledge store to SQLite (markdown stays canonical)
