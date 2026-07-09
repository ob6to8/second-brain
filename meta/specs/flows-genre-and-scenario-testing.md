---
type: spec
title: The flows genre + formal scenario testing
description: Collapse the capture flow's three overlapping prose docs into one meta/flows/ doc, back it with an ExUnit scenario test over the deterministic tool spine (structured + targeted assertions, in-code fixtures), and keep the skill as the terse agent procedure — with the harness research spike that corrected the testing approach folded in.
status: approved
tags: [meta, governance, flows, scenario-testing, elixir, testing, spec]
timestamp: 2026-07-09
---

# Spec — the `flows` genre + formal scenario testing

**Status:** approved and **built** (2026-07-09) per §9. `meta/flows/` genre
created; both planned flows landed with their scenario tests — `session-capture`
(collapsing `session-workflow.md` + `verification-flows/`) and `intake`. The
genre's planned scope is complete; further flows (e.g. the contract-render or
site-build pipelines) are additive follow-ups, not part of this spec.
**Branch of record:** `claude/flows-paths-documentation-b6mzee`.
**Decisions:** capture-first collapse · scenario tests over the deterministic
spine · **in-code fixtures + structured/targeted assertions** (not on-disk
whole-tree golden — corrected by the research spike, §8) · `steps.md` as human
documentation in the flow doc (not machine-parsed) · eval layer deferred (§7).

---

## 1. Problem & thesis

The brain currently traces one flow (`/capture`) across **three** overlapping
prose docs plus a hidden test fixture:

- `meta/session-workflow.md` — the "why + connective runbook" *(now collapsed
  into [`meta/flows/session-capture.md`](/meta/flows/session-capture.md))*.
- `meta/verification-flows/session-capture-routing-route-tags.md` — the
  "did-it-work?" checklist, which named a **live** thread↔concept pair
  (`2026-07-08…` ↔ `sb:d479e3`) as "the green example to diff against" *(also
  collapsed into the flow doc; the scenario test is now the canonical green
  example)*.
- [`.claude/skills/capture/SKILL.md`](/.claude/skills/capture/SKILL.md) — the
  agent's procedure.
- `test/second_brain/route_tags_test.exs` — a `green_fixture` mini-bundle run
  through `RouteTags.run_checks/1`, with one red test per failure mode. **This is
  already a scenario test**, just written as in-code heredocs, scoped to one
  module, and invisible to the prose.

**Thesis:** collapse the prose trilogy into one **flow doc**, back the flow with a
first-class **scenario** the flow doc narrates, and keep the **skill** as the
terse agent procedure. Three artifacts per flow, one concern each, no overlap.

### What formalizing actually buys (the corrected justification)

The original justification was "only a byte-exact golden fixture catches a
wrong-but-internally-consistent transform." The research spike (§8) sharpened
this. The *need* is real but the *mechanism* was over-built:

- **The need.** The live `log fidelity` check compares a sink's stored log to its
  re-derivation *from the current tags* — both sides run the current transform, so
  a change to the transform itself (header demotion, multi-ref lifting, block
  ordering) moves both sides together and the check stays green. Self-consistency
  cannot pin the transform's output to a known-good baseline.
- **The right mechanism.** A **targeted assertion on the materialized output**
  against an expected string the change would have to consciously update — done
  **in-code** (a heredoc), not as an on-disk whole-`expected/`-tree snapshot. This
  pins the transform, closes the gap the existing status-only assertions leave
  open, and keeps the repo's established in-code fixture idiom. Whole-tree golden
  is reserved for large opaque renders only (§4).

---

## 2. The formalizability boundary (honest)

A flow has two layers; only one is deterministically testable.

| Layer | Example (capture) | Formalizable? | Routes to |
|-------|-------------------|---------------|-----------|
| **Deterministic spine** — `mix brain.*` transforms + checks | `--materialize` writes logs; the 5 checks; registry/verify chaining | **Fully** — ExUnit over the tool functions | scenario |
| **Agent judgment** — LLM distillation & selection | "distill don't dump"; which paragraphs to tag; routing target | **No** — non-deterministic, needs an LLM+judge eval | skill (procedure) + flow doc (narrated boundary); phase-2 eval |

Forcing the judgment layer into a deterministic test is the trap. Each layer
routes to the artifact that can hold it. The eval over the judgment layer is
**deferred, not skipped** (§7).

---

## 3. The three-artifact model

Per flow, three artifacts, zero overlap:

