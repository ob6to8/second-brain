---
id: sb:f6e843
type: reference
title: ExUnit ships dependency-free fixtures and diffs (tmp_dir + built-in ==)
description: Two built-in ExUnit features — the :tmp_dir tag for isolated, pre-cleaned, async-safe scratch directories and the semantic assertion diff for `assert left == right` (since Elixir 1.6) — cover the mechanics an external snapshot/approval library would provide, so file-generating and golden-style tests need no extra dependency.
resource: https://ex-unit.hexdocs.pm/ExUnit.Case.html
provenance: "Distilled from ExUnit docs and the Elixir issue tracker via a test-harness research spike, 2026-07-09"
tags: [elixir, exunit, testing, tmp_dir, snapshot-testing, golden-testing, dependency-free]
timestamp: 2026-07-09
---

# ExUnit ships dependency-free fixtures and diffs (tmp_dir + built-in ==)

Two built-in ExUnit features remove the usual reasons to reach for an external
test dependency when testing file-generating code or comparing generated output.

**Temporary directories — `@tag :tmp_dir`.** Tagging a test (or a module/describe
block via `@moduletag`/`@describetag`) with `:tmp_dir` injects a `tmp_dir` key
into the test context pointing at a fresh directory. Per the docs, *"The temporary
directory path is unique (includes the test module and test name) and thus
appropriate for running tests concurrently,"* and *"The directory is removed
before being created to ensure we start with a blank slate."* So each test gets an
isolated, pre-cleaned scratch directory with no manual setup/teardown, safe under
`async: true`.

**Semantic assertion diffs — built into `assert`.** Since Elixir 1.6, a failing
`assert left == right` renders a colored, structure-/character-level diff of the
two sides, marking exactly what differs — making large string and data-structure
comparisons readable on failure with no helper library. (Caveat: it diffs one
left/right pair at a time, so compare per item rather than one concatenated blob.)

Together these cover what an external snapshot/approval library otherwise
provides — isolated fixtures and readable output comparison — so a project can
build golden-style tests with the standard library alone. The companion capture
[Elixir snapshot/approval-testing libraries require a dependency](/SWE/testing/elixir-snapshot-libraries-require-a-dependency.md)
covers the alternatives and their cost.

# Influence

This capture informed the harness design in
[The flows genre + formal scenario testing](/meta/plans/flows-genre-and-scenario-testing.md)
(§4, §8): it is the evidence that the deliberately dependency-free toolchain
(`deps: []`) can run scenario tests and any narrow golden comparison on ExUnit
built-ins alone, so no snapshot library was adopted.

# Citations

- ExUnit.Case — the `:tmp_dir` tag (path uniqueness, blank-slate removal, async
  compatibility): <https://ex-unit.hexdocs.pm/ExUnit.Case.html>
- ExUnit's semantic assertion diff, present by Elixir 1.6.0-rc0 (Jan 2018):
  <https://github.com/elixir-lang/elixir/issues/7169>
- ExUnit.Assertions / ExUnit.Formatter — assertion introspection and the diff
  formatter: <https://hexdocs.pm/ex_unit/ExUnit.Assertions.html>
- Easy concurrent temp dirs with ExUnit (ElixirStreams tip):
  <https://www.elixirstreams.com/tips/easy-concurrent-temp-dirs-with-exunit>

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="sb:f6e843">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-09-flows-genre-and-scenario-testing (2026-07-09)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:f6e843`]**  (co-feeds: `sb:b1ba4b`)

**3 — Research spike — important, and I want to be straight with you: it did *not* cleanly reaffirm. Verdict was "adjust (mostly reaffirm)."** What it upheld: plain ExUnit + `@tag :tmp_dir`, no external dep, no DSL, no custom mix runner — that half was correct. What it corrected, and which I folded into the persisted spec before saving it:
- **Drop whole-tree byte-exact golden as the primary oracle** — brittle, invites blind-approval of golden diffs, and for RouteTags re-encodes logic the tool already self-checks.
- **Keep fixtures in-code** (heredocs), not on-disk `before/expected/` trees.
- **Primary oracle = structured + targeted assertions** (matching the existing tests), with the transform-pinning need met by a *targeted* in-code expected-output assertion rather than a whole-tree snapshot. Reserve golden narrowly for large opaque renders (the Site HTML), dep-free, behind `UPDATE_GOLDEN`, normalized.
- **`steps.md` becomes a human-readable table in the flow doc, not a machine-parsed artifact** — which also deletes the warn-check task from the earlier plan.

My original "only golden catches a wrong-but-consistent transform" justification survived in *substance* (self-consistency checks genuinely can't pin the transform) but was over-built in *mechanism*; the spec's §1 now states the corrected version, and §8 records the spike's verdict + sources as provenance.
