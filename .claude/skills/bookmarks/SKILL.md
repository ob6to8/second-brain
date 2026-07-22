---
name: bookmarks
description: Process the survey tier — links parked in bulk that aren't worth fully ingesting yet. Use when the operator says "/bookmarks", drops URLs into survey/bookmarks.md and asks to process them, says "survey these links", "bookmark these", "add these to the survey tier", or "promote that bookmark". Fetches each URL, writes a one-line summary + tags, and parks it as surveyed; promotion hands off to /intake.
---

# /bookmarks — the survey tier

Maintain the **survey register** at [`survey/bookmarks.md`](/survey/bookmarks.md): links
worth keeping but not worth the full distill-file-cross-link pass of an
[`/intake`](/.claude/skills/intake/SKILL.md). A **bookmark** is a link *fetched,
one-line-summarized, and tagged* — enough metadata to be surfaced by a topic query —
parked with `status: surveyed`. It is the lower-effort staging sibling of `/intake`; see
the [link-processing](/meta/policy/link-processing.md) survey-tier carve-out and follow
the [operating contract](/CLAUDE.md).

The survey tier lives in the **`survey/` namespace**, which — like `inbox/` and `meta/` —
sits *outside* the OKF bundle: bookmarks carry **no `em:` id**, are never verified, and
make no claim on the taxonomy. They are register rows, not documents; the register reuses
`type: reference`. A bookmark earns a place in the tree only on **promotion**.

## Dispatch

The first argument selects the operation. With no argument, **process** the register's
Pending section (the default — this is the common case). Infer from phrasing when
ambiguous; if still unclear, ask.

- `/bookmarks` (or `/bookmarks process`) → **Process** the Pending dropzone (below).
- `/bookmarks add <url(s)>` → **Add** pasted URLs, then process them (below).
- `/bookmarks list [surveyed|promoted|all]` → **List** (below). Default filter: `surveyed`.
- `/bookmarks promote <url or title>` → **Promote** to a filed reference (below).

---

## Process

Turn raw links in the register's **Pending** section into summarized, tagged **Surveyed**
entries.

1. **Read the register.** Open [`survey/bookmarks.md`](/survey/bookmarks.md). Collect the
   raw URLs listed under `## Pending`. The operator groups them under **date-added
   headings** — an `### YYYY-MM-DD` line marks when the URLs beneath it were added;
   carry that date as each bookmark's **Added** date (below), *not* today's processing
   date. A URL with no date heading above it defaults its Added date to today. Each URL
   is one per line; a trailing `— note` is optional operator context to weave into the
   summary. If Pending is empty and no URLs were passed, tell the operator there is
   nothing to process and stop.
2. **Dedup.** For each URL, check it is not already present: grep `survey/bookmarks.md`
   for the URL, and grep the bundle (`rg <url> --glob '!survey/**'`) for an existing
   filed `reference` with that `resource`. Skip duplicates, noting which and why. If it
   is already a filed reference, say so — no need to survey what's ingested.