| Doc | Audience | Holds | Must NOT hold |
|-----|----------|-------|---------------|
| **Skill** `.claude/skills/<f>/SKILL.md` | agent, at run time | terse imperative procedure incl. judgment steps | the why; verification detail; narrative |
| **Scenario** `test/second_brain/<f>_scenario_test.exs` | CI | ExUnit over the deterministic spine — structured + targeted assertions | prose; anything non-deterministic |
| **Flow doc** `meta/flows/<f>.md` | operator + agent (comprehension) | touch-sequence narrative, the why, actor boundaries, the human-readable step table, pointers to skill + scenario | restating skill steps or duplicating tool logic |

The flow doc **supersedes** `meta/session-workflow.md` and
`meta/verification-flows/`: both fold in, their "did-it-work" checklist becoming
"here's the scenario CI runs + the editorial spot-checks the machine can't judge".

---

## 4. Scenario artifact — plain ExUnit over the tool spine

Per the spike (§8), reuse the repo's established pattern rather than inventing a
new one.

- **Runner:** a plain ExUnit case per flow (`@tag :tmp_dir`), no bespoke DSL, no
  new mix task. `mix test` already discovers it, runs async, and isolates it.
- **Fixtures: in-code** (heredoc `write_thread` / `write_concept` helpers, as
  `route_tags_test.exs` already does), so each scenario reads in one place. Reach
  for on-disk `before/` files only for a fixture too bulky to inline.
- **Primary oracle: structured + targeted assertions.** Assert `run_checks/1`
  statuses (`:ok`/`:warn`/`:fail`), assert `materialize/1`'s returned change-set,
  and assert the **materialized log block equals its expected content** (the
  transform-pinning assertion from §1) — plus a few load-bearing substrings.
- **Whole-file golden: narrow and dependency-free.** Only for large opaque
  renders (the `Site` HTML/Markdown), compare per file (path in the assertion
  message), **normalize volatile output first** (dates → a fixed token, absolute
  `tmp_dir` paths → a placeholder), and gate regeneration behind an env flag:
  `if System.get_env("UPDATE_GOLDEN"), do: File.write!(expected, got), else: assert got == expected`.
  This is the dep-free stand-in for `mneme`/`assert_value` (both hex deps, ruled
  out by `deps: []`).
- **Keep the live-bundle guard.** A test that runs `run_checks(".")` and asserts
  zero failures — cheapest, highest-value check, no fixtures.

### The touch-sequence lives in the flow doc, as prose

`steps.md` is **not** a machine-parsed artifact (that would be the bespoke DSL the
design rejects). The ordered step list — actor `{operator|agent|tool}`, action,
files touched — is a **table in the flow doc**, human-maintained, that the
narrative walks through. No cross-check task is needed; coverage of the table
stays editorial, like tag coverage.

### Fixture location is safe as-is

`test` is in `Registry`'s `@excluded_dirs`; the verifier scans via
`Registry.scan`; `route_tags` reads threads only from `meta/threads/` and sinks
from the registry. So anything under `test/` is invisible to all three scanners —
**no exclusion changes needed** (see the
[three bundle scanners](/meta/tutorials/the-three-bundle-scanners.md) tutorial).

---

## 5. First target: capture (a collapse, not an addition)

Capture is the ideal proof because it already has the three overlapping docs and
the richest deterministic spine (route_tags). Doing it first **demonstrates the
3→1 collapse** rather than greenfielding, and reuses the existing `green_fixture`
as the seed of the scenario.

Resulting artifacts:

- `meta/flows/index.md` — genre definition + contents (new).
- `meta/flows/session-capture.md` — the flow doc: absorbs `session-workflow.md`
  (why/pipeline/data-model) + the verification-flow (who-does-what, gates,
  editorial spot-checks), with the human-readable step table and a pointer to the
  scenario as its reference instance.
- `test/second_brain/capture_scenario_test.exs` — ExUnit scenario: `materialize`
  writes the expected log block (asserted content), the 5 checks green, and the
  transform edge cases (multi-ref lift, ATX→bold demotion, dated-block ordering).
- **Removals:** `meta/session-workflow.md` and `meta/verification-flows/` (dir +
  doc + index). Redirect inbound links.

`/intake` is the **second** target once the genre shape is proven — a follow-up,
not this change.

---

## 6. Migration & wiring

- **Inbound links.** `meta/index.md` lists both `session-workflow.md` and
  `verification-flows`; repoint to `meta/flows/`. Grep the bundle for links to the
  two removed paths and fix each.
- **`meta/index.md`** — add a `flows` row, drop the two removed rows.
- **`meta/log.md`** — dated entry recording the genre addition and the collapse.
- **`meta/flows/index.md`** — defines the genre against the others (policy = rules
  · tutorials = why · specs = plans for changes · threads = archive · flows = the
  touch-sequence of a canonical run, narrating a CI-checked scenario).
