---
id: sb:ea7acc
type: concept
title: provenance
description: Commonly, the documented origin and history of an artifact — where it came from and how it got here; in this brain, the frontmatter field recording a statement's immutable origin, orthogonal to verification.
provenance: "Agent-distilled glossary definition, pointer to the defining doc"
verified: false
tags: [glossary, frontmatter, provenance]
sense: dual
timestamp: 2026-07-13
attribution:
  when: 2026-07-11T08:41:24+02:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# provenance

The documented origin and history of an artifact — where data, a claim, or an object came from and the chain of custody that brought it here. Data provenance is what lets a reader judge trust and trace errors to their source.

**In this brain:** the frontmatter field recording the immutable origin/history of a statement (e.g. "Claude Opus 4.8, chat thread") — distinct from `resource`, which is a canonical asset URI. Provenance is orthogonal to verification: checking a statement never rewrites where it came from. Defined by the [frontmatter-schema policy](/meta/policy/frontmatter-schema.md).

*Seen in:* [2026-07-05 OKF bootstrap thread](/meta/threads/2026-07-05-greenfield-okf-bootstrap-and-verification-layer.md), [2026-07-12 news→research rename thread](/meta/threads/2026-07-12-rename-news-skill-to-research.md), [2026-07-13 resource-attribution property thread](/meta/threads/2026-07-13-resource-attribution-property-spec-and-build.md)

*See also:* [attribution](/beliefs/glossary/attribution.md)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="sb:ea7acc">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-13-resource-attribution-property-spec-and-build (2026-07-13)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:ea7acc`]**  (co-feeds: `/meta/plans/resource-attribution-property.md`)

Spec written, filed, and pushed. The plan is at [`meta/plans/resource-attribution-property.md`](meta/plans/resource-attribution-property.md) (`status: proposed`, awaiting your ratification since it changes the frontmatter schema), indexed in `meta/plans/index.md`, all gates green, pushed to `claude/resource-attribution-spec-l3hzjj`.

**The proposed shape** — one new frontmatter key on bundle concepts:


**Key design decisions in the spec:**

- **It's an immutable event record, not a log.** Written once at filing, never rewritten by update-in-place merges — so it can't drift and doesn't conflict with the retire-hand-kept-logs decision. Git stays the change *narrative*; attribution is the in-band summary of the one commit that renames, merges, and portable-bundle consumption make hard to reach.
- **Orthogonal to the existing fields**, resolving a real ambiguity: `provenance` has been informally carrying both "where the content came from" and "how it entered the brain" (compare the glossary files vs. the auto-intaken ones). The spec gives each field one job: `resource` = what asset, `provenance` = content origin, `attribution` = ingestion event, `timestamp` = last change.
- **The `why` finally lands on the concept.** Today the featuring rationale lives in a dated digest the concept never points back to; `/research` would write it into `attribution.why`, and `/intake` would reuse the operator's natural phrasing (the same text the dedup gold-harvest already collects).
- **Enforcement is phased**: verifier shape rules from day one, presence becomes mandatory only after a git-derived backfill (`mix brain.attribution --backfill`, delivered as a reviewable diff) so the rule is never aspirational. The `auto-intake` tag gets subsumed by `channel` and retired after a transition window.

**Four open questions are flagged for you** at the bottom of the plan: scope (all bundle concepts — my recommendation — vs. only `reference`/`source` captures), whether presence goes verifier-mandatory after backfill, whether `agent` names the pathway or the model, and whether to retire the `auto-intake` tag. No PR opened — say the word (or `/create-pull-request`) when you want one.
