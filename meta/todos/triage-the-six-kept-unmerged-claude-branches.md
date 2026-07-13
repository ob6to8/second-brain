---
type: todo
title: "Triage the six kept unmerged claude/* branches"
description: Each of the six unmerged branches kept on 2026-07-11 ends up merged, superseded-and-deleted, or explicitly retired — none left in limbo.
status: open
tags: [meta, todo, git, branches]
timestamp: 2026-07-13
---

# Triage the six kept unmerged claude/* branches

During the [orphaned-branches cleanup](/meta/issues/orphaned-remote-branches-cleanup.md)
the operator ratified **keeping** the six branches that carry commits not on
`main` (2026-07-11). Kept ≠ resolved: each still needs a final disposition.

**Content audit, 2026-07-13** (per-branch diff against `main`). A structural
caveat applies to every "port" verdict below: `main` has since been
**reorganized** (`SWE/` → `knowledge/SWE/`, `glossary/` → `beliefs/glossary/`)
and the hand-kept logs retired, so these branches must **not** be plainly
merged — a straight merge would resurrect dead paths and `log.md` files. Useful
content is transplanted (copy the docs onto a fresh branch under the new
layout, re-mint nothing — ids travel), then the source branch's deletion is
ratified.

- **`claude/code-review-docs-audit-j9ckd6`** — ✅ **resolved**: merged via its
  own PR and deleted in the operator's 2026-07-13 cleanup.
- **`claude/epistemic-artifact-beliefs-eirk0n`** — **keep; highest value.**
  57 files / ~2,240 lines genuinely absent from `main`: primary-source captures
  (Doyle 1979, de Kleer 1986, GSN Standard v1), layered breakdowns of five
  prior-art references, a belief-decomposition analysis + plan, and ~29
  glossary terms. Directly feeds the active
  [epistemic-overlay plan](/meta/plans/epistemic-overlay.md). Needs a dedicated
  transplant session (reorg paths + the glossary has since been deduped).
- **`claude/git-fetch-merge-skill-ke7adg`** — **port (small).** A
  `/sync-branch-with-main` skill absent from `main` — exactly the merge-main
  motion sessions now do by hand. Port the skill + skills-registry entry,
  recompile the contract.
- **`claude/repo-skills-namespacing-htu3lc`** — **port (small).** A ~100-line
  tutorial, "the agent's branch lifecycle across merged PRs" (same designated
  name, fresh base, new PR each cycle; why auto-delete makes restarts clean) —
  absent from `main`, complements the true-merge tutorial and the
  branch-deletion policy.
- **`claude/ccr-architecture-notes-csbiuv`** — **port (small).** A 60-line
  Chroma vector-database intake; `main` has no Chroma concept (only passing
  mentions). Port to `knowledge/SWE/llm-engineering/`.
- **`claude/glossary-thread-docs-zwfk6i`** — ❌ **false orphan, confirmed;
  ratify deletion.** Its thread doc differs from `main`'s copy by one line;
  everything else (skill edits, glossary files, indexes) was long superseded
  by PR #37 and later glossary work. Nothing to salvage.

Two stray unmerged branches discovered in the same audit, outside the original
six:

- **`claude/glossary-doctrine-policy-lkabog`** — ❌ **false orphan; ratify
  deletion.** Its doctrine/policy-type entries, cross-linking convention, and
  thread doc all landed on `main` via PR #40 (pre-policy squash), which is why
  ancestry says "unmerged" while the content is present.
- **`claude/council-review-secondbrain-oq5e8o`** — **port (small).** A
  254-line analysis, "council-round protocol suitability" (verdict:
  integrate as a `/council` skill after four ratified bindings) — a decision
  record absent from `main`; belongs in `meta/analysis/`.

**Done means:** every branch above is merged, deleted (operator-ratified, per
the [git-branch-deletion policy](/meta/policy/git-branch-deletion.md)), or
explicitly kept with a reason recorded here. Remaining actions: one transplant
session for the four ports + the epistemic batch; operator ratifies deleting
the two false orphans (and each source branch once its content lands).
