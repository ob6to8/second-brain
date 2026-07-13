---
id: sb:a91fb2
type: concept
title: timestamp
description: A record of when something was last modified; in this brain, the frontmatter field marking a doc's last meaningful change and the key every collection is ordered by.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, frontmatter, recency, ordering]
sense: dual
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T18:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "load-bearing term of the collection-ordering-by-date-modified thread — the ordering key every collection sorts by"
---

# timestamp

A record of when something was last modified — the everyday sense used across
software: a database row's `updated_at`, a file's mtime, a log line's clock
reading.

**In this brain:** the recommended frontmatter field holding the ISO 8601
date(time) of a doc's **last meaningful change** — bumped on an update-in-place
merge, distinct from [`attribution.when`](/beliefs/glossary/attribution.md) (the
immutable *ingestion* instant, write-once) and
[`provenance`](/beliefs/glossary/provenance.md) (content origin). `timestamp` is
the *semantic* modified-date, as opposed to the noisier mechanical git-commit
history (which also counts tooling churn like route-tag materialization).

It is the ratified **ordering key**: every collection in the bundle — the
rendered site navigation and every governance/knowledge-tree `index.md` body —
lists entries by most recent `timestamp` first (same-day ties broken by
`attribution.when`), except the name-keyed
[glossary](/beliefs/glossary/index.md), which stays alphabetical. See the
[collection ordering by date modified](/meta/plans/collection-ordering-by-date-modified.md)
plan and its precursor,
[collection views by date](https://github.com/ob6to8/second-brain/pull/68).

*Seen in:* [2026-07-13 collection ordering by date modified](/meta/threads/2026-07-13-collection-ordering-by-date-modified.md)

*See also:* [attribution](/beliefs/glossary/attribution.md), [provenance](/beliefs/glossary/provenance.md)
