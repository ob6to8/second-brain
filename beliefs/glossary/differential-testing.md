---
id: em:209429
type: concept
title: differential testing
description: Validating a new implementation by running it and an existing implementation over the same inputs and comparing outputs, so every divergence is either a bug in the new code or a latent bug in the old surfacing.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, testing, migration, tooling]
sense: common
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T23:16:49Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-20 storage-format and frontmatter-parser session"
---

# differential testing

It is cheapest when a real corpus already exists to serve as the input set — no test cases need inventing, and coverage is exactly the data the system must keep handling. The [frontmatter-parser-profile-rewrite plan](/meta/plans/frontmatter-parser-profile-rewrite.md) uses the bundle's own documents this way: a harness parses every document with the old and new parsers side by side, pinning behavior over the live corpus before the swap.

*Seen in:* [2026-07-20 storage-format and frontmatter-parser thread](/meta/threads/2026-07-20-storage-format-verdict-and-frontmatter-parser-plan.md)
