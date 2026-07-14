---
id: sb:a9113e
type: concept
title: orphaned branch
description: In this brain's git workflow, a remote session branch left lingering after its work concluded — merged-but-undeleted (deletable on sight) or unmerged (never deleted without operator ratification); distinct from git's own parentless orphan branch.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, git, branches, workflow]
sense: dual
timestamp: 2026-07-13
attribution:
  when: 2026-07-11T20:15:23+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# orphaned branch

In git generally, an *orphan branch* is one created with `git checkout --orphan`: a branch that starts with no parent history, disconnected from every existing commit.

**In this brain:** a remote session branch left lingering after its work concluded. Two kinds with opposite handling under the [git-branch-deletion policy](/meta/policy/git-branch-deletion.md): **merged-but-undeleted** (fully contained in the default branch's history, so deletable on sight — nothing is lost) and **unmerged** (carrying commits with no other home — never deleted without operator ratification). A *false* orphan is an unmerged branch whose content already landed on `main` via a different branch — most often because a **[squash merge](/beliefs/glossary/squash-merge.md)** replayed the content as one new commit, so git ancestry reports the original branch as unmerged while its content is fully present — making it superseded rather than stranded. Salvageable true orphans are recovered by [branch transplant](/beliefs/glossary/branch-transplant.md), not merge, when the mainline has since been reorganized. A practical consequence: both false orphans and transplanted branches show a **nonzero "ahead" count forever** (their commits never entered `main`'s ancestry), so the "delete when Ahead is 0" heuristic — valid only for [true-merged](/beliefs/glossary/true-merge.md) branches — cannot clear them; that they are safe to delete is established by the content audit, not the count, which is exactly why the policy routes them through operator ratification.

*Seen in:* [2026-07-11 branch-deletion/contract thread](/meta/threads/2026-07-11-branch-deletion-policy-and-contract-as-abstraction.md), [2026-07-13 orphaned-branch cleanup thread](/meta/threads/2026-07-13-orphaned-branch-cleanup-and-transplant-plan.md)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="sb:a9113e">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-13-orphaned-branch-cleanup-and-transplant-plan (2026-07-13)

2 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`sb:a9113e`]**

Reading the five rows you're showing:

- **Row 5 — PR #46 (purple merged icon), 7 behind / 0 ahead** — that's today's `branch-deletion-policy` branch. ✅ Safe, delete.
- **Row 3 — PR #47 (purple merged icon), 1 behind / 0 ahead** — another already-merged one. ✅ Safe, delete.
- **Row 1 — PR #48 (green icon = OPEN pull request), 14 ahead, updated 2 minutes ago** — ❌ do **not** delete; that's a live PR from another session, and the green badge means it hasn't merged.
- **Rows 2 and 4 — no PR badge, 5 ahead and 1 ahead, active minutes ago** — ❌ don't touch; ahead > 0 means unmerged commits (these are active sessions and/or the six branches you ratified keeping).

---

**[`sb:a9113e`]**  (co-feeds: `meta/todos/triage-the-six-kept-unmerged-claude-branches.md`)

**Worth saving — one big, four small:**

- **`epistemic-artifact-beliefs`** — the high-value one: 57 files / ~2,240 lines genuinely absent from `main`. Primary-source captures (Doyle 1979, de Kleer 1986, GSN Standard), layered breakdowns of five prior-art references, a belief-decomposition analysis + plan, and ~29 glossary terms. It directly feeds your active epistemic-overlay plan. Deserves its own dedicated transplant session (the glossary has since been deduped, so its 29 terms need reconciling).
- **`git-fetch-merge-skill`** — a `/sync-branch-with-main` skill that doesn't exist on `main`; it's exactly the merge-main motion sessions keep doing by hand. Small port.
- **`ccr-architecture-notes`** — a 60-line Chroma vector-database intake; `main` has no Chroma concept, only passing mentions. Small port.
- **`repo-skills-namespacing`** — a ~100-line tutorial on the agent's branch lifecycle across merged PRs (same branch name, fresh base, new PR each cycle) — literally documents what we've been doing today. Small port.
- **`council-review-secondbrain`** (a stray outside the original six) — a 254-line analysis concluding a "council round" adversarial-review protocol should become a `/council` skill after four ratified bindings. A decision record worth keeping.

**Confirmed false orphans — nothing to salvage, ratify deletion:**

- **`glossary-thread-docs`** — its thread doc differs from `main`'s copy by literally one line; the rest was superseded by PR #37. 
- **`glossary-doctrine-policy`** (the other stray) — its doctrine/policy-type entries and thread all landed via PR #40, a pre-policy squash merge, which is why git ancestry claims it's unmerged.
