---
id: sb:d58da3
type: methodology
title: "Testing methodology for the Second Brain Elixir tooling"
description: An agent-facing synthesis of matklad's two testing essays (features-not-code; purity and extent), applied to building the test suite for this bundle's dependency-free Elixir tooling.
provenance: "Claude Opus 4.8 — synthesized from the two matklad references filed in this directory, applied to this repo's lib/ and test/"
verified: false
tags: [testing, software-engineering, test-design, elixir, exunit]
timestamp: 2026-07-08
---

# Testing methodology for the Second Brain Elixir tooling

This is the working methodology an agent should follow when adding or extending
tests for the Elixir tooling in this repo (`lib/`, `test/`, the `mix brain.*`
tasks). It distills two essays by Alex Kladov (matklad) —
[test features, not code](/knowledge/SWE/testing/how-to-test-features-not-code.md) and
[purity and extent](/knowledge/SWE/testing/unit-vs-integration-purity-and-extent.md) — and
maps each principle onto the modules this app actually has. Read the two
references for the full argument; read this for what to *do* here.

## What this app is (so the methodology fits it)

- **Elixir 1.14, ExUnit, zero external deps.** The frontmatter parser, contract
  compiler, registry, and verifier are stdlib-only (see `mix.exs`), so the whole
  suite runs offline in any sandbox.
- **A pure core wrapped by an IO shell.** `SecondBrain.Frontmatter` and
  `SecondBrain.Policy` are (mostly) pure text/data transforms. `Registry`,
  `Contract`, and `Verifier` walk the filesystem. The `Mix.Tasks.Brain.*` tasks
  are the outer IO/CLI layer.
- **Two of its outputs are generated artifacts** — `CLAUDE.md` (from
  `Contract`) and `meta/registry.md` (from `Registry`) — each with a
  `write`/`check` round-trip. These are golden-file tests waiting to happen, and
  the existing suite already treats them that way.

## Principle 1 — Optimize purity; let it decide `async` and structure

Purity (freedom from threads, time, filesystem, network, processes) is the axis
you *actively optimize*. It maps directly onto ExUnit mechanics:

- **Pure computation → `use ExUnit.Case, async: true`.** `Frontmatter` parsing is
  rung 1 (single-threaded, pure); `frontmatter_test.exs` is already `async: true`.
  Any new logic that transforms strings/maps without touching disk belongs here
  and must stay parallel-safe.
- **Filesystem-touching → `async: false` + `@moduletag :tmp_dir`.** `Registry`,
  `Contract`, and `Verifier` tests read and write real files, so they run against
  ExUnit's per-test `tmp_dir` and are *not* async (see `contract_test.exs`,
  `registry_test.exs`). Never let a test touch the repo's own working tree — build
  a fixture bundle inside `tmp_dir`.
- **Push logic down the purity ladder.** When you add a feature, keep the
  decision-making sans-IO and confine `File.read!/1`, `File.write!/1`,
  `Path.wildcard/1`, and `Mix.shell/0` to a thin edge. Then the bulk of the
  feature is testable at rung 1. This is the same "keep logic sans-IO" move the
  features-not-code essay makes at the architecture level.
- **Purity is your anti-flake budget.** A pure function is nearly impossible to
  make flaky; every rung down (disk, processes) is where flakiness enters. If a
  new test needs `Process.sleep/1` or wall-clock time to pass, treat that as a
  design smell in the code under test, not a test to stabilize.

## Principle 2 — Test features, not code (survive the refactor)

The measure of the suite is how freely it lets you change the tooling. Apply the
essay's **"neural network test"**: would the test still pass if the module's
internals were rewritten? Anchor tests to observable contracts:

- The **error strings** `Verifier.run/1` returns (`"...: missing stable \`id\`"`,
  `"verified_by ... does not resolve"`) — those *are* the feature. `registry_test.exs`
  asserts on them directly; that's correct.
- The **rendered contract**: section headings, ordering, trace links, banner —
  not the private helpers that build them (`contract_test.exs` asserts the output).
- The **`:ok | {:stale, _}` round-trip** of `write`/`check` for both generated
  artifacts.

Do **not** test private functions or reach through the public API into internals.
Do **not** mock this app's own modules — the essays are explicit that mocking your
own code (vs. mocking impure IO) lowers fidelity and makes refactors brittle. Here
the "impure IO" boundary is the filesystem, and the right seam is already in place:
every IO-touching function takes a `root` directory argument (`Verifier.run(root)`,
`Contract.render(dir)`, `Registry.scan(dir)`), so you inject a `tmp_dir` instead of
mocking `File`.

## Principle 3 — The `check` chokepoint and data-driven cases

