# Second Brain

Markdown-based personal knowledge base. Obsidian-compatible vault.

## Ingestion Workflow
1. User provides a URL
2. Detect content type (article, YouTube video, paper)
3. Fetch content: `./scripts/ingest.sh <url>` for raw text, or WebFetch for articles
4. Generate frontmatter from template (`templates/<type>.md`) — summary, tags, metadata
5. Choose directory based on primary topic tag (e.g., `articles/ai/`, `videos/`)
6. Create the `.md` file with frontmatter + extracted body
7. Run `./scripts/build-index.sh` to update `index.json`
8. Commit the new note

## Conventions
- Filenames: kebab-case, derived from title
- Tags: lowercase, hyphenated (e.g., `multi-agent`, not `MultiAgent`)
- Directories: created on demand when a new top-level tag emerges
- Wikilinks: use `[[filename]]` (no path prefix) — Obsidian resolves these
- Summaries: 2-3 sentences max, written for scanning
- Always check `index.json` for existing related notes before creating a new one

## Reading the Brain
- Load `index.json` first to see all notes
- Only read full `.md` files when the user asks about a specific topic

## Scripts
- `scripts/ingest.sh <url>` — fetch raw content (article/YouTube/arxiv), print to stdout
- `scripts/build-index.sh` — regenerate `index.json` from all frontmatter

## Dependencies
- `yt-dlp` — YouTube transcript extraction
- `jq` — JSON processing
- `yq` — YAML frontmatter parsing
