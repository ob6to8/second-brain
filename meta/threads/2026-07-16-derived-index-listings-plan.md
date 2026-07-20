---
type: reference
title: 2026-07-16-derived-index-listings-plan
description: Investigated unmergeable PR #70, and the operator redirected from re-doing its hand-reorderings to deriving the index listings themselves — landed as the derived-index-listings plan (mix brain.index generator, write-time summary field, the write-time-vs-build-time LLM-placement decision rule), reconciled mid-session with PR #68's salvage landing via PR #95.
provenance: "Claude Code session (claude-fable-5), 2026-07-16; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, indexes, collections, generated-artifact, llm-placement, plans]
timestamp: 2026-07-16
session: https://claude.ai/code/session_015cRDSzmqfcqdHexYL8Fpfi
pr: 97
---

# 2026-07-16-derived-index-listings-plan

## Where this landed

The operator pointed at PR #70 ("order every collection by date modified"),
suspecting its merge conflicts weren't worth fixing. Investigation confirmed it:
the PR predates the `SecondBrain` → `ElixirMind` rename and the knowledge-tree
reorganization, and `main` had accumulated heavy index churn since its base — so
use-as-spec, not merge. The operator then redirected the goal itself: if ordering
is a derived property of the live site, the listings shouldn't be hand-maintained
at all. That became the session's deliverable — the
[derived-index-listings plan](/meta/plans/derived-index-listings.md)
(`status: proposed`): a `mix brain.index` generator deriving every directory's
listing section from its children's frontmatter, a new write-time `summary`
field absorbing the curated indexes' editorial bullets, and an explicit
LLM-placement decision rule (write-time in the authoring agent, never build-time
in the deterministic pipeline — *agents write, compilers derive, checkers
compare*). Along the way the session established that PR #68 is #70's unmergeable
sibling from the same 2026-07-13 session, and — after pulling `main` — that
#68 had just been closed and recreated as merged PR #95, so the plan's salvage
step was struck as done. Session closed with the operator's "Merge": this PR is
true-merged by the `/create-pull-request merge` flow that captured this thread.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| PR #70 investigation — unmergeable; use-as-spec verdict | closed | [derived-index-listings plan](/meta/plans/derived-index-listings.md) | - |
| Derived listings design: `mix brain.index`, `summary` field, ordering/grouping rules | closed | [derived-index-listings plan](/meta/plans/derived-index-listings.md) | - |
| LLM placement — write-time vs build-time decision rule | closed | [derived-index-listings plan](/meta/plans/derived-index-listings.md) | - |
| PR #68 overlap with #70; salvage of its orphaned artifacts | closed | [derived-index-listings plan](/meta/plans/derived-index-listings.md) | - |
| Plan execution (build the generator, migrate summaries, retire hand-listing policy) | paused | [derived-index-listings plan](/meta/plans/derived-index-listings.md) | A later session builds against the plan; operator may flip `status` to `accepted` |

## User

See pr 70 - the repo has moved on quite a bit since this was written and it may not be worth trying to fix merge conflicts - may be better to use it as a spec and recreate the work ona branch built of main. Investigate

## Assistant

<routes ref="/meta/plans/derived-index-listings.md lib/elixir_mind/site.ex">
## Investigation: PR #70

**Verdict: don't fix the conflicts — recreate from main. PR #70 is unmergeable and most of its diff is now stale.**

### What PR #70 does
"Order every collection by date modified, except the glossary." Two distinct parts:

1. **Mechanical core** (durable, self-maintaining): `Site.build_node/3` sorts nav collections by `timestamp` desc instead of title, with a `beliefs/glossary/` alphabetical carve-out. New helpers `sort_files/2`, `alphabetical_dir?/1`, `recency_key/1`, plus 2 test cases. ~40 lines in `site.ex`, ~55 in `site_test.exs`.
2. **Convention bulk**: hand-reordering the bodies of ~30 `index.md` files newest-first, plus a plan doc, a policy edit, and regenerated `CLAUDE.md`/`registry.md`.

