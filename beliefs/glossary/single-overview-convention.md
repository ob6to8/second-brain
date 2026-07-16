---
id: em:30dc3f
type: concept
title: single-overview convention
description: The glossary rule that each term's `description` frontmatter is its one canonical overview — rendered as the entry-page lede and shown verbatim as the index gloss — with the body kept expansion-only, both halves enforced by mix brain.glossary.
provenance: "Agent-distilled glossary definition; names the convention mix brain.glossary enforces"
verified: false
tags: [glossary, convention, verification, single-source-of-truth]
sense: repo
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T00:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "convention named and enforced in the 2026-07-16 glossary single-overview recreation session"
---

# single-overview convention

The failure it removes: an overview that lived in three independently drifting copies — the `description` lede, a body paragraph restating it, and a hand-written index gloss. Collapsing them to one source is a [single source of truth](/beliefs/glossary/single-source-of-truth.md) applied to the glossary. Enforcement splits by oracle: the index `## Terms` section is a [generated artifact](/beliefs/glossary/compiled-contract.md) re-derived from the descriptions (`mix brain.glossary --materialize`), while the no-restatement half rests on [content-word containment](/beliefs/glossary/content-word-containment.md), whose warn band leaves genuine judgment editorial.

*Seen in:* [2026-07-16 glossary single-overview recreation thread](/meta/threads/2026-07-16-recreate-pr-64-glossary-single-overview-and-check.md)
