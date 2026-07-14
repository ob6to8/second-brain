---
type: tutorial
title: The gate suite — what the checks prove and where they run
description: The repository's integrity gates — compile, format, tests, the two generated-artifact freshness checks (contract/registry --check), the two bundle validators (verify, route_tags), and the site build — what each one proves, and the three surfaces they run on (an agent's manual pass, the pre-commit hook, and the authoritative CI job).
tags: [meta, tooling, elixir, ci, gates, verification, pre-commit, workflow]
timestamp: 2026-07-12
attribution:
  when: 2026-07-10T10:41:12+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-10-todo-skill-and-gate-suite-tutorial.md]
---

# The gate suite — what the checks prove and where they run

A **gate** in this repository is a command that exits `0` when the bundle is in a
good state and non-zero when it isn't. Nothing merges to `main` with a red gate:
the [CI workflow](/.github/workflows/ci.yml) runs the whole suite on every push
and pull request, and a failure blocks the merge. When a session ends with "all
three gates pass: `mix brain.verify`, `mix brain.contract --check`, and `mix
brain.route_tags`," that is the agent reporting it ran the **content-editing
subset** of this suite locally and got green before handing the change to CI.

This note explains what each gate proves, why they split into four kinds, and the
three places they run — so you know which ones to run by hand, why the pre-commit
hook mirrors CI, and how to read a red one.

## The full suite

CI runs these in order. The suite is small on purpose — every gate is a plain
`mix` task with no network dependency (see
[why the toolchain runs offline](/meta/tutorials/why-the-toolchain-runs-offline.md)),
so the same commands run identically in CI, in the pre-commit hook, and in any
sandbox.

| # | Gate | Kind | Proves |
|---|------|------|--------|
| 1 | `mix compile --warnings-as-errors` | build | the Elixir toolchain compiles clean |
| 2 | `mix format --check-formatted` | build | all Elixir source is canonically formatted |
| 3 | `mix test` | build | the compiler, parser, and scenario tests pass |
| 4 | `mix brain.contract --check` | freshness | `CLAUDE.md` matches its policy sources |
| 5 | `mix brain.registry --check` | freshness | `meta/registry.md` matches the on-disk ids |
| 6 | `mix brain.verify` | validation | ids, evidence edges, and grounding all hold |
| 7 | `mix brain.route_tags` | validation | route tags resolve and sink logs are faithful |
| 8 | `mix brain.site` | build-artifact | the static site renders without error |

## The four kinds of gate

**Build gates (1–3)** are the ordinary Elixir ones: it compiles, it's formatted,
the tests are green. `mix test` is where the scenario suite lives, so a broken
flow spine trips here.

**Freshness gates (4–5)** guard the two **generated artifacts**. `CLAUDE.md` is
compiled from `meta/preamble.md` + `meta/policy/*.md`, and `meta/registry.md` is
compiled from the ids on disk — neither may be hand-edited. The `--check` variant
re-runs the compile *in memory* and compares it byte-for-byte against the checked-in
file; any drift fails. This is what converts "remember to re-render after editing a
policy" from a discipline into a structural guarantee: forget to run
`mix brain.contract`, and gate 4 catches it. **The fix is never to edit the
artifact** — it is to run the generator (`mix brain.contract` / `mix brain.registry`,
no `--check`) and commit the regenerated file alongside its source.

**Validation gates (6–7)** are the two bundle scanners that judge content rather
than regenerate a file. They share one crawler and differ in what they read and
enforce — the mechanics are laid out in
[the three bundle scanners](/meta/tutorials/the-three-bundle-scanners.md); here it
is enough to know what turns them red:

