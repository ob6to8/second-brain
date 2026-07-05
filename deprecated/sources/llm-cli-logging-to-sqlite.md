---
type: source
source_type: article
title: "LLM CLI — Logging to SQLite"
url: "https://llm.datasette.io/en/stable/logging.html"
aliases: ["llm logging", "llm sqlite schema", "llm logs"]
tags: [ai, llm-cli, sqlite, simon-willison, conversation-persistence]
authors: ["Simon Willison"]
date_published: ""
date_captured: "2026-03-03"
summary: >
  Documentation for Simon Willison's llm CLI logging system. Every prompt/response
  is automatically logged to SQLite with 12+ tables covering conversations, responses,
  tool calls, fragments, and FTS5 full-text search. Browsable via Datasette.
word_count: 700
related:
  - "[[context-engineering-and-persistent-agent-memory]]"
---

## Core Logging Features

The LLM CLI automatically logs all prompts and responses to a SQLite database.

**Key Commands:**
- `llm logs path` — returns platform-specific database location
- `llm logs status` — displays logging statistics
- `llm logs on/off` — toggles default logging
- `llm logs off` — disables logging
- `llm -n/--no-log` — skip logging for individual prompts
- `llm logs backup /path/to/backup.db` — uses SQLite VACUUM INTO for backups

## Viewing and Querying Logs

**Display Options:**
- `llm logs` — shows recent entries in Markdown format
- `-r/--response` — returns most recent response as plain text
- `--json` — formats results as JSON
- `-n 10` — specifies number of results (0 shows all)
- `-s/--short` — condensed YAML format with truncated prompts
- `-u/--usage` — includes token consumption data

**Search and Filter Options:**
- `-q TERM` — full-text search through prompts and responses
- `-m/--model` — filter by specific model
- `-c` or `--cid ID` — view conversation-specific logs
- `-f/--fragment X` — filter by fragment hash/alias
- `-T/--tool TOOLNAME` — filter by tool usage
- `--id-gt/$ID` and `--id-gte/$ID` — retrieve records after specified ID
- `--schema X` — view responses using particular schema

## Database Schema (logs.db)

**12 Primary Tables:**

**Core Data:**
- `conversations` — conversation metadata (id, name, model)
- `responses` — main table with prompts, responses, tokens, timestamps, model info
- `schemas` — schema definitions

**Attachments:**
- `attachments` — file/URL attachment storage
- `prompt_attachments` — links attachments to prompts

**Fragments (Reusable Prompts):**
- `fragments` — reusable prompt fragment definitions
- `fragment_aliases` — fragment hash/alias mappings
- `prompt_fragments` — links fragments to responses
- `system_fragments` — system prompt fragments

**Tool Usage:**
- `tools` — tool definitions
- `tool_calls` — individual tool invocations
- `tool_responses` — tool output
- `tool_results` — tool execution results
- `tool_instances` — tool instance metadata

**Search:**
- `responses_fts` — virtual FTS5 table for full-text search across prompts and responses

## Datasette Integration

Browse logs via web UI: `datasette "$(llm logs path)"`
