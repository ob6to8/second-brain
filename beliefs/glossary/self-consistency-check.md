---
id: em:4e01f8
type: concept
title: self-consistency check
description: A validation that re-derives a value from the same source data it is checking and compares the two; it catches drift between artifacts but is structurally blind to an error in the shared derivation logic itself.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, testing]
sense: common
timestamp: 2026-07-10
attribution:
  when: 2026-07-11T08:41:24+02:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# self-consistency check

A validation that re-derives a value from the same source data it is checking and compares the two. It catches drift between two artifacts but is structurally blind to an error in the shared derivation logic itself — which is why a golden test (an independently recorded expectation) complements it.

*Seen in:* [2026-07-09 flows-genre thread](/meta/threads/2026-07-09-flows-genre-and-scenario-testing.md)