- `mix brain.verify` fails on a malformed or duplicate `em:` id, a `verified_by`
  edge pointing at an id that doesn't exist, a capture (a concept with a
  `resource`) marked `verified: true`, or a `verified: true` statement with no
  `verified_by`. On a green bundle it additionally prints **advisory
  docs-freshness warnings** (`ElixirMind.Links`): internal links that don't
  resolve and index-coverage gaps. These never turn the gate red — broken links
  are tolerated per OKF conformance and index coverage is ultimately
  editorial — but a warning in the output is a prompt to fix the drift in the
  same change. Frozen thread bodies, materialized excerpt logs, code spans, and
  `…` placeholders are exempt.
- `mix brain.route_tags` fails on a malformed `<routes ref="…">` tag, a ref that
  resolves to no concept, or a materialized excerpt log that has drifted from what
  the current tags say it should be. It re-derives each sink's log and fails on
  divergence, so the doc-side logs can never silently rot. (Its ledger
  cross-check only *warns*.) When a tag or thread legitimately changed, the fix is
  `mix brain.route_tags --materialize`, which rewrites the logs from the tags.

**The build-artifact gate (8)** actually runs `mix brain.site` to prove the whole
bundle renders. CI can't `needs:`-depend the Pages deploy on this job across
workflow files, so the Pages build repeats the integrity checks itself — see
[gating the Pages deploy on a verified bundle](/meta/tutorials/gating-the-pages-deploy-on-a-verified-bundle.md).

## Where the gates run — three surfaces

The same commands run in three places, with widening scope:

1. **The agent, by hand, mid-session.** After editing bundle content the useful
   subset is gates 6, 4, and 7 — `mix brain.verify`, `mix brain.contract --check`,
   `mix brain.route_tags` — because content edits are what move *those* three. That
   is the "all three gates pass" report. If the change touched ids you also want
   `mix brain.registry --check`; if it touched Elixir you want the build gates. The
   subset is a convenience, not a different standard — it's chosen to match what the
   edit could have broken.

2. **The pre-commit hook** ([`.githooks/pre-commit`](/.githooks/pre-commit)),
   enabled once per clone with `git config core.hooksPath .githooks`. It is a fast
   local mirror of CI: format check, both `--check` freshness gates, `verify`,
   `route_tags`, then `test`. It degrades gracefully — if `mix` isn't on the PATH it
   prints a notice and exits `0` rather than blocking the commit — so it is a
   convenience for contributors who opt in, not a hard dependency.

3. **CI** ([`.github/workflows/ci.yml`](/.github/workflows/ci.yml)) is the
   authoritative gate. It runs the **full superset** — including the two build gates
   the quick manual pass skips and the `mix brain.site` render — on a clean checkout
   with pinned OTP/Elixir. This is the one that actually blocks a merge; the other
   two surfaces exist so you find a red gate *before* CI does.

The layering is deliberate: the manual subset is fast and scoped to the edit, the
pre-commit hook catches the common misses locally, and CI is the exhaustive
backstop no change can route around.

## Reading a red gate

Each gate names its own failure, and the fix follows the gate's *kind*:

- **A freshness gate (4/5) is red** → you edited a source but not its artifact.
  Run the generator without `--check` (`mix brain.contract` / `mix brain.registry`)
  and commit the regenerated file. Never hand-edit `CLAUDE.md` or
  `meta/registry.md`.
- **`verify` (6) is red** → the message points at the offending id/edge. Fix the
  frontmatter: mint a missing id (`mix brain.id`), repair a dangling `verified_by`,
  or drop `verified: true` from a capture.
- **`route_tags` (7) is red** → either a tag is malformed / points nowhere (fix the
  ref) or a sink log drifted (`mix brain.route_tags --materialize`).
- **A build gate (1–3) is red** → ordinary Elixir: read the compiler/formatter/test
  output.

## In one sentence

The gate suite is eight offline `mix` checks in four kinds — build, generated-artifact
freshness, bundle validation, and site render — run at three widening scopes (an
agent's scoped manual pass, the opt-in pre-commit hook, and the authoritative CI
job), so that a change that would break the bundle is caught before it reaches
`main`.
