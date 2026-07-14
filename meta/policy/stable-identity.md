---
type: policy
title: Stable identity — ids and the registry
description: Every bundle concept carries a stable id whose 6-hex tail is the immutable identity; the namespace prefix changes only by a ratified bundle-wide migration; cross-concept edges reference ids, and meta/registry.md is the compiled id-to-path view.
section: verification
order: 1
status: active
tags: [meta, governance, identity, registry]
timestamp: 2026-07-14
attribution:
  when: 2026-07-05T19:41:08+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-05-greenfield-okf-bootstrap-and-verification-layer.md]
---
- **Every bundle concept carries a stable `id`** in frontmatter: the bundle's
  id-namespace prefix + 6 lowercase hex chars — currently `em:` (e.g. `em:4c9e1f`).
  The **6-hex tail is the immutable identity**: minted once (`mix brain.id`), never
  changed, and never reused, even if the file moves, is renamed, or is superseded.
  Identity survives refactors; paths don't have to.
- **The prefix is a namespace token, not part of a concept's identity.** It is
  **opaque** — nothing may depend on its letters carrying meaning — and it changes
  only by an **operator-ratified, bundle-wide migration** that rewrites every id in
  one deterministic, tail-preserving pass, never per-id. One such migration has
  occurred: **2026-07, the `sb:` prefix → `em:`** (mirroring the repository rename
  second-brain → elixir-mind), swapping the prefix on every id while preserving each
  6-hex tail verbatim, so a historical `sb:`-prefixed token denotes exactly the `em:`
  id sharing its tail. A future prefix change would follow the same
  ratify-then-migrate path; absent one, the prefix is fixed.
- **Typed edges reference ids, not paths.** Structured frontmatter references
  (`verified_by`, and future typed edges) point at stable ids as an inline YAML list.
  Prose links in bodies still use ordinary markdown paths.
- **The per-file `id` is canonical; the registry is compiled.**
  [`meta/registry.md`](/meta/registry.md) — the id → path view — is a generated
  artifact (`mix brain.registry`, checked in CI with `--check`), exactly like
  `CLAUDE.md`. Never hand-edit it.