matklad's central technique is routing every test through one `check(input,
expected)` helper so an interface change is a one-line edit, not a hundred. This
repo already has the equivalent: the **`write_concept/3` and `write_policy/4`**
fixture builders in the test files. When extending the suite:

- **Funnel new cases through those helpers** (or a shared one) rather than
  hand-assembling frontmatter in each test. If two test modules need the same
  builder, promote it to `test/support/` — `mix.exs` already puts `test/support`
  on the `:test` compile path (`elixirc_paths(:test)`), but the directory is empty;
  create it when a helper is shared by more than one file.
- **Drive from serializable data.** Cases are `(fields, body) → expected` — plain
  maps/keyword lists and strings, exactly what the frontmatter layer consumes.
  This keeps cases implementation-agnostic and lets one table exercise several
  code paths.
- **Lower the friction to add a case.** If adding a verifier rule means more
  boilerplate than the rule itself, refactor the helper first — otherwise coverage
  quietly stops growing.

## Principle 4 — Golden / snapshot tests for the generated artifacts

`CLAUDE.md` and `meta/registry.md` are compiled outputs, which is precisely where
the essay's **expect/snapshot** idea pays off. The `write` → `check` → mutate →
`{:stale, _}` pattern in `contract_test.exs` and `registry_test.exs` *is* a
snapshot test: it asserts "the artifact regenerates to a stable value and drift is
detected." When you change rendering:

- Regenerate the real artifacts with `mix brain.contract` / `mix brain.registry`
  and commit them in the same change — CI runs `--check` and will fail on drift.
- Keep the *unit-level* golden assertions (a specific heading, a specific ordering)
  in `tmp_dir` fixtures so they don't depend on the repo's live content.
- Prefer hand-crafted assertions with clear failure messages over fluent-assertion
  chains; the essays explicitly reject fluent/heavy-mock styles.

## Principle 5 — Climb from examples toward generative testing

Past hand-written examples lies a spectrum of increasing power. Reach for it where
this app's invariants are naturally universal:

- **Property-based (invariants over random input).** `Registry.mint/1` has a clean
  property — *every minted id matches `id_format/0` and is absent from the `taken`
  set* — already asserted once; a generator over random `taken` sets strengthens
  it. Frontmatter has a **round-trip** property: for the scalar/quoted/list subset
  it supports, `parse` of a rendered block returns the original values.
- **Exhaustive (small bounded enumeration).** The controlled `type` vocabulary and
  the fixed contract `@sections` are small finite sets — enumerate them rather than
  spot-checking one.
- **Fuzzing** is overkill for stdlib parsing at this size; note it as available,
  don't build it yet.

Introducing a property-based library (e.g. StreamData) is a **new dependency** —
the project is deliberately dep-free (`deps: []`). Propose it to the operator
before adding; until then, emulate small properties with comprehensions over
generated inputs.

## Principle 6 — Use the harness as a test

The build itself enforces invariants no example test covers. Treat these as part
of the suite and keep them green in CI:

- `mix brain.contract --check` — `CLAUDE.md` is not stale vs. `meta/policy/*`.
- `mix brain.registry --check` — the id→path registry view matches the files.
- `mix brain.verify` — identity/verification rules hold across the live bundle.
- `mix format --check-formatted` — formatting is a test.

## Checklist for adding a test here

1. Is the logic pure? → `async: true`, no `tmp_dir`. If not, push IO to the edge
   first, then test the pure part.
2. Filesystem needed? → `async: false`, `@moduletag :tmp_dir`, build a fixture
   bundle; never touch the repo's own tree.
3. Assert on the **observable contract** (return values, error strings, rendered
   output), never private helpers; inject `root`, don't mock `File`.
4. Route cases through a shared `write_concept`/`write_policy`-style builder;
   promote it to `test/support/` once it's shared.
5. For generated artifacts, assert the `write`/`check` round-trip and detect drift.
6. If the invariant is universal (ids, round-trips, vocabularies), write a property
   or an exhaustive enumeration instead of one example.
7. Add the relevant `mix brain.*`/`mix format` harness check to CI rather than
   re-asserting it by hand.

# Citations

Synthesized from:

- Alex Kladov (matklad), "How to Test" —
  [local reference](/knowledge/SWE/testing/how-to-test-features-not-code.md),
  <https://matklad.github.io/2021/05/31/how-to-test.html>
- Alex Kladov (matklad), "Unit and Integration Tests" —
  [local reference](/knowledge/SWE/testing/unit-vs-integration-purity-and-extent.md),
  <https://matklad.github.io/2022/07/04/unit-and-integration-tests.html>

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="sb:d58da3">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-09-testing-methodology-types-and-cb-epistemic-overlay (2026-07-09)

2 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:d58da3`]**

I read the two testing articles already in the brain, grounded them in this repo's actual Elixir tooling, and filed a synthesized methodology. I produced `SWE/testing/elixir-second-brain-testing-methodology.md` — an agent-facing methodology that maps each principle onto this app's real modules rather than restating theory: **Purity → ExUnit mechanics** (`Frontmatter`/`Policy` are pure → `async: true`; the IO-touching `Registry`/`Contract`/`Verifier` → `async: false` + `@moduletag :tmp_dir`); **Features-not-code** (assert on the verifier's error strings and rendered output, not private helpers; inject the `root` arg instead of mocking `File`); **The `check` chokepoint** (the existing `write_concept`/`write_policy` fixture builders, promoted to `test/support/` when shared); **Golden/snapshot tests** (the `write`→`check`→drift round-trip for the generated `CLAUDE.md` and `meta/registry.md`); and a **generative ladder** (properties for `mint`/frontmatter round-trip, exhaustive enumeration for the `type` vocabulary — flagging that StreamData would be a new dependency needing ratification). Plus a concrete 7-step checklist and treating `mix brain.*`/`mix format --check` as part of the suite.

---

**[`sb:d58da3`]**

You ratified `methodology`, so I minted it and wired everything through the four questions you raised. **1. Type — now `methodology`.** Added to the controlled vocabulary in `meta/policy/controlled-type-vocabulary.md`, recompiled `CLAUDE.md`, and retyped the doc `note` → `methodology`. **2. Linking — now reciprocal.** The methodology already linked to both articles; I added an "Applied in:" back-link to each reference (`sb:a5ea86`, `sb:73115b`), kept as untyped prose links. **3. Tags — aligned.** `test-strategy` → `test-design` and dropped `methodology` as a tag since it's now the type. Final: `[testing, software-engineering, test-design, elixir, exunit]`. **4. Verification — left at `verified: false`.** I didn't force it; the path stays open (`verified_by` the two references for fidelity, or `type: source` code captures for the mapping).
