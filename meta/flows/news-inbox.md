---
type: note
title: News — generate the daily inbox of candidates
description: The end-to-end flow for the daily candidate feed — derive a query profile from the taxonomy, search, dedup twice, reason-tag, and write a dated digest into the non-bundle inbox/ namespace, handing off to /intake when the operator picks an item — the touch-sequence, actor boundaries, and why this flow has (almost) no deterministic spine.
tags: [meta, governance, news, inbox, feed, flow, workflow]
timestamp: 2026-07-11
---

# News — generate the daily inbox of candidates

The connective doc for how the *outside world* reaches the brain: `/news`
scans for material matching what the brain already tracks and writes a dated
**digest of candidates** into `inbox/` — the waiting room. Nothing here enters
the bundle; a candidate crosses over only when the operator picks it and the
[intake flow](/meta/flows/intake.md) runs.

> **The three artifacts (and the sources of truth — point, don't restate):**
> - **Rules** → [link-processing](/meta/policy/link-processing.md) (the inbox
>   deliberately does *not* violate "no parked URLs": items are candidates
>   with synopses, outside the bundle) ·
>   [tree-is-the-taxonomy](/meta/policy/tree-is-the-taxonomy.md) (the taxonomy
>   *is* the query profile).
> - **Procedure** → the [`/news` skill](/.claude/skills/news/SKILL.md) —
>   including the selection contract (four gates + reason-tag vocabulary).
> - **Mechanism** → none to speak of, and that is the honest headline: this
>   flow is almost **all judgment layer**. Its only structural guarantee is
>   the namespace boundary — `inbox` sits in `Registry`'s `@excluded_dirs`
>   ([registry.ex](/lib/second_brain/registry.ex)), so nothing written here
>   can acquire an id, enter the registry, or be verified. There is no
>   scenario test because there is no deterministic spine to pin.

---

## 1. The problem

A second brain that only receives what the operator happens to paste goes
stale in exactly the areas it cares most about. But pushing raw search results
into the bundle would violate distill-don't-dump and park unprocessed URLs.
The inbox splits the difference: a **daily, taxonomy-aimed, reason-tagged
shortlist** that costs the operator one glance, held outside the bundle until
a human decides an item is worth intake.

---

## 2. The pipeline

```
   the taxonomy (root index.md → domain index.md → concept titles/tags)
          │  read: this IS the query profile — the feed re-aims as the brain grows
          ▼
   ┌──────────────┐   /news (daily, or "run the feed")
   │ SEARCH        │   per-domain web/paper searches, current window
   │ DEDUP ×2      │   vs the bundle · vs recent digests
   │ SELECT + TAG  │   four gates; reason tags ARE the featuring criteria
   └──────┬───────┘
          │  writes (never into the bundle)
          ▼
   inbox/YYYY-MM-DD.md      (type: reference · NO sb: id · immutable once written)
   inbox/index.md           (Latest + archive)
          │  operator: "intake the <…> item"
          ▼
   the /intake flow — fetch → distill → file → mint id → registry → verify
   (optionally mark the digest line "✓ intaken → /path" — the one allowed
    edit to a past digest)
```

---

## 3. The touch-sequence (a canonical run)

| # | Actor | Action | Files touched | Checked by |
|---|-------|--------|---------------|------------|
| 1 | operator | Say `/news` (or the daily schedule fires) | — | — |
| 2 | agent | Build the query profile from the taxonomy: root + domain `index.md`s, concept titles/tags; note high-signal `sb:` ids to relate items to | — (reads bundle) | editorial |
| 3 | agent | Search per domain (web; paper tools for academic domains), current window | — (reads external) | editorial |
| 4 | agent | Dedup twice: against the bundle, then against recent digests | — (reads) | editorial |
| 5 | agent | Select through the four gates (relevance · novelty · a reason tag fires · source quality), cap for quality over volume | — | editorial |
| 6 | agent | Write today's digest: `##` per KB domain, one bullet per item with reason-tag badges, synopsis, `→ would file under` hint, `relates to sb:…` | `inbox/YYYY-MM-DD.md` | editorial |
| 7 | agent | Maintain the index: Latest + archive in `inbox/index.md` (the run narrative lives in the commit message; no hand-kept log) | `inbox/index.md` | editorial |
| 8 | operator | (later) Pick an item → hand off to [`/intake`](/meta/flows/intake.md) | — | (that flow's spine) |

Every "checked by" is editorial — the structural checks live at the boundary:
the registry/verifier cannot *see* `inbox/`, and the site renders it read-only.

---

## 4. Invariants

- **Candidates, not concepts.** No `sb:` ids, no `verified`, never filed as
  concepts; `/news` writes only under `inbox/`. Enforced structurally by the
  registry exclusion, editorially by the skill's guardrails.
- **Digests are immutable.** Previous days persist unchanged as the archive —
  except the one sanctioned edit: back-linking an item that graduated
  (`✓ intaken → …`).
- **The taxonomy is the filter.** An item with no mapping to a tracked domain
  is not featured, however interesting; the feed's aim drifts *with* the tree,
  not independently of it.
- **Reason tags are a closed vocabulary** (`recent` · `impactful` ·
  `influential` · `groundbreaking` · `buzz`) — additions are proposed to the
  operator, like `type`s and top-level directories.
- **One digest per day** — a re-run regenerates today's file rather than
  creating a sibling.

---

## 5. Verify — what can and cannot be checked

Nothing mechanical pins selection quality; the oracle is the operator's glance
at the digest. What *is* held structurally: the namespace boundary (a digest
that somehow acquired an id would surface in `mix brain.verify`'s scan the
moment it moved into the bundle), and the site build (CI renders `inbox/`
pages like any other, so a malformed digest that crashes the renderer fails
CI). Known operational risk is tracked as an issue:
[daily news Routine runs not landing](/meta/issues/daily-news-routine-runs-not-landing.md).
