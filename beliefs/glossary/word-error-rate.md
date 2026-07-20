---
id: em:e862bb
type: concept
title: word error rate
description: The standard accuracy metric for speech transcription — the fraction of words the transcriber gets wrong, counting substitutions, insertions, and deletions against a reference transcript.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, transcription, metrics, speech]
sense: common
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T23:23:55+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-20 evals-harness-ledger thread"
---

# word error rate

For observation records the aggregate number understates the risk: failures cluster on exactly the load-bearing vocabulary — jargon, identifiers, and negations, where a single miss inverts a sentence's meaning. Modern neural transcribers add a subtler hazard the metric doesn't capture: smoothing hedged, fragmented speech into fluent prose, an editorial rewrite by the instrument itself.

*Seen in:* [2026-07-20 evals and observation-records thread](/meta/threads/2026-07-20-evals-harness-ledger-and-observation-records.md)
