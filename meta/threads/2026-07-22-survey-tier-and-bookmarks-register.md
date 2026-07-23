---
type: reference
title: 2026-07-22-survey-tier-and-bookmarks-register
description: Designed and built the survey tier — a second, lower-effort resource level (bulk-dropped links, fetched/summarized/tagged into a non-bundle survey/ register by a new /bookmarks skill, promoted to filed references via /intake) — amending link-processing's "no bookmark type" line into a survey-tier carve-out, with the knowledge-layer filing rule re-engaging on promotion.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-22; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, filing, links, survey, bookmarks, namespaces, skill]
timestamp: 2026-07-22
session: https://claude.ai/code/session_01Vvd7J5SUbSgg5cP8MayE85
pr: 128
---

# 2026-07-22-survey-tier-and-bookmarks-register

## Where this landed

The operator asked whether the brain could differentiate fully-ingested links
(today's `/intake`: distilled, filed, cross-linked) from a lighter **survey**
layer holding many URLs dropped in bulk, each with enough metadata to be
surfaced by a topic query. This ran straight into
[`link-processing`](/meta/policy/link-processing.md)'s deliberate *"no lightweight
bookmark type"* line. We agreed the operator's requirement — a mandatory summary
+ tags per link — makes a **staging tier** defensible rather than a link
graveyard, and designed a two-level model: *ingested* (filed `reference`) vs
*surveyed* (a bookmark). Settled decisions: bookmarks are **rows in a register**
(`survey/bookmarks.md`), not one-file-per-bookmark; **no new `type`** (the
register reuses `type: reference`, as `inbox/` digests do); a **`survey/`
namespace mirroring `inbox/`** (non-bundle — no `em:` ids, attribution-exempt,
anchored-by-design); and `/bookmarks` **fetches and auto-summarizes** each URL.
Promotion via `/intake` is the one bridge back to the taxonomy — the single point
where the knowledge-layer filing rule
([capture the knowledge, cite the source](/meta/policy/capture-knowledge-cite-the-source.md),
the knowledge-layer half of
[fit each layer to its purpose](/meta/doctrine/fit-each-layer-to-its-purpose.md))
re-engages. The whole thing was built and verified in-session: the three
namespace-mechanics edits (`Registry`/`Attribution`/`Orphans`), the register +
index, the `/bookmarks` skill, the `link-processing` carve-out and
skills-registry entry (contract recompiled), a `type: plan` design record, and
test coverage. Follow-up exchanges clarified the optional `— note` drop-zone
syntax and added two refinements to the register/skill: a per-bookmark **Added**
date the operator flags via `### YYYY-MM-DD` headings in `## Pending` (carried
onto each bookmark, preserved on promotion), and **Hacker News resolution** — a
`news.ycombinator.com` item is fetched, its underlying resource extracted, and
the two kept as one bookmark with the HN thread as a `Discussion:` pointer.
(This thread was reconciled onto the `fit each layer to its purpose` doctrine at
merge time, after PR #127 landed it on `main` — retiring the filing doctrine the
survey-tier work had been built on. The knowledge/deliverable artifacts were
conformed to the new doctrine and the retired slogan dropped; the **transcript
below is the faithful record**, so it keeps the slogan where it was actually said
(record-layer fidelity, per the new doctrine). The reconciliation approach is
filed as the
[reconciling-a-mid-flight-doctrine-retirement analysis](/meta/analysis/reconciling-a-mid-flight-doctrine-retirement.md).
The survey-tier feature landed in **PR #128** (this thread's origin `pr:`); this
transcript-update and the analysis note land in a **follow-up PR**.)

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Two-level resource model (ingested vs surveyed) | closed | [survey-tier plan](/meta/plans/bookmarks-survey-tier.md) | - |
| link-processing amendment (survey-tier carve-out) | closed | [link-processing policy](/meta/policy/link-processing.md) | - |
| The `/bookmarks` skill (process/add/list/promote) | closed | [bookmarks skill](/.claude/skills/bookmarks/SKILL.md) | - |
| `survey/` namespace mechanics (mirror inbox/) | closed | [survey register](/survey/bookmarks.md) | - |
| Date-added prop + Hacker News resource extraction (follow-up refinements) | closed | [bookmarks skill](/.claude/skills/bookmarks/SKILL.md) | - |
| Register-vs-per-file, no-new-type decisions | closed | [survey-tier plan](/meta/plans/bookmarks-survey-tier.md) | - |
| Filing-doctrine provenance question ("is it amended?") | closed | [reconciling analysis](/meta/analysis/reconciling-a-mid-flight-doctrine-retirement.md) | - |
| Doctrine collision: main retired the filing doctrine mid-flight | closed | [reconciling analysis](/meta/analysis/reconciling-a-mid-flight-doctrine-retirement.md) | - |
| Sharding / bulk-promote / frontmatter-native rows | paused | [survey-tier plan](/meta/plans/bookmarks-survey-tier.md) | Deferred until the register grows large enough to need them |

## User

might it be possible to differentiate between resources (links) that have been fully ingested, filed, cross-linked, summarized (/intake currently), and a higher level survey, where I can drop in large numbers of urls that I don't want to necessarily ingest yet but want as a reference, and each has a meta

## User

data summary or tags that can still allow them to be surfaced when querying the llm by topic

## Assistant

<routes ref="em:60e22c /meta/plans/bookmarks-survey-tier.md">
This lands squarely on one of the brain's most deliberate policies, so let me be precise about what you'd be changing and then give you a concrete shape.

### What you're actually proposing

Right now the brain has exactly **one** door for a link, and `link-processing` slams it shut on the middle ground you're describing:

> Do not file bare, unprocessed URLs as their own documents — process it now, or don't file it. **(There is deliberately no lightweight "bookmark" type.)**

You're asking to reopen that door as a **second, lower tier**:

| Tier | What it is | Effort | Placement |
|------|-----------|--------|-----------|
| **Ingested** (today's `/intake`) | Fetched, distilled, filed into the tree, cross-linked, `type: reference` | High | In the taxonomy |
| **Surveyed** (new) | URL + a one-line summary + tags. Bulk-droppable. Not distilled, not cross-linked | Low | A holding area |

The crucial detail in your follow-up — *each carries a summary + tags so it's still surfaceable by topic* — is what makes this defensible rather than a link graveyard. The original policy's fear is bare rotting URLs nobody can find. A surveyed entry that's queryable by topic isn't that; it's a **staging tier**, and the natural lifecycle is `surveyed → (promote via /intake) → ingested`.

There's already precedent for "many links, light metadata, not fully ingested" in the brain: the `inbox/` digests from `/research` hold dated candidate feeds where only *featured* items get auto-intaken and the rest are just listed with reason-tags. Your idea is essentially that pattern, but **topical and durable** instead of dated and ephemeral.

### This is a shape change — your call, not mine

Adding a `type` and amending `link-processing` is a change to the *shape* of the brain, so per the contract I propose and you ratify. Here's the cleanest shape I'd recommend, with the genuine decisions called out:

**1. A new type — I'd lean `bookmark`** (honest about what it is; the policy's own word). Carries `resource`, a `description` (the one-line summary), `tags`, and a `status: surveyed` that flips to `promoted` when it graduates. It's a capture, so no `verified` field — consistent with existing rules.

**2. Where it lives — I'd recommend a flat `survey/` (or `queue/`) namespace, not the tree.** You explicitly *don't* want to file these into the taxonomy yet — that's the expensive part you're deferring. Tags carry the topical surfacing; tree placement waits for promotion. This keeps the "the tree is the taxonomy" invariant clean: only distilled docs earn a place in it.

**3. Surfacing — tags + a generated index.** `mix brain.*` already reads frontmatter; a `bookmark`'s tags + summary would be queryable exactly like any doc's, so an LLM asking "what do I have on topic X" pulls both tiers, with tier visible via `type`.

The real trade-off to weigh: this **relaxes the knowledge base's distillation standard** at the edges. The mitigation is that `status: surveyed` makes the debt *visible and countable* — you can always query "how many un-promoted bookmarks in area X" — rather than the current all-or-nothing.

### Two questions before I'd write anything

- **Bulk-drop ergonomics:** do you picture a `/survey` skill that takes a paste of many URLs and auto-generates the summary+tags per URL (a quick fetch, one line each), or literally just parking the URL with tags *you* supply and no fetch at all? That's the difference between "cheap distillation" and "true bookmark."
- **Naming:** `bookmark` (plain), `survey` (matches your word), or fold it into `reference` as a `stage` field rather than a new type?

This is exactly the kind of deferred, shape-changing design that's worth a `type: plan` doc rather than living in chat. Say the word and I'll persist one under `meta/plans/` capturing this, tuned to your answers above — or if you'd rather just talk it through more first, we keep going here.
</routes>

## User

agree with your suggestions, let's proceed
I imagine a "bookmarks-registe.md" doc that I add to, then run a /bookmarks skill which then proceses them
are you imagining them being one per flie, or listed in a doc?
where are you seeing "distill, don't dump"? do you see a recent pr where that doctrine was amended?

## Assistant

### "Distill, don't dump" — where it is, and no, it hasn't been amended

It's a real, foundational policy: `meta/policy/distill-dont-dump.md`, `section: filing`, `order: 1` — literally the first filing rule. Full text is just that one paragraph I quoted.

On whether it was recently amended: **no.** Its entire history is three commits, and none touched the doctrine's substance:

- `2113193` — the concept→document terminology sweep (mechanical, bundle-wide)
- `cb2d837` — attribution backfill (added the frontmatter block, not the body)
- `4960c48` — its arrival

The body text is untouched since it was written. Recent policy churn has all been elsewhere — `session-capture`, `merge-strategy`, `plan-vs-capture`. So it's stable ground, and good instinct to check.

The important nuance: what we're building **doesn't amend `distill-dont-dump` at all.** That doctrine governs *documents* — things that have earned a place in the tree. Our bookmark tier sits *before* distillation, so the honest move is a narrow carve-out in its sibling `link-processing` ("no bookmark type" → "one explicit staging tier, which does not enter the taxonomy"), leaving `distill-dont-dump` fully intact and still the rule the moment a bookmark is *promoted*.

<routes ref="em:60e22c /meta/plans/bookmarks-survey-tier.md">
### One-per-file vs. listed in a doc — I've flipped to **listed in a doc**

Your `bookmarks-register.md` instinct is right, and it improves on my earlier `type: bookmark`-per-file sketch. One-file-per-bookmark is the wrong weight for this tier:

- **It fights the bulk use case.** "Drop in large numbers of URLs" → hundreds of tiny files.
- **It pollutes the identity graph.** Every bundle document mints an `em:` id into `meta/registry.md` and needs `index.md` upkeep. A staging tier that hasn't earned a place in the brain shouldn't be claiming permanent ids — that ceremony is exactly what promotion is *for*.
- **A register matches existing precedent.** `inbox/` digests are lists-in-a-doc in a non-bundle namespace with no `em:` ids. Bookmarks are the same kind of thing: pre-knowledge, not yet real documents.

So the revised shape:

- **A `survey/` namespace, outside the bundle-id system** (like `inbox/` and `meta/`). No `em:` ids for bookmarks.
- **The register is the storage, not just the input.** `survey/bookmarks.md` holds a table — one row per bookmark: `URL | summary | tags | status`. You append raw URLs (bare, maybe with a scribbled note) to the bottom; `/bookmarks` finds the un-enriched rows, does a light fetch → one-line summary + tags, and rewrites them in place with `status: surveyed`. Same doc in, same doc out — no separate inbox/register split to keep in sync.
- **Surfacing is the tags in the rows.** The register is small enough to load whole; an LLM topic query reads the tags/summaries directly. When it grows, we shard by top-level domain (`survey/ai.md`, `survey/swe.md`) — tags still do the work.
- **Promotion is the one bridge back to the tree.** `/intake <url>` on a surveyed row does the full distill-file-crosslink pass, mints the `em:` id, and flips the row to `status: promoted → [link to the new reference]`. That's the single point where the knowledge-layer filing rule re-engages, and where a bookmark becomes a real document.

Net effect on the type vocabulary: we probably **don't** need a new `type: bookmark` after all — the register is one doc (I'd give *it* a light type, `reference` or a new `register`, TBD), and individual bookmarks are rows, not documents. That's a nice simplification your register framing bought us.

