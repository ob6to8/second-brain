---
type: policy
title: Resource attribution
description: Every bundle concept and governance doc carries a structured `attribution` frontmatter map recording the ingestion event — when it entered, through which channel and by whom, and why — immutable except the append-only governance `from` back-link.
section: composition
order: 3
status: active
tags: [meta, governance, attribution, frontmatter, provenance, intake, ingestion]
timestamp: 2026-07-13
---
**Attribution — the ingestion event, recorded on the doc.** Every bundle concept
(everything with an `sb:` id) and every governance doc carries an `attribution`
frontmatter map recording how it entered the brain (see the
[attribution plan](/meta/plans/resource-attribution-property.md) for the design
record):

```yaml
attribution:
  when: 2026-07-13T14:02:00Z
  channel: auto-intake
  agent: "Claude Code agent, /research daily Routine"
  why: "featured in the 2026-07-13 digest under agents/orchestration; reason-tag: impactful"
  from: [/meta/threads/2026-07-13-example.md]   # governance docs only
```

| Sub-key | Holds | Form |
|---------|-------|------|
| `when` | The ingestion instant | ISO 8601 (date minimum; datetime preferred) |
| `channel` | *How* it entered — the pathway | Controlled: `intake` · `auto-intake` · `glossary` · `agent-authored` · `backfill` (grows by operator ratification, like `type`) |
| `agent` | *Who* acted — the operator, or the agent and the automation context it ran in. Names the **pathway, not the model** (the model is in the commit trailer) | Free text, one line |
| `why` | Why it was deemed worth filing | Free text, one sentence (optional when `channel: backfill` — never invented) |
| `from` | **Governance docs only.** The doc(s) this entry was extracted from — the thread it came out of, and/or the concept doc that resulted from that thread | Inline YAML list of refs, route-tag style: an `sb:` id (concept) or a bundle-absolute path (thread/governance doc); targets must exist |

- **Immutable event, one carve-out.** The event sub-keys
  (`when`/`channel`/`agent`/`why`) are written once at filing and never
  rewritten — update-in-place merges bump `timestamp`, not attribution.
  Governance `from` is **append-only**: later sessions that substantively
  revise a doc add their thread (stamped by `/create-pull-request` after
  `/capture`, when the thread path exists), never remove or rewrite entries.
- **Orthogonal to the neighboring fields.** `resource` = *what asset* (canonical
  URI); `provenance` = *where the content came from* (author/origin, possibly
  predating the brain); `attribution` = *how it got here* (the ingestion event);
  `timestamp` = *when it last changed*. Attribution is not a log: the commit
  graph stays the single change-narrative layer, and this is one write-once
  record, not a maintained history.
- **Scope and exemptions.** Required on all bundle concepts and on governance
  docs (`from` required on ratification-flow docs — `plan`, `analysis`,
  `elaboration`, `issue`; permitted absent only where no source doc exists).
  Exempt — and it is an **error** for them to carry `attribution`: thread docs
  (they *are* the session record; `pr:` is their anchor), `inbox/` digests
  (dated and self-describing by construction), and generated artifacts
  (`CLAUDE.md`, `meta/registry.md`, `index.md` listings).
- **Machine-enforced.** `mix brain.verify` checks shape (parseable map, valid
  `when`/`channel`, non-empty `agent`, `why` per the backfill rule), `from` ref
  resolution, exemption placement, and presence.
