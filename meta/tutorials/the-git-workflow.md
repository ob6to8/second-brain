---
type: tutorial
title: The git workflow — single-trunk, true-merge, gate-before-deploy
description: The end-to-end version-control workflow the brain runs — one durable trunk (main) that is the production version, a short-lived session branch per unit of work in an isolated worktree, a local pre-commit gate then an authoritative CI gate on every push and PR, a true-merge that preserves session→commit provenance, head-branch deletion, and continuous deployment to the live site gated by re-verification — plus where it sits against trunk-based development and the two-tier reference it was audited against, and the hardening directions still open.
tags: [meta, tooling, git, version-control, workflow, ci, gates, trunk-based-development, deployment, provenance]
timestamp: 2026-07-22
attribution:
  when: 2026-07-22T00:00:00Z
  channel: agent-authored
  agent: "Claude Code agent, version-control-audit session"
  why: "operator requested a tutorial describing the whole git workflow arrived at in the version-control audit"
---

# The git workflow — single-trunk, true-merge, gate-before-deploy

This is the full version-control loop the brain runs, start to finish: how a
change goes from a fresh session branch to the live production site, and why each
step is shaped the way it is. It is the workflow the
[version-control audit](/meta/analysis/version-control-workflow-vs-trunk-based-reference.md)
landed on — the current practice as the spine, with the still-open hardening
directions marked as such.

## The shape in one line

**One durable trunk (`main`) that *is* production; a short-lived branch per unit of
work; a local gate then an authoritative CI gate on every change; a true merge that
keeps history; continuous deployment to the live site gated by re-verification.**

That makes this a **trunk-based, continuous-deployment** workflow. There is no
`dev`/`staging`/`master` branch split — environments are not encoded as long-lived
branches. `main` is the single integration point and the single thing that ships.

## The loop, step by step

### 1. Branch — one short-lived lane per unit of work

Each session works on its own `claude/<slug>` branch cut from `main`, in an
**isolated git worktree**. The branch is scaffolding, not history: it exists to
carry one change to a pull request and is deleted after merge. The worktree keeps
concurrent sessions from colliding in the working tree
([branch lifecycle](/meta/tutorials/branch-lifecycle-across-merged-prs.md)).

The isolation is at the *working-tree* level, not the *merge* level: two sessions
that both edit a shared file — most often a generated artifact like
[`registry.md`](/meta/registry.md), `CLAUDE.md`, or a directory `index.md` — still
collide when the second one merges. Reducing that collision class (lane by domain;
rebuild generated files on merge instead of 3-way-merging them) is tracked as an
[open issue](/meta/issues/generated-artifact-merge-conflicts.md).

### 2. Local gate — catch a red gate before CI does

Before a commit, the [gate suite](/meta/tutorials/the-gate-suite-and-where-it-runs.md)
runs locally. Two surfaces:

- **By hand, mid-session** — after editing bundle content the useful subset is
  `mix brain.verify`, `mix brain.contract --check`, `mix brain.route_tags`
  (the three that content edits move); the build gates if Elixir changed.
- **The pre-commit hook** ([`.githooks/pre-commit`](/.githooks/pre-commit)) — a fast
  mirror of CI, enabled per clone with `git config core.hooksPath .githooks`. It
  degrades to a no-op if `mix` is not on PATH, so it is a convenience, not a hard
  dependency.

Every gate is a plain `mix brain.*` task with no network dependency
([offline toolchain](/meta/tutorials/why-the-toolchain-runs-offline.md)), so the
same commands run identically here, in the hook, and in CI. **Open hardening:** the
hook is opt-in and is not auto-enabled in web sessions, so its local-first benefit
is mostly unrealized there — auto-wiring `core.hooksPath` in
[`session-start.sh`](/.claude/hooks/session-start.sh) is a tracked
[todo](/meta/todos/wire-pre-commit-hook-in-session-start.md).

### 3. Pull request — the presubmit

The branch is pushed and a PR opened into `main`.
[CI](/.github/workflows/ci.yml) runs the **full** gate suite on the PR — this is the
**presubmit**: compile-warnings-as-errors, format, tests, the generated-artifact
freshness `--check`s, the two bundle validators, and the site build. A red gate
blocks the merge. CI is the authoritative surface; the local gates exist so you find
a red one first.

