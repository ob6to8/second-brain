---
type: plan
title: "Transplant the salvageable content from the surviving unmerged claude/* branches"
description: Recover the genuinely-absent content from the surviving unmerged session branches by transplanting it onto the reorganized main (never plain-merging, which would resurrect dead paths). As of filing, most of the audited set has since merged via other sessions — only two small ports (Chroma intake, /sync-branch-with-main skill) and two false-orphan deletions remain to close the orphaned-branches cleanup.
status: proposed
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-13 — commissioned by the operator after a per-branch content audit of the surviving unmerged branches (recorded in the triage todo)"
tags: [meta, plan, git, branches, cleanup, transplant]
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T22:42:13Z
  channel: agent-authored
  agent: "Claude Code agent, branch-cleanup triage session"
  why: "records the remaining branch-transplant work identified in the orphaned-branches audit, so a future session can execute it"
  from: [/meta/threads/2026-07-13-orphaned-branch-cleanup-and-transplant-plan.md]
---

# Transplant the salvageable content from the surviving unmerged `claude/*` branches

## Status & provenance

**Proposed** — commissioned 2026-07-13 immediately after the content audit
recorded in the
[triage todo](/meta/todos/triage-the-six-kept-unmerged-claude-branches.md).
Executes the "port" verdicts from that audit and closes the loop opened by the
[orphaned-remote-branches issue](/meta/issues/orphaned-remote-branches-cleanup.md).

**Scope shrank on filing.** When this plan was merged with `main`, several of the
audited branches had *already* been resolved by parallel sessions and deleted:
the large **epistemic batch** (`epistemic-artifact-beliefs`) landed on `main`
(Doyle 1979 / de Kleer 1986 / GSN captures, the belief-decomposition
analysis + plan, glossary terms — all present under `knowledge/` and `meta/`),
and two of the four small ports merged too — **`repo-skills-namespacing`**
(PR #77) and **`council-review-secondbrain`** (PR #76, the council-round
analysis). What remains is **two small ports** and **two false-orphan
deletions** (below).

## 1. The problem

Six unmerged `claude/*` branches survived the 2026-07-13 merged-branch deletion.
An audit found real, `main`-absent content on five of them (plus one stray), but
they **cannot be plain-merged**: `main` was reorganized after they were cut
(`SWE/` → `knowledge/SWE/`, `glossary/` → `beliefs/glossary/`, hand-kept
`log.md` files retired). A straight merge would resurrect dead paths and deleted
log files. Each salvage is therefore a **transplant**: copy the useful docs onto
a fresh branch under the new layout, preserving `sb:` ids (identity survives
moves — never re-mint), file by the current tree, and let the source branch be
deleted once its content lands.

## 2. The work, per branch

Verdicts and sizing from the audit (see the triage todo for the full reasoning).

### Ports — bring the content forward (the remaining work)

- **`ccr-architecture-notes-csbiuv`** (small) — a 60-line Chroma
  vector-database **product** intake (`sb:ea15aa`). Transplant to
  `knowledge/SWE/llm-engineering/`; update that dir's `index.md`. `main` now
  carries a *distinct* Chroma concept —
  `knowledge/SWE/agentic/context-engineering/context-rot-chroma-research.md`
  (Chroma's context-rot *study*, not the database) — so cross-link the two
  rather than treating either as a duplicate.
- **`git-fetch-merge-skill-ke7adg`** (small) — the `/sync-branch-with-main`
  skill for merging `origin/main` into the working branch (genuinely absent
  from `main`). Port the `.claude/skills/sync-branch-with-main/SKILL.md` and add
  its entry to the skills-registry policy; recompile the contract
  (`mix brain.contract`). **Check first** whether the
  [skills-registry-compile plan](/meta/plans/compile-skills-registry-from-skill-frontmatter.md)
  has since changed how skills register.

### Already landed (no action — recorded for the audit trail)

- **`epistemic-artifact-beliefs-eirk0n`** — merged to `main` by a parallel
  session; the captures, analysis, plan, and glossary terms are all present.
- **`repo-skills-namespacing-htu3lc`** — merged via PR #77 (branch-lifecycle
  tutorial).
- **`council-review-secondbrain-oq5e8o`** — merged via PR #76
  ([council-round-suitability analysis](/meta/analysis/council-round-suitability.md)).
- **`code-review-docs-audit-j9ckd6`** — merged via its own PR earlier.

### False orphans — ratify deletion, salvage nothing

- **`glossary-thread-docs-zwfk6i`** — its thread doc differs from `main`'s copy
  by one line; the rest was superseded by PR #37 and later glossary work.
- **`glossary-doctrine-policy-lkabog`** (stray) — its doctrine/policy-type
  entries, cross-linking convention, and thread all landed via PR #40 (a
  pre-policy squash merge), which is why ancestry reports "unmerged" while the
  content is present.

## 3. Build order

1. **Small ports batch** (one session): transplant the two remaining port
   branches' content (Chroma intake, `/sync-branch-with-main` skill) onto a
   fresh branch under the current layout, preserving ids, updating each affected
   `index.md`, recompiling the contract for the skill. Gates: `mix brain.verify`,
   `mix brain.registry --check`, `mix brain.route_tags`,
   `mix brain.contract --check`, `mix test`. One PR.
2. **Operator ratifies deleting** the two false orphans (`glossary-thread-docs`,
   `glossary-doctrine-policy`) and each port's source branch once its content
   lands. Agents cannot delete refs in this environment (HTTP 403) — deletion is
   an operator step.
3. **Close the orphaned-branches issue** once the two ports land, the two false
   orphans are deleted, and the "Automatically delete head branches" repo setting
   is confirmed on. (The epistemic batch and the `repo-skills`/`council` ports
   already merged — no action.)

## 4. Scope boundary

This plan **recovers content and retires branches**; it does not adopt any
proposal the recovered docs contain. The `/sync-branch-with-main` skill files as
a skill (it is procedure, already scoped); the council analysis's `/council`
recommendation and the epistemic batch's plan remain separate ratification
decisions.

## Deferred

- Building the `/council` skill (a separate decision gated on the four bindings
  the now-merged [council analysis](/meta/analysis/council-round-suitability.md)
  names).
- Acting on the epistemic-overlay / belief-decomposition plans (their docs have
  landed on `main`; execution is tracked by those plans themselves).
