---
id: em:b1ba4b
type: reference
title: Elixir snapshot/approval-testing libraries all require a hex dependency
description: Elixir's snapshot / self-updating-assertion tools (mneme, snapshy, assert_value) are third-party hex packages, not part of ExUnit — so a deliberately dependency-free project cannot use them and must hand-roll golden comparison from built-ins.
resource: https://github.com/zachallaun/mneme
provenance: "Distilled from the library repositories via a test-harness research spike, 2026-07-09"
tags: [elixir, testing, snapshot-testing, approval-testing, mneme, dependencies]
timestamp: 2026-07-09
attribution:
  when: 2026-07-09T12:23:15+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# Elixir snapshot/approval-testing libraries all require a hex dependency

Elixir's snapshot / "auto-updating assertion" testing tools are third-party hex
packages layered on ExUnit, not part of the standard library:

- **mneme** — *"augments `ExUnit.Assertions` with a set of assertions that know
  how to update themselves."* You write `auto_assert`; on a mismatch it shows a
  diff and interactively rewrites the test source with the accepted value.
  Installed as a hex dep — `{:mneme, ">= 0.0.0", only: :test}` in `mix.exs`
  (Elixir 1.14+).
- **snapshy** — a snapshot-match helper for ExUnit; hex dependency.
- **assert_value** — `assert_value expr == <snapshot>` with interactive
  accept/update; hex dependency.

**The consequence for a `deps: []` project.** Adding any of these materializes a
`mix.lock` and a `mix deps.get` step, which breaks an offline / zero-dependency
build. So a project that keeps `deps: []` on purpose cannot adopt them and must
hand-roll snapshot/golden comparison from ExUnit built-ins — see
[ExUnit ships dependency-free fixtures and diffs](/knowledge/SWE/testing/exunit-dependency-free-fixtures-and-diffs.md).

# Influence

This capture informed the harness design in
[The flows genre + formal scenario testing](/meta/plans/flows-genre-and-scenario-testing.md)
(§4, §8): it is why the spec rules out an off-the-shelf snapshot library and,
combined with the built-ins capture above, settles on plain ExUnit with
structured/targeted assertions plus a narrow, env-flag-gated golden only where
needed.

# Citations

- mneme (self-updating ExUnit assertions): <https://github.com/zachallaun/mneme>
- snapshy (ExUnit snapshot matcher): <https://github.com/DCzajkowski/snapshy>
- assert_value (interactive expected-value updates) — a further hex-dependency
  example in the same category.

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:b1ba4b">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-09-flows-genre-and-scenario-testing (2026-07-09)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:b1ba4b`]**  (co-feeds: `em:f6e843`)

**3 — Research spike — important, and I want to be straight with you: it did *not* cleanly reaffirm. Verdict was "adjust (mostly reaffirm)."** What it upheld: plain ExUnit + `@tag :tmp_dir`, no external dep, no DSL, no custom mix runner — that half was correct. What it corrected, and which I folded into the persisted spec before saving it:
- **Drop whole-tree byte-exact golden as the primary oracle** — brittle, invites blind-approval of golden diffs, and for RouteTags re-encodes logic the tool already self-checks.
- **Keep fixtures in-code** (heredocs), not on-disk `before/expected/` trees.
- **Primary oracle = structured + targeted assertions** (matching the existing tests), with the transform-pinning need met by a *targeted* in-code expected-output assertion rather than a whole-tree snapshot. Reserve golden narrowly for large opaque renders (the Site HTML), dep-free, behind `UPDATE_GOLDEN`, normalized.
- **`steps.md` becomes a human-readable table in the flow doc, not a machine-parsed artifact** — which also deletes the warn-check task from the earlier plan.

My original "only golden catches a wrong-but-consistent transform" justification survived in *substance* (self-consistency checks genuinely can't pin the transform) but was over-built in *mechanism*; the spec's §1 now states the corrected version, and §8 records the spike's verdict + sources as provenance.
