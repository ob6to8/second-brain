---
id: sb:b1ba4b
type: reference
title: Elixir snapshot/approval-testing libraries all require a hex dependency
description: Elixir's snapshot / self-updating-assertion tools (mneme, snapshy, assert_value) are third-party hex packages, not part of ExUnit — so a deliberately dependency-free project cannot use them and must hand-roll golden comparison from built-ins.
resource: https://github.com/zachallaun/mneme
provenance: "Distilled from the library repositories via a test-harness research spike, 2026-07-09"
tags: [elixir, testing, snapshot-testing, approval-testing, mneme, dependencies]
timestamp: 2026-07-09
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
[ExUnit ships dependency-free fixtures and diffs](/SWE/testing/exunit-dependency-free-fixtures-and-diffs.md).

# Influence

This capture informed the harness design in
[The flows genre + formal scenario testing](/meta/specs/flows-genre-and-scenario-testing.md)
(§4, §8): it is why the spec rules out an off-the-shelf snapshot library and,
combined with the built-ins capture above, settles on plain ExUnit with
structured/targeted assertions plus a narrow, env-flag-gated golden only where
needed.

# Citations

- mneme (self-updating ExUnit assertions): <https://github.com/zachallaun/mneme>
- snapshy (ExUnit snapshot matcher): <https://github.com/DCzajkowski/snapshy>
- assert_value (interactive expected-value updates) — a further hex-dependency
  example in the same category.
