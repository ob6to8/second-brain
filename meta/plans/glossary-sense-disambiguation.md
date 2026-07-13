---
type: plan
title: "Glossary sense disambiguation: common vs. repo-specific usage"
description: Classify every glossary term by where its usage lives — common (portable), repo (this brain's own vocabulary), or dual (both senses) — via a `sense` frontmatter field, a dual-entry body convention, a verifier rule, and the /add-to-glossary conventions to keep it current.
status: done
provenance: "Claude Code session, 2026-07-13 — operator proposed disambiguating glossary usages between common and repo-specific; ratified and implemented same session"
tags: [meta, plan, glossary, terminology, verification]
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T09:22:33+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-13-glossary-sense-disambiguation.md]
---

# Glossary sense disambiguation: common vs. repo-specific usage

## Status & provenance

**Done** — proposed by the operator on 2026-07-13 ("look into disambiguating
usages between common and repo specific — some glossary entries may have both"),
ratified in the same session, and implemented immediately: every glossary entry
classified, the dual-sense bodies restructured, the verifier rule and its tests
added, and the `/add-to-glossary` skill updated. Filed as the durable decision
record per the persist-plans policy.

## Problem

The glossary (~148 terms under [`/beliefs/glossary/`](/beliefs/glossary/index.md)) mixes
three populations without marking them:

- **Purely common terms** (`BM25`, `embeddings`, `CRLF`, `actor model`) —
  portable knowledge that means the same thing outside this repository.
- **Purely repo-specific terms** (`route tag`, `routing ledger`, `feeding
  pairs`) — this brain's own vocabulary: coined here or naming local machinery.
- **Dual-sense terms** (`materialize`, `deduplication`, `digest`, `sink`) — a
  common technical term this brain has *additionally* narrowed to a specific
  local referent.

Nothing distinguished them. The risks: the local sense silently overwrites the
common one (the entry for *sink* becomes useless for reading an external
dataflow paper); `/add-to-glossary` merges have no guidance when a new source
uses a term in its common sense (does the citation extend the local definition
or contaminate it?); and there is no way to query "which terms in this repo
mean something non-standard?" — exactly what an agent or reader priming
themselves on local jargon wants.

A de facto convention already existed — several entries open with the general
meaning and pivot on "In this brain …" — but it was applied inconsistently and
carried no machine-readable marker.

## Decisions

1. **One file per term stays.** Dual-sense terms are *not* split into two
   files: splitting fragments (against update-in-place), mints two ids for one
   string, and makes `[materialize](…)` links ambiguous.
2. **A `sense` frontmatter field on every glossary term file**, controlled
   vocabulary of three values:
   - `common` — the usage is portable: the term is used this way in the wider
     world (industry, a field, or an ecosystem such as Claude Code, Elixir,
     git, or ML — folding *ecosystem* into *common* was an explicit call: what
     matters to a reader is whether the meaning survives outside this repo).
   - `repo` — the usage lives only in this brain's world: coined here
     (operator or agent), or naming this brain's machinery, genres, or rules —
     even when the definition is written portably.
   - `dual` — both senses exist *and both are worth defining*: an established
     common technical sense plus a specific repo referent. The everyday
     English meaning of a word (e.g. *graduation*) does not make a repo term
     dual; only a technical common sense does.
3. **Dual-entry body convention**: the common sense is defined first, then the
   repo-specific sense in a clearly marked passage beginning **In this
   brain/bundle:** — common first, so the portable meaning is never displaced.
   Title qualification (e.g. "run (canonical run)", "sink (route-tag sink)")
   remains the disambiguator *between separate entries*; `sense: dual` is the
   disambiguator *within one*.
4. **Machine enforcement**: `mix brain.verify` rule 7 — every bundle concept
   under `beliefs/glossary/` must carry `sense` with one of the three values.
   Presence is required (not optional) so every future entry gets classified
   at write time; the field is not policed outside the glossary (a graduated
   term may keep or drop it).
5. **`/add-to-glossary` owns the convention going forward**: the skill's
   define/merge steps now classify each term's sense, prescribe the dual body
   shape, and direct sense-aware merging (a common-sense citation on a `dual`
   term extends the common paragraph, not the repo one).

## Classification principles applied

Editorial calls made during the initial pass, recorded so future
classification stays consistent:

- Coined-here-but-portable terms (`cognitive debt`, `deterministic spine`,
  `drift class`, `two-plane rule`) are `repo`: the classification tracks where
  the *usage* lives, not whether the idea generalizes.
- Field-survey failure-mode vocabulary that arrived from external material and
  reads as field usage (`cross-reference drift`, `invisible degradation`,
  `epistemic poisoning`, `probabilistic enforcement`) is `common`.
- Ecosystem terms (`Routine`, `SessionStart hook`, `skill`, `plugin`, `Jido`,
  `Claude Managed Agents`) are `common` (see decision 2).
- Controlled-type pointer entries (`plan (type)`, `issue (type)`, …) are
  `repo` — already title-qualified, no dual needed.
- The initial `dual` set (10): `deduplication`, `digest`, `doctrine`,
  `lineage`, `materialize`, `orphaned branch`, `provenance`,
  `sink (route-tag sink)`, `run (canonical run)`, `typed edge`.

## Build order (as executed)

1. This plan doc (persist before acting).
2. Tooling: `Registry.Entry` gains a `sense` field; `Verifier` rule 7 with
   red + green tests.
3. Classification pass: `sense` inserted into all term files' frontmatter
   (scripted, mapping reviewed by hand). Timestamps bumped only where the body
   changed.
4. Dual bodies restructured to the common-first convention.
5. `/add-to-glossary` skill + glossary hub + glossary index updated.
6. Full gate suite, commit, push.

## Deferred

- **Index badging** — annotating `/beliefs/glossary/index.md` lines with the sense
  (e.g. a `(repo)` marker). The field makes this derivable; deferred until the
  index's readability is revisited.
- **A `sense` column in the compiled registry** — same reasoning; the
  registry render stays untouched for now.
