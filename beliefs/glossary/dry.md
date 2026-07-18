---
id: em:9074c1
type: concept
title: DRY (don't repeat yourself)
description: The principle that every piece of knowledge should have a single, authoritative representation in a system — duplication creates copies that drift apart, so one of them is eventually wrong.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, principles, provenance]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-11T19:52:12+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# DRY (don't repeat yourself)

Duplication is the failure mode this software-engineering principle names: copies drift apart, and once they disagree a reader cannot tell which is current — so the fix for drift is never synchronization discipline but a [single source of truth](/beliefs/glossary/single-source-of-truth.md). In this brain it motivated retiring the hand-kept `log.md` files, whose entries duplicated commit messages and thread docs.

*Seen in:* [2026-07-11 deprecated-triage thread](/meta/threads/2026-07-11-deprecated-directory-triage-and-machinery-deletion.md)