### Why it can't be merged as-is
The repo has moved substantially since PR #70's base (`7434013`, 2026-07-13):

- **The whole module was renamed** `SecondBrain` → `ElixirMind`. PR #70 edits `lib/second_brain/site.ex` and `test/second_brain/site_test.exs` — **neither path exists anymore** (now `lib/elixir_mind/…`). Git can't even rename-track cleanly across this.
- **The knowledge tree was reorganized.** PR #70 reorders e.g. `knowledge/SWE/agentic-coding/agentic-loop/index.md` — that path is now `knowledge/SWE/agentic/anthropic/…`. Entire subtrees moved.
- **Index drift is large**: **358 insertions / 161 deletions across index.md files on main since the PR base**, on top of PR #70's own 458/84 touching the same files. Re-applying PR #70's reordered bodies would *revert* newer intake.

So a merge would be a wall of conflicts, and even fully resolved, the copied reorderings would be wrong (stale paths, dropped entries).

### What ports cleanly vs. what must be re-derived
| Piece | Action |
|---|---|
| `site.ex` sort logic + 2 tests | **Port near-verbatim** — module is internal, only lands in `ElixirMind.Site`; add `nav_pos` helper to test |
| Plan `collection-ordering-by-date-modified.md` | Port with fresh id/attribution |
| Policy `maintain-reserved-files.md` edit | Re-derive (small) |
| ~30 `index.md` reorderings | **Re-derive fresh against current main** — do NOT copy from PR #70 |
| `CLAUDE.md`, `registry.md` | Regenerate via `mix`, never hand-copy |

The mechanical change is the real payload — it makes the nav sort by date *automatically and forever*. The index-body reorderings are the brittle, now-stale part that has to be redone from scratch anyway.

My branch `claude/pr-70-merge-conflicts-hj3xlj` is already sitting exactly on latest `origin/main`, so it's the right base to rebuild on.

### How do you want to proceed?

I'd recommend I rebuild it here: port the mechanical change + tests + plan + policy, then re-derive every collection index newest-first against *current* main (glossary excepted), and regenerate `CLAUDE.md`/`registry.md`. That's ~30 index files to reorder by hand — the bulk of the effort.

Want me to do the full rebuild, or just the durable mechanical core (site sort + tests + plan/policy) and leave the index-body reorderings as a follow-up? The mechanical change alone gets you correct date-ordering on the deployed site; the hand-reorderings only affect the checked-in `index.md` bodies.
</routes>

## User

<routes ref="/meta/plans/derived-index-listings.md">
If the correct date-ordering is a derived property of the display on the live site, do we need to list items on the index? A need to edit "by hand" to keep in sync seems like unecessary complexity if derivation works
</routes>

## Assistant

