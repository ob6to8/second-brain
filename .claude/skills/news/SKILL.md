---
name: news
description: Generate today's inbox — a daily candidate feed of news, articles, papers, and resources matched against the brain's taxonomy, grouped by category and tagged by why each was chosen — then auto-intake the featured items into the bundle. Use when the operator says "/news", "run the feed", "what's new", or on the daily schedule.
---

# /news — the daily candidate feed (home-page inbox)

Scan the outside world for material that matches what this brain already cares
about, and write it into today's **inbox digest** — a dated, categorized list of
candidate links, each with a one-line synopsis and a reason tag — then **auto-intake
the featured items into the bundle**. The digest is the daily *record* in the
non-bundle `inbox/` namespace (no `sb:` ids); its featured items graduate into filed
concepts in the same run (§6). This is the standing decision from the
[auto-intake plan](/meta/plans/auto-intake-featured-news.md): the featuring gates
(§4) are already the quality filter, so a featured item needs no second human gate —
the operator's contribution moves from a pre-intake gate to **post-intake editorial**
(prune, relabel, merge). The digest file itself never acquires an `sb:` id; the
concepts its featured items become do.

Read the [operating contract](../../../CLAUDE.md) first. Two rules shape this skill:

- **Links must be processed, not parked** — a bare URL never becomes a bundle
  concept. `/news` honors this by *processing* every featured item: each is fetched
  and distilled through `/intake` (§6), not parked as a bare link. The only items that
  linger as candidates are those **deferred** for needing a new top-level domain
  (§6) — held in the digest until the operator ratifies the shape.
- **The tree is the taxonomy** — the KB's `index.md` hierarchy *is* the query
  profile. The feed's categories mirror the KB's top-level domains, and what the
  feed looks for is derived from what's already filed. As the brain grows, the
  feed re-aims itself.

## Where it writes

```
inbox/
  index.md          # landing view: links to the latest digest + the archive (reserved, no frontmatter)
  YYYY-MM-DD.md     # one digest per day — type: reference, no sb: id, immutable once written
```

Days are inherently time-ordered, so digests use the `YYYY-MM-DD.md` filename
convention. Previous days are **never rewritten** — they persist as the archive.

## Procedure

### 1. Build the query profile from the taxonomy
- Read the root `index.md`, then each top-level domain's `index.md`, and skim the
  concept titles/tags under each (Grep/Glob over `*.md`, excluding `deprecated/`
  and `inbox/`). This yields, per domain, a set of interest signals — the topics
  the brain actively tracks and the specific concepts it has already filed.
- Note the `sb:` ids and titles of recent/high-signal concepts so items can
  back-link to what they extend or challenge (e.g. a new margin datapoint relates
  to an existing margin-collapse `reference`).

### 2. Search, per domain
- For each domain, run a few targeted searches (`WebSearch`; `discover_papers`
  for academic domains; fetch specific pages only when a synopsis needs it).
- Cast for the current window (recent days/weeks). Prefer primary and
  high-signal sources over aggregators.

### 3. Dedup — twice
- **Against the bundle**: drop anything already filed (match on URL, title, key
  terms). The inbox surfaces what's *not yet* in the brain.
- **Against recent digests**: read the last few `inbox/*.md` and drop items
  already surfaced, unless there's a genuinely new development. Don't repeat
  yesterday's feed.

### 4. Select and reason-tag — how the agent decides what to feature

An item is **featured** only if it clears every gate below. This is the selection
contract — the reason a candidate makes today's digest or gets dropped:

1. **Relevance** — it maps to a domain's interest signals (a topic the brain
   actively tracks, or a concept it has already filed). No mapping ⇒ not featured,
   however interesting in the abstract. The taxonomy is the filter.
2. **Novelty** — it survives both dedup passes (§3): not already in the bundle, and
   not already surfaced in a recent digest (unless it's a genuinely new
   development). The inbox features what's *not yet* in the brain.
