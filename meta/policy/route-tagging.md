---
type: policy
title: Route tagging
description: Per-paragraph <routes ref="sb:…"> tags on the frozen thread body materialize an append-only, date-stamped excerpt log into each referenced document; mix brain.route_tags re-derives the log from the tags and fails on divergence.
section: session-workflow
order: 3
status: active
tags: [meta, governance, threads, provenance, linkage, workflow]
timestamp: 2026-07-13
---
Mark each region of a finalized thread body with the document(s) its content
feeds, so a matter's cross-thread discussion aggregates into one place. The tag
is an inline `<routes ref="...">` region, applied over the **frozen** body as
the last motion of `/capture`.

```
<routes ref="sb:4c9e1f lib/second_brain/route_tags.ex">
... one paragraph, feeding a document and back-linking a code path ...
</routes>
```

Settled properties:

- **Keyed on canonical ids, never free-text topics.** A ref is a document's
  stable **`sb:` id** (the aggregating sink — it accretes the log) or a **path**
  (a non-aggregating back-link to code or a file — no log). Ids, not phrases, so
  two threads about the same matter emit the same string and the cross-thread
  join is exact. This mirrors the identity rule that typed edges reference ids,
  not paths.
- **Per-paragraph, multi-ref, lifted whole.** A paragraph feeding two matters
  carries both refs on one region (never nested regions). The tag boundary *is*
  the auditable selection — no within-region trimming. A region must not cross a
  `## User`/`## Assistant` turn boundary.

**The doc-side log.** Each referenced document carries a
**`## Thread excerpts — route-tagged log`** section: an append-only, per-thread,
date-stamped block for every thread that tags it, each block lifting the tagged
regions whole (ATX headers demoted to bold). Each block quotes a *frozen* thread,
so it never goes stale; the section is **generated, not hand-kept** — `mix
brain.route_tags --materialize` writes it from the current tags.

**The verifier owns it.** `mix brain.route_tags` (see `SecondBrain.RouteTags`)
runs beside `mix brain.verify` in CI and the pre-commit hook. It re-derives each
sink's log from the current tags and **fails on divergence**, converting the
log's freshness from procedural to structural, and checks tag wellformedness,
ref resolution, and per-sink block presence. Tag *coverage* — whether every
feeding paragraph was tagged — has no mechanical oracle and stays editorial; a
routing-ledger cross-check lifts it to row granularity and **warns** (never
fails).

**Freeze on matter-resolution.** A document accepts new excerpt blocks while its
matter is unresolved and freezes acceptance when the matter resolves — per
matter, not on archival.
