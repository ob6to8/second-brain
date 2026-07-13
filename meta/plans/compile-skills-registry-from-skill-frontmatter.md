---
type: plan
title: "Compile the contract's Skills section from SKILL.md frontmatter"
description: Invert the skills-registry drift by making each .claude/skills/*/SKILL.md's own frontmatter the source of truth for the contract's Skills section — the compiler scans the skills and renders §7 with the usual --check drift gate, retiring the hand-maintained duplicate list in the skills-registry policy.
status: proposed
priority: 1
provenance: "Claude Code session (2026-07-11) — commissioned by the operator following the contracts-and-rendered-aggregations analysis; marked top priority at commissioning"
tags: [meta, plan, contract, skills, compiler, drift, tooling]
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T20:01:40+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-12-beam-jido-evaluation-and-dark-factory-scenario.md]
---

# Compile the contract's Skills section from SKILL.md frontmatter

## Status & provenance

**Proposed — operator-designated top priority** at commissioning (2026-07-11).
The operator ratified a session-init priority override as **build-order step
1**; a parallel session built the same mechanism the same day (`62d9327`, PR
#45) as an **integer** `priority:` frontmatter key that outranks the status
heuristic — so this plan carries `priority: 1` and step 1 is already
satisfied. Executes the skills-direction recommendation of
[the contracts-and-rendered-aggregations analysis](/meta/analysis/contracts-and-rendered-aggregations.md).

## 1. The problem

The contract's Skills section (§7) is today rendered from
[`meta/policy/skills-registry.md`](/meta/policy/skills-registry.md) — a
**hand-maintained duplicate** of information each skill already declares about
itself: every `.claude/skills/<name>/SKILL.md` carries `name` and `description`
frontmatter that the Claude Code harness treats as authoritative. Two
representations of the same truth is exactly the drift class the contract
compiler exists to kill, and it bit twice on 2026-07-11 alone: the
`/render-contract` skill's hardcoded section list had silently gone stale, and
every skill addition (most recently `/todo`, PR #33) obligates a parallel
manual edit to the skills-registry policy that nothing checks.

The fix is *not* to compile skills from the bundle (a skill's `SKILL.md` **is**
its source of truth — compiling it would create dual homes); it is to run the
compile the other way: **skills as sources, the contract's §7 as the derived
view**, same as `meta/registry.md` is derived from per-file ids.

## 2. The shape of the change

- **A skills scanner** (`SecondBrain.Skills` or similar): enumerate
  `.claude/skills/*/SKILL.md`, parse each frontmatter's `name` + `description`
  (reusing `SecondBrain.Frontmatter`), error on a missing/empty pair.
- **Render §7 from the scan.** `mix brain.contract` composes the Skills section
  as one generated bullet per skill (`**/<name>** — <description> See
  .claude/skills/<name>/SKILL.md.`) plus the standing trailer ("New skills are
  added under…").
- **The drift gate is free**: `mix brain.contract --check` already byte-diffs
  the whole artifact, so a new/renamed/edited skill that isn't recompiled fails
  CI with no new tooling.
- **The skills-registry policy shrinks or retires** (see Q1/Q2) — it stops
  being a hand-kept list.

## 3. Open questions (operator input wanted)

- **Q1 — What survives of the curated §7 prose?** Some current annotations
  exceed any skill's `description` (e.g. `/intake` "is the primary way
  knowledge enters the brain", `/capture`'s cross-references). Options: (a) a
  `contract_note:` frontmatter key in `SKILL.md` for contract-only prose; (b) a
  short hand-written preface kept in the wrapper policy, with the per-skill
  list fully generated; (c) drop the annotations — descriptions must carry the
  weight. Leaning: (b) — smallest mechanism, keeps curated framing.
- **Q2 — Wrapper policy or native section?** (a) Keep
  `meta/policy/skills-registry.md` as a thin wrapper that owns
  `section`/`order` and the preface, with the compiler injecting the generated
  list into its body; (b) retire it and special-case the `skills` section in
  `contract.ex`. Leaning: (a) — preserves "every section renders from a
  policy" uniformity and the per-rule trace link.
- **Q3 — Ordering.** Alphabetical by name, or a curated order (intake-first)?
  Leaning: alphabetical with `/intake` pinned first via the preface prose, not
  the list order.
- **Q4 — Scope.** Directory-scoped/plugin skills, if they ever appear, are out
  of scope for the first cut.

## 4. Build order

1. ~~Teach the session-init digest to respect a priority override~~ —
   **already built** (ratified here 2026-07-11; independently implemented the
   same day on `main` by PR #45, `62d9327`): `SecondBrain.SessionInit` reads
   an integer `priority:` frontmatter key on issues/todos/plans and ranks
   flagged items ahead of the status heuristic (lower = higher). This plan
   carries `priority: 1` accordingly. Nothing left to build.
2. Scanner module + unit tests (missing frontmatter is a compile error).
3. Wire into `Contract.render/1` per the Q1/Q2 decisions; regenerate.
4. Extend
   [`contract_scenario_test.exs`](/test/second_brain/contract_scenario_test.exs):
   a fixture skill appears in the render; deleting it without recompiling
   fails `check/1`.
5. Update the connective layer in the same motion: the
   [render-contract flow doc](/meta/flows/render-contract.md) touch-sequence,
   the [`/render-contract` skill](/.claude/skills/render-contract/SKILL.md),
   and the skills-registry policy per Q2.

## Deferred

- Generalizing the scan to other harness mounting points (hooks, commands) —
  no observed drift there yet; revisit if it bites.
