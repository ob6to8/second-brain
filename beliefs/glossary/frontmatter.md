---
id: em:640701
type: concept
title: frontmatter
description: The structured metadata block — conventionally YAML delimited by `---` lines — at the top of a markdown file, carrying machine-readable fields ahead of the human-readable prose body.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, markdown, metadata, tooling]
sense: common
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T23:16:49Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-20 storage-format and frontmatter-parser session"
---

# frontmatter

In this brain it is the entire structured layer: the operating contract mandates `id`, `type`, and `attribution` here; typed edges (`verified_by`) live here rather than in prose; and `ElixirMind.Frontmatter` parses a deliberate [YAML](/beliefs/glossary/yaml.md) subset of it — leaving the body free for prose while every query, verifier rule, and generated artifact reads from this one place.

*Seen in:* [2026-07-20 storage-format and frontmatter-parser thread](/meta/threads/2026-07-20-storage-format-verdict-and-frontmatter-parser-plan.md), [frontmatter-parser-profile-rewrite plan](/meta/plans/frontmatter-parser-profile-rewrite.md), [frontmatter-schema policy](/meta/policy/frontmatter-schema.md)
