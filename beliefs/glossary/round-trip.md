---
id: em:490d9d
type: concept
title: round-trip
description: The property that parsing a document into a structured representation and serializing it back reproduces the original byte-for-byte, so a parse-modify-write pipeline changes only what it means to change.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, parsing, serialization, tooling]
sense: common
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T23:16:49Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-20 storage-format and frontmatter-parser session"
---

# round-trip

Achieving it requires the parser to preserve incidental structure — key order, quoting style, formatting — that a semantics-only parser discards. In exchange it buys a free canonical-form check (any file that fails to round-trip has drifted from the canonical formatting), minimal diffs when tooling rewrites a file, and safe structural edits where regex surgery would otherwise be needed; the [frontmatter-parser-profile-rewrite plan](/meta/plans/frontmatter-parser-profile-rewrite.md) makes it the design constraint for `Frontmatter.dump/1`.

*Seen in:* [2026-07-20 storage-format and frontmatter-parser thread](/meta/threads/2026-07-20-storage-format-verdict-and-frontmatter-parser-plan.md)
