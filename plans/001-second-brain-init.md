# Plan 001: Second Brain — Initial Architecture

## Goal

Build a markdown-based second brain that:
1. Ingests web content (articles, YouTube videos) via URL
2. Extracts text and generates structured YAML frontmatter
3. Organizes into a taxonomy of directories
4. Is a valid Obsidian vault out of the box
5. Produces a scannable `index.json` catalog (all frontmatter, no body text)
6. Has a clean migration path to postgres + pgvector

## Directory Structure

```
second-brain/
├── .gitignore              # .obsidian/, node_modules/, etc.
├── plans/                  # project plans (this file)
├── templates/              # frontmatter templates per content type
│   ├── article.md
│   ├── video.md
│   └── paper.md
├── articles/               # ingested articles, organized by topic
│   ├── ai/
│   ├── engineering/
│   └── ...                 # directories created on demand
├── videos/                 # youtube transcripts
├── papers/                 # arxiv, research papers
├── scripts/                # automation scripts
│   ├── ingest.sh           # URL → markdown pipeline (called by Claude)
│   └── build-index.sh      # regenerate index.json from all frontmatter
├── index.json              # generated catalog of all frontmatter
└── CLAUDE.md               # project-level instructions for Claude
```

## Step 1: Templates

Create frontmatter templates for each content type.

### `templates/article.md`
```yaml
---
title: ""
url: ""
aliases: []
tags: []
source: ""
authors: []
date_published: ""
date_captured: ""
summary: >
content_type: article
word_count: 0
related: []
---
```

### `templates/video.md`
```yaml
---
title: ""
url: ""
aliases: []
tags: []
channel: ""
date_published: ""
date_captured: ""
summary: >
duration: ""
content_type: video
word_count: 0
related: []
---
```

### `templates/paper.md`
```yaml
---
title: ""
url: ""
aliases: []
tags: []
authors: []
date_published: ""
date_captured: ""
summary: >
content_type: paper
word_count: 0
related: []
---
```

## Step 2: Ingestion Script (`scripts/ingest.sh`)

A shell script that:
1. Takes a URL as argument
2. Detects content type (article vs YouTube vs paper)
3. For articles: uses `curl` + `pandoc` (html → markdown) or falls back to readable text extraction
4. For YouTube: uses `yt-dlp --write-auto-sub --sub-lang en --skip-download` to grab transcript
5. Outputs raw text to stdout (Claude handles frontmatter generation and file placement)

This keeps the script simple — it's a fetcher, not a brain. Claude does the smart parts:
- Generating the summary
- Picking tags from existing taxonomy (or creating new ones)
- Choosing the right directory
- Creating `[[wikilinks]]` to related notes

## Step 3: Index Generator (`scripts/build-index.sh`)

Scans all `.md` files (excluding `plans/`, `templates/`), extracts YAML frontmatter, and writes `index.json`:

```json
[
  {
    "file": "articles/ai/multi-agent-workflows.md",
    "title": "Multi-Agent Workflows...",
    "url": "https://...",
    "tags": ["ai", "multi-agent"],
    "summary": "...",
    "content_type": "article",
    "date_captured": "2026-02-25"
  }
]
```

This is what Claude loads to "know" the whole brain without reading every file.

## Step 4: CLAUDE.md (Project Instructions)

Project-level instructions so Claude knows how to operate in this repo:

```markdown
# Second Brain

## Ingestion Workflow
1. User provides a URL
2. Fetch content (WebFetch for articles, yt-dlp for YouTube)
3. Generate frontmatter from template (summary, tags, metadata)
4. Choose directory based on primary topic tag
5. Create the .md file with frontmatter + extracted body
6. Run build-index.sh to update index.json
7. Commit the new note

## Conventions
- Filenames: kebab-case, derived from title
- Tags: lowercase, hyphenated (e.g., multi-agent, not MultiAgent)
- Directories: created on demand when a new top-level tag emerges
- Wikilinks: use [[filename]] (no path prefix) — Obsidian resolves these
- Summaries: 2-3 sentences max, written for scanning
- Always check index.json for existing related notes before creating a new one

## Reading the Brain
- Load index.json first to see all notes
- Only read full .md files when the user asks about a specific topic
```

## Step 5: Install Dependencies

Check for and note required tools:
- `yt-dlp` — YouTube transcript extraction (`brew install yt-dlp`)
- `jq` — JSON processing for build-index (`brew install jq`)
- `yq` — YAML frontmatter parsing (`brew install yq`)

## Execution Order

1. Create directory structure (`templates/`, `articles/`, `videos/`, `papers/`, `scripts/`)
2. Write template files
3. Write `scripts/ingest.sh` + `scripts/build-index.sh`
4. Write `CLAUDE.md`
5. Write initial empty `index.json` (`[]`)
6. Run `shellcheck` on both scripts
7. Commit everything as initial scaffold
8. Test with the GitHub blog URL from the user's original message
