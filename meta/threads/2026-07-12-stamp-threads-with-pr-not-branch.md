---
type: reference
title: 2026-07-12-stamp-threads-with-pr-not-branch
description: A reporting lapse (the create-pull-request wrap-up omitted the thread name) traced to substituting hand-work for the systematic skill step, which also dropped run.md's thread citation; resolved by recording each thread's durable PR anchor — retroactively matched from git and backfilled across all 25 threads, made a create-pull-request convention, with the branch deliberately not recorded.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-12; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped. Continuation of the docs-audit session captured in the 2026-07-12-docs-audit thread (PR #49); only this follow-up arc is rendered here."
tags: [meta, thread, provenance, threads, capture, pull-request, git]
timestamp: 2026-07-12
session: https://claude.ai/code/session_01Rjo8egdXArMpQQEp9CDwZY
pr: 51
---

# 2026-07-12-stamp-threads-with-pr-not-branch

## Where this landed

A follow-up to the docs-audit session (thread `2026-07-12-docs-audit…`, PR #49).
The operator noticed the `/create-pull-request` wrap-up never plainly stated the
thread doc's name. Auditing the cause surfaced a second, real miss — `run.md`
never got its docs-audit thread citation — both traced to the same root: in the
final stretch I substituted hand-work and memory for the systematic skill step
(step 2's `/add-to-glossary` pass was short-circuited into a hand-typed citation
loop that omitted `run`). The operator then asked whether a thread should record
its branch or just its PR, and whether threads could be retroactively matched to
PRs. Settled: record the **PR, not the branch** — the branch is ephemeral and
deleted after merge, and the pre-policy squash era left original branch commits
unreachable, so the PR number is the only durable anchor. Retroactive matching
is exact from git (the merge on `main`'s first-parent line that first makes a
thread's add-commit reachable, then the PR number from that subject); it resolved
all 25 threads and even corrected the glossary-backfill thread's own prose (it
says "#37" but landed via #38). Shipped: `pr:` backfilled across all 25 threads,
a new `session-capture` policy bullet, the `/create-pull-request` stamp step, a
`/capture` note, and the `run.md` citation fix.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Reporting lapse (thread name omitted) + root-cause diagnosis | closed | unrouted | - |
| run.md missing its docs-audit thread citation (citation fix, not a content route) | closed | unrouted | - |
| Record PR not branch; the durable-anchor argument | closed | [session-capture policy](/meta/policy/session-capture.md) | - |
| Retroactive thread→PR matching from git | closed | unrouted | - |
| `pr:` backfill + create-pull-request convention | closed | [session-capture policy](/meta/policy/session-capture.md) | - |

## User

I don't see where after calling /create-pull-request that you gave me the branch name. What led to the lapse, and could it indicate that other things were missed too

## User

My mistake, I meant to say thread name instead of branch name. That said, maybe we want to log the branch. And meanwhile, I'm still needing the thread name.

## Assistant

<routes ref="meta/policy/session-capture.md">
Got it — and sorry for the runaround. Here it is plainly:

**Thread name:** `meta/threads/2026-07-12-docs-audit-wiki-verdict-and-freshness-warnings.md`

That's the frozen record of this whole session (audit → wiki verdict → Tier-1/Tier-2 work → glossary → the merge). It's live on `main`.
</routes>

## User

Do we actually need the branch stamped, or can we just use the PR given that we are going to be delete... deleting branches once they've been merged?

Would you be able to retroactively match up threads to PRs and stamp the threads with the PR name?

## Assistant

<routes ref="meta/policy/session-capture.md">
Good instinct on both counts. On the first: I agree — stamp the PR, not the branch. The branch is ephemeral and gets deleted after merge, so its name is worthless the moment the merge lands; the PR number (and the merge commit it produces) is the durable anchor that stays reachable forever under the true-merge policy. So the field should be `pr:`, not `branch:`.
</routes>

<routes ref="meta/policy/session-capture.md">
On the second — yes, this is retroactively recoverable from git, no guessing. Each thread doc was added in some commit, and the first-parent merge that carried that commit into `main` is its PR. The naive walk collides (three threads can't all be PR #42) because it gets fooled by intermediate "merge main into branch" commits; the correct question is which merge on `main`'s first-parent line first makes the thread's add-commit reachable. That resolves all 25 cleanly and even caught the glossary-backfill thread's prose saying #37 when it actually landed via #38 — the git-derived truth is more reliable than the docs' self-report.
</routes>

*(The session closed by shipping the change via `/create-pull-request`: the
backfill, the convention, this capture, and the PR stamp were produced after the
last retained exchange.)*
