---
type: policy
title: Maintain the reserved files
description: After filing, update the directory's index.md; the change itself is recorded by the commit, not a log entry.
section: filing
order: 6
status: active
tags: [meta, governance, filing, index]
timestamp: 2026-07-13
attribution:
  when: 2026-07-05T12:30:48+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-05-greenfield-okf-bootstrap-and-verification-layer.md, /meta/threads/2026-07-13-collection-ordering-by-date-modified.md]
---
**Maintain the reserved files**: after filing, update the directory's `index.md`
(create it if missing). The change itself is recorded by the commit — write the
commit message at the semantic level ("intake X", "ratify Y"); there is no
`log.md` to append to (see the reserved-filenames policy).

**Order every listing by date modified.** Within an `index.md`, list concept
entries by most recent `timestamp` first (newest at the top; same-day ties broken
by `attribution.when`) — and *within* an existing grouping (status sections,
`## Concepts` vs `## Subdirectories`) where one exists, so the grouping stays
primary and recency orders inside it. A newly filed concept therefore lands at the
top of its section. Subdirectory-map bullets keep their structural order — a
taxonomy map is not a dated collection. **The one exception is the glossary**
([`beliefs/glossary/`](/beliefs/glossary/index.md)), a name-keyed reference
collection that stays alphabetical. The generated site nav applies the same rule
mechanically (`SecondBrain.Site`); see
[collection ordering by date modified](/meta/plans/collection-ordering-by-date-modified.md).
