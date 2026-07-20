---
id: em:a267ab
type: concept
title: OKF frontmatter profile
description: The explicitly defined subset of YAML this bundle's document frontmatter is allowed to use — scalars, quoted strings, inline and block lists, nested block maps — with everything outside it rejected loudly rather than tolerated silently.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, frontmatter, parsing, contract]
sense: repo
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T23:16:49Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term coined in the 2026-07-20 frontmatter-parser design session"
---

# OKF frontmatter profile

Proposed by the [frontmatter-parser-profile-rewrite plan](/meta/plans/frontmatter-parser-profile-rewrite.md) as the grammar of the replacement `ElixirMind.Frontmatter` parser. Naming the profile graduates "which [YAML](/beliefs/glossary/yaml.md) is legal in [frontmatter](/beliefs/glossary/frontmatter.md)" from an accident of the parser's implementation to a contract surface: agents write within it, the parser enforces it with line-numbered errors, and the rejection set is part of the spec.

*Seen in:* [2026-07-20 storage-format and frontmatter-parser thread](/meta/threads/2026-07-20-storage-format-verdict-and-frontmatter-parser-plan.md)
