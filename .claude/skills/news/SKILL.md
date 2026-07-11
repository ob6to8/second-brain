---
name: news
description: Generate today's inbox — a daily candidate feed of news, articles, papers, and resources matched against the brain's taxonomy, grouped by category and tagged by why each was chosen. Use when the operator says "/news", "run the feed", "what's new", or on the daily schedule. Hand off to /intake when the operator wants a candidate filed into the brain.
---

# /news — the daily candidate feed (home-page inbox)

Scan the outside world for material that matches what this brain already cares
about, and write it into today's **inbox digest** — a dated, categorized list of
candidate links, each with a one-line synopsis and a reason tag. The inbox is the
brain's **waiting room**: candidates live here until the operator decides to
`/intake` one into the bundle. Nothing written by `/news` enters the OKF bundle
or carries an `sb:` id.

Read the [operating contract](../../../CLAUDE.md) first. Two rules shape this skill:

- **Links must be processed, not parked** — a bare URL never becomes a bundle
  concept. The inbox does not violate this: its items are *candidates with
  synopses*, held **outside** the bundle in the `inbox/` namespace (like `meta/`).
  The full fetch-and-distill step is `/intake`, run only when the operator picks
  an item.
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

### 6. Maintain the inbox reserved files
- `inbox/index.md`: point "Latest" at today's digest (one-line summary + count),
  and prepend today to the dated **archive** list. No frontmatter. (No log —
  the dated digests are their own history; the commit records the generation.)

### 7. Report
- One-line summary: how many items across which domains, and the path to today's
  digest. Remind the operator they can say **"intake the <…> item"** to file any
  candidate into the brain.

## The intake handoff

The inbox only *proposes*. When the operator points at an item ("intake the
TurboQuant one"), run **`/intake`** on that item's URL: fetch → distill → file
under the suggested path → mint an `sb:` id → update indexes/log. Optionally mark
the digest line `✓ intaken → /path/to/concept.md` so the archive records what
graduated into the brain. (Editing a past digest **only** to add an intake
backlink is the one allowed exception to digest immutability.)

## Guardrails
- The inbox is **not** the bundle: no `sb:` ids, no `verified` field, never filed
  as concepts. `/news` writes only under `inbox/`.
- Distill synopses; never dump full articles into the digest — that's what
  `/intake` is for.
- Don't repeat prior days. Dedup against both the bundle and recent digests.
- Reason tags come from the fixed vocabulary above; propose additions, don't
  invent them silently.
- Never touch `deprecated/`.
