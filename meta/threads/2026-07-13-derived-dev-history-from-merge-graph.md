---
type: reference
title: 2026-07-13-derived-dev-history-from-merge-graph
description: The operator asked for a per-PR overview of development progress without re-introducing the hand-crafted log; the session designed and built mix brain.dev_history, which derives the generated meta/dev-history.md from the default branch's first-parent merge graph, with a lag-tolerant CI check and deploy-time re-derivation for the Pages copy.
provenance: "Claude Code session, 2026-07-13; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, dev-history, generated-artifact, merge-graph, tooling]
timestamp: 2026-07-13
pr: 69
---

# 2026-07-13-derived-dev-history-from-merge-graph

## Where this landed

The operator wanted the retired hand-kept log's convenience — a bulleted
overview of features and progress per PR — without its craft. The session
resolved this as a derivation, not a document: the
[merge-strategy policy](/meta/policy/merge-strategy.md) already guarantees the
data (one first-parent commit per PR; branch commits reachable through the true
merge), so `mix brain.dev_history` (`SecondBrain.DevHistory`) compiles the
generated [`meta/dev-history.md`](/meta/dev-history.md) from the merge graph on
the same discipline as `CLAUDE.md` and `meta/registry.md`. All three history
eras are handled (true merges, the pre-policy squash era, the pre-PR
direct-commit era); the `--check` gate is lag-tolerant because a checked-in
derivation cannot contain the merge that ships it; and the Pages build
re-derives the doc at deploy time so the live page is always current. The
design is persisted as the
[derived-dev-history plan](/meta/plans/derived-dev-history.md)
(`status: done`), everything was built, gated green, committed, and pushed in
the same session, and the session closed via `/create-pull-request`.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Derived dev history: `mix brain.dev_history` + generated `meta/dev-history.md` | closed | [derived-dev-history plan](/meta/plans/derived-dev-history.md) | - |
| Freshness of the checked-in copy (lag-tolerant check; deploy-time re-derivation) | closed | [derived-dev-history plan](/meta/plans/derived-dev-history.md) | - |

## User

<routes ref="/meta/plans/derived-dev-history.md">
While being fully aware that we recently removed the log document from the repo, I am finding myself wanting to look at an overview of recent development without needing to pour through pull requests in GitHub. Might it be possible to avoid the craft that was created with the last log, but somehow derive a Dev history of bullet point features and progress that have been implemented per PR and keep that in the log for handy reference?
</routes>

## Assistant

<routes ref="/meta/plans/derived-dev-history.md lib/second_brain/dev_history.ex">
The retired hand-kept log doesn't rule this out — what was retired was *hand-written* history; generated artifacts (like `meta/registry.md` and `CLAUDE.md`) are explicitly fine. So the natural shape is a **derived** dev-history doc compiled from the merge commits on `main` (`git log --first-parent`), which is exactly the per-PR record the merge-strategy policy preserves. Let me look at the existing tooling to see how to build this consistently.

This is very buildable, and there's already a matching pattern in the repo: generated artifacts derived from canonical sources (`registry.md`, `lineage.md`). Here the canonical source is the **git merge history itself** — `git log --first-parent main` gives exactly one line per PR, and each merge's branch commits give the bullet points. No hand-crafting; a `mix brain.dev_history` task derives the whole doc. Let me check the remaining details (CI checkout depth, verifier exclusions, non-merge commits on main).

The history has three eras I need to handle: true merge commits ("Merge pull request #N"), a pre-policy squash era (`Title (#40)` directly on main), and an early pre-PR era of direct commits (the legacy "Assertion Graph" work). Let me check the squash commit bodies, the remote URL, and the index files I'll need to update.

Everything's in place. The design writes itself from the repo's own conventions: a generated `meta/dev-history.md` (same discipline as `registry.md` and `lineage.md`), derived entirely from the merge graph — the very thing the merge-strategy policy preserves as the provenance layer. No hand-crafting; `mix brain.dev_history` re-derives it, and the Pages build regenerates it at deploy so the live site page is always current. Building it now.
</routes>

<routes ref="/meta/plans/derived-dev-history.md lib/second_brain/dev_history.ex meta/dev-history.md">
Yes — and it's built and pushed to `claude/dev-history-log-0nfdtf`. The key insight is that the craft of the old log isn't needed, because the data already exists in exactly the shape you want: the true-merge policy means `git log --first-parent` reads as one commit per PR, and each merge keeps its branch's deliberately-messaged commits reachable forever. So the dev history is now a **derived artifact**, on the same discipline as `CLAUDE.md` and `meta/registry.md` — never hand-written, always regenerable.

What shipped:

- **`mix brain.dev_history`** derives `meta/dev-history.md`: one section per merged PR, newest first — linked PR number, title, merge date — with the branch's commit subjects as bullets. It handles all three eras of the repo's history: true merges (bullets from the merge's second parent), the pre-policy squash era (bullets recovered from the squash bodies), and the pre-PR "Assertion Graph" era as a dated closing section. 67 PRs rendered on first derivation.
- **A lag-tolerant `--check`** in CI and the pre-commit hook. A checked-in derivation is inherently one PR behind (a PR can't contain its own merge commit), so the check tolerates missing *newer* sections but fails on any hand-edit or drift in what the file does contain. Shallow clones skip the check rather than derive a truncated history.
- **Always-current on the site**: `pages.yml` now checks out full history and re-derives the doc right before the site build, so once this merges, the page at https://ob6to8.github.io/second-brain/meta/dev-history.html will always include even the merge that triggered the deploy. The checked-in copy is the in-repo convenience.
- The design rationale is persisted per the persist-plans policy (will render at https://ob6to8.github.io/second-brain/meta/plans/derived-dev-history.html after merge), the generated file is exempted from attribution like the other compiled views, and PR links come from a new `repo_url` config key beside `site_base_url`.

The full CI-equivalent gate runs green locally (156 tests, 15 of them new; contract, registry, verify, route tags, lineage, and the new check all pass — the one advisory warning is the plan doc's missing `attribution.from`, which `/create-pull-request` stamps once the session thread is captured). One deliberate boundary: the bullets are raw commit subjects, unedited — editorializing them would re-introduce the craft this exists to avoid. No PR opened; say the word (or `/create-pull-request`) when you want one.
</routes>
