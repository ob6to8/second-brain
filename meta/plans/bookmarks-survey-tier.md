---
type: plan
title: "The survey tier: a two-level resource model with a /bookmarks staging register"
description: Add a second, lower-effort resource level beneath the filed reference — a survey tier where links are dropped in bulk, fetched, one-line-summarized, and tagged into a non-bundle survey/ register by a /bookmarks skill, queryable by topic but outside the taxonomy, and promoted to a filed reference via /intake. Amends link-processing's "no bookmark type" line; reuses type: reference rather than adding a type.
status: accepted
provenance: "Claude Code session, 2026-07-22 — the operator asked whether the brain could differentiate fully-ingested links from a lighter survey layer holding many URLs with enough metadata to be surfaced by topic query; designed and built in the same session"
attribution:
  when: 2026-07-22T00:00:00Z
  channel: agent-authored
  agent: "Claude Code agent, survey-tier design session"
  why: "persists the two-level resource model, the register-over-per-file and no-new-type decisions, and the namespace-mirrors-inbox mechanics per the persist-plans policy, as a first-class queryable record of a shape change to the brain"
  from: [/meta/threads/2026-07-22-survey-tier-and-bookmarks-register.md]
tags: [meta, plan, filing, links, survey, bookmarks, namespaces, skill]
timestamp: 2026-07-22
---

# The survey tier: a two-level resource model with a /bookmarks staging register

## Problem

The brain had exactly **one** door for a link. [`link-processing`](/meta/policy/link-processing.md)
closed the middle ground explicitly: *"Do not file bare, unprocessed URLs as their own
documents — process it now, or don't file it. (There is deliberately no lightweight
'bookmark' type.)"* The operator wanted a **second, lower tier**: drop large numbers of
URLs that aren't worth fully ingesting yet, but keep each with enough metadata (a summary
and tags) to be **surfaced when querying by topic**. That is neither a bare URL (the thing
the policy rightly forbids) nor a filed reference — it is a *surveyed* link, a staging
level the model had no room for.

## Decisions

- **Two levels, one bridge.** *Ingested* = a filed `reference` in the taxonomy (today's
  `/intake`: fetched, distilled, cross-linked, `em:` id). *Surveyed* = a bookmark: fetched,
  one-line-summarized, tagged, parked outside the tree. The bridge is **promotion** — a
  surveyed link graduates to a filed reference via `/intake`, the single point where
  [distill, don't dump](/meta/policy/distill-dont-dump.md) re-engages. `distill-dont-dump`
  is **not** amended: it governs documents, and a bookmark isn't one until promotion.
- **Register, not one-file-per-bookmark.** Bookmarks are **rows in a register**
  (`survey/bookmarks.md`), not individual documents. One-file-per-bookmark was the wrong
  weight — it fights the bulk-drop use case (hundreds of tiny files) and pollutes the
  identity graph (an `em:` id per staging link). A register matches the operator's own
  "bookmarks-register.md" mental model and the existing `inbox/` precedent (lists-in-a-doc,
  non-bundle).
- **No new `type`.** Because bookmarks are rows, the doc-level `type` buys no per-bookmark
  queryability; the row's `status` column does that. The register reuses `type: reference`
  exactly as `inbox/` digests do — the controlled-type vocabulary is untouched, no
  ratification of a new type required.
- **A `survey/` namespace mirroring `inbox/`.** Non-bundle: no `em:` ids, never verified,
  outside the taxonomy, exempt from `attribution`. Machine-enforced by mirroring `inbox/`
  in three places (see build order). Tags carry topical surfacing; tree placement waits
  for promotion.
- **`/bookmarks` fetches and auto-summarizes.** The operator's chosen behavior: a light
  `WebFetch` per URL → one sentence + 2–5 kebab-case tags. Mandatory metadata is what keeps
  the tier from degrading into a link graveyard (the original policy's real fear). The
  register has a `## Pending` dropzone the operator pastes into and a `## Surveyed` section
  the skill populates, emptying Pending as it processes.
- **Debt stays visible.** `status: surveyed` vs `promoted → <link>` makes un-promoted links
  countable rather than all-or-nothing — the mitigation for relaxing "distill, don't dump"
  at the edges.

## Artifact shape

- `survey/bookmarks.md` — the register: frontmatter (`type: reference`, no id/attribution),
  a `## Pending` dropzone (operator groups URLs under `### YYYY-MM-DD` date-added
  headings), a `## Surveyed` block list (`### [title](url)` + an **Added** date carried
  from the Pending heading + status/tags + one-line summary). `Added` is the operator's
  date-added, preserved on promotion — distinct from the register's `timestamp`.
- `survey/index.md` — namespace landing page (reserved file, no frontmatter).
- `.claude/skills/bookmarks/SKILL.md` — dispatch: `process` (default), `add`, `list`,
  `promote`.
- Root `index.md` — surfaces `survey/` beside `inbox/`.
- `meta/policy/link-processing.md` — the "no bookmark type" line replaced by the survey-tier
  carve-out; `meta/policy/skills-registry.md` — `/bookmarks` registered. (Both recompiled
  into `CLAUDE.md`.)

## Build order (all complete in this session)

1. **Namespace mechanics** — mirror `inbox/` so `survey/` is non-bundle:
   `ElixirMind.Registry` `@excluded_dirs` (no `em:` id demanded),
   `ElixirMind.Attribution` `governance_paths`/`exempt?` (exempt from attribution, must
   carry none), `ElixirMind.Orphans` `@anchored_dirs` (unreferenced-by-design, not
   flagged). `survey/` is deliberately left **in** link-checking (`ElixirMind.Links`) and
   **in** the rendered site (`SiteConfig`) so its links resolve and its pages/search work.
2. **Namespace content** — `survey/bookmarks.md`, `survey/index.md`, root-index entry.
3. **Policy** — the `link-processing` carve-out and the `skills-registry` entry; recompile
   `CLAUDE.md` via `mix brain.contract`.
4. **Skill** — `.claude/skills/bookmarks/SKILL.md`.
5. **Regenerate & verify** — `mix brain.codemap` (lib edited), then the full gate
   (`format`, `test`, `contract --check`, `registry --check`, `codemap --check`, `verify`,
   `route_tags`, `glossary`, `lineage --check`, `dev_history --check`, `site`), plus new
   test coverage for the `survey/` exclusion in `registry_test`/`attribution_test`.

## Deferred

- **Sharding.** Start single-file; split by top-level domain (`survey/ai.md`,
  `survey/swe.md`) only when `survey/bookmarks.md` grows unwieldy — a shape change to
  surface to the operator when it happens.
- **A `mix brain.bookmarks` view / frontmatter-native rows.** If per-bookmark querying
  outgrows full-text search over the register body, revisit promoting rows to a
  machine-parsed form (or one-file-per-bookmark after all). Not needed at current scale.
- **Bulk-promote / auto-promote heuristics.** Promotion is one-at-a-time and
  operator-driven for now; a "promote all tagged X" motion can follow if the tier fills up.
