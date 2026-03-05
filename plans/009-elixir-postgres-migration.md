# Plan 009: Migrate Assertion Graph to Elixir + Postgres

**Status: PENDING**

## Context

The assertion graph project hit the complexity ceiling of bash: no data structures on macOS bash 3.2, DAG traversal hacks, manual error handling everywhere. The user has committed to Elixir + Postgres as the stack going forward. Key architectural shifts:

- **Postgres-canonical** — data lives in postgres, not markdown files. Markdown becomes an export/view format rendered on demand.
- **Jido actions** replace shell scripts as composable units of work.
- **Tidewave** provides dev-time MCP access to the running app.
- **New repo** — the Elixir project has a completely different structure. Old repo becomes migration source.
- **Conversations in Postgres** — no more llm CLI + SQLite dependency.

Current data is small (14 sources, 9 assertions, 21 edges) — migration is trivial.

## Postgres Schema

```
sources
  id          text PK (kebab-case slug)
  title       text NOT NULL
  source_type text (article|video|paper|journal|transcript|conversation)
  url         text
  aliases     text[]
  tags        text[]
  authors     text[]
  channel     text
  date_published date
  date_captured  date NOT NULL
  summary     text
  duration    text
  word_count  integer
  body        text
  related     text[]
  timestamps

assertions
  id          text PK (kebab-case slug)
  tier        text NOT NULL (primitive|compound)
  claim       text NOT NULL
  confidence  text DEFAULT 'high' (high|medium|low|contested)
  tags        text[]
  date_asserted date NOT NULL
  implication text (compound only)
  body        text
  related     text[]
  timestamps

edges
  id          bigserial PK
  from_id     text NOT NULL
  to_id       text NOT NULL
  edge_type   text NOT NULL (evidence|dependency|supersedes)
  evidence_type text (citation|supporting|reasoning|axiom — for evidence edges)
  timestamps
  UNIQUE(from_id, to_id, edge_type)

conversations
  id          text PK (sb-YYYYMMDD-HHMMSS format)
  topic       text
  tags        text[]
  status      text DEFAULT 'active' (active|concluded|exported)
  timestamps

messages
  id          bigserial PK
  conversation_id text FK -> conversations
  role        text (user|assistant|system)
  content     text
  token_count integer
  timestamps
```

GIN indexes on all `tags` columns. Indexes on `edges(from_id, edge_type)` and `edges(to_id, edge_type)`.

## Script → Action Mapping

| Bash script | Jido Action | Mix task |
|---|---|---|
| `build-index.sh` | **Eliminated** | — |
| `query.sh` | `Actions.Query` | `mix ag.query` |
| `deps.sh` | `Actions.WalkDeps` | `mix ag.deps` |
| `orphans.sh` | `Actions.FindOrphans` | `mix ag.orphans` |
| `contested.sh` | `Actions.FindContested` | `mix ag.contested` |
| `ingest.sh` | `Actions.Ingest` | `mix ag.ingest` |
| `context-load.sh` | `Actions.LoadContext` | — |
| `thread.sh` | `Actions.Thread` | `mix ag.thread` |
| `export-conversation.sh` | `Actions.ExportConversation` | — |
| `publish-post.sh` | `Actions.PublishPost` | `mix ag.publish` |
| `publish-research.sh` | `Actions.PublishResearch` | `mix ag.publish` |
| `lib/llm-call.sh` | **jido_ai** | — |

Skills → Agents:
- `/conclude` → `Agents.ConcludeAgent`
- `/search` → `Agents.SearchAgent`

## Phases

### Phase 1: Foundation

Ecto schemas, core read queries, data migration. The app compiles and can answer every question the bash scripts could.

1. `mix phx.new assertion_graph --no-html --no-assets --no-mailer --no-dashboard`
2. Add deps: `jido`, `jido_action`, `tidewave` (dev only)
3. Create migrations for `sources`, `assertions`, `edges`
4. Implement Ecto schemas with changesets
5. Write data migration script (`priv/repo/seeds/migrate_markdown.exs`) — reads old repo's markdown files + `index.json`, inserts into postgres
6. Implement actions: `Query`, `WalkDeps`, `FindOrphans`, `FindContested`
7. Implement `Export.Markdown` — render any record as markdown on demand
8. Write Mix tasks: `mix ag.query`, `mix ag.deps`, `mix ag.orphans`, `mix ag.contested`
9. Add Tidewave to dev endpoint
10. Tests for all schemas and actions
11. Verify: compare output of old bash scripts vs new Mix tasks for same queries

**After Phase 1:** All data in Postgres. Read-only operations work. Tidewave gives Claude Code `project_eval` access.

### Phase 2: Write Path

Ingestion, assertion creation, conversation management. The app can grow its own knowledge base.

