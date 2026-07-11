---
type: policy
title: Reserved filenames
description: index.md is reserved at any directory level and follows a fixed structure; log.md stays reserved for OKF tolerance but this bundle does not keep logs — git history is the change record.
section: composition
order: 3
status: active
tags: [meta, governance, okf, index, log]
timestamp: 2026-07-11
---
Reserved filenames (any directory level):

- **`index.md`** — directory listing for progressive disclosure. Markdown sections
  with bulleted links + one-line descriptions. **No frontmatter** — except the
  bundle-root `index.md`, which carries only `okf_version: "0.1"`.
- **`log.md`** — reserved by OKF (chronological change history; tolerate one when
  consuming a foreign bundle), but **this bundle does not keep hand-written logs**:
  the true-merge commit graph is the single provenance layer (see the
  merge-strategy policy and the
  [retire-hand-kept-logs plan](/meta/plans/retire-hand-kept-logs.md)). Do not
  create `log.md` files or append log entries; the change narrative belongs in
  commit messages. (The generated `## Thread excerpts — route-tagged log`
  sections inside concepts are unrelated — they are compiled, CI-verified
  artifacts and stay.)
