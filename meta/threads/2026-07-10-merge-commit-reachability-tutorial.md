---
type: reference
title: 2026-07-10-merge-commit-reachability-tutorial
description: Turned a session quote — deliberately true-merging a port branch because PLAN.md cites its commits by SHA — into a git tutorial on reachability (why a true merge, not a squash, keeps cited commits permanently reachable after branch deletion), filed under meta/tutorials/.
provenance: "Claude Code session (claude-fable-5), 2026-07-10; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, tutorial, git, merge, reachability]
timestamp: 2026-07-10
pr: 36
---

# 2026-07-10-merge-commit-reachability-tutorial

## Where this landed

A single-task session: the operator supplied a quote from another session — an
agent explaining it had used a *true merge rather than a squash* on purpose,
because `PLAN.md` cites the port commits (`0fdee9e..e6ae1f9`) by SHA and the
merge commit keeps them permanently reachable from `main` after branch
deletion — and asked for a tutorial built around it. The quote was not found
in any captured thread in this repo (it comes from an external session; the
quote itself is the source). The result is
[why-a-true-merge-keeps-cited-commits-reachable](/meta/tutorials/why-a-true-merge-keeps-cited-commits-reachable.md):
a `type: tutorial` under `meta/tutorials/` unpacking git reachability (a
branch is a ref; deleting it removes a pointer, never commits), what each
merge strategy does to a branch's original SHAs, why lingering orphans on
GitHub make dead citations sneaky, and the rule that SHA citations in durable
documents make history load-bearing. Indexed, logged, all gates green,
committed (`d799808`) and pushed to `claude/merge-commit-tutorial-u1wnzo`.
This capture ran as step 1 of a `/create-pull-request` invocation, so the
thread doc ships in the same PR.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Tutorial: why a true merge (not a squash) keeps cited commits reachable | closed | [/meta/tutorials/why-a-true-merge-keeps-cited-commits-reachable.md](/meta/tutorials/why-a-true-merge-keeps-cited-commits-reachable.md) | - |
| Provenance of the quote (not in this repo's threads; external session) | closed | `unrouted` | - |
| Commit, push, and PR via `/create-pull-request` | closed | `unrouted` | - |

## User

Create a tutorial based around this quote from a thread:

"I used a true merge rather than a squash on purpose: PLAN.md cites the port commits (0fdee9e..e6ae1f9) as the reference for re-adoption, and the merge commit keeps them permanently reachable from main even after the branch is deleted. So the branch is now safe to delete whenever you like."

## Assistant

<routes ref="meta/tutorials/why-a-true-merge-keeps-cited-commits-reachable.md">
Done — the tutorial is written, filed, and pushed to `claude/merge-commit-tutorial-u1wnzo` (commit `d799808`).

**What I created:** [`meta/tutorials/why-a-true-merge-keeps-cited-commits-reachable.md`](meta/tutorials/why-a-true-merge-keeps-cited-commits-reachable.md) — a `type: tutorial` in the governance namespace (no `sb:` id, matching the other tutorials). It opens with the quote verbatim, then unpacks it in the same style as the existing git tutorial in the collection:

- **Reachability as the core mental model** — a branch is just a ref, deleting it removes a pointer rather than commits, and a commit survives as long as some permanent ref can walk parent pointers back to it.
- **What each GitHub merge strategy does to the branch's SHAs** — a true merge's second parent wires the branch's real history into `main`'s ancestry; squash lands one brand-new commit and leaves the originals orphaned; rebase recreates everything under new hashes so written-down SHAs point at abandoned objects.
- **The sneaky part** — orphaned commits linger (reflogs, GitHub's PR pages) so a dead citation keeps *looking* alive, but fresh clones only fetch reachable objects and GC eventually collects the rest.
- **The rule the quote embodies** — SHA citations in durable documents (like PLAN.md citing `0fdee9e..e6ae1f9` for re-adoption) make history load-bearing, so true-merge before deleting the branch; squash remains a fine default when nothing cites individual commits, and tagging the branch tip is the escape hatch under an enforced-squash workflow.

**Housekeeping per the contract:** added it to `meta/tutorials/index.md` and logged a dated entry in `meta/log.md`. All gates pass — `mix brain.verify`, `registry --check`, `contract --check`, `route_tags`, and the 78-test suite.

One note: I searched the captured threads for the quote and it isn't in this repo — it appears to come from a session (and a PLAN.md) in another codebase, so the tutorial cites the quote itself as its source rather than linking a thread doc. I didn't open a PR since you didn't ask for one; say the word (or `/create-pull-request`) if you want it opened.
</routes>
