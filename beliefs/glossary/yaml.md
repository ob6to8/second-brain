---
id: em:751e4e
type: concept
title: YAML
description: A human-readable data-serialization language of indented key–value pairs, lists, and scalars, widely used for configuration files and for frontmatter metadata blocks.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, serialization, metadata, tooling]
sense: common
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T23:16:49Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-20 storage-format and frontmatter-parser session"
---

# YAML

Its full specification is far larger than its familiar surface: version 1.1 silently coerces tokens like `no` into booleans and date-like strings into timestamps (the "Norway problem"), and features such as anchors, flow maps, and folded scalars let permissive parsers accept documents their authors never intended. That gap is why this bundle's [frontmatter](/beliefs/glossary/frontmatter.md) tooling parses only a deliberate subset — the proposed [OKF frontmatter profile](/beliefs/glossary/okf-frontmatter-profile.md) — rather than adopting a full-spec library.

*Seen in:* [2026-07-20 storage-format and frontmatter-parser thread](/meta/threads/2026-07-20-storage-format-verdict-and-frontmatter-parser-plan.md), [frontmatter-parser-profile-rewrite plan](/meta/plans/frontmatter-parser-profile-rewrite.md)
