---
id: em:0c8532
type: concept
title: graduation
description: A document or work item earning promotion up a level — a glossary term relocating into the domain taxonomy (sense 1), a grounded claim becoming a concept (sense 2), or a deferred strand or analysis residue becoming a plan (sense 3).
provenance: "Agent-distilled glossary definition; coined by the /add-to-glossary skill"
verified: false
tags: [glossary, taxonomy, lifecycle]
sense: repo
timestamp: 2026-07-21
attribution:
  when: 2026-07-10T23:09:18+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# graduation

A document earning promotion up a level once it has been earned. Two senses:

1. **Glossary term → taxonomy.** A glossary term that has outgrown its entry —
   accumulating senses, claims, or citations that belong in the domain tree —
   relocates into the taxonomy (e.g. `/knowledge/SWE/…`): the file moves, its
   stable id travels with it, and a
   [pointer entry](/beliefs/glossary/pointer-entry.md) stub stays behind in
   `/beliefs/glossary/` linking to the new home. The glossary is a staging
   layer, not a terminal home. Defined by the
   [`/add-to-glossary` skill](/.claude/skills/add-to-glossary/SKILL.md).
2. **Claim → concept.** A [`claim`](/beliefs/glossary/statement-type.md) that
   has been grounded via `verified_by` against evidence "may graduate to
   `concept`" per the
   [verification-grounding policy](/meta/policy/verification-grounding.md) — the
   asserted-but-unchecked statement becoming an accepted one. (What a
   proposition-shaped `concept` then *is*, versus a verified claim, is an open
   question — see the
   [concept-terminology plan](/meta/plans/concept-terminology-and-type-redefinition.md).)
3. **Strand → plan.** Deferred work living only as a paused
   [routing-ledger](/beliefs/glossary/routing-ledger.md)
   [strand](/beliefs/glossary/strand.md) (or as an analysis's "if commissioned"
   residue) is promoted into a `type: plan` doc once the operator commissions
   it — a *new* plan citing its source as decision record, never a retype of
   the source. The promotion is what resolves the dangling strand.

*Seen in:* [2026-07-16 harness-plan graduation thread](/meta/threads/2026-07-16-graduate-swarm-eval-harness-plan.md) (sense 3: the swarm-eval harness strand → the [harness plan](/meta/plans/inkling-beam-swarm-eval-harness.md)), [2026-07-15 concept→document replication thread](/meta/threads/2026-07-15-replicate-concept-document-terminology-from-pr-71.md), [2026-07-10 add-to-glossary thread](/meta/threads/2026-07-10-add-to-glossary-skill-and-pr-wiring.md), [2026-07-05 OKF bootstrap thread](/meta/threads/2026-07-05-greenfield-okf-bootstrap-and-verification-layer.md), [2026-07-09 flows-genre thread](/meta/threads/2026-07-09-flows-genre-and-scenario-testing.md), [2026-07-09 news-inbox thread](/meta/threads/2026-07-09-home-page-news-filter-inbox.md), [2026-07-09 testing-methodology thread](/meta/threads/2026-07-09-testing-methodology-types-and-cb-epistemic-overlay.md), [2026-07-21 multi-model dev environment thread](/meta/threads/2026-07-21-multi-model-dev-environment-and-cross-model-pr-review.md) (the graduation criterion as role-not-size: a term graduates when it stops being a lookup and becomes a subject that wants sections)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:0c8532">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-21-multi-model-dev-environment-and-cross-model-pr-review (2026-07-21)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:0c8532`]**

**Should any tree concepts fold into the glossary?** No — for these, and rarely in general. Two reasons: (1) the tree *is* the taxonomy — a domain concept belongs in its branch, related to its siblings; folding it into the flat glossary would strip it of its taxonomic home. (2) When a tree concept is *also* a term you want to link by name, the tool is a glossary **pointer**, not relocation — you get linkability without duplication or displacement. The only real fold-in candidate would be a tree doc that's a *bare cross-cutting term-definition with no domain-node role* — misfiled vocabulary. None of the six qualify; the most instructive is `git-local-branches-dont-auto-advance-on-fetch` (31 lines, `verified: true`): short, but it's a **verified proposition**, not a term — the glossary holds terms you look up, not claims.

**What determines graduation:** the discriminator is **role, not size**. A glossary entry answers "what does this word *mean*?" (a cross-cutting term you look up, a 1–3 sentence definition + citations); a tree concept answers "tell me *about* X" (a subject you study, a node in a domain, with mechanism/senses/claims/sections). A term **graduates** (glossary → tree) when it stops being a lookup and becomes a subject — concretely, when it accumulates **verified claims** (`verified_by` evidence), grows **multiple senses or real exposition** that want headings, becomes a **hub** other terms point at, and has a **natural taxonomic home**. The tell-tale sign: the entry *wants sections*. Move the file into the tree (its `em:` id travels), leave a pointer stub, and the two homes stay in sync rather than competing.
