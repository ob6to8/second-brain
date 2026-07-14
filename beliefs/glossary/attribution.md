---
id: em:57c7d1
type: concept
title: attribution
description: In this brain, the frontmatter map recording a doc's ingestion event — when it entered, through which channel and by whom, and why — an immutable record orthogonal to provenance (content origin) and timestamp (last change).
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, frontmatter, attribution, provenance, ingestion]
sense: repo
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T15:30:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "central term of the resource-attribution property spec-and-build thread"
---

# attribution

**In this brain:** the frontmatter map recording a doc's **ingestion event** — how it came to be in the bundle, as opposed to what it says or when it last changed. Every bundle concept and governance doc carries one, with fixed sub-keys: `when` (the ingestion instant), `channel` (the pathway — a controlled vocabulary: `intake`/`auto-intake`/`glossary`/`agent-authored`/`backfill`), `agent` (the acting pathway, named not by model but by route), `why` (one sentence on why it was worth filing), and — on governance docs only — `from`, a back-link to the thread or concept it was extracted from.

It is an **event** record, so it does not change: the event sub-keys are write-once, and the governance `from` is [append-only](/beliefs/glossary/append-only.md) (feature lineage accretes as later sessions revise a doc). This is what distinguishes it from the three neighbouring fields it is deliberately orthogonal to — [`resource`](/beliefs/glossary/single-source-of-truth.md) (*what asset*), [`provenance`](/beliefs/glossary/provenance.md) (*where the content came from*, possibly predating the brain), and `timestamp` (*when it last changed*). It is not a competing change-log either: the commit graph stays the single change narrative, and attribution is the one in-band summary of the ingestion commit that renames, merges, and portable-bundle consumption otherwise make hard to recover. Enforced by `mix brain.verify` (shape, `from` resolution, exemption placement, presence) and defined by the [resource-attribution policy](/meta/policy/resource-attribution.md).

*Seen in:* [2026-07-13 resource-attribution property thread](/meta/threads/2026-07-13-resource-attribution-property-spec-and-build.md)

*See also:* [provenance](/beliefs/glossary/provenance.md), [append-only](/beliefs/glossary/append-only.md), [lineage](/beliefs/glossary/lineage.md), [backfill](/beliefs/glossary/backfill.md)
