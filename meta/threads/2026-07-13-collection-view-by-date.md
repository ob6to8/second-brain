---
type: reference
title: 2026-07-13-collection-view-by-date
description: Surveyed the brain's three date signals and four surfaces for viewing a collection by date; the operator ratified `timestamp` as the ordering key and the least-work resolution — the plans/todos/issues indexes now ordered newest-first, the design persisted as a done plan with the heavier surfaces deferred.
provenance: "Claude Code session, 2026-07-13; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, indexes, collections, recency, timestamp]
timestamp: 2026-07-13
---

# 2026-07-13-collection-view-by-date

## Where this landed

The operator asked how a collection (e.g. `/plans`) could be viewed by date
modified/created. The agent's survey found the raw material already recorded —
`attribution.when` (created), `timestamp` (semantic modified), and git history
(mechanical) — and laid out four surfaces: a `mix brain.recent` primitive,
skill-level `by-date` dispatch, a site-side sort toggle, and (rejected)
committed date-ordered listings. The operator ratified `timestamp` as the
signal and chose the least-work resolution: order the entries in the
[plans](/meta/plans/index.md), [todos](/meta/todos/index.md), and
[issues](/meta/issues/index.md) indexes by most recent `timestamp` (within each
status section, convention stated in each index header), and persist the design
as the [collection-view-by-date plan](/meta/plans/collection-view-by-date.md)
(`status: done`, with the heavier surfaces under its Deferred heading). One
drift was fixed in passing: the done dedup-recall-probe plan was still listed
under "Proposed".

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Date-ordered collection views — signal survey, decision, index-ordering convention | closed | [collection-view-by-date plan](/meta/plans/collection-view-by-date.md) | - |
| Deferred recency surfaces (`mix brain.recent`, skill `by-date` dispatch, site sort toggle) | paused | [collection-view-by-date plan](/meta/plans/collection-view-by-date.md) | Build the `mix brain.recent` primitive when a real in-session recency need shows up |
| Plans-index status drift (dedup-recall-probe listed as Proposed while `done`) | closed | `unrouted` | - |

## User

How might we create a way to view a collection according to date modified/created? Say for instance, /plans

## Assistant

<routes ref="/meta/plans/collection-view-by-date.md lib/second_brain/site.ex">
Good question to ground in what's already there — I dug through the tooling and here's my assessment.

## The raw material already exists — three date signals per doc

Every collection in the brain already carries enough data to sort by date; nothing new needs to be recorded:

1. **`attribution.when`** — the ingestion instant, immutable, machine-verified by `mix brain.verify`. This *is* "created" in the brain's own semantics, and coverage is complete (the attribution backfill saw to that).
2. **`timestamp`** — "last meaningful change," bumped on update-in-place merges. This is the *semantic* "modified." Coverage check: all 10 plans have it, and zero bundle concepts are missing it.
3. **Git history** — first/last commit touching the path gives *mechanical* created/modified. Authoritative but noisy: it counts route-tag materialization, backfills, and other tooling churn as "modifications," which usually isn't what you mean.

So the design choice isn't "where do dates come from" but "which surface renders the sorted view."

## Options

**A. A read-only mix task as the primitive (recommended)** — something like:

```
mix brain.recent meta/plans --by modified --limit 10
mix brain.recent knowledge/agents --by created
```

It would reuse `SecondBrain.Frontmatter.parse/1`, sort by `timestamp` (modified) or `attribution.when` (created) with git-date fallback, and print a table (date · status · title · path). This follows the brain's existing pattern exactly: derived on demand, never committed — the same shape as `mix brain.evidence`. It works recursively, so it covers deep knowledge dirs, not just flat `meta/` collections. A `--git` flag could switch to commit dates when you want the mechanical view.

**B. Skill-layer dispatch on top of it** — extend `/plan` (and `/issue`, `/todo`) with a `by-date` argument, e.g. `/plan by-date`. Note `/plan` already sorts newest-first *within* status groups; what's missing is the cross-cutting recency view that ignores status. With option A in place, the skill change is one paragraph of SKILL.md.

**C. Site-layer sorting** — the generated Pages site already shows `timestamp` as "Updated" on each concept page ([site.ex:410](/home/user/second-brain/lib/second_brain/site.ex#L410)). Generated directory pages could grow a client-side "sort by date" toggle. Nice for browsing at [the plans index](https://ob6to8.github.io/second-brain/meta/plans/index.html), but it doesn't help in-session, so I'd treat it as a follow-on.

**D. Committed date-ordered sections in `index.md` files — rejected.** That's a hand-maintained map that drifts, exactly what the tree-is-the-taxonomy and retire-hand-kept-logs policies moved away from.

## Recommendation

Build **A**, then **B** as a thin layer over it; defer **C**. One open design point worth your call: whether the default "modified" means `timestamp` (semantic, editorial) or git last-commit (mechanical). I'd default to `timestamp` and offer `--git` — the brain's whole ethos is that `timestamp` marks *meaningful* change while the commit graph holds the mechanical narrative.

Since this is a tooling addition of some substance, per the persist-plans policy I've stopped at the proposal: say the word and I'll persist it as a `type: plan` under `meta/plans/` and implement it on this branch (`claude/collection-view-by-date-29n28w`).
</routes>

## User

<routes ref="/meta/plans/collection-view-by-date.md">
Timestamp

I think two things would resolve this with the least work - 

1. for plans, todos, and issues, list in the items in index by most recent

2. Create a plan documenting what you have outlined here
</routes>

## Assistant

<routes ref="/meta/plans/collection-view-by-date.md /meta/plans/index.md /meta/todos/index.md /meta/issues/index.md">
Both items are done and pushed to `claude/collection-view-by-date-29n28w` (commit `d9a739a`); all verification gates pass.

**1. Indexes ordered by most recent `timestamp`.** The [plans](https://ob6to8.github.io/second-brain/meta/plans/index.html), [todos](https://ob6to8.github.io/second-brain/meta/todos/index.html), and [issues](https://ob6to8.github.io/second-brain/meta/issues/index.html) indexes now keep entries newest-first within each status section (same-day ties broken by `attribution.when`), and each index header states the convention so future agents inherit it at filing time — no new regeneration step, just part of the existing update-the-index motion. One drift surfaced by the reorder and was fixed in passing: the dedup-recall-probe plan was still listed under "Proposed" despite being `done`; it moved to the Done section.

**2. The plan is persisted** as `meta/plans/collection-view-by-date.md` ([live page once merged](https://ob6to8.github.io/second-brain/meta/plans/collection-view-by-date.html)), `status: done` for the ratified scope. It records the three date signals, your ratification of `timestamp` as the ordering key, explicit scope boundaries (no policy amendment, knowledge-tree indexes untouched — they're taxonomic maps, not chronologies), and the deferred options under their own heading: the `mix brain.recent` primitive, skill-level `by-date` dispatch, and the site-side sort toggle.

The verifier emits one expected advisory: the plan's `attribution` lacks `from`, which is correct until this session is captured — `/create-pull-request` stamps the thread path in when it runs. Say the word if you'd like me to run that now to capture the session and open the PR.
</routes>
