---
id: em:a74152
type: concept
title: append-only
description: A data structure or field that admits new entries but never allows existing ones to be modified or removed — so its history is immutable even as it grows.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, data-structures, immutability, provenance]
sense: common
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T15:30:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "the carve-out that lets governance attribution.from grow without breaking immutability"
---

# append-only

A structure that grows by **addition alone**: new entries may be appended, but existing entries are never edited or deleted. Append-only logs (write-ahead logs, event stores, ledgers, git's commit graph) are valued precisely because the past cannot be silently rewritten — every reader sees the same immutable history, and new information extends it rather than replacing it. It is a middle ground between fully immutable (no change at all) and freely mutable (any change): the *set of facts* is monotonic.

In this brain it is the one carve-out in [attribution](/beliefs/glossary/attribution.md)'s immutability: the event sub-keys are write-once, but a governance doc's `from` back-links are append-only, because feature [lineage](/beliefs/glossary/lineage.md) accretes — each later session that substantively revises a doc appends its own thread, never removing the earlier ones. That monotonic growth is exactly what lets `mix brain.lineage` derive a multi-session chain from the field.

*Seen in:* [2026-07-13 resource-attribution property thread](/meta/threads/2026-07-13-resource-attribution-property-spec-and-build.md)
