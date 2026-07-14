---
type: todo
title: "Triage the six kept unmerged claude/* branches"
description: Each of the six unmerged branches kept on 2026-07-11 ends up merged, superseded-and-deleted, or explicitly retired — none left in limbo.
status: open
tags: [meta, todo, git, branches]
timestamp: 2026-07-13
attribution:
  when: 2026-07-11T19:38:44+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-12-beam-jido-evaluation-and-dark-factory-scenario.md, /meta/threads/2026-07-13-orphaned-branch-cleanup-and-transplant-plan.md, /meta/threads/2026-07-13-execute-branch-transplant-ports.md]
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

**Second update, 2026-07-13 (later):** by the time the transplant work was
planned, parallel sessions had already merged and deleted most of the set. The
per-branch execution now lives in the
[transplant plan](/meta/plans/transplant-surviving-unmerged-branches.md); this
todo just records the final disposition:

- **`claude/code-review-docs-audit-j9ckd6`** — ✅ merged via its own PR, deleted.
- **`claude/epistemic-artifact-beliefs-eirk0n`** — ✅ merged to `main` by a
  parallel session (the Doyle/de Kleer/GSN captures, belief-decomposition
  analysis + plan, and glossary terms are all present under `knowledge/` and
  `meta/`), deleted. *This was the highest-value keep; it landed independently.*
- **`claude/repo-skills-namespacing-htu3lc`** — ✅ merged via PR #77
  (branch-lifecycle tutorial), deleted.
- **`claude/council-review-secondbrain-oq5e8o`** — ✅ merged via PR #76
  ([council-round-suitability analysis](/meta/analysis/council-round-suitability.md)),
  deleted.
- **`claude/git-fetch-merge-skill-ke7adg`** — ✅ **ported 2026-07-13**: the
  [`/sync-branch-with-main`](/.claude/skills/sync-branch-with-main/SKILL.md)
  skill + registry entry transplanted (PR #82), contract recompiled; its
  build-session record also rescued as
  [`2026-07-10-sync-branch-with-main-skill`](/meta/threads/2026-07-10-sync-branch-with-main-skill.md).
  Source branch now a **zero-loss** delete.
- **`claude/ccr-architecture-notes-csbiuv`** — ✅ **ported 2026-07-13**: the
  Chroma **product** intake landed at
  [`chroma-vector-database.md`](/knowledge/SWE/llm-engineering/chroma-vector-database.md)
  (`sb:ea15aa`), links repointed, cross-linked to `main`'s Chroma context-rot
  *research* concept. Source branch now safe to delete.
- **`claude/glossary-thread-docs-zwfk6i`** — ❌ false orphan; ratify deletion.
- **`claude/glossary-doctrine-policy-lkabog`** — ❌ false orphan (content landed
  via PR #40); ratify deletion.

**Done means:** every branch above is merged, deleted, or explicitly kept with a
reason. The two ports are executed (per the
[transplant plan](/meta/plans/transplant-surviving-unmerged-branches.md));
**remaining is operator-only**: delete the two false orphans
(`glossary-thread-docs`, `glossary-doctrine-policy`) and the two now-ported
source branches (`git-fetch-merge-skill`, `ccr-architecture-notes`).

---

*Original 2026-07-13 audit (superseded by the update above; kept for the record).*
The audit that produced these verdicts found `main` had been **reorganized**
(`SWE/` → `knowledge/SWE/`, `glossary/` → `beliefs/glossary/`, hand-kept logs
retired), so branches must be **transplanted** (docs copied onto a fresh branch
under the new layout, ids preserved), never plainly merged — a straight merge
would resurrect dead paths and `log.md` files.
