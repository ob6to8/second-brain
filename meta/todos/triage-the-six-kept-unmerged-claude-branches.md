---
type: todo
title: "Triage the six kept unmerged claude/* branches"
description: Each of the six unmerged branches kept on 2026-07-11 ends up merged, superseded-and-deleted, or explicitly retired — none left in limbo.
status: open
tags: [meta, todo, git, branches]
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T19:38:44+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-12-beam-jido-evaluation-and-dark-factory-scenario.md]
---

# Triage the six kept unmerged claude/* branches

During the [orphaned-branches cleanup](/meta/issues/orphaned-remote-branches-cleanup.md)
the operator ratified **keeping** the six branches that carry commits not on
`main` (2026-07-11). Kept ≠ resolved: each still needs a final disposition.
What each holds, per a commit audit that day:

- **`claude/code-review-docs-audit-j9ckd6`** — substantial, active 2026-07-11:
  an `/elaborate` skill, a proposed `meta/elaborations/` genre + `elaboration`
  type, glossary additions (68 → 71), and a `code-review-toolchain-hardening`
  plan. Likely heading to its own PR — check before acting.
- **`claude/epistemic-artifact-beliefs-eirk0n`** — substantial, active
  2026-07-11: belief-decomposition analysis + plan, primary-source captures
  (Doyle 1979, de Kleer 1986, GSN), layered breakdowns, glossary terms. Likely
  heading to its own PR — check before acting.
- **`claude/git-fetch-merge-skill-ke7adg`** — a `/sync-branch-with-main` skill
  (2026-07-10) for merging `origin/main` into the working branch. Useful;
  revive as a PR.
- **`claude/repo-skills-namespacing-htu3lc`** — one tutorial on the agent's
  branch lifecycle across merged PRs (2026-07-10). Small: revive as a PR or
  ratify deletion.
- **`claude/ccr-architecture-notes-csbiuv`** — one Chroma intake (2026-07-08),
  the oldest straggler. Small: revive as a PR or ratify deletion.
- **`claude/glossary-thread-docs-zwfk6i`** — likely a *false* orphan: captures
  the glossary-backfill thread that landed on `main` via PR #37 from a
  different branch. Diff against `main`; if fully superseded, ratify deletion.

**Done means:** every branch above is merged, deleted (operator-ratified, per
the [git-branch-deletion policy](/meta/policy/git-branch-deletion.md)), or
explicitly kept with a reason recorded here.
