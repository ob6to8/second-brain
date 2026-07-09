---
type: tutorial
title: How the Pages deploy is gated on a verified bundle
description: The live site is a published render of the brain, so it must never show an invalid one; because GitHub Actions workflows are isolated and a job in pages.yml cannot depend on a job in ci.yml, the same integrity checks are repeated inside the Pages build job so the deploy only proceeds when the bundle verifies.
tags: [meta, tooling, ci, github-actions, github-pages, verification, deployment]
timestamp: 2026-07-09
---

# How the Pages deploy is gated on a verified bundle

The brain publishes itself: `mix brain.site` renders every concept into a static
HTML site that GitHub Pages serves to anyone with the link (see
[why the toolchain runs offline](/meta/tutorials/why-the-toolchain-runs-offline.md)
for how that build needs no network). A published render is *outward-facing* — so
it must never show an **invalid** brain: broken evidence edges, a stale `CLAUDE.md`
or registry, malformed route tags. The point of *gating* the deploy is exactly
that guarantee: **the live site is only ever a render of a bundle that passed the
same integrity checks CI runs.** This note explains the mechanics of that gate —
and, more interestingly, *why it takes the shape it does*, which is a direct
consequence of how GitHub Actions isolates workflows.

## Two workflows, one push

On a push to `main`, **two independent workflows fire**:

| Workflow | Trigger | Does |
|----------|---------|------|
| `ci.yml` (`verify` job) | every push + PR | compile, format, tests, `brain.contract --check`, `brain.registry --check`, `brain.verify`, `brain.route_tags`, and a `brain.site` build smoke-check |
| `pages.yml` (`build` → `deploy`) | push to `main` + manual | render the site and publish it to GitHub Pages |

The critical fact: these are **separate workflow files, and GitHub Actions runs
each workflow in isolation.** They start at the same time, on different runners,
and neither can see the other's job results. So in the original design, `pages.yml`
would render and deploy *regardless of whether `ci.yml` went red on the same
commit.* A push that broke `mix brain.verify` would still publish the broken bundle
to the live site — CI's failure email would arrive *after* the bad render was
already public.

## Why you can't just write `needs:`

The obvious instinct is to make the deploy "depend on" verification. Within a
workflow you would write:

```yaml
deploy:
  needs: verify   # wait for, and require, the `verify` job
```

But **`needs:` only orders jobs *inside the same workflow file*.** There is no
`needs:` that reaches across from `pages.yml` into `ci.yml`'s `verify` job — the
dependency graph is per-workflow. GitHub gives you exactly three ways to make a
deploy in one workflow contingent on checks in another:

1. **`workflow_run` trigger** — have `pages.yml` fire *after* `ci.yml` completes
   (`on: workflow_run: workflows: [CI], types: [completed]`) and gate on
   `github.event.workflow_run.conclusion == 'success'`. Correct, but heavier: the
   triggered workflow runs from the **default branch's** copy of the YAML, doesn't
   carry the head commit's checkout for free, and the artifact/ref plumbing for a
   Pages deploy under `workflow_run` is fiddly.
2. **Consolidate** — move the deploy into `ci.yml` as a job with `needs: verify`,
   deleting `pages.yml` entirely. Also correct; it's what a parallel
   implementation of this feature did. The cost is coupling "run on every PR" CI
   with "deploy only from `main`" behind `if:` conditions on one workflow.
3. **Repeat the gate in the build job** — run the integrity checks *inside*
   `pages.yml`'s `build` job, before `mix brain.site`. This is what shipped here.

## The mechanic that actually gates the deploy

Option 3 leans on one primitive: **a `run:` step that exits non-zero fails its
job, and dependent jobs are skipped.** `pages.yml` reads:

