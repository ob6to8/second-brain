---
type: analysis
title: "The brain's git workflow vs. trunk-based development and a two-tier reference: which practices to import"
description: Audits elixir-mind's actual single-trunk, true-merge, gate-on-every-change workflow against the Atlassian trunk-based-development model and an external two-tier (dev→master, batched-release) reference workflow — finds the repo is already more trunk-based than the reference it's benchmarked against, that main = production makes it continuous deployment with one gate tier, and recommends importing a small set of the reference's practices (pre-commit auto-wiring, generated-artifact merge handling, a pre-deploy link-crawl, banned-word/complexity/second-model review) while explicitly not importing the reference's long-lived dev/master branches or batched daily releases.
provenance: "Claude Code session (2026-07-22) — operator asked for a version-control workflow audit against the Atlassian trunk-based-development article and an external reference workflow (dev→master two-tier, Playwright deep gate, banned-word/complexity gates, presubmit/postsubmit/changelist-review/dictionary-check/daily-release practices); clarified that the reference is someone else's setup used as a benchmark, and this repo is the single production version"
tags: [meta, analysis, git, version-control, trunk-based-development, ci, gates, code-review, deployment]
timestamp: 2026-07-22
attribution:
  when: 2026-07-22T00:00:00Z
  channel: agent-authored
  agent: "Claude Code agent, version-control-audit session"
  why: "operator requested a version-control workflow audit and ratified persisting the reasoning and its recommendations so they survive the session"
---

# The brain's git workflow vs. trunk-based development and a two-tier reference

**Question.** Audit this repository's version-control workflow. Benchmark it
against the Atlassian [trunk-based development][tbd] model and against an external
**reference workflow** (someone else's setup, supplied for comparison): a `dev`
branch feeding a development server and a `master` branch feeding production, with
each unit of work PR'd into `dev` behind a fast gate (~1 min: lint, leaked-secret
scan, banned-LLM-slop words, cyclomatic complexity), then batches promoted from
`dev` into `master` behind a deep gate (full DB migrations + an automated headless
Playwright click-through) before deploying to prod. Also weigh the Google-style
practices the operator named — presubmits, postsubmits, changelist reviews,
dictionary checks against the binary, CI, daily releases — plus three pieces of
advice: run cheap checks locally first, keep one pinned "current state" document,
and give each AI session its own lane.

[tbd]: https://www.atlassian.com/continuous-delivery/continuous-integration/trunk-based-development

**Correction to the framing.** The `dev`→`master` model is *not* this repo — it is
the external reference. This repo has one durable branch, `main`, and `main` is the
production version (it deploys to GitHub Pages). So the audit is not "migrate toward
the reference"; it is "which of the reference's *practices* are worth importing into
an already-sound single-trunk model."

## Verdict — you are already more trunk-based than the reference

Against the article, the reference's `dev`→`master`, batch-then-promote model has
**two long-lived branches**, which is the exact pattern trunk-based development
warns against: they diverge between promotions and the promotion becomes a
big-bang merge that is harder to bisect when the deep gate goes red. This repo has
**one durable trunk** (`main`), short-lived `claude/<slug>` session branches, small
frequent merges, a CI gate on every change, and an always-releasable trunk that
deploys to production per merge. On branching topology the brain is *ahead* of the
reference it is benchmarked against — no move toward the reference's shape is
warranted.

## What `main` = production implies

The repo does **continuous deployment**: every green merge to `main` ships to prod
([Pages deploy](/meta/tutorials/gating-the-pages-deploy-on-a-verified-bundle.md)).
That is the opposite end of the spectrum from the reference's *batched daily release
behind a deep gate*, and for a markdown + static-site bundle it is the right call —
batching would add latency for no safety CI is not already providing. Two
consequences:

1. The reference's `dev` staging branch and its "accumulate a batch" step are **not
   worth importing** — they would add divergence and latency without buying safety.
2. The repo has **one gate tier, firing before merge, not before deploy**. The
   reference's genuinely useful idea — a *heavier* verification specifically before
   production — has exactly one meaningful analog here (a link-crawl of the built
   site; see below). The rest of its deep gate (DB migrations, browser click-through)
   tests app runtime this bundle has no equivalent surface for.

## Practice-by-practice

