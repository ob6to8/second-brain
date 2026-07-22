---
id: em:60e22c
type: concept
title: survey tier
description: The brain's lower-effort resource level — links kept but not yet fully ingested, parked in the non-bundle `survey/` register with a mandatory one-line summary and topical tags so they stay queryable by topic, and promoted to a filed reference via `/intake`.
provenance: "Agent-distilled glossary definition; coined by the survey-tier design session"
verified: false
tags: [glossary, filing, links, survey, namespaces]
sense: repo
timestamp: 2026-07-22
attribution:
  when: 2026-07-22T00:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-22 survey-tier-and-bookmarks-register thread that coined it"
---

# survey tier

The second of two levels a link can occupy. A link is either *ingested* — a filed
[`reference`](/meta/policy/controlled-type-vocabulary.md) in the taxonomy, distilled and
cross-linked with an [`em:` id](/beliefs/glossary/stable-id.md) — or *surveyed*: a
**bookmark**, a row in the `survey/bookmarks.md` register that has been fetched,
one-line-summarized, and tagged, but not filed. The summary and tags are **mandatory**
(the [`/bookmarks`](/.claude/skills/bookmarks/SKILL.md) skill auto-generates them on a
light fetch), which is what keeps the tier from degrading into a link graveyard and lets
a topic query surface a surveyed link the same way it surfaces a filed one.

