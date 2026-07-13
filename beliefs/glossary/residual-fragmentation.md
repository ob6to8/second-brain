---
id: sb:96a610
type: concept
title: residual fragmentation
description: The near-duplicate or fragmented concepts that remain after automated intake dedup has done its cheap best, left for a human editorial pass to catch and merge.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, intake, dedup, editorial]
sense: repo
timestamp: 2026-07-12
---

# residual fragmentation

The duplicated or split-apart concepts that survive automated intake [deduplication](/beliefs/glossary/deduplication.md) — the leftover after the machine has done the cheap merges it can (e.g. updating in place on a known `relates to sb:` hint). It names a division of labor in the [auto-intake model](/meta/plans/auto-intake-featured-research.md): automation handles the *bulk* of don't-fragment via update-in-place, and the operator's editorial pass reconciles the *residual* that lexical [recall](/beliefs/glossary/recall.md) missed. The cost asymmetry matters — reconciling a fragmentation already committed to history (reassigning ids, redirecting [`verified_by`](/beliefs/glossary/verified-by.md) edges) is dearer than avoiding it at write time, which is why the residual is kept small rather than left to grow.

*Seen in:* [auto-intake-featured-research plan](/meta/plans/auto-intake-featured-research.md)

*See also:* [deduplication](/beliefs/glossary/deduplication.md), [recall](/beliefs/glossary/recall.md), [cognitive debt](/beliefs/glossary/cognitive-debt.md)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="sb:96a610">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-12-news-auto-intake-featured-items (2026-07-12)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:96a610`]**  (co-feeds: `sb:5e7da1`)

**`/elaborate`: low recall → silent fragmentation**

This is now written into `recall.md`, but plainly: intake dedup fires a **lexical** search for an existing home for the new item. Because lexical search matches shared *words*, not *meaning*, it misses a concept that says the same thing in different terms (the recall failure). Intake therefore concludes "nothing exists" and files a **new** concept next to the one it should have updated. Crucially, **nothing errors** — the miss is invisible at write time — so the duplicate lands *silently*, gets committed to history, and the two files drift apart. That's why low recall is dangerous rather than merely lossy: it quietly converts a retrieval gap into committed fragmentation that only a later editorial pass, never an error message, can catch. (This is exactly the debt Fork A is meant to avoid paying.)
