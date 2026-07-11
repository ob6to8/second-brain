# Testing

Software testing — test design, strategy, and the properties that make tests fast
and reliable.

## Methodologies

- [Testing methodology for the Second Brain Elixir tooling](/knowledge/SWE/testing/elixir-second-brain-testing-methodology.md) — agent-facing synthesis of the two matklad essays, applied to this repo: purity decides `async`/`tmp_dir`, test observable contracts not internals, funnel cases through shared fixture builders, golden-test the generated artifacts, and reach for properties on universal invariants. `sb:d58da3` _(methodology)_

## References

- [How to test: test features, not code (matklad)](/knowledge/SWE/testing/how-to-test-features-not-code.md) — couple tests to features not code structure; funnel through a `check` helper, keep logic sans-IO, drive from data, and climb from examples to property-based/exhaustive/fuzz testing. `sb:a5ea86` _(reference)_
- [Unit vs. integration tests: replace the dichotomy with purity and extent (matklad)](/knowledge/SWE/testing/unit-vs-integration-purity-and-extent.md) — drop the confused unit/integration split; measure tests by purity (freedom from threads/time/IO/processes) and extent (how much code runs). `sb:73115b` _(reference)_
- [ExUnit ships dependency-free fixtures and diffs (tmp_dir + built-in ==)](/knowledge/SWE/testing/exunit-dependency-free-fixtures-and-diffs.md) — the `:tmp_dir` tag (unique, pre-cleaned, async-safe scratch dirs) and the built-in semantic `assert ==` diff (since Elixir 1.6) cover snapshot-library mechanics with the standard library alone. `sb:f6e843` _(reference)_
- [Elixir snapshot/approval-testing libraries all require a hex dependency](/knowledge/SWE/testing/elixir-snapshot-libraries-require-a-dependency.md) — mneme, snapshy, and assert_value are third-party hex packages, so a `deps: []` project must hand-roll golden comparison from ExUnit built-ins. `sb:b1ba4b` _(reference)_