- **Shape change?** A new `meta/` genre is governance namespace, not the knowledge
  taxonomy; operator approval of this spec is the ratification. No new `type` for
  flow docs (they reuse `type: note`, as the current session-workflow/verification
  docs do). (`type: spec` for *this* doc's genre was ratified separately.)
- **CI.** The new ExUnit case is picked up by the existing `mix test` step — no
  workflow edit, no new mix task.
- **Skill.** `.claude/skills/capture/SKILL.md` stays; trim any narrative that now
  lives in the flow doc so the skill is purely the procedure. Point its "see also"
  at `meta/flows/session-capture.md`.

---

## 7. Deferred: the eval layer (phase 2, spec'd not built)

The judgment layer (distillation quality, tag coverage, routing choice) needs an
**eval**, not a unit test: run the agent on a fixed input, grade the output with
an LLM judge against a rubric (e.g. "every ≥300-char non-pre-tool block kept",
"no synthesized content in the ledger", "every feeding paragraph tagged"). Kept
out of v1 because it's non-deterministic, needs a judge harness, and shouldn't
gate CI the way the deterministic scenario does. The v1 design leaves the door
open: the scenario's fixture already contains a raw-ish input the eval could
consume, and the flow doc's step table already marks which steps are `agent`
(eval targets) vs `tool` (scenario targets). **This is where the eval-layer
design is persisted until it graduates into its own `meta/specs/` doc when built.**

---

## 8. Design review — harness research spike (2026-07-09)

A research spike was commissioned to reaffirm or challenge the test-harness
architecture against Elixir best practices and the repo's `deps: []` constraint.
**Verdict: adjust (mostly reaffirm).**

- **Reaffirmed:** plain ExUnit + `@tag :tmp_dir`, core modules called against the
  tmp root, no external dep, no DSL, no custom `mix` runner. This is the repo's
  established idiom and the only correct dependency-free baseline.
- **Corrected (folded into §1, §4):**
  - **Drop whole-tree byte-exact golden as the primary oracle.** It's brittle
    (fails on incidental reordering/whitespace/date drift), invites blind-approval
    of golden diffs, and for RouteTags largely re-encodes logic the tool already
    self-checks. Assert on **structured results + targeted content** instead —
    matching `route_tags_test.exs` and `site_test.exs`.
  - **Keep fixtures in-code** (heredocs), not on-disk `before/expected/` trees;
    on-disk `before/` only when a fixture is too bulky to inline, and `expected/`
    trees avoided.
  - **Scope golden narrowly** to large opaque renders (the `Site` output),
    dependency-free, behind an `UPDATE_GOLDEN` env flag, per-file, with volatile
    output normalized. ExUnit's built-in `assert a == b` already gives a readable
    character-level diff (since 1.6) — no helper dep needed, but diff one file at a
    time. Evidence:
    [ExUnit ships dependency-free fixtures and diffs](/SWE/testing/exunit-dependency-free-fixtures-and-diffs.md)
    (`sb:f6e843`).
  - **`steps.md` stays human documentation, not machine-parsed** — avoiding the
    bespoke DSL. (Reflected in §4: the step list is a table in the flow doc.)

**Outside references (intook, with the full citations).** The two design changes
above trace to these captures — the *drop-the-snapshot-library* decision to
[Elixir snapshot/approval-testing libraries require a dependency](/SWE/testing/elixir-snapshot-libraries-require-a-dependency.md)
(`sb:b1ba4b`), and the *built-ins-are-enough* basis to
[ExUnit ships dependency-free fixtures and diffs](/SWE/testing/exunit-dependency-free-fixtures-and-diffs.md)
(`sb:f6e843`); each capture holds the underlying hexdocs / issue-tracker / repo
URLs under its `# Citations`. Repo evidence (in-tree, not intook): `mix.exs`
(`deps: []`), `route_tags_test.exs`, `site_test.exs`.

---

## 9. Build order (once build is authorized)

1. `test/second_brain/capture_scenario_test.exs` — in-code fixture seeded from
   `green_fixture`; assert `materialize` output content + `run_checks` statuses +
   the transform edge cases; green against current `RouteTags`. *(Formal spine
   first — per "spec the hard thing first".)*
2. `meta/flows/index.md` + `meta/flows/session-capture.md` narrating that
   scenario, with the human-readable step table.
3. Collapse: remove `session-workflow.md` + `verification-flows/`, repoint links,
   update `meta/index.md` + `meta/log.md`, trim the skill.
4. Run the full gate suite; commit; push.

---

## 10. Non-blocking choices to confirm at build time

1. **Golden ergonomics** — the `UPDATE_GOLDEN` flag applies only if/when a `Site`
   golden is added; not needed for the capture scenario.
2. **Scenario file layout** — one `*_scenario_test.exs` per flow vs a shared file
   with a `describe` per flow. Lean: per-flow file.

Neither changes the artifact shape.