<routes ref="/meta/plans/derived-index-listings.md lib/elixir_mind/site.ex">
Important: the **nav sidebar** is derived from the filesystem (that's what PR #70 sorts), but the **index page's main content** is the hand-written body of `index.md` — rendered verbatim via `Markdown.to_html`. So there are two parallel representations. Let me check whether the hand-written listing carries anything the filesystem+frontmatter doesn't already have.
</routes>

<routes ref="/meta/plans/derived-index-listings.md">
This settles it. Every concept file carries a `description` in frontmatter, and the pure listings (`## Contents`, `## Terms`) are just `link — that description`. So those listings are **fully derivable** — and hand-sorting them is precisely the needless sync work you're pointing at.

## You're right — and it reframes PR #70

Here's the distinction the PR blurred. There are **three** things, not two:

**1. The nav sidebar** — already derived from the filesystem (that's what PR #70 sorts), shown on every page. This is PR #70's durable core (`sort_files/2`). Zero hand-maintenance, self-correcting. Keep this.

**2. The `index.md` page body** — this is *not* auto-generated. When you visit `/meta/plans/index.html`, the main content is the hand-written body of `plans/index.md`, rendered verbatim. So the body isn't a redundant copy of the nav (nav = titles only; body adds descriptions + curation). But it splits into two populations:

- **Pure listings** (knowledge tree, `inbox`, `beliefs/glossary`): every bullet is `[link] — <child's frontmatter description>`. I confirmed every concept carries `description`; the glossary one-liners already mirror it. **These are 100% derivable.** Hand-maintaining their order — or their existence — is pure overhead.
- **Curated governance indexes** (`plans`, `issues`, `analysis`, …): the bullets are multi-sentence editorial synthesis with status grouping and genre-intro prose, far beyond any frontmatter `description`. Look at the plans index — "*operator-designated top priority (`priority: 1`)…*". **That can't be derived without destroying authored content.**

**3. Ordering** — for the pure listings, ordering is a mechanical property that should be derived (never touched by hand). For the curated indexes, ordering is an editorial choice, and PR #70's "sort these by date too" is exactly the low-value hand-work worth dropping.

## What this means for the work

PR #70 had the right *durable* idea (derive nav order) wrapped around the *anti-pattern* you just named (hand-reorder 30 index bodies). The better move — aligned with your principle — is to push **more** into derivation, not recreate the hand-sorting:

- **Ship** the nav sort (PR #70's `site.ex` core + tests). Small, self-maintaining.
- **Drop** PR #70's 30 hand-reorderings entirely.
- **New, better change:** have `mix brain.site` *generate* the `## Contents` / `## Terms` sections for pure-listing directories at build time (date-sorted; glossary A–Z), from children + their `description` frontmatter. Then relax `maintain-reserved-files.md` so those dirs stop being hand-maintained at all. Curated governance indexes stay hand-written (their value *is* the curation) but nobody hand-sorts them.

That deletes a whole class of drift instead of re-doing it.

This changes a policy (the `index.md` hand-update mandate) and the site build — a change to the *shape* of the brain, so it's yours to ratify. Two questions before I go further:

1. **Scope** — do you want just the durable nav sort now (safe, small), or the full move to **build-time-derived listings** for the pure-listing directories (the real fix, bigger)?
2. **Curated indexes** — leave the governance genre indexes (`plans`/`issues`/etc.) hand-written as they are, or would you also want their *skeleton* derived with hand-authored annotations layered on? (I'd recommend leaving them hand-written — the synthesis is the point.)

If you want the derivation route, I'll persist it as a `type: plan` first (per the persist-plans policy) so the design and this reasoning survive, then build against it.
</routes>

## User

<routes ref="/meta/plans/derived-index-listings.md">
Our deliverable for this session is a plan that a later session will build against

1- full move to build-time-derived listings

2- what would hand-written look like if it too was derived programatically? I assume each summary would be generated on creation of the plan artifact? If so, should the creation of the summary just be done as part of the plan creation process? Or - should there be a call to an llm somewhere in Site.build_nodes, or somewhere else? What does it look like to add discrete calls to llms to carry out functions like this embedded in worflows like these?
</routes>

## Assistant

<routes ref="/meta/plans/derived-index-listings.md">
The plan is filed and pushed. **`meta/plans/derived-index-listings.md`** on `claude/pr-70-merge-conflicts-hj3xlj` (commit `35d89f2`), registered in the plans index, all verification gates green. (It'll get a Pages URL once merged; until then the branch link is the navigable one.)

What the plan specs, and the answers to your two points:

**1. Full derivation.** A new `mix brain.index` (`--materialize`/`--check`, same idiom as `brain.route_tags` and `brain.lineage`) re-derives every directory's listing section from its children's frontmatter, wired into CI and the pre-commit hook. The generator owns only the marked listing block — hand-written preamble prose stays above it, which is the exact hybrid shape the route-tagged excerpt logs already use. Ordering is data-driven everywhere: files newest-first, glossary A–Z, subdirectory bullets alphabetical (taxonomy maps are structural, not dated), and status grouping appears automatically wherever children carry a `status` field — no per-directory config. PR #70's nav-sort core ports near-verbatim, with nav and listings sharing one ordering module so they can't disagree.

**2. Where the LLM call lives: at the authoring edge, not in the build.** Your instinct was right — the summary is generated as part of artifact creation. The key observation is that every doc in this brain is *already* authored by an agent session, so an LLM is already in the loop at exactly the moment the doc's meaning is freshest. The plan adds a `summary` frontmatter field (multi-sentence editorial text, richer than `description`), written by the authoring agent when it creates or substantively revises the doc; the index bullet renders `summary || description`. The existing curated bullets are migrated verbatim onto their docs, so nothing hand-written is lost — it just moves to the artifact it describes.

An LLM call *inside* `Site.build`/`brain.index` was considered and rejected for three structural reasons: your `--check` gates work by re-deriving and byte-comparing, which a non-deterministic step can never pass; CI and the Pages deploy would need API secrets and per-build spend; and the site would stop being reproducible from a commit. Mechanically it's easy — an HTTP call to the Messages API from a mix task, or a shell-out to headless Claude (`claude -p`) — and the plan keeps that shape available as an optional `mix brain.summarize` backfill tool (generate → operator reviews → commit). But that's still write-time architecturally. The decision rule the plan records for all future "should an LLM call go here?" questions: **agents write, compilers derive, checkers compare** — LLM output enters the system only as committed, reviewable source.

The plan is `status: proposed` with three open questions flagged for the build session (generated-heading ownership, threads-index granularity, verifier treatment of `summary`). Flip it to `accepted` if the design as written matches your intent. It also records the PR #70 disposition: close unmerged once this ships, with its branch deletion proposed to you rather than automatic, per the branch-deletion policy.
</routes>

## User

<routes ref="/meta/plans/derived-index-listings.md">
Check out pr 68 - is there overlap between that and 70?
</routes>

## Assistant

<routes ref="/meta/plans/derived-index-listings.md /meta/plans/collection-view-by-date.md">
Now the full picture is clear. **Yes — substantial overlap: PR #70 semantically subsumes PR #68**, and both are open, unmergeable siblings from the *same session* (`session_0178xLQ4gm6TTuzVhfrVreAw`, 2026-07-13). They're not stacked branches — #68 forked before the PR #67 merge, #70 after — but #70 was written with #68's content in context and re-applies it:

- **#68** (the "least-work" first pass): reorders just the 3 governance indexes (plans/todos/issues) newest-first, states the convention in their headers, and files the `collection-view-by-date` plan — the decision record ratifying `timestamp` as the ordering key, with the deferred options (`mix brain.recent`, skill `by-date` dispatch, site sort toggle).
- **#70** (the extension): reorders *every* index and adds the mechanical nav sort. Its reorder of plans/todos/issues includes #68's; it even **duplicates #68's glossary `timestamp` entry** (`sb:715275`) since neither had merged.

Neither carries the other's plan or thread doc, though. What #68 uniquely holds that #70 and my new plan don't: the **date-signals survey and decision record** (`collection-view-by-date.md`, ratifying `timestamp` over `attribution.when`/git-dates, with the deferred `mix brain.recent` options), its **thread doc** (`pr: 68`), and the **glossary `timestamp` entry**. None of that exists on `main` — and both branches are pre-rename (`sb:` ids, `second_brain` paths), so both are stale the same way.

My plan only recorded a disposition for #70. Let me amend it to cover #68 and the salvage step:
</routes>

<routes ref="/meta/plans/derived-index-listings.md /meta/plans/collection-view-by-date.md">
**Yes — PR #68 and #70 overlap almost completely, and the plan now handles both.** Pushed as `b3b8e7a`.

The relationship, in brief:

- **Same session, sibling branches.** Both came out of `session_0178xLQ4gm6TTuzVhfrVreAw` on 2026-07-13. #68 was the operator-ratified "least-work" pass (reorder just the plans/todos/issues indexes newest-first by `timestamp`); #70 was the same session extending it to every collection plus the mechanical nav sort, after you directed "apply this to all collection types."
- **#70 subsumes #68's convention.** #70's every-index reorder includes #68's three indexes, and #70 independently re-creates #68's glossary `timestamp` entry — if both merged they'd collide. Neither branch contains the other's commits.
- **Both are equally stale.** Same pre-rename vintage: `sb:` ids, `lib/second_brain` paths, the old `second-brain` Pages URLs, and the pre-reorganization knowledge tree. #68 shows `mergeable_state: dirty` just like #70. Neither can merge, and both are made obsolete by the derivation approach anyway — the convention they establish ("keep the index ordered by hand at filing time, state it in the header") is precisely what `mix brain.index` retires.

**What #68 has that nothing else does** — three artifacts that never reached `main` and aren't on #70's branch either:

1. The **`collection-view-by-date` plan doc** — the decision record underneath everything since: the survey of the three date signals (`attribution.when` = created, `timestamp` = semantic modified, git = mechanical), your ratification of `timestamp` as the ordering key, and the deferred options (`mix brain.recent`, `/plan by-date`, site sort toggle) that are still live ideas.
2. Its **thread doc** (`pr: 68`), which that plan's `attribution.from` points at.
3. The **glossary `timestamp` entry** (`sb:715275` — I checked the registry: the tail is collision-free, so it carries cleanly to `em:715275` under the migration rule).

The plan's §7 is now a joint **PR #68 + #70 disposition**: both superseded, both closed unmerged once this plan's PR lands, and a new build step 3a transplants #68's three orphaned artifacts onto the current tree (transplant-never-plain-merge, same discipline as the existing transplant-surviving-unmerged-branches plan, whose problem class both branches join). Branch deletion afterward remains yours to ratify per the branch-deletion policy.

One thing worth knowing: #68's decision record is the *reason* the ordering key in this plan is `timestamp` with `attribution.when` tiebreak — so salvaging it isn't just archaeology; it's the `attribution.from` ancestry for the ordering rule the generator will encode.
</routes>

## User

<routes ref="/meta/plans/derived-index-listings.md">
Pull and see merge of 68
</routes>

## Assistant

<routes ref="/meta/plans/derived-index-listings.md /meta/plans/collection-view-by-date.md">
Pulled, merged, and reconciled — pushed as `c665285`. Here's what the pull revealed and what changed:

**PR #68 is resolved: closed unmerged this morning (2026-07-16) and recreated on the current tree as PR #95, which merged.** A parallel session did exactly the transplant-don't-merge recreation for #68 that this session's plan prescribed for it. What #95 landed:

- The **`collection-view-by-date` plan doc** (`status: done`) — the decision record ratifying `timestamp` as the ordering key, with the deferred recency surfaces (`mix brain.recent`, `/plan by-date`, site sort toggle).
- A **recreated thread doc** (`2026-07-16-recreate-collection-view-by-date.md`) plus the glossary **`timestamp`** entry — minted fresh as `em:59cff6` rather than carrying the `sb:715275` tail, which is sound: that id never reached `main`, so no committed reference to it ever existed.
- The **hand-maintained ordering-convention headers** in the plans/todos/issues indexes ("entries ordered by `timestamp`, most recent first… maintained at filing time").

**On this branch I did three things:**

1. **Merged `origin/main` in.** One conflict, in `meta/plans/index.md` — my plan's bullet vs. a new `concept-terminology` plan bullet from main. Resolved keeping both, mine first per the newest-first convention.
2. **Reconciled the plan doc.** §7 now records #68's disposition as *history* (closed, recreated as merged #95) instead of pending work; build step 3a (the salvage) is struck through as done via #95; the only remaining PR disposition is closing #70 once this plan ships. All gates green.
3. **Fixed the date stamps** — I'd written the plan as 2026-07-15; corrected to today.

One connection worth noting: #95's convention headers say the ordering is "maintained at filing time" — that's precisely the hand-sync obligation your derivation plan retires. So the sequence is coherent: #95 put the *decision record and convention* on `main` now, and the derived-listings plan replaces the convention's hand-maintenance with the generator when it's built. The plan's §6 already covers retiring those headers in favor of generator-stated convention.

The branch is current with `main`, the plan is up to date, and the remaining loose end is PR #70 itself — still open, to be closed unmerged when the derived-listings plan's build lands (or sooner if you'd rather close it now, since the plan doc fully records what it contained).
</routes>

## User

Merge