CI also runs `on: push` to `main`, which gives a **postsubmit** on the trunk: if two
PRs each passed in isolation but conflict *semantically* once both are on `main`, the
post-merge run catches it. This matters precisely because many sessions land in
parallel.

**Open hardening — review depth.** The gate suite checks *form* (does it parse, does
it match its re-derivation, do ids resolve); it cannot check *substance* (is a claim
true, is a doc a good distillation, does it contradict an existing one). A
second-model / Copilot review pass and a banned-word / complexity scan would close
that gap; see the
[gate-suite hardening plan](/meta/plans/gate-suite-hardening-review-depth.md).

### 4. Merge — a true merge, never squash or rebase

PRs land with a **true merge commit** — never squash, never rebase — per the
[merge-strategy policy](/meta/policy/merge-strategy.md). The reason is provenance:
session-authored commits carry the `Claude-Session:` trailer, durable docs cite
commits by SHA, and a true merge wires the branch's real commits into `main`'s
ancestry so those cited SHAs stay reachable forever, even after the branch is
deleted ([why a true merge keeps cited commits reachable](/meta/tutorials/why-a-true-merge-keeps-cited-commits-reachable.md)).
For a one-line-per-PR reading of `main`, use `git log --first-parent`.

### 5. Delete the head branch

A merged branch is fully contained in `main`'s history, so its head branch is
deleted as part of the merge motion — preferably via the repo's "Automatically
delete head branches" setting ([git-branch-deletion policy](/meta/policy/git-branch-deletion.md)).
Branches carrying *unmerged* work, and `main` itself, are never deleted without the
operator.

### 6. Deploy — continuous, gated by re-verification

`main` is the production version. Every merge triggers the
[Pages deploy](/meta/tutorials/gating-the-pages-deploy-on-a-verified-bundle.md),
which **repeats the integrity checks in its own build job** — GitHub Actions'
per-workflow isolation means a `needs:` cannot reach across from `pages.yml` to
`ci.yml`, so the deploy re-runs the gates itself and only a bundle that verifies
reaches the live site. This is continuous deployment: no batching, no promotion
branch.

**Open hardening — pre-deploy artifact check.** `mix brain.site` proves the site
*builds*; nothing yet crawls the *built output* for broken links or unreachable
pages. `brain.verify` already warns on broken internal links but tolerates them
per OKF conformance. A pre-deploy link-crawl is the closest analog to "click
through the deployed artifact before it ships"; see the
[hardening plan](/meta/plans/gate-suite-hardening-review-depth.md).

## Where this sits against trunk-based development

The [trunk-based development][tbd] model asks for exactly what this workflow does:
one trunk, short-lived branches, small frequent merges, a comprehensive automated
gate on every change, and an always-releasable trunk. The workflow was audited
against an external **two-tier reference** (a `dev` branch → dev server and a
`master` branch → prod server, with work batched on `dev` and promoted to `master`
behind a deep gate). That reference has *two* long-lived branches — the pattern
trunk-based development warns against — so on branching topology this repo is
**more** trunk-based than the reference it was compared to. The reference's useful
idea is its two-tier *gate* (cheap per-change, deep pre-prod), not its two-branch
topology; the hardening directions above import the gate depth without importing the
branches. Full reasoning:
[the version-control audit](/meta/analysis/version-control-workflow-vs-trunk-based-reference.md).

[tbd]: https://www.atlassian.com/continuous-delivery/continuous-integration/trunk-based-development

## The workflow at a glance

| Step | Artifact | Gate | Provenance kept |
|------|----------|------|-----------------|
| Branch | `claude/<slug>` in a worktree | — | branch is ephemeral |
| Local | working commits | pre-commit hook (opt-in) | `Claude-Session:` trailer |
| PR | pull request into `main` | CI presubmit (full suite) | PR body carries session URL |
| Merge | true merge commit | CI postsubmit (`on: push`) | real SHAs wired into `main` |
| Delete | — | — | merge is the record |
| Deploy | live Pages site | Pages re-verification | commit graph = change narrative |
