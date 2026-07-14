---
id: em:9fc7da
type: concept
title: backfill
description: Retroactively populating a newly-added field or dataset for records that predate it, deriving the values from history rather than leaving the past blank.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, data, migration, attribution]
sense: common
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T15:30:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "the mechanism that populated attribution across the pre-policy corpus"
---

# backfill

Retroactively filling in a new field, column, or dataset for records that existed *before* it — so a schema addition applies to the whole history, not just to new writes. The defining discipline of a good backfill is that it **derives** values from what is already recoverable (logs, timestamps, existing metadata) rather than inventing them: where a value genuinely cannot be reconstructed, it is left absent, not guessed.

In this brain, `mix brain.attribution --backfill` reconstructed the [attribution](/beliefs/glossary/attribution.md) block for the ~265 docs predating the resource-attribution policy — `when` from each file's git first-add commit, `channel` from its pathway, and governance `from` resolved precisely through the introducing PR to the [thread](/beliefs/glossary/thread-doc.md) carrying that `pr:`. A backfill is what lets an enforced-presence rule flip on without being aspirational: the past is made conformant before the gate closes.

*Seen in:* [2026-07-13 resource-attribution property thread](/meta/threads/2026-07-13-resource-attribution-property-spec-and-build.md)
