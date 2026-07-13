---
type: policy
title: Stable identity — ids and the registry
description: Every bundle document carries an immutable opaque id; cross-document edges reference ids, and meta/registry.md is the compiled id-to-path view.
section: verification
order: 1
status: active
tags: [meta, governance, identity, registry]
timestamp: 2026-07-13
---
- **Every bundle document carries a stable `id`** in frontmatter: `sb:` + 6 lowercase
  hex chars (e.g. `sb:4c9e1f`). Ids are **opaque and immutable** — minted once
  (`mix brain.id`), never changed, and never reused, even if the file moves, is
  renamed, or is superseded. Identity survives refactors; paths don't have to.
- **Typed edges reference ids, not paths.** Structured frontmatter references
  (`verified_by`, and future typed edges) point at stable ids as an inline YAML list.
  Prose links in bodies still use ordinary markdown paths.
- **The per-file `id` is canonical; the registry is compiled.**
  [`meta/registry.md`](/meta/registry.md) — the id → path view — is a generated
  artifact (`mix brain.registry`, checked in CI with `--check`), exactly like
  `CLAUDE.md`. Never hand-edit it.
