---
type: reference
title: 2026-07-13-orphaned-branch-cleanup-and-transplant-plan
description: Closed out the operator side of the orphaned-branch cleanup — located the auto-delete setting, gave the Ahead-0 deletion rule over a branches screenshot, then audited every surviving unmerged branch for main-absent content — and filed a transplant plan for the remainder, which a mid-session merge with main revealed had already shrunk (epistemic batch + two ports merged by parallel sessions).
provenance: "Claude Code session (Claude Opus 4.8, with earlier turns as Claude Fable 5), 2026-07-13; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, git, branches, cleanup, transplant, orphaned-branch]
timestamp: 2026-07-13
pr: 81
---

# 2026-07-13-orphaned-branch-cleanup-and-transplant-plan

## Where this landed

A continuation of the branch-deletion-policy session after PR #46 merged. Three
matters: (1) the operator asked where the "Automatically delete head branches"
setting lives and, over a screenshot of the GitHub branches view, got the
**Ahead-0 rule** for deciding which branches are safe to delete (Ahead = commits
only on that branch; 0 means fully contained in `main`). (2) After the operator
deleted the merged branches, an **audit** of every surviving unmerged branch
sorted them into ports (real `main`-absent content), false orphans (content
already landed via pre-policy squash merges), and active-session branches to
leave alone — persisted into the triage todo and the issue. (3) The operator
commissioned a **transplant plan** for the remaining work; pulling `main` mid-way
revealed it had already shrunk — the large epistemic batch and two of the four
ports (`repo-skills-namespacing` PR #77, `council-review` PR #76) had merged via
parallel sessions — leaving two small ports (Chroma product intake,
`/sync-branch-with-main` skill) and two false-orphan deletions. A structural
caveat runs through it all: `main` was reorganized (`SWE/` → `knowledge/SWE/`,
`glossary/` → `beliefs/glossary/`, hand-kept logs retired), so these branches
must be **transplanted**, never plain-merged.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Where the auto-delete-head-branches setting lives | closed | `unrouted` | - |
| Ahead-0 rule for safe branch deletion | closed | [orphaned branch](/beliefs/glossary/orphaned-branch.md) | - |
| Audit of surviving unmerged branches | closed | [orphaned branch](/beliefs/glossary/orphaned-branch.md) · [triage todo](/meta/todos/triage-the-six-kept-unmerged-claude-branches.md) | - |
| Transplant plan for remaining work | open | [transplant plan](/meta/plans/transplant-surviving-unmerged-branches.md) | Two ports to execute; two false orphans for operator to delete |
| Orphaned-branches issue close-out | open | [issue](/meta/issues/orphaned-remote-branches-cleanup.md) | Resolves once ports land, false orphans deleted, auto-delete setting confirmed on |

## User

Where can i find that setting

## Assistant

It's in the repo's settings on GitHub, under the Pull Requests section:

1. Go to **https://github.com/ob6to8/second-brain/settings** (or from the repo page: the **Settings** tab, far right — visible only because you're the owner/admin).
2. You land on the **General** section. Scroll down to the **Pull Requests** heading — the same block where squash/rebase merging was disabled earlier today.
3. Near the bottom of that block, check **"Automatically delete head branches"**. It saves immediately, no confirm button.

One caveat: it only applies to PRs merged *from then on* — it won't retroactively clean up the 16 already-merged branches (the 15 in the issue plus `claude/branch-deletion-policy-kvzm25` from today's merge). For those, the quickest path is **https://github.com/ob6to8/second-brain/branches** — merged branches show a red trash icon you can click one by one — or run the `git push origin --delete …` command recorded in the issue from any machine where you're authenticated as yourself.

Once you've flipped the setting and cleared the backlog, say the word in a future session and the agent can verify the remote is clean and flip the issue to `resolved`.

## User

*(screenshot of the GitHub "Your branches" view)* I don't see a red trash icon, but i can see the branches that have been merged via pr - should i delete those?

## Assistant

Yes — but not all of them, and your screenshot is exactly why I'd have you use one simple rule rather than "has a PR badge": **delete a row only if its "Ahead" count is 0.** Ahead = commits that exist only on that branch; 0 means it's fully contained in `main` and deletion loses nothing. (The trash icon is the grey one on the right — it only turns red on hover; clicking deletes immediately, with a "Restore" undo appearing in place.)

<routes ref="em:a9113e">
Reading the five rows you're showing:

- **Row 5 — PR #46 (purple merged icon), 7 behind / 0 ahead** — that's today's `branch-deletion-policy` branch. ✅ Safe, delete.
- **Row 3 — PR #47 (purple merged icon), 1 behind / 0 ahead** — another already-merged one. ✅ Safe, delete.
- **Row 1 — PR #48 (green icon = OPEN pull request), 14 ahead, updated 2 minutes ago** — ❌ do **not** delete; that's a live PR from another session, and the green badge means it hasn't merged.
- **Rows 2 and 4 — no PR badge, 5 ahead and 1 ahead, active minutes ago** — ❌ don't touch; ahead > 0 means unmerged commits (these are active sessions and/or the six branches you ratified keeping).
</routes>

