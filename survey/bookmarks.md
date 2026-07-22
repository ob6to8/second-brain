---
type: reference
title: "Bookmarks — survey register"
description: The survey tier — links parked with a one-line summary and topical tags, awaiting full intake. A lower-effort staging register than a filed reference; process with /bookmarks, promote with /intake.
provenance: "Maintained by /bookmarks — the operator drops raw URLs under Pending; the skill fetches each and writes a summarized, tagged Surveyed entry."
tags: [survey, bookmark]
timestamp: 2026-07-22
---

# Bookmarks — survey register

The brain's **survey tier**: links worth keeping but not worth fully ingesting yet.
Each surveyed entry carries a one-line summary and topical tags — enough to be found
by a topic query — without the full distill-file-cross-link pass that a
[`reference`](/knowledge/knowledge-management/open-knowledge-format.md) demands. This
namespace sits *outside* the OKF bundle (no `em:` ids, never verified), the same way
[`inbox/`](/inbox/index.md) and `meta/` do.

Two tiers, one bridge:

- **Surveyed** (here) — bulk-droppable, fetched-and-summarized, tagged, `status: surveyed`.
- **Ingested** — a promoted bookmark becomes a filed `reference` in the taxonomy, with
  an `em:` id and cross-links. `status: promoted → <link>` records the graduation.

The bridge is [`/intake`](/.claude/skills/intake/SKILL.md), driven by
[`/bookmarks promote`](/.claude/skills/bookmarks/SKILL.md): that is the single point
where [distill, don't dump](/meta/policy/distill-dont-dump.md) re-engages.

## Pending

<!--
  Drop raw URLs here under a date-added heading — an `### YYYY-MM-DD` line marking
  when you added them — one URL per line (a trailing " — note" is optional context):

    ### 2026-07-22
    https://example.com/article
    https://example.com/other — focus on the eval section

  Then run `/bookmarks` (no argument) to fetch each, generate a one-line summary and
  tags, and move it to Surveyed below, carrying that heading date as the bookmark's
  **Added** date. The skill empties this section as it processes. A URL with no date
  heading defaults its Added date to the day it is processed.
-->

_(none pending)_

## Surveyed

<!--
  Each entry is appended by /bookmarks in this shape — newest first. **Added** is the
  date-added the operator flagged in Pending (its `### YYYY-MM-DD` heading), not the
  day it was processed:

  ### [Page title](https://example.com/article)
  - **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `tag-a` `tag-b`
  - One-sentence summary of what the resource is and why it might matter.

  For a Hacker News (or similar) link, /bookmarks extracts the underlying resource as
  the primary link and keeps the discussion alongside it — one bookmark, two URLs:
  ### [Page title](https://example.com/the-actual-article)
  - **Added:** 2026-07-22 · **Status:** surveyed · **Tags:** `tag-a` · **Discussion:** [HN](https://news.ycombinator.com/item?id=48623434)
  - One-sentence summary.

  On promotion, /bookmarks flips the Status (Added is preserved):
  - **Added:** 2026-07-22 · **Status:** promoted → [filed reference](/knowledge/…/x.md) · **Tags:** …
-->

_No bookmarks surveyed yet._