| Reference practice | This repo today | Import? |
|---|---|---|
| Two-tier gate (cheap presubmit + deep pre-prod gate) | one tier on every push/PR (~1 min, offline, deterministic) | mostly **no** — the deep tier tests runtime the bundle lacks |
| Presubmit (checks before merge) | ✅ CI on every PR | have it |
| Postsubmit (checks on trunk after merge) | ✅ CI also runs `on: push` to `main` — catches semantic conflicts between two individually-green PRs | have it; a real strength given parallel sessions |
| Playwright click-through of the deployed artifact | ❌ `mix brain.site` proves the site *builds*; nothing crawls the built output | **yes, lightly** — a pre-deploy link-crawl is the "does the artifact actually work" analog; [`brain.verify`](/meta/tutorials/the-three-bundle-scanners.md) already *warns* on broken internal links but tolerates them |
| Banned-LLM-slop-word scan | ❌ absent | **yes** if wanted — the "dictionary check against the binary" analog: scan rendered site text |
| Cyclomatic complexity | ❌ no Credo on `lib/` | **optional** — cheap; low stakes, `lib/` is small |
| Changelist review | ⚠️ *machine* review (the [gate suite](/meta/tutorials/the-gate-suite-and-where-it-runs.md)) only | **consider** — a second-model / Copilot pass covers what deterministic gates cannot |
| Daily releases | N/A — deploys continuously | **skip** — batching is a step backward here |
| Rollback | implicit (revert + re-deploy) | **confirm** a one-command revert path, since a bad merge ships straight to prod |

## The three pieces of advice, as import candidates

**Run cheap checks locally first.** The repo already has the hook
([`.githooks/pre-commit`](/.githooks/pre-commit)) — but it is opt-in
(`git config core.hooksPath .githooks`) and almost certainly **not wired in web
sessions**, which run in fresh sandboxes where `core.hooksPath` was never set. So
the dominant flow only learns of a red gate from CI, not locally. One-line fix:
have [`session-start.sh`](/.claude/hooks/session-start.sh) set `core.hooksPath`.
This is the highest-leverage item — it makes the local-first advice actually true
for how the brain is worked. Filed as a
[todo](/meta/todos/wire-pre-commit-hook-in-session-start.md).

**A single "current state" document.** Already solved, better than a pinned issue:
the [retire-hand-kept-logs](/meta/plans/retire-hand-kept-logs.md) policy killed hand
logs; live state = open issues/todos/plans surfaced via
[`/priorities`](/.claude/skills/priorities/SKILL.md); history = thread docs + closed
items + the commit graph. Nothing to import.

**Give each AI its own lane.** The sharpest live finding. Worktree isolation stops
working-tree collisions, but **merge-level** collisions persist — PRs #97 and #98 are
literally `pr-64-merge-conflicts` / `pr-70-merge-conflicts`. The magnets are the
**generated/shared artifacts** every session touches: `CLAUDE.md`,
[`registry.md`](/meta/registry.md), `meta/code-map.md`, and derived `index.md`
files. Fixes: lane by domain where sessions are independent, and stop 3-way-merging
generated files — treat them as *rebuild-on-merge* so two sessions that both
regenerated the registry do not conflict; the merge just re-derives it. Filed as an
[issue](/meta/issues/generated-artifact-merge-conflicts.md).

## Recommendations, prioritized

1. **Auto-wire the pre-commit hook in `session-start.sh`** — makes local-first real
   for web sessions (one line). → [todo](/meta/todos/wire-pre-commit-hook-in-session-start.md)
2. **Neutralize generated-artifact merge conflicts** via rebuild-on-merge — kills the
   recurring conflict class. → [issue](/meta/issues/generated-artifact-merge-conflicts.md)
3. **Add a pre-deploy link-crawl**, plus optional banned-word / Credo / second-model
   review — the review-depth and dictionary-check analogs. → [plan](/meta/plans/gate-suite-hardening-review-depth.md)
4. **Confirm a one-command rollback**, since every merge deploys to prod.

**Do not import:** the `dev`/`master` two-branch split and batched daily releases.
For a continuously-deployed knowledge bundle they add divergence and latency without
buying safety CI does not already provide — and they are the least trunk-based parts
of the reference.

The full workflow this audit lands on is written up as a tutorial:
[the git workflow](/meta/tutorials/the-git-workflow.md).
