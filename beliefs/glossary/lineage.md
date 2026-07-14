---
id: em:f97e44
type: concept
title: lineage
description: The provenance chain that produced an artifact — for a flow doc, the analysis → plan → thread → PR arc — recorded as a canonical frontmatter block from which human-readable views are derived.
provenance: "Agent-distilled glossary definition, 2026-07-12"
verified: false
tags: [glossary, provenance, flows, tooling]
sense: dual
timestamp: 2026-07-13
attribution:
  when: 2026-07-12T17:33:07+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# lineage

In data engineering, lineage is the traceable chain of sources and transformations that produced an artifact — which inputs, through which steps, led to this output (data lineage) — made explicit so impact and trust can be assessed by traversal rather than archaeology.

**In this brain:** the provenance chain that produced an artifact, made explicit rather than left implicit in scattered backward citations. For a [flow doc](/beliefs/glossary/flow-touch-sequence.md), lineage is the arc `analysis → plan → thread → PR → flow` — the problem identified against evidence, the design that answered it, the session that built it, and the pull request that merged it — recorded as `attribution.from` back-links (classified by governance path) plus each thread's `pr:` anchor — the hand-kept `lineage:` block this began as was retired by the resource-attribution property. Human-readable views (a per-doc blockquote, a cross-flow flowchart) are [materialized](/beliefs/glossary/materialize.md) from those edges, never hand-kept, so the arc reads top-to-bottom and the upstream docs gain the forward pointer plain citations lack. The flow-scoped precursor of the [typed edges](/beliefs/glossary/typed-edge.md) an [epistemic overlay](/beliefs/glossary/epistemic-overlay.md) would generalize across all concepts.

*Seen in:* [2026-07-12 fuzzy-search spike and flow lineage thread](/meta/threads/2026-07-12-fuzzy-search-spike-and-flow-lineage.md), [2026-07-13 resource-attribution property thread](/meta/threads/2026-07-13-resource-attribution-property-spec-and-build.md)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:f97e44">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-13-resource-attribution-property-spec-and-build (2026-07-13)

2 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:f97e44`]**  (co-feeds: `/meta/plans/resource-attribution-property.md`)

All five ratified — I'll record the decisions in the plan and flip it to `accepted`. On Q5, my thoughts first, because agreeing with it has one structural consequence:

**I agree derivation is cleaner, and it fits a pattern this bundle already trusts** — the registry, `CLAUDE.md`, and the excerpt logs are all "hand-write the source once, compile the view, gate on `--check`". A hand-kept `lineage:` block is itself drift-prone (ironic, given the flow-lineage plan was anti-drift motivated). But deriving it forces one amendment to the spec: **`from` must be append-only, not frozen.** Feature lineage accretes — every thread that revises a plan is part of the chain — so if `from` were locked at creation like the rest of attribution, the derived lineage would stop at the first session. So the immutability rule splits: the event sub-keys (`when`/`channel`/`agent`/`why`) stay write-once, while `from` grows as later sessions' `/create-pull-request` stamps them. And "ASAP" has a hard dependency: derivation can only ship after the governance backfill populates `from` across the existing chain — so it slots in right after backfill in the build order, with the backfill diff doubling as the check that derived lineage matches the existing hand-kept blocks. Updating the plan now:

---

**[`em:f97e44`]**  (co-feeds: `/meta/plans/resource-attribution-property.md em:f8ae3a`)

All five decisions are recorded and the plan is now `status: accepted` — pushed as `e615742`, gates green, and the index entry moved into "Accepted / In progress" (its first occupant).

How each answer landed in the spec:

1. **Scope: all bundle concepts** — the capture-type carve-out question is closed.
2. **Presence: verifier-mandatory after backfill** — for both the bundle-concept rule and the governance `from` rule.
3. **`agent` = pathway** — locked in as the ratified convention.
4. **`auto-intake` tag retires immediately** — no transition window. The skill stops writing it in build step 3, the backfill converts existing tags to `channel: auto-intake`, and until the query task ships the editorial pass greps the channel instead.
5. **Lineage derives from `from`** — with the two consequences I flagged folded in: semantics rule 1 now splits immutability (event sub-keys write-once; governance `from` append-only, since feature lineage accretes across sessions), and derivation is sequenced as build step 5, immediately after the governance backfill that populates `from` — the backfill diff doubles as the migration check that derived chains reproduce today's hand-kept `lineage:` blocks before those get deleted. A pleasant side effect: `mix brain.lineage` becomes the first machine consumer of `from`, which is what earns the typed edge under the bundle's own rule — so I also promoted `mix brain.attribution` from optional to build step 6, since the traversal code will already exist.

The build order now reads: policy + contract render → verifier shape rules → skill writers (including `/create-pull-request` stamping, tag and `thread:` retirement) → backfill + flip mandatory → lineage rewire → query surface. The spec phase is complete; say the word when you want execution to start (step 1, the policy doc + `/render-contract`, is a natural first slice), and `/create-pull-request` whenever you want this session's work captured and opened as a PR.
