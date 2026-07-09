---
id: sb:a5ea86
type: reference
title: "How to test: test features, not code (matklad)"
description: Alex Kladov's methodology for testing — couple tests to features rather than code structure so refactors don't break them, funnel assertions through a single check helper, keep logic sans-IO, drive tests from serializable data, and climb from example tests to property-based, exhaustive, and coverage-guided generation.
resource: https://matklad.github.io/2021/05/31/how-to-test.html
provenance: "Distilled from Alex Kladov's (matklad) blog post, 2021-05-31"
tags: [testing, software-engineering, test-design, property-based-testing, fuzzing, snapshot-tests]
timestamp: 2026-07-06
---

# How to test: test features, not code

Alex Kladov (matklad) on how to structure a test suite. The measure of a good
suite is **how easily it lets you change the software** — not coverage numbers or
testing dogma. Related: his later reframing of test taxonomy into
[purity and extent](/SWE/testing/unit-vs-integration-purity-and-extent.md).
Applied to this repo in
[the Second Brain testing methodology](/SWE/testing/elixir-second-brain-testing-methodology.md).

## Thesis — test features, not code

Tests coupled to code *structure* ossify it: when each test calls the API under
test directly, renaming a signature cascades into dozens of edits. Couple tests to
**features / observable behavior** instead. The litmus test: the **"neural network
test"** — would your tests still pass if the whole implementation were swapped for
a completely different one (even an ML model)? If yes, they test features, not
code.

## Core techniques

- **The `check` chokepoint.** Route tests through a single `check(input, expected)`
  helper that wraps the API under test. When the interface changes, you update one
  function instead of every test.
- **Keep logic sans-IO.** *"Architecture the software to keep as much as possible
  sans io."* Pure, IO-free logic tests fast and without flakiness (echoing the
  purity ladder). Mock impure IO — not your own code.
- **Data-driven tests.** Operate on serializable input/output data rather than
  mock objects, so the same cases can drive multiple implementations.
- **Expect / snapshot tests.** Instead of hand-writing every expected value inline,
  let the test record expected output and provide a mode that **auto-updates** the
  expectations when output legitimately changes — bulk assertion updates become
  trivial.
- **Externalize test cases into files.** Test data as data files (not code) makes
  the suite language-agnostic and enforces disciplined data-driven design.
- **Lower friction.** *"If writing a test is more effort than the fix itself,
  testing tends to go out of the window."* Reducing the effort to add a test grows
  coverage organically.

## Beyond examples — generative testing

A spectrum of increasing power past hand-written examples:

- **Property-based testing** — random inputs checked against invariants.
- **Full coverage** — exhaustively enumerate all inputs within small bounds.
- **Coverage-guided fuzzing** — random bytes steered toward uncovered branches.

## Practical stances

- **Speed comes from IO patterns, not code volume.** Even large systems test fast
  when isolated from disk/network. He contests Gary Bernhardt's claim that
  integration tests scale superlinearly: the limiting factor is IO, not lines of
  code (merge sort beats bubble sort despite "more code").
- **Structured concurrency is a prerequisite for testing concurrent code.**
  Unstructured, fire-and-forget threading (`go`-statement style) makes tests unable
  to wait for completion, so it's effectively untestable.
- **Layered architecture, layered tests.** Test each architectural layer directly
  rather than always through the full dependency chain.
- **Reject fluent assertions and heavy mocking.** Prefer hand-crafted error
  messages and real integration.
- **Use the harness for general validation.** Formatting, docs, license
  compatibility, and performance can all be enforced as "tests."

# Citations

Source: Alex Kladov (matklad), "How to Test", 2021-05-31 —
<https://matklad.github.io/2021/05/31/how-to-test.html>
