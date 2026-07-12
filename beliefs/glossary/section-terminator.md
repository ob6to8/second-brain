---
id: sb:23844f
type: concept
title: section terminator
description: The pattern a parser uses to decide where a document section ends (here, the next h1/h2 heading); two code paths that read and rewrite the same section must agree on it or their views of the file diverge.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, parsing, markdown, tooling]
timestamp: 2026-07-12
---

# section terminator

The pattern a parser uses to decide where a document section *ends* — in this
bundle's tooling, the next h1 or h2 heading closes the
[excerpt log](/beliefs/glossary/excerpt-log.md) section. The subtlety is agreement:
when one code path **reads** a section and another **rewrites** it, the two
must share the same terminator, or the reader includes content the writer
would preserve (or vice versa) and the same file has two inconsistent
boundaries. The hardening batch aligned the excerpt-log parser's terminator
with its rewriter's for exactly this reason.

*Seen in:* [code-review toolchain hardening plan](/meta/plans/code-review-toolchain-hardening.md)