The tier lives in a [non-bundle namespace](/beliefs/glossary/non-bundle-namespace.md)
(`survey/`), so bookmarks carry no `em:` id and make no claim on the tree — the sibling of
the [inbox namespace](/beliefs/glossary/inbox-namespace.md) for durable, topical staging
rather than dated candidate feeds. It is the one sanctioned exception carved into the
[link-processing policy](/meta/policy/link-processing.md)'s otherwise flat "process it or
don't file it" rule, and it deliberately does **not** relax
[distill, don't dump](/beliefs/glossary/distill-dont-dump.md): that rule re-engages the
moment a bookmark is promoted. Promotion — a surveyed bookmark becoming a filed reference
via `/intake` — is a [graduation](/beliefs/glossary/graduation.md), and the register row
records it (`status: promoted → <link>`) so the staging debt stays visible and countable.

*Seen in:* [2026-07-22 survey-tier thread](/meta/threads/2026-07-22-survey-tier-and-bookmarks-register.md)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:60e22c">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-22-survey-tier-and-bookmarks-register (2026-07-22)

4 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:60e22c`]**  (co-feeds: `/meta/plans/bookmarks-survey-tier.md`)

This lands squarely on one of the brain's most deliberate policies, so let me be precise about what you'd be changing and then give you a concrete shape.

**What you're actually proposing**

Right now the brain has exactly **one** door for a link, and `link-processing` slams it shut on the middle ground you're describing:

> Do not file bare, unprocessed URLs as their own documents — process it now, or don't file it. **(There is deliberately no lightweight "bookmark" type.)**

You're asking to reopen that door as a **second, lower tier**:

| Tier | What it is | Effort | Placement |
|------|-----------|--------|-----------|
| **Ingested** (today's `/intake`) | Fetched, distilled, filed into the tree, cross-linked, `type: reference` | High | In the taxonomy |
| **Surveyed** (new) | URL + a one-line summary + tags. Bulk-droppable. Not distilled, not cross-linked | Low | A holding area |

The crucial detail in your follow-up — *each carries a summary + tags so it's still surfaceable by topic* — is what makes this defensible rather than a link graveyard. The original policy's fear is bare rotting URLs nobody can find. A surveyed entry that's queryable by topic isn't that; it's a **staging tier**, and the natural lifecycle is `surveyed → (promote via /intake) → ingested`.

There's already precedent for "many links, light metadata, not fully ingested" in the brain: the `inbox/` digests from `/research` hold dated candidate feeds where only *featured* items get auto-intaken and the rest are just listed with reason-tags. Your idea is essentially that pattern, but **topical and durable** instead of dated and ephemeral.

**This is a shape change — your call, not mine**

Adding a `type` and amending `link-processing` is a change to the *shape* of the brain, so per the contract I propose and you ratify. Here's the cleanest shape I'd recommend, with the genuine decisions called out:

**1. A new type — I'd lean `bookmark`** (honest about what it is; the policy's own word). Carries `resource`, a `description` (the one-line summary), `tags`, and a `status: surveyed` that flips to `promoted` when it graduates. It's a capture, so no `verified` field — consistent with existing rules.

**2. Where it lives — I'd recommend a flat `survey/` (or `queue/`) namespace, not the tree.** You explicitly *don't* want to file these into the taxonomy yet — that's the expensive part you're deferring. Tags carry the topical surfacing; tree placement waits for promotion. This keeps the "the tree is the taxonomy" invariant clean: only distilled docs earn a place in it.

**3. Surfacing — tags + a generated index.** `mix brain.*` already reads frontmatter; a `bookmark`'s tags + summary would be queryable exactly like any doc's, so an LLM asking "what do I have on topic X" pulls both tiers, with tier visible via `type`.

The real trade-off to weigh: this **relaxes "distill, don't dump"** at the edges. The mitigation is that `status: surveyed` makes the debt *visible and countable* — you can always query "how many un-promoted bookmarks in area X" — rather than the current all-or-nothing.

**Two questions before I'd write anything**

- **Bulk-drop ergonomics:** do you picture a `/survey` skill that takes a paste of many URLs and auto-generates the summary+tags per URL (a quick fetch, one line each), or literally just parking the URL with tags *you* supply and no fetch at all? That's the difference between "cheap distillation" and "true bookmark."
- **Naming:** `bookmark` (plain), `survey` (matches your word), or fold it into `reference` as a `stage` field rather than a new type?

This is exactly the kind of deferred, shape-changing design that's worth a `type: plan` doc rather than living in chat. Say the word and I'll persist one under `meta/plans/` capturing this, tuned to your answers above — or if you'd rather just talk it through more first, we keep going here.

---

**[`em:60e22c`]**  (co-feeds: `/meta/plans/bookmarks-survey-tier.md /meta/policy/distill-dont-dump.md`)

**"Distill, don't dump" — where it is, and no, it hasn't been amended**

It's a real, foundational policy: `meta/policy/distill-dont-dump.md`, `section: filing`, `order: 1` — literally the first filing rule. Full text is just that one paragraph I quoted.

On whether it was recently amended: **no.** Its entire history is three commits, and none touched the doctrine's substance:

- `2113193` — the concept→document terminology sweep (mechanical, bundle-wide)
- `cb2d837` — attribution backfill (added the frontmatter block, not the body)
- `4960c48` — its arrival

The body text is untouched since it was written. Recent policy churn has all been elsewhere — `session-capture`, `merge-strategy`, `plan-vs-capture`. So it's stable ground, and good instinct to check.

The important nuance: what we're building **doesn't amend `distill-dont-dump` at all.** That doctrine governs *documents* — things that have earned a place in the tree. Our bookmark tier sits *before* distillation, so the honest move is a narrow carve-out in its sibling `link-processing` ("no bookmark type" → "one explicit staging tier, which does not enter the taxonomy"), leaving `distill-dont-dump` fully intact and still the rule the moment a bookmark is *promoted*.

**One-per-file vs. listed in a doc — I've flipped to **listed in a doc****

Your `bookmarks-register.md` instinct is right, and it improves on my earlier `type: bookmark`-per-file sketch. One-file-per-bookmark is the wrong weight for this tier:

- **It fights the bulk use case.** "Drop in large numbers of URLs" → hundreds of tiny files.
- **It pollutes the identity graph.** Every bundle document mints an `em:` id into `meta/registry.md` and needs `index.md` upkeep. A staging tier that hasn't earned a place in the brain shouldn't be claiming permanent ids — that ceremony is exactly what promotion is *for*.
- **A register matches existing precedent.** `inbox/` digests are lists-in-a-doc in a non-bundle namespace with no `em:` ids. Bookmarks are the same kind of thing: pre-knowledge, not yet real documents.

So the revised shape:

- **A `survey/` namespace, outside the bundle-id system** (like `inbox/` and `meta/`). No `em:` ids for bookmarks.
- **The register is the storage, not just the input.** `survey/bookmarks.md` holds a table — one row per bookmark: `URL | summary | tags | status`. You append raw URLs (bare, maybe with a scribbled note) to the bottom; `/bookmarks` finds the un-enriched rows, does a light fetch → one-line summary + tags, and rewrites them in place with `status: surveyed`. Same doc in, same doc out — no separate inbox/register split to keep in sync.
- **Surfacing is the tags in the rows.** The register is small enough to load whole; an LLM topic query reads the tags/summaries directly. When it grows, we shard by top-level domain (`survey/ai.md`, `survey/swe.md`) — tags still do the work.
- **Promotion is the one bridge back to the tree.** `/intake <url>` on a surveyed row does the full distill-file-crosslink pass, mints the `em:` id, and flips the row to `status: promoted → [link to the new reference]`. That's the single point where `distill-dont-dump` re-engages, and where a bookmark becomes a real document.

Net effect on the type vocabulary: we probably **don't** need a new `type: bookmark` after all — the register is one doc (I'd give *it* a light type, `reference` or a new `register`, TBD), and individual bookmarks are rows, not documents. That's a nice simplification your register framing bought us.

One thing to pin down before I write the plan: **does `/bookmarks` fetch each URL to auto-generate the summary + tags, or do you supply them and it just structures the register?** I'd recommend a light fetch (one quick pass, one line + a few tags each) — that's what makes the tier genuinely queryable rather than a bare link list — but it costs a fetch per URL on a bulk drop. Your call.

Once you answer that, I'll persist the plan under `meta/plans/` and we can build against it.

---

**[`em:60e22c`]**  (co-feeds: `/meta/plans/bookmarks-survey-tier.md /survey/bookmarks.md /.claude/skills/bookmarks/SKILL.md /meta/policy/link-processing.md`)

Built, verified, committed, and pushed to `claude/resource-intake-levels-fqi6xw`. Here's what landed.

**The two-level resource model**

Your brain now distinguishes exactly the two tiers you asked for:

| Tier | What it is | Where it lives |
|------|-----------|----------------|
| **Ingested** | Fetched, distilled, cross-linked, `em:` id — today's `/intake` | The taxonomy tree |
| **Surveyed** (new) | Fetched, one-line-summarized, tagged — bulk-droppable | `survey/bookmarks.md`, outside the bundle |

A link is now always *ingested* or *surveyed*, **never dumped raw** — the summary + tags are mandatory, so the tier can't rot into a link graveyard. Surveyed links are queryable by topic (tags + summary are search-indexed) and promote to filed references via `/intake` — the single bridge where "distill, don't dump" re-engages.

**How you'll use it**

1. Open `survey/bookmarks.md`, paste URLs under `## Pending` (one per line, optional `— note`).
2. Run **`/bookmarks`** — it fetches each, writes a one-sentence summary + 2–5 topical tags, moves them to `## Surveyed`, and clears Pending.
3. `/bookmarks list` to review; `/bookmarks promote <url>` to graduate one into a filed reference (records `status: promoted → <link>` so nothing's lost).

**Decisions I made on your behalf (flag if you'd change any)**

- **Register, not one-file-per-bookmark** — your instinct was right; per-file would've minted an `em:` id per staging link and fought bulk drops.
- **No new `type`** — the register reuses `type: reference` exactly as `inbox/` digests do, since bookmarks are rows, not documents. This kept the type vocabulary untouched (no ratification needed). The one call you didn't explicitly make — say the word if you'd rather have a distinct `type: bookmark`.
- **`survey/` mirrors `inbox/` mechanically** — non-bundle, no ids, attribution-exempt, but still link-checked and rendered to the Pages site.

**On your grounding question**

"Distill, don't dump" is real (`meta/policy/distill-dont-dump.md`, the *first* filing rule) and **has never been amended** — its three commits were all mechanical (terminology sweep, attribution backfill). Importantly, this change **doesn't touch it**: I carved the exception into its sibling `link-processing` instead, leaving the distillation doctrine fully intact and still the rule at promotion time.

Full design record is in `meta/plans/bookmarks-survey-tier.md`. All 178 tests + every `mix brain.*` gate pass. No PR opened — the branch is pushed and waiting. Want me to open one (`/create-pull-request`), or try a `/bookmarks` dry run on a few URLs first?

---

**[`em:60e22c`]**  (co-feeds: `/survey/bookmarks.md /.claude/skills/bookmarks/SKILL.md`)

Both incorporated into the register and the `/bookmarks` skill, in the same PR.

**Date added.** Each surveyed bookmark now carries an **Added** prop, and it's *your* date-added, not the processing date. You flag it in `## Pending` by grouping URLs under an `### YYYY-MM-DD` heading; `/bookmarks` reads that heading and stamps it onto each bookmark's `Added` line (defaulting to the processing day only when a URL has no heading above it). `Added` is preserved on promotion — it's the stable "when I flagged this," distinct from the register's own `timestamp`.

**Hacker News links.** When you drop a `news.ycombinator.com/item?id=…` URL, `/bookmarks` fetches the discussion, extracts the actual submitted resource at the top, and treats the two as **one bookmark**: the underlying resource is the primary link (it gets the title/summary/tags), and the HN thread rides along as a `Discussion:` pointer on the metadata line. Same logic covers Lobsters/Reddit; an Ask/Show/text post with no external URL just stays the resource itself. Both changes are also recorded in the plan's artifact shape.
