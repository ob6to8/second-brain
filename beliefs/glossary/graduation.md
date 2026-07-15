---
id: em:0c8532
type: concept
title: graduation
description: A document earning promotion up a level — a glossary term relocating into the domain taxonomy (sense 1), or a grounded claim becoming a concept (sense 2).
provenance: "Agent-distilled glossary definition; coined by the /add-to-glossary skill"
verified: false
tags: [glossary, taxonomy, lifecycle]
sense: repo
timestamp: 2026-07-15
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

*Seen in:* [2026-07-10 add-to-glossary thread](/meta/threads/2026-07-10-add-to-glossary-skill-and-pr-wiring.md), [2026-07-05 OKF bootstrap thread](/meta/threads/2026-07-05-greenfield-okf-bootstrap-and-verification-layer.md), [2026-07-09 flows-genre thread](/meta/threads/2026-07-09-flows-genre-and-scenario-testing.md), [2026-07-09 news-inbox thread](/meta/threads/2026-07-09-home-page-news-filter-inbox.md), [2026-07-09 testing-methodology thread](/meta/threads/2026-07-09-testing-methodology-types-and-cb-epistemic-overlay.md)