1. Add deps: `jido_ai`, `req`, `floki` (HTML parsing)
2. Implement content fetchers: `Ingestion.YouTube` (yt-dlp), `Ingestion.Reddit` (JSON API), `Ingestion.Article` (Req + Floki), `Ingestion.Arxiv`
3. Implement actions: `Ingest`, `CreateAssertion`, `UpdateAssertion`
4. Create `conversations` and `messages` migrations
5. Implement actions: `Thread` (new/continue/list/conclude), `ExportConversation`
6. Configure jido_ai with Anthropic provider
7. Implement `LoadContext` — composes Query + WalkDeps to assemble LLM context
8. Mix tasks: `mix ag.ingest`, `mix ag.assert`, `mix ag.thread`
9. Tests with HTTP fixtures (Bypass for external APIs)

**After Phase 2:** Full CRUD. URL ingestion works. Conversations stored in Postgres. No markdown files needed.

### Phase 3: Agents + MCP

The intelligence layer. Multi-step workflows and tool exposure.

1. Implement `Agents.ConcludeAgent` — decompose conversation into claims, check for existing assertions, create new ones with evidence links
2. Implement `Agents.SearchAgent` — web research + knowledge base cross-reference
3. MCP tool exposure — evaluate options:
   - Tidewave `project_eval` with documented function signatures in CLAUDE.md
   - Custom MCP server via `hermes_mcp` wrapping Jido actions
   - Wait for Tidewave custom tool registration if it ships
4. Update CLAUDE.md for the new project
5. Integration tests: ingest URL → create assertions → verify edges → query back

**After Phase 3:** Full feature parity with bash system. All operations available via MCP.

### Phase 4: Scale

Production hardening. Only execute when the corpus demands it.

1. `pg_trgm` + GIN indexes for fuzzy text search
2. `tsvector` full-text search on claims and source bodies
3. Fly.io deployment with Postgres snapshots
4. Optional: `pgvector` for semantic search / embeddings
5. Optional: LiveView dashboard for visual graph browsing

## Project Structure

```
assertion_graph/
  config/
    config.exs, dev.exs, prod.exs, runtime.exs, test.exs
  lib/
    assertion_graph/
      application.ex
      repo.ex
      schema/
        source.ex, assertion.ex, edge.ex, conversation.ex, message.ex
      actions/
        query.ex, walk_deps.ex, find_orphans.ex, find_contested.ex
        ingest.ex, create_assertion.ex, update_assertion.ex
        load_context.ex, thread.ex, export_conversation.ex
        publish_post.ex, publish_research.ex
      agents/
        conclude_agent.ex, search_agent.ex
      ingestion/
        youtube.ex, reddit.ex, article.ex, arxiv.ex
      export/
        markdown.ex
    assertion_graph_web/
      endpoint.ex, router.ex
    mix/
      tasks/
        ag.query.ex, ag.deps.ex, ag.orphans.ex, ag.contested.ex
        ag.ingest.ex, ag.assert.ex, ag.thread.ex, ag.publish.ex
  priv/
    repo/
      migrations/
      seeds/
        migrate_markdown.exs
  test/
  mix.exs
  fly.toml
```

## Dependencies

```elixir
{:phoenix, "~> 1.7"},
{:ecto_sql, "~> 3.11"},
{:postgrex, ">= 0.0.0"},
{:jason, "~> 1.4"},
{:jido, "~> 2.0"},
{:jido_action, "~> 1.0"},
{:jido_ai, "~> 0.5"},        # Phase 2
{:req, "~> 0.5"},             # Phase 2
{:floki, "~> 0.36"},          # Phase 2
{:tidewave, "~> 0.5", only: :dev},
{:mox, "~> 1.0", only: :test},
{:bypass, "~> 2.1", only: :test}
```

## What Happens to Old Files

| Current | Fate |
|---|---|
| `sources/*.md`, `assertions/*.md` | Migrated to Postgres via seed script, then archived |
| `index.json` | Edges extracted during migration, then deleted |
| `schema/*.md` | Docs only — Ecto schemas are source of truth |
| `templates/*.md` | Eliminated — changesets enforce structure |
| `scripts/*.sh` | Replaced by Jido Actions + Mix tasks |
| `.claude/skills/*` | Replaced by Jido Agents via MCP |
| `plans/*.md` | Stay as historical documentation |

## Migration Input Files

- `/Users/mark/dev/repos/mine/SECOND-BRAIN/second-brain/index.json` — all edges + node metadata
- `/Users/mark/dev/repos/mine/SECOND-BRAIN/second-brain/sources/*.md` — 14 source files to parse
- `/Users/mark/dev/repos/mine/SECOND-BRAIN/second-brain/assertions/*.md` — 9 assertion files to parse
- `/Users/mark/dev/repos/mine/SECOND-BRAIN/second-brain/schema/assertion.md` — field definitions
- `/Users/mark/dev/repos/mine/SECOND-BRAIN/second-brain/schema/source.md` — field definitions

## Verification

**Phase 1:** Run old `query.sh --tag ai` and `mix ag.query --tag ai` — output should match. Same for deps, orphans, contested. Count records: 14 sources, 9 assertions, 21 edges.

**Phase 2:** Ingest a test URL, create an assertion with evidence link, verify edge created. Start a conversation, add messages, verify persistence across app restart.

**Phase 3:** Run the conclude workflow on a test conversation, verify assertions created with correct evidence links. Call actions via MCP tool, verify responses.
