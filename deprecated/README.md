# Assertion Graph

A knowledge base that turns research into structured claims.

You read articles, watch talks, have conversations. Some of that produces insights worth keeping. This system captures the sources, extracts atomic claims from them, and tracks which claims depend on which evidence. The result is a directed acyclic graph (DAG) where every claim traces back to its origins.

Everything is markdown files and shell scripts. No database, no framework, no server. Git is the history layer. `jq` and `yq` do the heavy lifting.

## The two file types

Every file in the system is one of two things:

### Sources (`sources/`)

External content you've ingested — articles, videos, papers, conversations. Each has YAML frontmatter and the extracted content as markdown.

```yaml
---
type: source
source_type: article
title: "MCP is dead. Long live the CLI."
url: "https://..."
tags: [mcp, cli, llm-tooling, shell]
date_captured: "2026-03-01"
summary: >
  Argues that MCP over-engineers what shell scripts already solve.
---

Full extracted text of the article goes here...
```

Sources are evidence. They don't make claims — they're what claims point to.

### Assertions (`assertions/`)

Atomic claims you believe, with explicit evidence. Two tiers:

**Primitives** are leaf nodes. They make a single claim backed by sources:

```yaml
---
type: assertion
tier: primitive
claim: "The LLM context window is a lossy viewport, not a memory system"
confidence: high
evidence:
  - source: "[[context-engineering-and-persistent-agent-memory]]"
    type: citation
  - source: "[[longform-guide-everything-claude-code]]"
    type: supporting
tags: [context-engineering, llm-architecture]
---

The context window is treated as the unit of work, but it's a temporary,
lossy view. Multiple sources confirm this independently...
```

**Compounds** compose primitives. They have `deps` (which primitives they build on) and an `implication` (the "so what"):

```yaml
---
type: assertion
tier: compound
claim: "Markdown files should be the canonical persistence layer with database indexes derived on demand"
confidence: high
deps:
  - "[[industry-converged-on-markdown-canonical-sqlite-derived]]"
  - "[[file-based-approach-scales-to-about-1000-notes]]"
implication: "The migration path is markdown → JSON index → SQLite index → postgres + pgvector. The file layer stays constant; only the query layer scales up."
evidence:
  - source: "[[logseq-markdown-vs-sqlite-discussion]]"
    type: supporting
tags: [knowledge-management, markdown, sqlite, architecture]
---
```

The `[[wikilinks]]` in evidence and deps are how the DAG is built. They reference other files by ID (filename without `.md`).

## The index

`index.json` is a derived file — generated from the frontmatter of every source and assertion. It contains three arrays:

- **sources** — metadata for each source file
- **assertions** — metadata for each assertion file
- **edges** — the DAG connections (evidence links, dependency links, supersedes links)

Regenerate it anytime with:

```bash
./scripts/build-index.sh
```

If `index.json` is deleted, rebuild it. The markdown files are the source of truth.

## Querying

```bash
# Find everything tagged "agent-memory"
./scripts/query.sh --tag agent-memory

# Search assertion claims for a phrase
./scripts/query.sh --claim "context window"

# Find all compound assertions
./scripts/query.sh --type assertion --tier compound

# Full-text search across all files
./scripts/query.sh --text "pre-compaction flush"

# Walk a compound assertion's dependency tree
./scripts/deps.sh markdown-canonical-with-derived-query-layer-is-optimal-path

# Find orphaned nodes (nothing points to them)
./scripts/orphans.sh

# Find contested or low-confidence assertions
./scripts/contested.sh
```

Every script supports `--describe` to output its interface as JSON:

```bash
./scripts/query.sh --describe
# {"name":"query","description":"Search the knowledge base by tag, claim, type, tier, confidence, or full-text","parameters":{...}}
```

## Adding sources

For URLs:

```bash
# Fetch raw content (auto-detects YouTube, Reddit, arxiv, generic article)
./scripts/ingest.sh https://example.com/some-article

# Output goes to stdout — you create the source file with frontmatter
```

For content that can't be auto-fetched (X/Twitter, paywalled sites), paste the content manually into a new file in `sources/` with the frontmatter from `templates/source.md`.

After adding sources, rebuild the index:

```bash
./scripts/build-index.sh
```

## Extracting assertions

This is the core intellectual work. After researching a topic:

