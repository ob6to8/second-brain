---
type: plan
title: "Collection views by date: order the governance indexes by timestamp"
description: Give plans, todos, and issues a date-ordered view with the least work — keep the entries in each collection's index.md ordered by most recent `timestamp` — while recording the surveyed design space (a generic `mix brain.recent` primitive, skill-level by-date dispatch, a site-side sort toggle) as deferred options.
status: done
provenance: "Claude Code session, 2026-07-13 — operator question ('how might we view a collection according to date modified/created? Say for instance, /plans'), agent survey of the brain's date signals and rendering surfaces, operator ratified `timestamp` as the signal and the two least-work items. Recreated onto post-rename main 2026-07-16 from PR #68 (which predated the second-brain→elixir-mind / sb:→em: rename) as spec."
tags: [meta, plan, indexes, collections, recency, timestamp]
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T06:52:11Z
  channel: agent-authored
  agent: "Claude Code agent, PR-68 recreation session"
  why: "operator ratified persisting the date-ordered-collection design and its least-work resolution as a plan (2026-07-13); recreated onto post-rename main from PR #68 as spec"
  from: [/meta/threads/2026-07-16-recreate-collection-view-by-date.md]
---

# Plan — collection views by date

**Status:** `done` for the ratified scope — the three governance indexes
([plans](/meta/plans/index.md), [todos](/meta/todos/index.md),
[issues](/meta/issues/index.md)) are ordered by most recent `timestamp` and each
states the convention in its header, and this plan records the design. The
heavier surfaces (§Deferred) were surveyed and deliberately not built.

> The design was ratified on 2026-07-13 and first landed as PR #68, cut before
> the second-brain → elixir-mind (and `sb:` → `em:`) rename. Rather than resolve
> that PR's now-pervasive conflicts, the work was recreated from it as a spec on
> post-rename `main`; this doc, its glossary entries, and the reorder are that
> recreation. The decision itself is unchanged.

## Problem

The brain had no way to view a collection by date. The `/plan`, `/todo`, and
`/issue` skills group by `status`, and the `index.md` listings carried no
deliberate ordering at all — so "what changed recently in `meta/plans/`?" had no
answer short of re-deriving it from git or reading every frontmatter. The
operator's motivating example was `/plans`: reviewing the collection by recency.

## The date signals — and the decision

Nothing new needed recording; every doc already carries three date signals:

1. **`attribution.when`** — the immutable ingestion instant, machine-verified by
   `mix brain.verify`. The brain's own semantics for *created*.
2. **`timestamp`** — "last meaningful change," bumped on update-in-place merges.
   The *semantic* modified-date.
3. **Git history** — first/last commit touching the path: the *mechanical*
   created/modified. Authoritative but noisy — it counts route-tag
   materialization, backfills, and other tooling churn as modifications.

**Decision (operator-ratified): `timestamp` is the ordering key.** It marks
*meaningful* change, which is what a recency view of a collection is for; the
commit graph stays the mechanical narrative. Coverage was verified complete at
decision time (every plan, todo, issue, and bundle concept carries one).
Same-day ties break by `attribution.when`, newest first.

## What shipped (the least-work resolution)

1. **Index ordering convention.** Entries in
   [`meta/plans/index.md`](/meta/plans/index.md),
   [`meta/todos/index.md`](/meta/todos/index.md), and
   [`meta/issues/index.md`](/meta/issues/index.md) are kept ordered by
   `timestamp`, most recent first, *within* each existing status section (the
   status grouping stays primary — it is what the listing skills dispatch on).
   The convention is **maintained at filing time**: the
   maintain-reserved-files policy already requires updating the directory's
   `index.md` after filing, so ordering the touched entry correctly is part of
   that same motion, not a new regeneration step. Each index header states the
   convention and links back here, so future agents inherit it from the index
   itself.
2. **This plan** — the durable record of the survey, the decision, and the
   deferred options.

Executed alongside: the reorder surfaced accumulated section drift on the
post-rename main — two done/in-progress plans still sat under the section their
earlier status put them in. Fixed in passing: the `rename-second-brain-to-elixir-mind`
plan (`status: done`) moved from "Accepted / In progress" to "Done / Superseded",
and `transplant-surviving-unmerged-branches` (`status: in-progress`) moved from
"Proposed" to "Accepted / In progress". (PR #68's original run made the same kind
of fix for the dedup-recall-probe plan, which is already correctly placed here.)

## Scope boundaries

- **No policy amendment / contract recompile.** The convention lives in the
  three index headers and this plan; promoting it into the
  maintain-reserved-files policy (and thus `CLAUDE.md`) was judged not worth the
  weight for a three-index convention. Revisit if the convention spreads to
  knowledge-tree indexes.
- **Knowledge-tree `index.md` files are untouched.** Their listings are
  taxonomic (grouped by subject), not chronological; imposing recency ordering
  there would fight the tree-is-the-taxonomy policy's reading of an index as a
  map.
- **No committed date-ordered listings beyond reordering what exists** — a
  separate dated listing would be a hand-kept map that drifts, exactly what the
  retire-hand-kept-logs direction moved away from.

## Deferred

Surveyed, viable, and deliberately not built until a real need shows up:

- **A. `mix brain.recent <dir> [--by created|modified] [--limit N]`** — a
  read-only task reusing `ElixirMind.Frontmatter.parse/1`: sort by `timestamp`
  (modified) or `attribution.when` (created), git-date fallback for docs missing
  the field, a `--git` flag for the mechanical view, recursive so it covers deep
  knowledge dirs. Derived on demand, never committed — the `mix brain.evidence`
  shape. This is the primitive the other deferred items would sit on.
- **B. Skill-level dispatch** — `/plan by-date` (and `/issue`, `/todo`): a
  cross-cutting recency view that ignores status grouping, one SKILL.md
  paragraph once A exists.
- **C. Site-side sort toggle** — the generated Pages site already renders
  `timestamp` as "Updated" on each concept page ([site.ex:410](/lib/elixir_mind/site.ex));
  generated directory pages could grow a client-side sort-by-date control.
  Browsing nicety, no in-session value.

Rejected outright: committed date-ordered sections *separate from* the existing
indexes (drift, per the scope boundary above).
