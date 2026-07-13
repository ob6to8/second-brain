---
type: reference
title: 2026-07-13-collection-ordering-by-date-modified
description: Extended PR #68's plans/todos/issues date-ordering convention to every collection surface — the site nav sort and every governance/knowledge-tree index.md body — except the glossary; shipped as PR #70.
provenance: "Claude Code session (Claude Opus 4.8, then Claude Sonnet 5 after a mid-session operator model switch), 2026-07-13; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, indexes, collections, recency, timestamp, site]
timestamp: 2026-07-13
pr: 70
---

# 2026-07-13-collection-ordering-by-date-modified

## Where this landed

Following up on [PR #68](https://github.com/ob6to8/second-brain/pull/68), which
ordered the `plans`/`todos`/`issues` indexes by `timestamp` (date modified) and
settled `timestamp` as the ordering key, the operator directed extending the same
treatment to every collection in the brain, glossary excepted. The session
implemented this two ways: mechanically, in `SecondBrain.Site`'s navigation sort
(`timestamp` descending, with a `beliefs/glossary/` carve-out that stays
alphabetical), pinned by two new tests; and by convention, reordering every
governance-genre and knowledge-tree `index.md` body newest-first within its
existing section/status grouping, via three parallel subagents each handed exact
per-collection ordering data and a strict pure-reorder spec. A pre-existing status
drift (`dedup-recall-probe.md` listed under "Proposed" despite `status: done`) was
found and fixed along the way. The design was persisted as
[`collection-ordering-by-date-modified`](/meta/plans/collection-ordering-by-date-modified.md),
the `maintain-reserved-files` policy now states the convention, and every
reordered file was verified as a byte-identical bullet multiset (pure reorder,
only positions and one new header sentence changed). All gates green; the change
shipped as [PR #70](https://github.com/ob6to8/second-brain/pull/70).

_Editorial note: the session's model was switched from Opus 4.8 to Sonnet 5
partway through via `/model claude-sonnet-5`, with no other effect on the work._

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Extend date-modified collection ordering to all collection types, except glossary | closed | `unrouted` (governance plan doc, not a concept) | - |
| Open PR #70 | closed | `unrouted` | - |
| Capture this session via `/create-pull-request` | closed | `unrouted` | - |

No `concept` (`sb:`-id) docs were touched this session — only governance docs
(a plan, a policy) and code/index files — so there is no route-tag sink and no
`<routes>` regions apply.

## User

See the recent pr where plans were sorted date modified first. Apply this to all collection types - anywhere that is sorted alphabetically should instead be sorted by date modified, EXCEPT for glossary
Continue from where you left off.

## User

Continue

## Assistant

Pushed. Here's a summary of what changed:

**Mechanical (durable, self-maintaining):**
- `SecondBrain.Site.build_node/3` in `lib/second_brain/site.ex` now sorts every rendered nav collection by `timestamp` descending instead of title — with `beliefs/glossary/` carved out to stay alphabetical, since it's a name-keyed reference collection, not a dated one. Two new tests in `site_test.exs` pin both behaviors.

**Convention (hand-maintained index bodies, per PR #68's precedent):**
- Reordered every `index.md` body newest-first within its existing section/status grouping: `meta/plans`, `meta/issues`, `meta/todos`, `meta/threads`, `meta/tutorials`, `meta/analysis`, `meta/flows`, `meta/doctrine`, `meta/elaborations`, `meta/evals`, plus every knowledge-tree/`inbox`/`beliefs` index with a direct concept listing. Subdirectory-map bullets (taxonomy links) were left untouched — those aren't dated collections. Each header now states the convention and links the design doc.
- Fixed a pre-existing drift found along the way: `dedup-recall-probe.md` was listed under "Proposed" despite `status: done`.
- Added the convention to the `maintain-reserved-files` policy and recompiled `CLAUDE.md`.
- Persisted the design record as `meta/plans/collection-ordering-by-date-modified.md`.

All gates green: format, compile, contract/registry/route_tags/lineage checks, `mix brain.verify`, and `mix test` (143 tests). Branch pushed to `claude/sort-collections-date-modified-brq02g`; no PR opened since none was requested.

## User

open a PR for this

## Assistant

PR opened: **[#70](https://github.com/ob6to8/second-brain/pull/70)** — "Order every collection by date modified, except the glossary."

Want me to watch it for CI failures and review comments?