1. Identify atomic claims from your sources
2. Check existing assertions for overlap (`./scripts/query.sh --claim "..."`)
3. Create primitive assertions in `assertions/` with evidence linking to sources
4. When multiple primitives imply something larger, create a compound
5. Rebuild the index

The `/conclude` Claude Code skill automates this from a conversation.

## Conversations

Persistent research conversations via Simon Willison's `llm` CLI:

```bash
# Start a new conversation with knowledge base context
./scripts/thread.sh new "Why is the context window the unit of work?" --topic "context-engineering"

# Continue an existing conversation
./scripts/thread.sh continue sb-20260303-141500 "What about pre-compaction?"

# List all assertion-graph conversations
./scripts/thread.sh list

# Export a conversation as a source file
./scripts/thread.sh export sb-20260303-141500

# Export and prompt for assertion extraction
./scripts/thread.sh conclude sb-20260303-141500
```

`context-load.sh` assembles relevant knowledge base content before each LLM call:

```bash
# By topic (searches tags and claims)
./scripts/context-load.sh --topic "agent memory"

# By assertion (walks deps, reads evidence)
./scripts/context-load.sh --assertion-id "context-window-is-viewport-not-memory"

# By conversation thread (pulls recent messages + related notes)
./scripts/context-load.sh --thread-id "sb-20260303-141500"
```

## Publishing

Generate content for itsjustshell.com from the knowledge base:

```bash
# Blog post from a compound assertion (uses its deps + evidence as context)
./scripts/publish-post.sh markdown-canonical-with-derived-query-layer-is-optimal-path

# Research item from a source (three thesis-grounded bullets)
./scripts/publish-research.sh mcp-is-dead-long-live-the-cli
```

Output goes to `publish/` in NimblePublisher format (Elixir map syntax, not YAML). Files are drafts — review and edit before copying to the Phoenix site.

## LLM abstraction

Scripts that call LLMs use `scripts/lib/llm-call.sh`, which supports three backends:

| Backend | When | How |
|---|---|---|
| `llm` | Conversation threading, persistent logging | Simon Willison's CLI (SQLite-backed) |
| `claude` | Publish scripts, heavy reasoning | Anthropic CLI, no session persistence |
| `stub` | Testing | File-based counter, deterministic "stub response N" |

```bash
source scripts/lib/llm-call.sh
SB_LLM_BACKEND=stub llm_call "test"  # → "stub response 1"
```

## Testing

```bash
./scripts/test/run_all.sh
```

Discovers and runs all `scripts/test/test_*.sh` files. Currently 66 tests across 4 suites (llm-call, log, --describe, context-load).

Tests use `scripts/lib/test-harness.sh`:

```bash
source scripts/lib/test-harness.sh
setup_tmpdir
check_output "$(echo hi)" "hi" "echo works"
check_contains "$json" '"event"' "has event field"
check_file_exists "$path" "file was created"
summary "my tests"
```

## Claude Code skills

Three skills for use within Claude Code sessions:

- `/search` — deep web research (like Perplexity), checks the brain for existing knowledge first
- `/conclude` — extract assertions from a conversation, create source + assertion files, rebuild index
- `/publish` — generate blog posts or research items from knowledge base content

## File format specs

Detailed schemas live in `schema/`:

- `schema/source.md` — source file format
- `schema/assertion.md` — assertion file format (primitives + compounds)
- `schema/conventions.md` — naming, tagging, wikilink rules
- `schema/index.md` — index.json structure and edge derivation rules

## Dependencies

- `jq` — JSON processing
- `yq` — YAML frontmatter parsing
- `llm` — LLM CLI for conversations (`pip install llm`)
- `claude` — Anthropic CLI for publish scripts
- `yt-dlp` — YouTube transcript extraction (optional, for ingestion)

## Directory layout

```
sources/          14 source files (articles, videos, conversations)
assertions/        9 assertion files (7 primitives, 2 compounds)
index.json         Derived DAG index (rebuild with build-index.sh)
schema/            File format specifications
templates/         Frontmatter templates for new files
scripts/           Shell tooling (query, ingest, thread, publish, etc.)
scripts/lib/       Shared libraries (llm-call, log, test-harness)
scripts/test/      Test suite
plans/             Architecture decision records
intake/            URL staging area (not yet ingested)
publish/           Generated content for itsjustshell.com
logs/              JSONL event logs
.claude/skills/    Claude Code skill definitions
CLAUDE.md          Agent instructions (Claude Code reads this)
```
