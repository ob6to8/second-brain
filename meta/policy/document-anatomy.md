---
type: policy
title: Bundle and document anatomy
description: The repo root is the OKF bundle; a document is frontmatter plus a markdown body; the document ID is its path minus .md.
section: composition
order: 1
status: active
tags: [meta, governance, okf, structure]
timestamp: 2026-07-15
attribution:
  when: 2026-07-05T12:30:48+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-05-greenfield-okf-bootstrap-and-verification-layer.md, /meta/threads/2026-07-15-replicate-concept-document-terminology-from-pr-71.md]
---
- **The repo root is the OKF bundle.** Documents live at the root and in
  subdirectories. `.claude/` (skills), `meta/` (governance), the Elixir tooling
  (`mix.exs`, `lib/`, `test/`), and `deprecated/` (archived legacy content,
  read-only) sit alongside but are **not** part of the knowledge bundle.
- **A document** is a single UTF-8 markdown file with two parts:
  1. **YAML frontmatter** (required), delimited by `---`.
  2. **Markdown body** (distilled prose; no required sections).
- **Document ID** = file path minus `.md` (e.g. `areas/health.md` → `areas/health`).
- **Terminology: "document", not "concept".** The OKF spec calls this unit a
  *concept document*, but the anatomy above is purely structural — nothing in it
  guarantees concept-like content. This bundle therefore says **document** for
  the unit and reserves **`concept`** for the controlled `type` of that name (a
  definition or mental model). When reading the OKF spec, its "concept" is this
  bundle's "document".
