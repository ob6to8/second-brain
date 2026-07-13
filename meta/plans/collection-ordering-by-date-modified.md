---
type: plan
title: "Collection ordering by date modified: make recency the default sort everywhere but the glossary"
description: Order every collection in the brain — the rendered site navigation and the governance and knowledge-tree index.md bodies — by most recent `timestamp` (date modified) first, replacing alphabetical ordering, with the glossary held out as a name-keyed reference collection that stays A–Z.
status: done
provenance: "Claude Code session, 2026-07-13 — operator directive: 'apply [the plans date-modified ordering of PR #68] to all collection types — anywhere that is sorted alphabetically should instead be sorted by date modified, EXCEPT for glossary'"
attribution:
  when: 2026-07-13T17:30:00Z
  channel: agent-authored
  agent: "Claude Code agent, collection-ordering-by-date-modified session"
  why: "persists the operator-ratified extension of the date-ordered-collection convention to every collection surface per the persist-plans policy"
  from: [/meta/threads/2026-07-13-collection-ordering-by-date-modified.md]
tags: [meta, plan, indexes, collections, recency, timestamp, site]
timestamp: 2026-07-13
---

# Plan — collection ordering by date modified

**Status:** `done`. Recency (`timestamp`, newest first) is now the ordering key
for every collection surface except the glossary: the site generator's navigation
sort, and the `index.md` body listings across the governance genres and the
knowledge tree.

## Problem

[PR #68](https://github.com/ob6to8/second-brain/pull/68) (not yet merged as of
this plan; its `collection-view-by-date` design doc is not on this branch) gave
the `plans`, `todos`, and `issues` indexes a date-ordered view by hand, and
settled the signal question: **`timestamp` is the ordering key** (the
*meaningful*-change date; same-day ties break by `attribution.when`), leaving a
generic site-side sort explicitly deferred. The operator then directed that the
same treatment apply to **all** collection types — *"anywhere that is sorted
alphabetically should instead be sorted by date modified, EXCEPT for glossary"*
— which is the deferred mechanical option (a default recency sort) plus the
remaining index bodies.

## The decision

- **Ordering key: `timestamp`, descending** (newest modified first). Same-day ties
  break by `attribution.when`, then title. Inherited from PR #68; every bundle
  concept and governance doc carries a `timestamp`, so coverage is complete. ISO
  8601 dates sort as strings, so no date parsing is needed.
- **The glossary is the sole exception.** It is a name-keyed *reference*
  collection — terms are looked up by name, not browsed by recency — so
  [`beliefs/glossary/`](/beliefs/glossary/index.md) (and anything nested under it)
  keeps alphabetical, case-insensitive ordering, as
  [`/add-to-glossary`](/.claude/skills/add-to-glossary/SKILL.md) already maintains.

## What shipped

1. **Mechanical: the site navigation sort.** `SecondBrain.Site.build_node/3`
   sorted every directory's files alphabetically by title; it now sorts by
   `timestamp` (descending), with a `beliefs/glossary/` carve-out that stays
   alphabetical (`SecondBrain.Site.sort_files/2` + `alphabetical_dir?/1`). This is
   the durable, self-maintaining half — every rendered collection view (the whole
   nav sidebar) is date-ordered automatically, with no per-file upkeep. Two
   `site_test.exs` cases pin it: a non-glossary collection lists newest-first even
   when that disagrees with alphabetical, and the glossary stays A–Z even when
   dates disagree.
2. **Convention: the index.md bodies.** Every governance genre index (`plans`,
   `todos`, `issues`, `threads`, `elaborations`, `analysis`, `tutorials`,
   `doctrine`, `flows`, `evals`) and every knowledge-tree / `inbox` / `beliefs`
   index lists its concept entries by most recent `timestamp` first — within each
   existing `status`/section grouping where one exists (the grouping stays
   primary; recency orders *within* it). Each index header states the convention
   and links here, so the ordering is inherited from the index itself and
   maintained at filing time (the maintain-reserved-files motion already touches
   the index on every filing). Subdirectory-map bullets (links to child
   `index.md` files) keep their structural order — they are a taxonomy map, not a
   dated collection.

## Scope boundaries

- **Glossary untouched** — the ratified exception, alphabetical in both the nav
  and its index body.
- **Subdirectory listings stay structural** — an `index.md`'s "Subdirectories"
  section maps the taxonomy; only leaf-concept listings are recency-ordered.
- **No new committed dated listing** — this reorders what already exists and flips
  one sort in the generator; it does not add a separate hand-kept recency map
  (which would drift, per the retire-hand-kept-logs direction).
- **`mix brain.recent` primitive and skill-level `by-date` dispatch** — the
  heavier deferred options PR #68 surveyed — stay deferred; not needed to
  satisfy the directive.
