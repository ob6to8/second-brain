---
type: policy
title: Links must be processed
description: A web resource becomes a bundle reference only once distilled; the survey tier is the one sanctioned staging exception, where links are fetched, summarized, and tagged but not filed.
section: filing
order: 5
status: active
tags: [meta, governance, filing, links, references]
timestamp: 2026-07-22
attribution:
  when: 2026-07-05T12:30:48+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-05-greenfield-okf-bootstrap-and-verification-layer.md, /meta/threads/2026-07-22-survey-tier-and-bookmarks-register.md]
---
- **No bare URLs as bundle documents.** A link becomes a bundle
  [`reference`](/meta/policy/controlled-type-vocabulary.md) — filed into the taxonomy,
  distilled, cross-linked, carrying an `em:` id — only once it has been **processed**
  (fetched and summarized/captured). Never file a bare, unprocessed URL as a bundle
  document: distill it into a reference, or park it in the survey tier below. The two
  levels are the point — a link is either *ingested* (a filed reference) or *surveyed*
  (a bookmark), never dumped raw into the taxonomy.
- **The survey tier — the one sanctioned staging exception.** Links worth keeping but
  not worth fully ingesting yet live in [`survey/`](/survey/index.md) as **bookmarks**:
  rows in a register (`survey/bookmarks.md`), each **fetched, one-line-summarized, and
  tagged** by [`/bookmarks`](/.claude/skills/bookmarks/SKILL.md) — enough metadata to be
  surfaced by a topic query, without the distill-file-cross-link cost of a reference. A
  bookmark is *surveyed, not parked bare*; the summary + tags are mandatory, so the tier
  never degrades into a link graveyard. `survey/` is a **non-bundle namespace** (no `em:`
  ids, never verified, outside the taxonomy) like `inbox/` and `meta/`, so a bookmark
  makes no claim on the tree. It is a distinct staging level, **not** a new bundle
  `type` — bookmarks are register rows, and the register reuses `type: reference` (as
  `inbox/` digests do).
- **Promotion is the bridge back to the taxonomy.** A surveyed bookmark graduates to a
  filed `reference` via [`/intake`](/.claude/skills/intake/SKILL.md) (driven by
  `/bookmarks promote`); that is the single point where the full distill pass runs and
  [distill, don't dump](/meta/policy/distill-dont-dump.md) re-engages. The register row
  records the graduation (`status: promoted → <link>`) so the staging debt stays
  visible and countable rather than all-or-nothing.
- **Oversized linked resources**: if a linked source is too large to reasonably copy,
  **write a faithful summary** as the document body and **persist the link** in the
  `resource` frontmatter field (and/or `# Citations`) so nothing is lost.