```yaml
jobs:
  build:
    steps:
      - uses: actions/checkout@v4
      - uses: erlef/setup-beam@v1
        with: { otp-version: "25", elixir-version: "1.14" }

      # --- the gate: same integrity checks ci.yml runs ---
      - run: mix brain.contract --check     # CLAUDE.md compiled & current
      - run: mix brain.registry --check     # meta/registry.md current
      - run: mix brain.verify               # ids, evidence edges, grounding
      - run: mix brain.route_tags           # tags, refs, sink logs, fidelity

      - run: mix brain.site                 # only reached if all gates passed
      - uses: actions/configure-pages@v5
      - uses: actions/upload-pages-artifact@v3
        with: { path: _site }

  deploy:
    needs: build                            # ← skipped if build failed
    steps:
      - uses: actions/deploy-pages@v4
```

Trace a failure. Say `mix brain.verify` finds a dangling `verified_by` edge and
exits `1`:

1. That **step** fails, and because steps run sequentially and a failed step
   aborts the job by default, **every later step is skipped** — including
   `mix brain.site`, `upload-pages-artifact`, and so the artifact is never
   produced.
2. The **`build` job** is marked failed.
3. **`deploy` has `needs: build`**, so with `build` failed it **does not run** —
   `deploy-pages` never fires.

No new deployment happens. Crucially, gating **prevents publishing a bad render;
it does not take the site down** — the previously deployed (good) site stays live
until a *passing* push replaces it. The gate fails safe.

Putting the checks *before* `mix brain.site` is deliberate on two counts: the
build effort is skipped on a bad bundle (minor), and — the real reason — the
artifact that feeds `deploy` is only ever created from a bundle that already
passed every gate.

## What the four checks guarantee (and why not the tests)

The gate runs the **bundle-integrity** checks, not the whole CI suite. The
distinction matters:

- **`brain.contract --check` / `brain.registry --check`** — `CLAUDE.md` and
  `meta/registry.md` are *compiled artifacts*. `--check` recomputes each from its
  sources and diffs against what's committed, failing if stale. This stops the
  site publishing a contract or id-registry that no longer matches the bundle it's
  rendering.
- **`brain.verify`** — every concept parses, ids are well-formed and unique,
  `verified_by` targets exist, and `verified: true` is properly grounded. This is
  the core "the knowledge graph is sound" gate.
- **`brain.route_tags`** — route-tag wellformedness, ref resolution, and each
  sink's derived excerpt log matches the tags.

Notably absent: `mix test` and `mix format --check-formatted`. Those check the
*tooling's* correctness and the *source's* style — properties of the codebase, not
of the rendered brain. A deploy gate answers one question — *"is the bundle we're
about to publish valid?"* — so it runs exactly the checks that answer it. The full
suite still guards the code on every push and PR via `ci.yml`; it just isn't what
decides whether a render is fit to publish. (Nothing breaks if you add `mix test`
to the gate too; it's a scoping choice, not a correctness one.)

## The trade-off this shape accepts

Repeating the checks in `pages.yml` **duplicates** the four gate lines that also
live in `ci.yml`. That duplication is the price of workflow isolation, and it
carries one real risk: **drift.** If a future integrity gate is added to
`ci.yml`'s `verify` job, the Pages gate won't inherit it — the live site could
then publish a bundle that a newer CI check would have rejected. The mitigations
are conventional, not mechanical:

- Keep the gate list in `pages.yml` a mirror of the bundle-integrity checks in
  `ci.yml`, and treat "add a check to one, add it to the other" as a paired edit.
- Because `ci.yml` *also* runs all four on the same commit, drift shows up as a
  visible asymmetry between the two workflow files — easy to catch in review.

The alternative that eliminates duplication is consolidation (option 2): one
workflow, one copy of the checks, deploy `needs: verify`. It's a legitimate choice
and arguably cleaner; the repeat-the-gate shape was kept here only to leave the
existing two-workflow layout intact. Either way the *guarantee* is identical — a
deploy is reachable only through the integrity checks.

## In one sentence

Because GitHub Actions can't express "deploy in workflow B only if the checks in
workflow A passed" with a plain `needs:`, the Pages `build` job re-runs the
bundle-integrity checks itself and lets a non-zero exit fail the job — so the
`deploy` job, which `needs` it, is reachable only for a bundle that verifies.
