---
id: sb:73115b
type: reference
title: "Unit vs. integration tests: replace the dichotomy with purity and extent (matklad)"
description: Alex Kladov argues the unit/integration distinction is confused and harmful, and proposes measuring tests along two independent axes instead — purity (freedom from threads, time, filesystem, network, processes) and extent (how much code is exercised).
resource: https://matklad.github.io/2022/07/04/unit-and-integration-tests.html
provenance: "Distilled from Alex Kladov's (matklad) blog post, 2022-07-04"
tags: [testing, software-engineering, test-design, unit-tests, integration-tests, flakiness]
timestamp: 2026-07-06
attribution:
  when: 2026-07-06T10:38:13+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# Unit vs. integration tests: replace the dichotomy with purity and extent

Alex Kladov (matklad) argues the classic **unit vs. integration** distinction is
"confused, and harmful," and should be replaced by two *independent* axes:
**purity** and **extent**. Applied to this repo in
[the Elixir Mind testing methodology](/knowledge/SWE/testing/elixir-mind-testing-methodology.md).

## Why the old dichotomy fails

- **"Unit" gets conflated with "automated."** xUnit-style frameworks made
  "unit test" a synonym for any automated test, collapsing a testing *philosophy*
  into testing *infrastructure*.
- **Language tooling overloads the terms.** Cargo's "unit" vs. "integration" tests
  describe Rust *compilation* boundaries (in-crate vs. external test crate), which
  is orthogonal to the traditional (already fuzzy) meaning.
- Conclusion: most of the time, just say **"tests"** (or "automated tests") rather
  than argue which side of the line something falls on.

## Axis 1 — Purity

How free a test is from threads, time, filesystem, network, and processes. This
tracks performance, repeatability, and stability. Purity is **non-binary but
mostly discrete** — "test speed is categorical, rather than numerical" — with a
ladder where each rung adds roughly half an order of magnitude to runtime:

1. single-threaded pure computation
2. multi-threaded parallel computation
3. concurrent computation with time-based synchronization and disk access
4. multi-process computation
5. distributed computation

Purity drives flakiness: *"It's nigh impossible to make a test for a pure function
flaky. If you add threads into the mix, keeping flakiness out requires some
careful thinking."* Threads, time, filesystem, network, and processes are the
notches to reason about.

## Axis 2 — Extent

The fraction of code exercised (possibly indirectly) by the test. Crucially,
**extent is not purity**: "running more code doesn't mean that the code will run
slower. An infinite loop takes very little code." High extent is not inherently
bad — and artificially shrinking it is often harmful: *"artificially limiting the
extent of tests by mocking your own code (as opposed to mocking impure IO) reduces
fidelity of the tests, and makes the code more brittle in the face of refactors."*

## Practical recommendations

- **Ruthlessly optimize purity.** Moving one step down the impurity ladder has
  outsized impact on speed and reliability. Mock impure IO, not your own code.
  (See also his [how-to-test methodology](/knowledge/SWE/testing/how-to-test-features-not-code.md),
  where keeping logic sans-IO is the same move applied to architecture.)
- **Let extent be natural.** Don't optimize extent for its own sake — but do read
  it as a signal: unexpectedly high extent for a small test can tell you something
  about your application's architecture.

The two axes are asymmetric: purity is something you actively *optimize*; extent
is something you mostly *observe*.

# Citations

Source: Alex Kladov (matklad), "Unit and Integration Tests", 2022-07-04 —
<https://matklad.github.io/2022/07/04/unit-and-integration-tests.html>