3. **A reason tag fires** — at least one tag from the fixed vocabulary below must
   apply. **The reason tags *are* the featuring criteria**: if you can't attach a
   reason, there's no reason to feature it. An item with no firing tag is dropped.
4. **Source quality** — prefer primary and high-signal sources over aggregators;
   when two items say the same thing, feature the more authoritative one.

Then apply a **quality-over-volume cap**: a handful of strong items beats a long
weak list. When more items clear the gates than are worth featuring, keep the ones
with the strongest / most reason tags and drop the marginal. Within a domain,
order the strongest first.

Tag **each** featured item with one or more **reason tags** (why it surfaced). This
vocabulary is fixed; propose additions to the operator rather than inventing:

  | Tag | Fires when |
  |-----|-----------|
  | `recent` | Published in the window; the primary axis is freshness |
  | `impactful` | Real-world consequence — shifts a decision, market, or practice |
  | `influential` | Being cited / built on by others (citation velocity, references) |
  | `groundbreaking` | Genuinely novel result or capability, not incremental |
  | `buzz` | High discussion volume (HN points, social velocity) regardless of merit |

  Tags are orthogonal to topic tags and describe *selection reason*, not subject.
  More (or stronger) tags on an item is itself a signal it deserves featuring.

### 4.5 Write the daily read — the cross-domain synthesis

Once the featured set is fixed, write **the read**: a short perspective on the day's
selections *as a set*, framed against the brain's standing concerns. This is the most
valuable part of the digest — it turns a pile of links into a *view of where things
are moving relative to what the brain already tracks*. See the design record in
[`meta/plans/news-daily-read-synthesis.md`](/meta/plans/news-daily-read-synthesis.md).

- **A perspective, not a re-listing.** 1–3 tight paragraphs. Never restate the item
  synopses — those live in the domain sections below. The read is the layer *above*
  them: the trend, tension, or throughline.
- **Grounded in `sb:` ids.** Name the standing concepts the day bears on
  (`sb:07610c`, `sb:2867ac`, …) so the synthesis is anchored to the actual taxonomy,
  not free-floating commentary. Say whether today's items **reinforce, contest, or
  extend** those filed positions — that *is* the intake-relevant signal.
- **Cross-domain by mandate.** Its explicit job is the connective tissue the
  per-domain buckets can't hold (e.g. a lossless-inference item + a long-horizon-agent
  item + a worktree item all pointing at one "agents running longer and cheaper" arc).
  On a single-domain day it collapses to one short paragraph.
- **Candidate-side.** Distilled, no `sb:` id, asserts nothing beyond what the day's
  selections support — a reading of candidates, not a filed claim.

