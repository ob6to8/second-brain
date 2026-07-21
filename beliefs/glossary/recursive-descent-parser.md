---
id: em:d8f3bb
type: concept
title: recursive-descent parser
description: A parser written as a set of mutually recursive functions, one per grammar construct, each consuming the input it recognizes — the most direct way to hand-write a parser for a small, explicitly defined grammar.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, parsing, tooling]
sense: common
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T23:16:49Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-20 storage-format and frontmatter-parser session"
---

# recursive-descent parser

Because the code structure mirrors the grammar one-to-one, unsupported constructs have nowhere to hide: anything outside the grammar falls through to an explicit error path instead of being half-handled. That makes the technique a natural fit for strict-profile parsing — the [frontmatter-parser-profile-rewrite plan](/meta/plans/frontmatter-parser-profile-rewrite.md) chooses it over a full [YAML](/beliefs/glossary/yaml.md) library precisely to reject loudly what the profile excludes.

*Seen in:* [2026-07-20 storage-format and frontmatter-parser thread](/meta/threads/2026-07-20-storage-format-verdict-and-frontmatter-parser-plan.md)
