---
id: em:c86162
type: concept
title: recall probe
description: A repeatable evaluation that issues a fixed set of natural-phrasing queries mapped to known target items and measures whether the search surfaces them, used as an early-warning signal for retrieval degradation.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, search, evaluation]
sense: repo
timestamp: 2026-07-12
attribution:
  when: 2026-07-11T08:41:24+02:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# recall probe

A repeatable evaluation that issues a fixed set of natural-phrasing queries mapped to known target items and measures whether the search surfaces them (e.g. [recall@k](/beliefs/glossary/recall-at-k.md)). It scores a [gold set](/beliefs/glossary/gold-set.md) of query→target pairs against a search backend and is used as an early-warning signal that retrieval is degrading as a corpus scales. In this brain it is realized as `mix brain.dedup_probe`: an offline, deterministic probe over [lexical search](/beliefs/glossary/lexical-search.md), whose plain-vs-[synonym-expanded](/beliefs/glossary/synonym-expansion.md) score gap quantifies the [deduplication](/beliefs/glossary/deduplication.md) recall that intake is missing.

*Seen in:* [2026-07-09 vector-DB recall thread](/meta/threads/2026-07-09-vector-db-recall-evaluation-and-analysis-type.md), [2026-07-12 dedup recall probe thread](/meta/threads/2026-07-12-dedup-recall-probe-and-synonym-intake.md)