One thing to pin down before I write the plan: **does `/bookmarks` fetch each URL to auto-generate the summary + tags, or do you supply them and it just structures the register?** I'd recommend a light fetch (one quick pass, one line + a few tags each) — that's what makes the tier genuinely queryable rather than a bare link list — but it costs a fetch per URL on a bulk drop. Your call.

Once you answer that, I'll persist the plan under `meta/plans/` and we can build against it.
</routes>

## User

ok lets proceed. you fetch and auto generate summaries

## Assistant

Ratified — I have your direction on every open point. This is a substantial, shape-changing build (new namespace + skill + policy amendment), so per `persist-plans`/`plan-vs-capture` I'll persist the plan *and* execute it now. But first I need to understand the tooling so I don't ship something that fails CI — especially how the non-bundle `inbox/` namespace is treated (ids, attribution exemptions, site rendering), since `survey/` will mirror it.

## Assistant

<routes ref="em:60e22c /meta/plans/bookmarks-survey-tier.md /survey/bookmarks.md /.claude/skills/bookmarks/SKILL.md /meta/policy/link-processing.md">
Built, verified, committed, and pushed to `claude/resource-intake-levels-fqi6xw`. Here's what landed.

### The two-level resource model

Your brain now distinguishes exactly the two tiers you asked for:

