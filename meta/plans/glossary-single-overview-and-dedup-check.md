---
type: plan
title: "Glossary single canonical overview, expansion-only bodies, and the mix brain.glossary check"
description: Make each glossary term's description the one canonical overview (rendered as the entry-page lede and shown verbatim as the index gloss), rewrite every entry body to expansion-only, and enforce both with a new mix brain.glossary verifier — recreated against current main from the superseded PR #64.
status: accepted
provenance: "Claude Code session, 2026-07-15 — recreated from PR #64 (built on the pre-rename sb: corpus) as spec, rebuilt against current main"
tags: [meta, plan, glossary, verification, dedup, tooling]
timestamp: 2026-07-15
attribution:
  when: 2026-07-15T00:00:00Z
  channel: agent-authored
  agent: "Claude Code agent, in-session authoring"
  why: "authored at operator request to recreate PR #64's glossary work on a fresh branch off main rather than resolve its conflicts"
  from: [/meta/threads/2026-07-16-recreate-pr-64-glossary-single-overview-and-check.md]
---

# Glossary single canonical overview, expansion-only bodies, and the mix brain.glossary check

## Status & provenance

`status: accepted`. This plan **recreates the work of PR #64**
(`claude/glossary-dedup-check-kuvgpg`), which was left `mergeable_state: dirty`
and is superseded rather than merged. PR #64 was built on base `e92fa5e`, **121
commits behind main and before the bundle-wide `sb:` → `em:` rename** (PR #92,
`second-brain` → `elixir-mind`, `SecondBrain.*` → `ElixirMind.*`,
`lib/second_brain/` → `lib/elixir_mind/`). Since that base the glossary grew
from **148 → 234 terms** and every term file gained an `attribution` block and a
`sense` field, so the PR's 170-file diff conflicts on essentially every file and
its new module/thread use retired `sb:` ids and `SecondBrain.*` names. The
decision (operator-ratified this session) is to **use PR #64 as the spec** and
rebuild against current main, not to reconcile the diff.

## The problem

Each glossary term carried its overview in **three independently drifting
places**:

1. the `description` frontmatter, rendered by the site as the entry page's lede;
2. a body paragraph that re-stated that definition (stacking a second definition
   directly under the lede — visible on the operator's `actor-model` screenshot);
3. a **hand-written** abbreviated gloss in `beliefs/glossary/index.md`'s
   `## Terms` list.

Three copies of one overview, maintained by hand, drift apart. Prose guidance
("don't repeat the description") is unenforceable and had already rotted.

## The decisions

- **One canonical overview = the `description`.** It is the single source of the
  term's overview: rendered as the entry-page lede (already true) and shown
  **verbatim** as the index `## Terms` gloss (new — replaces the hand-written
  abbreviations).
- **Bodies are expansion-only.** A body adds only what the description does not
  already say — mechanism, consequences, examples, senses, distinctions,
  cross-links. A body with nothing non-redundant to add is left **empty**
  (heading + *Seen in:*), honest emptiness over filler. Links that lived in
  removed sentences are re-woven into the surviving prose, never dropped.
  *Seen in:* / *See also:* citation lines and generated excerpt logs are left
  untouched.
- **Enforce both halves mechanically**, splitting by what has a deterministic
  oracle (the same pattern as `mix brain.route_tags`):
  - *Deterministic half* — `mix brain.glossary --materialize` regenerates the
    index `## Terms` section from the term files (title-sorted case-insensitively,
    gloss = `description` verbatim); the plain check **fails** if the committed
    index diverges from that re-derivation, or if any term lacks a `description`.
  - *Heuristic half* — for each body sentence (citations and generated sections
    excluded; sentences under 8 content words skipped): normalize (lowercase,
    strip punctuation and link URLs, drop stopwords, naive plural stemming) and
    measure **content-word containment** against the description. **Fail** at or
    above the fail threshold (a near-restatement); **warn** in the band below it
    (editorial, never gates).
- **Honest limit.** Vocabulary containment is not meaning: a paraphrase that
  shares meaning but little vocabulary evades it. What the check makes impossible
  is the failure mode that actually occurred — re-defining the term in nearby
  words. The editorial bar stays above the mechanical floor.

## Artifact shape

- `lib/elixir_mind/glossary.ex` — `ElixirMind.Glossary`: `run_checks/1`
  (`descriptions`, `index sync`, `repetition`), `materialize/1`, ported from
  PR #64's `SecondBrain.Glossary` and renamed.
- `lib/mix/tasks/brain.glossary.ex` — `mix brain.glossary` / `--materialize`,
  modeled on `brain.route_tags`.
- `test/elixir_mind/glossary_test.exs` — scenario tests over each check.
- All 234 entry bodies rewritten to expansion-only.
- `beliefs/glossary/index.md` `## Terms` materialized.
- Wiring: `ci.yml`, `pages.yml` (deploy gate), `.githooks/pre-commit`.
- Docs: the `/add-to-glossary` skill and the glossary hub
  (`beliefs/glossary.md`) codify the convention.

## Calibration

Thresholds (`fail ≥ 0.72`, `warn ≥ 0.55`, 8-content-word floor) are kept from
PR #64 but **re-measured against the current 234-term corpus** (its "88 / 0"
numbers are for the old 148-term corpus):

- **Baseline:** 107 failing sentences across 103 of 234 files, plus the index
  `## Terms` diverging from its re-derivation (hand-written abbreviations).
  Descriptions all present.
- **Pass 1** (fan-out over the 103 fail files → expansion-only bodies): 102
  rewritten, 1 emptied (`deploy-gating`), 0 fails remaining after one manual
  fix (`agent-time-horizon`). Warn band then stood at 71 sentences across 69
  files — mostly entries the fail-pass never touched.
- **Pass 2** (fan-out over the 69 warn files, tighten genuine restatement only,
  leave legitimate expansion): 52 tightened, 17 kept as legitimate expansion; 1
  over-tighten regressed to a fail (`factscore`) and was fixed by hand.
- **Result:** **0 fails**, index in sync, **25 warn-band sentences** remaining
  — the residue of legitimate expansion prose that shares domain vocabulary
  with its description (the warn band's designed purpose). Full link audit
  across all 155 changed term files: **0 links lost**; no frontmatter or
  citation lines altered by the rewrites.

The honest limit stands: the warn band is not driven to 0 because doing so would
mean padding or distorting sound prose to dodge a vocabulary heuristic. The fail
band — the real failure mode (re-defining the term in nearby words) — is fully
closed.

## Build order

1. Reset the branch onto `origin/main` (done).
2. Persist this plan (this doc).
3. Port the verifier module + mix task.
4. Calibrate thresholds against the current corpus (pre-rewrite baseline).
5. Rewrite all 234 bodies to expansion-only (fan-out workflow, verified against
   the check, failures looped).
6. Materialize the index; wire CI / pages / pre-commit; update the skill + hub.
7. Add scenario tests; run the full gate suite green.

## Deferred

None — the flow doc PR #64 also added (`meta/flows/glossary-single-overview-check.md`)
is folded into this plan's build order rather than recreated separately, since
the `meta/flows/` lineage machinery has itself changed since PR #64 (`lineage`
is now derived from `attribution.from`). A flow doc can be added later if the
operator wants one.
