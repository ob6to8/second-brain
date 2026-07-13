---
id: sb:c67f48
type: concept
title: spurious (warning)
description: A warning or match triggered by something that is not a real instance of what the check looks for — a false positive; tolerable at warn level but erosive, since repeated spurious output teaches the reader to ignore the channel.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, testing, tooling]
sense: common
timestamp: 2026-07-12
attribution:
  when: 2026-07-12T09:10:24+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# spurious (warning)

Said of a warning, match, or finding triggered by something that is *not* a
real instance of what the check looks for — a false positive. A spurious
warning never fails a build, but it is erosive in a different way: each one
teaches the reader to skim past the channel, so the real warning eventually
arrives pre-ignored. The remedy is usually scoping the check's input more
precisely (as with the ledger cross-check reading only the `## Routing`
section's [pipe table](/beliefs/glossary/pipe-table.md)) rather than downgrading or
silencing the output.

*Seen in:* [code-review toolchain hardening plan](/meta/plans/code-review-toolchain-hardening.md)