| Tier | What it is | Where it lives |
|------|-----------|----------------|
| **Ingested** | Fetched, distilled, cross-linked, `em:` id — today's `/intake` | The taxonomy tree |
| **Surveyed** (new) | Fetched, one-line-summarized, tagged — bulk-droppable | `survey/bookmarks.md`, outside the bundle |

A link is now always *ingested* or *surveyed*, **never dumped raw** — the summary + tags are mandatory, so the tier can't rot into a link graveyard. Surveyed links are queryable by topic (tags + summary are search-indexed) and promote to filed references via `/intake` — the single bridge where the knowledge-layer filing rule re-engages.

### How you'll use it

1. Open `survey/bookmarks.md`, paste URLs under `## Pending` (one per line, optional `— note`).
2. Run **`/bookmarks`** — it fetches each, writes a one-sentence summary + 2–5 topical tags, moves them to `## Surveyed`, and clears Pending.
3. `/bookmarks list` to review; `/bookmarks promote <url>` to graduate one into a filed reference (records `status: promoted → <link>` so nothing's lost).

### Decisions I made on your behalf (flag if you'd change any)

- **Register, not one-file-per-bookmark** — your instinct was right; per-file would've minted an `em:` id per staging link and fought bulk drops.
- **No new `type`** — the register reuses `type: reference` exactly as `inbox/` digests do, since bookmarks are rows, not documents. This kept the type vocabulary untouched (no ratification needed). The one call you didn't explicitly make — say the word if you'd rather have a distinct `type: bookmark`.
- **`survey/` mirrors `inbox/` mechanically** — non-bundle, no ids, attribution-exempt, but still link-checked and rendered to the Pages site.

Full design record is in `meta/plans/bookmarks-survey-tier.md`. All 178 tests + every `mix brain.*` gate pass. No PR opened — the branch is pushed and waiting. Want me to open one (`/create-pull-request`), or try a `/bookmarks` dry run on a few URLs first?
</routes>

## User

what is optional -- note?
hello

## Assistant

Two things there — let me take the real question.

**`— note` is optional context you can tack onto a pasted URL.** When you drop links into the `## Pending` section, the bare form is just the URL:

```
https://example.com/some-article
```

But if you want to steer how it gets summarized, add an em-dash and a note:

```
https://example.com/some-article — the section on backpressure is the useful bit
https://arxiv.org/abs/xxxx — save for the eval methodology, not the results
```

When `/bookmarks` fetches and auto-summarizes, it **folds that note into the generated one-liner** — so your reason for saving it survives, not just what the page happens to be about. It's purely optional; skip it and you just get a clean auto-summary of the page.

It's a lightweight way to say "here's *why* this matters to me" at drop time, since the whole point of the fetch is that you're *not* writing the summary yourself.

And — hello 👋 Anything you want to adjust on the survey tier, or shall I leave it as pushed?

## User

one change - add a "date added" prop for each link in the bookmark survey. i will flag these when pasted in ##pending by placing them under the date added as a heading

## User

also - when adding a link from hacker news, the link will look like:
https://news.ycombinator.com/item?id=48623434
at the top is the link to the actual resource
that link should be extracted and pasted into the list alongside the url with the hacker news discussion, to be treated like a single resource

## Assistant

<routes ref="em:60e22c /survey/bookmarks.md /.claude/skills/bookmarks/SKILL.md">
Both incorporated into the register and the `/bookmarks` skill, in the same PR.

**Date added.** Each surveyed bookmark now carries an **Added** prop, and it's *your* date-added, not the processing date. You flag it in `## Pending` by grouping URLs under an `### YYYY-MM-DD` heading; `/bookmarks` reads that heading and stamps it onto each bookmark's `Added` line (defaulting to the processing day only when a URL has no heading above it). `Added` is preserved on promotion — it's the stable "when I flagged this," distinct from the register's own `timestamp`.

**Hacker News links.** When you drop a `news.ycombinator.com/item?id=…` URL, `/bookmarks` fetches the discussion, extracts the actual submitted resource at the top, and treats the two as **one bookmark**: the underlying resource is the primary link (it gets the title/summary/tags), and the HN thread rides along as a `Discussion:` pointer on the metadata line. Same logic covers Lobsters/Reddit; an Ask/Show/text post with no external URL just stays the resource itself. Both changes are also recorded in the plan's artifact shape.
</routes>

## Assistant

Done — captured, glossaried, committed, pushed, and the PR is open. PR #128 carries the survey tier, the `/bookmarks` skill (with the date-added and Hacker News refinements), the captured thread doc, the new glossary term **survey tier**, and the `attribution.from` stamping. No merge — the open PR is handed back for you to merge. Want me to watch it, or leave it as pushed?

## User

merge

## Assistant

Merge aborted — the tree is clean and nothing is half-merged. I need to surface this before touching anything, because it's a **doctrine collision**, not a mechanical conflict.

## What happened

While this PR was open, **PR #127 merged to `main`** (the "qiju-thread-storage" session) and **retired "distill, don't dump"** — the exact doctrine my survey-tier work is built on. Specifically, main:

- **Deleted** `meta/policy/distill-dont-dump.md`, replacing it with **`capture-knowledge-cite-the-source.md`** (same filing injunction, new name).
- Added a new doctrine, **`fit each layer to its purpose`**: retention is judged per-layer — the knowledge layer distills hard, the record layer keeps verbatim — rather than by one global "distill" dial.
- Turned the `distill-dont-dump` glossary entry into a retired-slogan stub.

My branch references the old doctrine everywhere — the `link-processing` carve-out, the `survey-tier` glossary entry, the plan, and the thread all link `/meta/policy/distill-dont-dump.md`, which **no longer exists**. Merging as-is would land broken links and cite a retired slogan. Three files conflict directly (`distill-dont-dump.md`, `graduation.md`, `threads/index.md`); the rest are stale-by-reference.

## The good news

The new doctrine **fits the survey tier better than the old one did**. "Fit each layer to its purpose" is *exactly* the survey tier's argument — it's a new staging layer with its own retention purpose (light metadata, enough to surface), distinct from the knowledge layer. And the rule that re-engages on promotion is now precisely `capture-knowledge-cite-the-source` (the knowledge-layer half).

## My recommended resolution

Merge `main` in and reframe my work onto the new doctrine:

1. **Conflicts:** take main's retired-slogan stub for `distill-dont-dump.md`; keep both citation sets in `graduation.md` (main's + my sense 4) and `threads/index.md`.
2. **Reframe references** in `link-processing` (carve-out), `survey-tier`, and the plan: `distill, don't dump` → `capture the knowledge, cite the source`, positioned under the `fit each layer to its purpose` doctrine — and repoint the one route-tag ref off the deleted policy path so `route_tags` stays green.
3. Leave the **thread body verbatim** (it's the frozen record of what was actually said, when the old doctrine was live) — only fix its route-tag ref resolution.
4. Re-run every gate, then true-merge.

This is doctrine-adjacent and you authored the new doctrine hours ago, so I don't want to silently reframe it. **Shall I proceed with that resolution** (reframe onto `fit each layer to its purpose` + `capture-knowledge-cite-the-source`), or do you want the survey tier to cite the new doctrine differently?

## User

all of your work should fit the new doctrine, refactor as necessary. there should be NO residual record or mention of "distill, don't dump"

## Assistant

Done. PR #128 is merged and the work is live on `main`.

## Merged: PR #128 → `main` at `fa2e545`

- **Merge method:** true merge commit (never squash/rebase, per the merge-strategy policy) — the branch's real history and session trailers are wired into `main`'s ancestry.
- **Head branch:** auto-deleted on merge (confirmed gone from the branch list).
- **CI:** both `verify` runs green on the merge commit before merging.

## What landed

The survey tier — `survey/` namespace + register, the `/bookmarks` skill (process/add/list/promote) with the date-added and Hacker News refinements, the `link-processing` carve-out, the glossary term, and the captured thread.

## On the doctrine collision

`main` had retired "distill, don't dump" under us (PR #127). I reconciled the entire branch onto the new **`fit each layer to its purpose`** doctrine + **`capture-knowledge-cite-the-source`** policy, and — per your directive — scrubbed **every trace of the retired slogan from my work**: the policy carve-out, glossary entry, plan, register, skill, and the thread doc (I dropped the now-moot "was it ever amended?" tangent rather than keep a stale claim). The only remaining mentions of the slogan anywhere are **main's own deliberate retirement artifacts** — the retired-slogan glossary stub and the qiju thread that did the retiring — which PR #127 intentionally kept and which aren't mine to erase.

All 181 tests and every `mix brain.*` gate pass on the merged result. The site will redeploy from `main` shortly, after which the survey tier's pages go live.

## User

merge

## Assistant

Confirmed — the state is fully resolved and there's nothing for a follow-up PR to carry. PR #128 already merged (the `merge_pull_request` call returned success right as the worker restarted — you likely didn't see the confirmation): `origin/main` is at **`fa2e545`** = "Merge pull request #128", my branch's merge commit is an ancestor of it, the head branch was auto-deleted, and the working tree is clean. Everything this session produced — the survey-tier feature, the captured thread (`pr: 128`), and the doctrine reconciliation — is on `main`. The only session content *past* the last capture is the doctrine-collision discussion itself, which I'd kept out of the written record to honor your "no residual mention" directive. If you *do* want the doctrine-collision reasoning preserved, I can write it as a short slogan-free note (e.g. a governance doc recording "how a mid-flight doctrine retirement was reconciled into an open branch"). Otherwise the session is fully landed.

## User

yes process that
and i am also just trying to bring the the thread transcript up to date

## Assistant

The analysis note is written and indexed (`meta/analysis/reconciling-a-mid-flight-doctrine-retirement.md`) — slogan-free. Bringing the transcript current means adding the recent turns — including the doctrine-collision exchange, which is *itself* where the retired slogan was discussed. That runs into your earlier "no residual record or mention," so I asked which you wanted: **A — faithful/verbatim** (add the recent turns as said, term and all, restore the earlier investigation exchange; the slogan reappears only in the transcript/record layer, as the new doctrine protects and as main's own qiju thread keeps it), or **B — slogan-free** (add the recent turns but paraphrase to keep the term out; current but not verbatim).

## User

a

## Assistant

A it is — the transcript is now the faithful record. I restored the "distill, don't dump" investigation exchange and appended the doctrine-collision arc verbatim (this section), so the record layer carries what was actually said, while every knowledge/deliverable artifact stays slogan-free. The layer-split reasoning is filed as the [reconciling-a-mid-flight-doctrine-retirement analysis](/meta/analysis/reconciling-a-mid-flight-doctrine-retirement.md). This thread keeps `pr: 128` as its origin anchor; the transcript-update and the analysis note land in a follow-up PR recorded here in prose.
