---
type: reference
title: 2026-07-16-recreate-collection-view-by-date
description: Investigated whether PR #68 (date-ordered governance indexes) was worth conflict-resolving onto post-rename main or better recreated from as a spec; determined recreate, and rebuilt the work — the plans/todos/issues indexes ordered newest-first by `timestamp`, the collection-view-by-date plan and `timestamp` glossary entry re-created with em: ids and elixir-mind refs, and two accumulated index section-drifts fixed in passing.
provenance: "Claude Code session, 2026-07-16; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, indexes, collections, recency, timestamp, pr-recreation]
timestamp: 2026-07-16
---

# 2026-07-16-recreate-collection-view-by-date

## Where this landed

The operator asked whether [PR #68](https://github.com/ob6to8/elixir-mind/pull/68)
— which gave the governance collections a date-ordered view — was worth
conflict-resolving, given the repo has moved on. Investigation confirmed PR #68
was cut before the second-brain → elixir-mind / `sb:` → `em:` rename: it
conflicts on nearly every touched file (registry, three indexes, glossary),
embeds stale `sb:` ids, `SecondBrain` module paths, and `second-brain` URLs
throughout its *body content*, and one of its edits (the dedup-recall-probe
drift fix) is already done on main. Verdict: **recreate from it as a spec**, not
merge-fix — and this branch was already a clean branch off current main, set up
for exactly that.

The operator chose the full faithful recreation. Rebuilt on post-rename main: the
[plans](/meta/plans/index.md), [todos](/meta/todos/index.md), and
[issues](/meta/issues/index.md) indexes now keep entries newest-first by
`timestamp` within each status section (convention stated in each header), the
design is persisted as the
[collection-view-by-date plan](/meta/plans/collection-view-by-date.md)
(`status: done`, heavier surfaces deferred), and the dual-sense
[timestamp](/beliefs/glossary/timestamp.md) glossary entry (`em:59cff6`) plus the
[attribution](/beliefs/glossary/attribution.md) created-date nuance were
re-created with `em:` ids and elixir-mind references. Two accumulated index
section-drifts surfaced by the reorder were fixed in passing: the `done` rename
plan moved out of "Accepted / In progress", and the `in-progress` transplant
plan moved out of "Proposed". All gates green (verify, route_tags, registry
--check, contract --check, 156 tests / 0 failures).

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| PR #68 merge-fix vs. recreate — investigation and verdict | closed | [collection-view-by-date plan](/meta/plans/collection-view-by-date.md) | - |
| Date-ordered collection views — convention, plan, glossary (recreated on post-rename main) | closed | [collection-view-by-date plan](/meta/plans/collection-view-by-date.md) | - |
| Deferred recency surfaces (`mix brain.recent`, skill `by-date` dispatch, site sort toggle) | paused | [collection-view-by-date plan](/meta/plans/collection-view-by-date.md) | Build the `mix brain.recent` primitive when a real in-session recency need shows up |
| Index section-drift fixed in passing (rename→Done, transplant→In-progress) | closed | [plans index](/meta/plans/index.md) | - |

## User

See pr 68 - the repo has moved on quite a bit since this was written and it may not be worth trying to fix merge conflicts - may be better to use it as a spec and recreate the work ona branch built off main. Investigate

## Assistant

<routes ref="/meta/plans/collection-view-by-date.md">
## Investigation: PR 68 — merge-fix vs. recreate

**Verdict: recreate off `main`. Do not fix the conflicts.** The evidence is decisive.

**What PR 68 delivers** (a small, self-contained convention change):
- Orders the `plans` / `todos` / `issues` index entries newest-first by `timestamp` within each status section, with the convention stated in each index header
- A `collection-view-by-date` plan doc (the design record; `status: done`)
- A `timestamp` glossary entry + a created-date nuance on the `attribution` entry
- A session thread doc, plus registry/index refreshes
- A "drift fix in passing" (dedup-recall-probe plan moved Proposed → Done)

**Why merging is the wrong tool** — PR 68 was cut on 2026-07-13, *before* the big rename, and main has moved substantially since:

| Divergence | PR 68 branch | Current `main` |
|---|---|---|
| ID namespace | mints `sb:715275` | `sb:` → `em:` bundle-wide migration done |
| Module / paths | `SecondBrain.Frontmatter`, `lib/second_brain/site.ex` | `ElixirMind`, `lib/elixir_mind/…` |
| Site URLs | `ob6to8.github.io/second-brain/…` | `…/elixir-mind/…` |
| `registry.md` | old `sb:` rows | fully `em:`, different content |

Nearly every touched file (registry, three indexes, glossary index, attribution entry) conflicts, and the diff carries stale ids, module names, and URLs throughout its *body content* — things a conflict resolver wouldn't catch, only a rewrite would. Worse, one of its changes is **already moot**: the dedup-recall-probe "drift fix" is unnecessary because on current main that plan is *already* in the Done section. So a conflict-resolve would drag along a no-op edit and a pile of stale references.

**None of the deliverables exist on main** — `collection-view-by-date.md`, the thread doc, and `timestamp.md` are all absent; the three index headers still lack the convention. So there's clean-slate work to do, with PR 68 as a faithful spec. And this branch (`claude/pr-68-merge-conflicts-shg16o`) is already a pristine branch off current main — set up for exactly this.

The design was **already operator-ratified** (`timestamp` as the ordering key + the least-work resolution), so recreating is re-applying settled decisions to current main, not reopening them. I'll proceed.
</routes>

## User

Ask question in thread here, no tool

## Assistant

<routes ref="/meta/plans/collection-view-by-date.md /meta/plans/index.md">
Understood — per this brain's own "ask in the chat, not the dialog box" convention, here it is inline.

## Recommendation stands: recreate off main (this branch is already set up for it)

The investigation is conclusive — PR 68 predates the `second-brain`→`elixir-mind` + `sb:`→`em:` rename, conflicts on nearly every touched file, embeds stale ids/module-paths/URLs in its *body content*, and one of its edits (the dedup drift fix) is already done on main. Recreating from it as a spec is clearly right.

**One scope question before I write anything.** PR 68's convention is "order each index's entries by `timestamp`, newest first, *within each status section*." Applying that to *current* main surfaces section-drift that has accumulated since (the indexes weren't kept sorted, and a couple of entries are now in the wrong section for their status):

- **`rename-second-brain-to-elixir-mind`** — `status: done`, but currently listed under **Accepted / In progress**
- **`transplant-surviving-unmerged-branches`** — `status: in-progress`, but currently listed under **Proposed**

You can't order a section correctly while entries sit in the wrong section, so a truly faithful recreation re-sections those two (PR 68 did the same kind of "drift fix in passing" for dedup-recall-probe — that one's already fixed on main).

