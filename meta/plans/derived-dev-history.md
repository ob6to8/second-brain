---
type: plan
title: "Derived dev history: a per-PR progress view compiled from the merge graph"
description: Replace the appetite for a hand-kept development log with a generated meta/dev-history.md — one section per merged PR with its branch-commit bullets, derived entirely from the default branch's first-parent git history by mix brain.dev_history, lag-tolerantly checked in CI and re-derived fresh at every Pages deploy.
status: done
provenance: "Claude Code session, 2026-07-13 — operator asked for an overview of recent development per PR without re-introducing the hand-crafted log; designed and built same session"
attribution:
  when: 2026-07-13T00:00:00Z
  channel: agent-authored
  agent: "Claude Code agent, derived dev-history session"
  why: "persists the design of the generated dev-history view per the persist-plans policy"
  from: [/meta/threads/2026-07-13-derived-dev-history-from-merge-graph.md]
tags: [meta, plan, tooling, provenance, generated-artifact]
timestamp: 2026-07-13
---

# Derived dev history: a per-PR progress view compiled from the merge graph

## Problem

The [retire-hand-kept-logs plan](/meta/plans/retire-hand-kept-logs.md) removed
`log.md`: the true-merge commit graph is the single provenance layer, and a
hand-appended log was a drifting shadow of it. But the graph's readability
problem remained — "what has been built lately?" meant pouring through PRs on
GitHub. The operator wanted the old log's *convenience* (a bulleted overview of
features and progress per PR) without its *craft* (hand-written entries that go
stale and duplicate the commit narrative).

## Decision

Derive, don't write. The
[merge-strategy policy](/meta/policy/merge-strategy.md) already guarantees the
data: every PR lands as a true merge, `git log --first-parent` reads one commit
per PR, and each merge's second parent keeps the branch's deliberately-messaged
commits reachable forever. So the overview is a **generated artifact** on the
same discipline as `CLAUDE.md`, `meta/registry.md`, and
`meta/flows/lineage.md`:

- **`mix brain.dev_history`** (`SecondBrain.DevHistory`) derives
  [`meta/dev-history.md`](/meta/dev-history.md): one section per merged PR,
  newest first — linked PR number, title, merge date — bulleted with the merged
  branch's commit subjects in order. Nothing is authored; everything re-derives
  from the graph.
- **Three eras handled**: true merges (`Merge pull request #N …`; bullets from
  `merge^1..merge^2`), the pre-policy squash era (`Title (#N)` commits whose
  bullets come from the squash body's `* ` lines), and the pre-PR era (direct
  commits, listed as a dated closing section).
- **Titles** come from the merge subject or body first line (HTML entities
  decoded); an empty merge body falls back to a humanized branch slug.
- **PR links** use a new `repo_url` config key
  (`SecondBrain.SiteConfig.repo_url/0`), beside `site_base_url`.

## The staleness carve-out (why the check is lag-tolerant)

A checked-in derivation of merge history has an inherent lag: a PR cannot
contain its own merge commit, so the file is always at least one PR behind
`main` the moment anything merges. Two mechanisms absorb this instead of
fighting it:

- **`mix brain.dev_history --check`** (CI + pre-commit) is *lag-tolerant*: a
  fresh derivation may carry newer sections the file lacks, but the preamble
  and every section the file does contain must match exactly — so hand edits
  and drift fail the gate while ordinary lag passes. On a shallow clone the
  check skips itself (and a plain run refuses to write a truncated history).
  Both CI workflows now check out with `fetch-depth: 0`.
- **The Pages build re-derives the doc before rendering**, so the page on the
  deployed site is always fully current — including the merge that triggered
  the deploy. The live page is the handy reference; the checked-in copy is the
  in-repo convenience.

## Scope boundaries

- Not a `log.md` and not hand-appendable: the reserved-filenames policy stands;
  the file carries the standard GENERATED-FILE header and is exempt from
  `attribution` like the other compiled views.
- No per-session regeneration obligation: freshness is structural (deploy-time
  re-derivation), not procedural. Any session *may* run `mix brain.dev_history`
  to refresh the checked-in copy, but nothing breaks if none does.
- Bullets are raw commit subjects, deliberately unedited — the commit messages
  are already the semantic change narrative; editorializing them here would
  re-introduce the craft this plan exists to avoid.

## Build order (all shipped in this plan's PR)

1. `SecondBrain.DevHistory` + `mix brain.dev_history [--check]`, with pure,
   unit-tested parsing/rendering (`test/second_brain/dev_history_test.exs`).
2. `repo_url` config + `SiteConfig.repo_url/0`; attribution exemption for the
   generated file.
3. The generated `meta/dev-history.md` itself; `meta/index.md` listing.
4. CI (`ci.yml`) lag-tolerant check + pre-commit hook line; Pages (`pages.yml`)
   full-history checkout and deploy-time re-derivation.
