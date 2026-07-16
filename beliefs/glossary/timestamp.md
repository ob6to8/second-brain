---
id: em:59cff6
type: concept
title: timestamp
description: Commonly, a recorded date-time marking when an event occurred or data changed; in this brain, the frontmatter field for a doc's last meaningful change — the semantic modified-date, distinct from attribution.when (created) and git commit dates (mechanical).
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, frontmatter, timestamp, recency]
sense: dual
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T06:52:11Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the collection-view-by-date thread — ratified there as the ordering key for date-ordered collection views"
---

# timestamp

A recorded date-time marking when an event occurred or a piece of data was created or changed. Timestamps are what let systems order records, detect staleness, and reason about concurrency — the general currency of "when" in computing.

**In this brain:** the frontmatter field recording a doc's last **meaningful** change — the *semantic* modified-date, bumped by update-in-place merges but not by mechanical churn (route-tag materialization, backfills), which git commit dates record instead. It is one of three deliberately orthogonal date signals: [`attribution`](/beliefs/glossary/attribution.md)`.when` is the created/ingestion instant, git history is the mechanical narrative, and `timestamp` marks when the *content* last meaningfully moved. Ratified as the ordering key for date-ordered collection views: the plans, todos, and issues indexes keep entries newest-first by it (see the [collection-view-by-date plan](/meta/plans/collection-view-by-date.md)). Defined by the [frontmatter-schema policy](/meta/policy/frontmatter-schema.md).

*Seen in:* [2026-07-16 collection-view-by-date recreation thread](/meta/threads/2026-07-16-recreate-collection-view-by-date.md)

*See also:* [attribution](/beliefs/glossary/attribution.md), [provenance](/beliefs/glossary/provenance.md)
