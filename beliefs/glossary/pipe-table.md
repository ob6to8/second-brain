---
id: sb:8048c6
type: concept
title: pipe table
description: Markdown's pipe-delimited table syntax (a GFM extension) — a header row, a dashes/colons separator row, then one row per line, cells split on |.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, markdown, formats]
timestamp: 2026-07-12
---

# pipe table

Markdown's `|`-delimited table syntax, a
[GitHub Flavored Markdown](/beliefs/glossary/github-flavored-markdown.md) extension: a
header row, a separator row of dashes (with optional `:` alignment markers),
then one row per line, cells split on `|`. Being plain text, any pipe table in
a document *looks* the same to a naive parser — which is why a tool reading a
specific table (this bundle's
[routing ledger](/beliefs/glossary/routing-ledger.md)) must scope itself to that
table's section rather than matching every `|`-prefixed line.

*Seen in:* [code-review toolchain hardening plan](/meta/plans/code-review-toolchain-hardening.md)