### 5. Write today's digest
- Path: `inbox/YYYY-MM-DD.md`. If today's digest already exists, **regenerate that
  same file** (don't create a second one for the same day).
- Frontmatter: `type: reference`, no `sb:` id, `provenance` naming the tools/date,
  `tags: [inbox, feed]`, `timestamp` today.
- Body: lead with **`## The read`** (the cross-domain synthesis from §4.5), then an
  `##`-section **per KB domain touched**, mirroring the KB tree. A domain section may
  open with an optional one-line *domain-level* lede before its bullets; `## The read`
  is the *cross-domain* layer above those. Under each domain, one bullet per item:
  - **`[title](url)`** on the first line;
  - the reason tag(s) as inline `` `code` `` badges, then a one-to-two-line
    synopsis of *what it is and why it matters*;
  - a `→ would file under /<kb-path>/` filing hint, and `· relates to sb:xxxxxx`
    when it extends/challenges an existing concept.
- Keep synopses distilled — enough to decide intake-or-skip at a glance.

### 6. Auto-intake the featured items
Once today's digest is written, **file each featured item into the bundle** by
running [`/intake`](../intake/SKILL.md) on it. Auto-intake runs on **featured items
only** — never the ones the quality-over-volume cap dropped, so the cap (§4) is also
the volume knob on how many concepts a run files.

For each featured item, in digest order:

- **Hand `/intake` the item's URL plus the digest's two hints** — the
  `→ would file under /<path>/` filing hint and any `· relates to sb:xxxxxx`. Intake
  does the rest: fetch → distill → its own **synonym-expanded dedup** (its §3) →
  file → mint id → registry → verify. You inherit that dedup and its automatic
  gold-harvest for free — do not re-implement either here.
- **Prefer update-in-place on a `relates to sb:` hint.** When an item carries one,
  that related concept is intake's dedup target: **update it in place** rather than
  filing a sibling — *unless* the item is a genuinely distinct matter (a contrasting
  datapoint, not a continuation), which earns its own concept. This keeps
  [residual fragmentation](/beliefs/glossary/residual-fragmentation.md) small.
- **Stay inside the known tree — defer, don't propose.** A featured item files
  autonomously into an existing domain (new *subdirectories* under an established
  top-level domain are fine). But an item that would require a **new top-level
  directory** is *not* filed: leave it in the digest, marked
  `⏸ deferred → needs new top-level domain, awaiting ratification`, and surface it in
  the report. Auto-intake never creates top-level shape — that stays the operator's
  to ratify (taxonomy-evolution protocol).
- **Tag what you file `auto-intake`.** Add `auto-intake` to the filed concept's
  `tags` and record its origin in `provenance` (e.g. "auto-intaken from /news inbox
  YYYY-MM-DD"), so the whole auto-filed set — the operator's editorial queue — is a
  single `tags: auto-intake` query.
- **Gold-harvest no-ops here.** Intake's gold-harvest wants the *operator's* natural
  phrasing; auto-intake has none (the query is a synopsis), so intake skips it
  silently — correct; don't force a synthetic row.

Then **mark each featured digest line** with its outcome, in place: `✓ auto-intaken
→ /path/to/concept.md` (new file), `✓ merged → /path` (updated in place), or
`⏸ deferred → …`. This is today's digest, written this same run — not a past one —
so annotating it is not the immutability exception.

### 7. Maintain the inbox reserved files
- `inbox/index.md`: point "Latest" at today's digest (one-line summary + count),
  and prepend today to the dated **archive** list. No frontmatter. (No log —
  the dated digests are their own history; the commit records the generation.)

### 8. Report
- One-line summary: how many items across which domains, and the path to today's
  digest.
- **The auto-intake outcome**: how many concepts were newly filed vs. merged in
  place vs. deferred, with the deferred items called out (they await your
  ratification of a new top-level domain). Note any **dedup-recall regression**
  bubbled up from an intake run.

## The intake handoff

Featured items are filed automatically (§6); the operator's role is the
**editorial pass afterward** — review the `auto-intake`-tagged concepts, merge any
residual duplicates, relabel, or reject. Two manual paths remain: **ratify a
deferred item** (approve the new top-level domain, then it files), and **`/intake` a
non-featured link** the operator wants filed by hand. When marking a *past* digest's
line with an intake backlink after the fact, that edit is the one allowed exception
to digest immutability.

## Guardrails
- The **digest** is not the bundle: it stays under `inbox/` with no `sb:` id and no
  `verified` field. Auto-intake (§6) is the only thing that writes into the bundle,
  and it does so through `/intake` (which mints ids and runs the gates) — never by
  `/news` filing a concept directly.
- Distill synopses; never dump full articles into the digest — that's what
  `/intake` is for (and §6 hands it the URL, not the synopsis).
- **Auto-intake is bounded to featured items and the known tree.** Never file a
  dropped item; never create a new top-level directory or a new `type` autonomously —
  defer to the operator (§6).
- Don't repeat prior days. Dedup against both the bundle and recent digests.
- Reason tags come from the fixed vocabulary above; propose additions, don't
  invent them silently.
- Never touch `deprecated/`.