3. **Fetch and summarize each** (this is the tier's defining work — *auto-generate*,
   don't ask the operator to write summaries):
   - **Aggregator links → resolve to the underlying resource.** If the URL is a
     discussion-aggregator item — a Hacker News item
     (`news.ycombinator.com/item?id=…`), and by the same logic a Lobsters/Reddit
     discussion — fetch it, **extract the actual submitted resource URL** (the link at
     the top of the HN item), and treat the two as **one bookmark**: the underlying
     resource is the primary link and gets the title/summary/tags, while the discussion
     is kept alongside it as a `Discussion:` link. If the item has no external URL (an
     Ask HN / Show HN / text post), the discussion page *is* the resource — no
     extraction needed.
   - `WebFetch` the URL (the underlying resource for an aggregator link). If the fetch
     fails (dead link, paywall, timeout), still record the bookmark but mark the summary
     `(unfetched: <reason>)` so nothing is silently dropped — the operator can retry or
     supply context later.
   - Write a **one-sentence** summary: what the resource *is* and why it might matter.
     Distillation-light — a locator, not a digest. Fold in the operator's `— note` if
     given.
   - Assign **2–5 topical tags**, kebab-case, drawn from the resource's subject and
     aligned to the [taxonomy](/index.md) tree where they fit (e.g. `ai-agents`,
     `elixir`, `okf`) so a topic query surfaces it. Tags are the primary retrieval
     handle — choose them the way you would choose a filing directory.
   - Capture the page's real title for the link text.
4. **Write the Surveyed entries.** Under `## Surveyed`, prepend each new bookmark
   (newest first) in this shape:
   ```
   ### [<page title>](<underlying resource url>)
   - **Added:** <date-added from the Pending heading; today if none> · **Status:** surveyed · **Tags:** `tag-a` `tag-b`
   - <one-sentence summary>
   ```
   `Added` is the operator's date-added, carried from the Pending date heading — it is
   the bookmark's stable "when I flagged this" property and is **preserved on
   promotion** (only `Status` changes). For an aggregator link, append a discussion
   pointer to the metadata line — ` · **Discussion:** [HN](<hn item url>)` — so the
   resource and its discussion stay one bookmark. Remove the `_No bookmarks surveyed
   yet._` placeholder on first use.
5. **Clear Pending.** Delete the processed URLs from `## Pending`, restoring the
   `_(none pending)_` placeholder if it is now empty. Leave any URL you skipped or could
   not fetch only if the operator should revisit it, with a one-line reason.
6. **Bump `timestamp`** in the register frontmatter to today.
7. **Verify & report.** Run `mix brain.verify` (the register carries no `em:` id, so no
   `mix brain.id`/`registry` step — `survey/` is excluded from the registry). Report how
   many bookmarks were surveyed, how many skipped, and any that failed to fetch.

## Add

Same as **Process**, but the URLs come from the command argument (a paste of one or more
URLs) instead of the Pending section. Append them to `## Pending` first (so the register
is the record of intent even if processing is interrupted), then run **Process**.

## List

1. **Read** `survey/bookmarks.md`, parsing each `### [title](url)` block's status, tags,
   and summary.
2. **Filter** by the argument (`surveyed` by default; `promoted` shows graduated ones;
   `all` shows everything).
3. **Render** a concise grouped list to the operator — grouped by status, newest first,
   each row: title (linked), tags, one-line summary. Note the total count. Read-only.

## Promote

Graduate a surveyed bookmark into a filed bundle `reference` — the bridge where
[distill, don't dump](/meta/policy/distill-dont-dump.md) re-engages.

1. **Locate** the bookmark in the register by URL or title.
2. **Run [`/intake`](/.claude/skills/intake/SKILL.md)** on its URL — the full pass:
   fetch, distill, file into the correct taxonomy directory, mint an `em:` id,
   cross-link, and maintain that directory's `index.md`. Intake owns this; do not
   duplicate its logic here.
3. **Record the graduation** on the register row — flip its status line to:
   ```
   - **Added:** <date> · **Status:** promoted → [<filed title>](/knowledge/…/<slug>.md) · **Tags:** …
   ```
   Keep the row (do not delete it) so the survey → ingested trail stays visible, and bump
   the register `timestamp`.
4. **Verify & report.** Run `mix brain.verify` and report the new reference's path (the
   `/intake` step mints and registers its `em:` id).

## Guardrails

- **Summaries are mandatory and auto-generated.** The tier's whole justification is that
  a bookmark is *surveyed, not parked bare* — never write a row without a summary and
  tags. A link with no metadata is a link graveyard entry; the contract forbids it.
- **Never mint an `em:` id for a bookmark.** `survey/` is a non-bundle namespace; the id
  belongs to the filed reference that promotion creates, not to the staging row.
- **The register carries no `attribution`.** Like `inbox/` digests, `survey/` files are
  exempt (machine-enforced by `mix brain.verify`) — do not add one.
- **Distillation stays light.** One sentence, a locator. If you find yourself writing
  paragraphs, the link deserves promotion via `/intake`, not a bloated bookmark.
- **Shard only when large.** Start with the single `survey/bookmarks.md`. If it grows
  unwieldy, split by top-level domain (`survey/ai.md`, `survey/swe.md`) and list the
  shards in [`survey/index.md`](/survey/index.md) — a change to the shape of the survey
  tier, so surface it to the operator first.
- Keep the register OKF-conformant: parseable frontmatter, non-empty `type`.
- Never touch `deprecated/`.
