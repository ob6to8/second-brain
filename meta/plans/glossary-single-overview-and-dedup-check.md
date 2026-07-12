---
type: plan
title: "Glossary: single canonical overview per term, dedup'd bodies, and a mechanical check"
description: Make each glossary entry's `description` the one canonical overview — shown verbatim as the index gloss and the entry lede — rewrite bodies to expansion-only, and enforce both halves with a new `mix brain.glossary` verifier.
status: done
provenance: "Operator request, 2026-07-12 session (glossary dedup + enforceable check)"
tags: [glossary, verification, tooling, dedup]
timestamp: 2026-07-12
---

# Glossary: single canonical overview per term, dedup'd bodies, and a mechanical check

## Problem

A glossary term's overview existed in **three** hand-maintained variants that
drifted independently:

1. the `description` frontmatter, rendered as the entry page's lede paragraph
   by the site generator;
2. the entry body's first paragraph, which typically *restated* the same
   definition in slightly different words (the operator's actor-model
   screenshot: two near-identical definition paragraphs stacked on one page);
3. the hand-written one-line gloss in `beliefs/glossary/index.md` — a third
   paraphrase, and the one the site's Terms list actually shows.

The operator's direction: the Terms-list overview must be the entry page's
first overview paragraph **verbatim**, and the rest of each entry must not
repeat what that paragraph already said — expansion and new information only.
And the convention should be *enforceable*, not prose guidance.

## Decisions

- **The `description` is the single canonical overview.** It is already what
  the entry page renders first (the lede), so it becomes the one source of
  truth. The index gloss is derived from it, never hand-written.
- **The index Terms section is materialized, not maintained.**
  `mix brain.glossary --materialize` regenerates `beliefs/glossary/index.md`'s
  `## Terms` section from the term files' `title` + `description`, sorted
  case-insensitively — the same generated-artifact pattern as `CLAUDE.md`, the
  registry, and the route-tag excerpt logs. The verbatim-sync requirement
  stops being procedural discipline and becomes structural.
- **Bodies are expansion-only.** Everything between the `# term` heading and
  the *Seen in:* line must add material the description doesn't already carry:
  mechanism, consequences, examples, distinctions, senses, cross-links. All
  148 entries were rewritten to this shape in the same change; links that
  lived only in redundant sentences were rewoven, never dropped. Generated
  `## Thread excerpts — route-tagged log` sections are untouched (they quote
  frozen threads and are owned by `mix brain.route_tags`).
- **Enforcement is split by what has a mechanical oracle**, mirroring the
  route-tagging precedent (mechanical → fail, editorial → warn):
  - **Fail:** a term file missing a non-empty `description`; the index
    `## Terms` section diverging from its re-derivation (order, coverage, or
    gloss text).
  - **Fail:** a body sentence that is a *near-restatement* of the description —
    detected by normalized content-word containment (lowercase, punctuation
    stripped, stopwords dropped, naive plural stemming; sentences under 8
    content words skipped) at or above a high threshold. High containment of a
    full sentence's vocabulary inside the description is mechanical enough to
    gate on: it catches the stacked-definition failure mode with a wide margin
    over legitimate expansion prose (calibrated against the rewritten corpus
    and the pre-rewrite corpus, which it flags extensively).
  - **Warn:** moderate containment — real semantic redundancy judgment stays
    editorial, so the middle band reports without failing, like the
    routing-ledger coverage warning.
- **Placement:** `SecondBrain.Glossary` + `mix brain.glossary`, run in CI
  (`ci.yml`) and in the Pages deploy gate (`pages.yml`) beside
  `mix brain.verify` and `mix brain.route_tags`. The `/add-to-glossary` skill
  codifies the authoring-side convention and runs `--materialize` in its
  maintain-and-verify step.

## Non-goals / limits

- The heuristic is deliberately *not* a semantic-equivalence oracle. A
  paraphrase that shares little vocabulary with the description will pass
  mechanically; catching it stays an editorial judgment (the warn band and
  review). The check makes the common failure mode — restating the definition
  in nearby words — impossible to land silently, which is the enforceable
  core of the convention.
- Pointer entries keep their shape: the body's link to the canonical defining
  doc is dispatch, not repetition.
