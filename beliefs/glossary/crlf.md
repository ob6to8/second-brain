---
id: em:a48aeb
type: concept
title: CRLF
description: The two-byte carriage-return + line-feed line ending (Windows convention), versus Unix's bare LF; tools that pattern-match on line boundaries must normalize it or honor the file's own ending when writing.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, formats, encoding]
sense: common
timestamp: 2026-07-12
attribution:
  when: 2026-07-12T09:10:24+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# CRLF

The two-byte **c**arriage-**r**eturn + **l**ine-**f**eed sequence (`\r\n`)
that ends lines in the Windows convention, versus Unix's bare LF (`\n`). The
practical rule for text tooling: anything that pattern-matches on line
boundaries must either normalize CRLF away on read (as this bundle's
frontmatter parser does) or honor the file's own ending when writing into it
(as `mix brain.id` does when inserting an id line) — matching only `\n` while
writing `\n` into a `\r\n` file silently mixes endings.

*Seen in:* [code-review toolchain hardening plan](/meta/plans/code-review-toolchain-hardening.md)