The 15 older merged branches from the issue probably aren't in this "Your branches" view — click **"View more branches"** and use the **Stale** or **All** tabs; same rule applies there (purple merged badge and/or Ahead 0 → trash). The authoritative names are listed in the issue (`meta/issues/orphaned-remote-branches-cleanup.md`) if you want to tick them off, and the six to *keep* are named in the triage todo.

Also worth noting: PRs #47 and #48 are news to me — other sessions have kept shipping since our merge, which is all the more reason to lean on the Ahead-0 rule rather than memory. Once you've cleared the stale set and flipped the auto-delete setting (Settings → General → Pull Requests), have any future session re-audit and mark the issue resolved.

## User

Ok have deleted ahead:0 branches. Are you able to investigate specific branches Determine if there is mergeable useful information?
Continue from where you left off.

## Assistant

Investigation complete — here's the verdict on every surviving unmerged branch. Yes, there is genuinely mergeable material, but with one structural caveat that changes how it must land: **`main` has been reorganized since these branches were cut** (`SWE/` → `knowledge/`, `glossary/` → `beliefs/glossary/`, hand-kept logs retired), so none of them can be plainly merged — a straight merge would resurrect dead paths. Useful content gets *transplanted* onto a fresh branch under the new layout instead.

<routes ref="em:a9113e meta/todos/triage-the-six-kept-unmerged-claude-branches.md">
**Worth saving — one big, four small:**

- **`epistemic-artifact-beliefs`** — the high-value one: 57 files / ~2,240 lines genuinely absent from `main`. Primary-source captures (Doyle 1979, de Kleer 1986, GSN Standard), layered breakdowns of five prior-art references, a belief-decomposition analysis + plan, and ~29 glossary terms. It directly feeds your active epistemic-overlay plan. Deserves its own dedicated transplant session (the glossary has since been deduped, so its 29 terms need reconciling).
- **`git-fetch-merge-skill`** — a `/sync-branch-with-main` skill that doesn't exist on `main`; it's exactly the merge-main motion sessions keep doing by hand. Small port.
- **`ccr-architecture-notes`** — a 60-line Chroma vector-database intake; `main` has no Chroma concept, only passing mentions. Small port.
- **`repo-skills-namespacing`** — a ~100-line tutorial on the agent's branch lifecycle across merged PRs (same branch name, fresh base, new PR each cycle) — literally documents what we've been doing today. Small port.
- **`council-review-secondbrain`** (a stray outside the original six) — a 254-line analysis concluding a "council round" adversarial-review protocol should become a `/council` skill after four ratified bindings. A decision record worth keeping.

**Confirmed false orphans — nothing to salvage, ratify deletion:**

- **`glossary-thread-docs`** — its thread doc differs from `main`'s copy by literally one line; the rest was superseded by PR #37. 
- **`glossary-doctrine-policy`** (the other stray) — its doctrine/policy-type entries and thread all landed via PR #40, a pre-policy squash merge, which is why git ancestry claims it's unmerged.
</routes>

**Already resolved en route:** `code-review-docs-audit` merged via its own PR and was deleted in your cleanup. The four branches from active sessions (`concept-definition-review`, `glossary-dedup-check`, `rename-second-brain-elixir`, `resource-attribution-spec`) I left strictly alone — they're live work, some updated today.

All of this is persisted: the triage todo now carries the per-branch verdicts and the no-plain-merge caveat, and the issue records your 2026-07-13 deletion as executed — it now resolves on one remaining confirmation, that the auto-delete setting is on. Committed to the recreated `claude/branch-deletion-policy-kvzm25` (fresh from `main`, per the branch-lifecycle model) and pushed as `7711fbd`.

Two natural next steps, your call: I can **execute the four small ports right now** on this branch (Chroma intake, sync skill, lifecycle tutorial, council analysis — transplanted to the new layout, gates run), and/or open the PR for what's committed. The epistemic batch I'd leave for its own session either way.

## User

*(switched model to claude-opus-4-8)* Create a plan for all remaining work
Then pull main and merge in
Commit
Then run /create-pull-request

## Assistant

<routes ref="meta/plans/transplant-surviving-unmerged-branches.md meta/issues/orphaned-remote-branches-cleanup.md">
The picture collapsed favorably — four of my flagged branches (including the big epistemic batch) merged and were deleted by other sessions. Both remaining ports are genuinely still absent from main (the Chroma *product* intake is distinct from main's Chroma *context-rot research* concept). I updated the plan I just wrote to reflect what the merge revealed — the epistemic batch and two ports already landed via other sessions — so the transplant plan, its index entry, and the triage todo now record the true remaining scope: two small ports (Chroma product intake, `/sync-branch-with-main` skill) plus two false-orphan deletions.
</routes>

The merge required resolving two conflicts — the triage todo and the orphaned-branches issue both had `attribution` blocks added on `main` (a new resource-attribution policy landed while we worked), which I combined with this session's content updates. All gates pass on the merged tree (156 tests). The new plan needed the now-required `attribution` block; its `from` back-link is stamped by this `/create-pull-request` run.

## Assistant

*(This capture, the glossary pass, and the PR are `/create-pull-request` executing.)*