How far should I go?

1. **Full faithful recreation** *(my recommendation)* — add the convention to the three index headers + create the `collection-view-by-date` plan doc + the `timestamp` glossary entry + the `attribution` created-date nuance, mint an `em:` id, regenerate the registry, **and** reorder every entry by `timestamp`, moving the two drifted plans into their correct sections. I'll list each drift fix explicitly in the summary.
2. **Deliverables only, no reorder** — everything above *except* touching the existing entry order; you reorder/ratify later. Safest, smallest diff.
3. **Reorder within sections, skip drift** — sort each section by `timestamp` but leave the two mis-sectioned entries where they are.

I'll also persist this session (thread doc) so the plan's `attribution.from` and the glossary "Seen in" links resolve, and run all gates (`mix brain.verify`, `route_tags`, `registry --check`, `contract --check`, tests) before committing and pushing to `claude/pr-68-merge-conflicts-shg16o`. No PR unless you ask.

Which scope?
</routes>

## User

1

## Assistant

<routes ref="/meta/plans/collection-view-by-date.md /meta/plans/index.md /meta/todos/index.md /meta/issues/index.md /beliefs/glossary/timestamp.md /beliefs/glossary/attribution.md">
Pushed. Done.

## Summary

**Investigation verdict: PR #68 was not worth conflict-resolving — recreated from it as a spec instead.** PR #68 was cut on 2026-07-13, before the `second-brain`→`elixir-mind` / `sb:`→`em:` rename, and:
- conflicts on nearly every touched file (registry, three indexes, glossary),
- embeds stale `sb:` ids, `SecondBrain` module paths, and `second-brain` URLs *inside its body content* (things a conflict resolver wouldn't fix — only a rewrite would),
- and one of its edits (the dedup-recall-probe "drift fix") is already done on main.

None of its deliverables existed on main, and the design was already operator-ratified — so recreating was re-applying settled decisions to current main.

**Recreated on `claude/pr-68-merge-conflicts-shg16o`** (10 files, same shape as PR #68, adapted to post-rename main):
- **Convention** — plans/todos/issues index entries now ordered newest-first by `timestamp` within each status section, stated in each header, linking back to the plan.
- **Plan** — `meta/plans/collection-view-by-date.md` (`status: done`), with `em:` refs, elixir-mind URLs, `ElixirMind.Frontmatter`/`site.ex:410`, and a note recording that it's the recreation.
- **Glossary** — new dual-sense `timestamp` entry (freshly minted **`em:59cff6`**) + the `attribution` created-date nuance; glossary index and registry refreshed.
- **Session thread doc** — `meta/threads/2026-07-16-recreate-collection-view-by-date.md`, so the plan's `attribution.from` and glossary *Seen in* links resolve.
- **Two drift-fixes in passing** (surfaced by the reorder, and beyond what PR #68's smaller main had): the `done` `rename` plan moved to **Done/Superseded**; the `in-progress` `transplant` plan moved to **Accepted/In progress**.

**All gates green:** `mix brain.verify`, `mix brain.route_tags`, `registry --check`, `contract --check`, **156 tests / 0 failures**. (The only verify/route_tags warnings are pre-existing and unrelated to this change.)

No PR opened (you didn't ask for one). When you're ready, `/create-pull-request` will capture-finalize this session, stamp the thread's `pr:`, and open it — or `/create-pull-request merge` to also drive it to a true-merge.

One thing worth your eye: I re-sectioned the two drifted plans as part of honoring the convention. If you'd rather I hadn't touched their placement, say so and I'll revert just those moves.
</routes>
