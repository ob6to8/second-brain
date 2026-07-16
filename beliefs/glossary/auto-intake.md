---
id: em:f8ae3a
type: concept
title: auto-intake
description: The /research step that files its featured items into the bundle via /intake in the same run, moving the operator from a pre-intake gate to a post-intake editorial role.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, research, intake, automation]
sense: repo
timestamp: 2026-07-16
attribution:
  when: 2026-07-12T15:51:02+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# auto-intake

[`/research`](/.claude/skills/research/SKILL.md) runs [`/intake`](/.claude/skills/intake/SKILL.md) on each **featured** item rather than leaving them as candidates for a human to pick. Its premise is that the [featuring](/beliefs/glossary/featuring.md) gates are already the quality filter, so a featured item needs no second pre-intake gate; the operator's contribution moves to the *post-intake editorial* pass (prune, relabel, merge). It is bounded to the known tree — items needing a new top-level directory are **deferred** for ratification, never filed autonomously — prefers update-in-place on a `relates to em:` hint to keep [residual fragmentation](/beliefs/glossary/residual-fragmentation.md) small, and records what it files with `channel: auto-intake` in the concept's [attribution](/beliefs/glossary/attribution.md) so the editorial queue is one query (`mix brain.attribution --channel auto-intake`; this superseded an earlier `auto-intake` *tag*, retired when attribution landed). The digest itself stays a non-bundle record; only its featured items acquire ids. The tradeoff it accepts is [cognitive debt](/beliefs/glossary/cognitive-debt.md): the corpus can grow faster than the operator internalizes it.

*Seen in:* [auto-intake-featured-research plan](/meta/plans/auto-intake-featured-research.md), [2026-07-12 news auto-intake thread](/meta/threads/2026-07-12-news-auto-intake-featured-items.md), [2026-07-13 resource-attribution property thread](/meta/threads/2026-07-13-resource-attribution-property-spec-and-build.md)

*See also:* [featuring](/beliefs/glossary/featuring.md), [deduplication](/beliefs/glossary/deduplication.md), [residual fragmentation](/beliefs/glossary/residual-fragmentation.md), [cognitive debt](/beliefs/glossary/cognitive-debt.md)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:f8ae3a">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-13-resource-attribution-property-spec-and-build (2026-07-13)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:f8ae3a`]**  (co-feeds: `/meta/plans/resource-attribution-property.md em:f97e44`)

All five decisions are recorded and the plan is now `status: accepted` — pushed as `e615742`, gates green, and the index entry moved into "Accepted / In progress" (its first occupant).

How each answer landed in the spec:

1. **Scope: all bundle concepts** — the capture-type carve-out question is closed.
2. **Presence: verifier-mandatory after backfill** — for both the bundle-concept rule and the governance `from` rule.
3. **`agent` = pathway** — locked in as the ratified convention.
4. **`auto-intake` tag retires immediately** — no transition window. The skill stops writing it in build step 3, the backfill converts existing tags to `channel: auto-intake`, and until the query task ships the editorial pass greps the channel instead.
5. **Lineage derives from `from`** — with the two consequences I flagged folded in: semantics rule 1 now splits immutability (event sub-keys write-once; governance `from` append-only, since feature lineage accretes across sessions), and derivation is sequenced as build step 5, immediately after the governance backfill that populates `from` — the backfill diff doubles as the migration check that derived chains reproduce today's hand-kept `lineage:` blocks before those get deleted. A pleasant side effect: `mix brain.lineage` becomes the first machine consumer of `from`, which is what earns the typed edge under the bundle's own rule — so I also promoted `mix brain.attribution` from optional to build step 6, since the traversal code will already exist.

The build order now reads: policy + contract render → verifier shape rules → skill writers (including `/create-pull-request` stamping, tag and `thread:` retirement) → backfill + flip mandatory → lineage rewire → query surface. The spec phase is complete; say the word when you want execution to start (step 1, the policy doc + `/render-contract`, is a natural first slice), and `/create-pull-request` whenever you want this session's work captured and opened as a PR.
