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
[timestamp](/beliefs/glossary/timestamp.md) glossary entry plus the
[attribution](/beliefs/glossary/attribution.md) created-date nuance were
re-created with `em:` ids and elixir-mind references. Two accumulated index
section-drifts surfaced by the reorder were fixed in passing: the `done` rename
plan moved out of "Accepted / In progress", and the `in-progress` transplant
plan moved out of "Proposed".

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
**Verdict: recreate off `main`. Do not fix the conflicts.**

PR #68 delivers a small, self-contained convention change: ordering the plans / todos / issues index entries newest-first by `timestamp` within each status section, a `collection-view-by-date` plan doc, a `timestamp` glossary entry plus an `attribution` created-date nuance, a session thread doc, and registry/index refreshes, with a "drift fix in passing" (dedup-recall-probe moved Proposed → Done).

Merging is the wrong tool because PR #68 was cut on 2026-07-13, before the big rename, and main has moved substantially: the id namespace went `sb:` → `em:` bundle-wide; the module/paths went `SecondBrain` → `ElixirMind` (`lib/second_brain/…` → `lib/elixir_mind/…`); the site URLs went `second-brain` → `elixir-mind`; and `registry.md` diverged entirely. Nearly every touched file conflicts, and the diff carries stale ids, module names, and URLs throughout its *body content* — things a conflict resolver wouldn't catch, only a rewrite would. Worse, the dedup drift fix is already moot: on current main that plan is already in the Done section.

None of the deliverables exist on main, and this branch is already a pristine branch off current main — set up for exactly this. The design was already operator-ratified (`timestamp` as the ordering key + the least-work resolution), so recreating is re-applying settled decisions to current main, not reopening them.
</routes>

## Assistant

<routes ref="/meta/plans/index.md /meta/plans/collection-view-by-date.md">
One scope question before writing anything. PR #68's convention is "order each index's entries by `timestamp`, newest first, within each status section." Applying that to current main surfaces section-drift that accumulated since: `rename-second-brain-to-elixir-mind` is `status: done` but listed under "Accepted / In progress", and `transplant-surviving-unmerged-branches` is `status: in-progress` but listed under "Proposed". You can't order a section correctly while entries sit in the wrong section, so a truly faithful recreation re-sections those two — the same kind of "drift fix in passing" PR #68 did for dedup-recall-probe.

Options: (1) full faithful recreation including the reorder and re-sectioning; (2) deliverables only, no reorder; (3) reorder within sections but skip the drift. Recommendation: full faithful recreation.
</routes>

## User

1

## Assistant

<routes ref="/meta/plans/collection-view-by-date.md /meta/plans/index.md /meta/todos/index.md /meta/issues/index.md /beliefs/glossary/timestamp.md /beliefs/glossary/attribution.md">
Full faithful recreation done on `claude/pr-68-merge-conflicts-shg16o`. The three governance indexes now keep entries newest-first by `timestamp` within each status section, with the convention stated in each header and linking back to the plan. The [collection-view-by-date plan](/meta/plans/collection-view-by-date.md) is persisted (`status: done`), recording the three date signals, the operator's ratification of `timestamp` as the ordering key, the scope boundaries, and the deferred surfaces (`mix brain.recent`, skill `by-date` dispatch, site sort toggle). The dual-sense [timestamp](/beliefs/glossary/timestamp.md) glossary entry was minted fresh with an `em:` id, and the [attribution](/beliefs/glossary/attribution.md) entry gained the `when`-as-created-date nuance. Two section-drifts were fixed in passing: the `done` rename plan moved to "Done / Superseded" and the `in-progress` transplant plan moved to "Accepted / In progress". All gates green.
</routes>
