# Source File Spec

Sources are external content ingested into the knowledge base. They provide evidence for assertions.

## Required Fields

| Field | Type | Description |
|---|---|---|
| `type` | string | Always `source` |
| `title` | string | Human-readable title |
| `tags` | string[] | Lowercase, hyphenated taxonomy tags |
| `date_captured` | string | ISO 8601 date when ingested |

## Optional Fields

| Field | Type | Description |
|---|---|---|
| `url` | string | Original URL |
| `aliases` | string[] | Alternative names for search |
| `source_type` | string | One of: `article`, `video`, `paper`, `journal`, `transcript` |
| `authors` | string[] | Author names |
| `channel` | string | YouTube channel, publication name |
| `date_published` | string | ISO 8601 original publication date |
| `summary` | string | 2-3 sentence description |
| `duration` | string | For video/audio (e.g., `"59:01"`) |
| `word_count` | number | Approximate word count |
| `related` | string[] | Wikilinks to related sources or assertions |

## Body

Extracted or curated content from the source. Structure varies by source type (article text, transcript, discussion threads, etc.).

## Example

```yaml
---
type: source
source_type: article
title: "Example Article Title"
url: "https://example.com/article"
aliases: ["example article"]
tags: [ai, context-engineering]
authors: ["Jane Doe"]
date_published: "2026-01-15"
date_captured: "2026-02-25"
summary: >
  Two sentence summary of what this source contains
  and why it matters.
word_count: 1200
related:
  - "[[some-assertion-id]]"
---

## Content here...
```
