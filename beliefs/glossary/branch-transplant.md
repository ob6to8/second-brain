---
id: sb:7c6ca8
type: concept
title: branch transplant
description: Recovering the useful content from a stale unmerged branch by copying its docs onto a fresh branch cut from current main — under the current layout, ids preserved — rather than merging the branch, which would resurrect paths and files the mainline has since moved or deleted.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, git, branches, workflow, cleanup]
sense: repo
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T22:42:13Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary via /create-pull-request"
  why: "the technique named repeatedly while triaging the surviving unmerged branches against a reorganized main"
---

# branch transplant

Recovering the salvageable content from a stale, long-unmerged branch by **copying its docs onto a fresh branch cut from current `main`** — filed under the current directory layout, with stable `sb:` ids preserved (identity survives moves) — rather than merging the branch itself. The distinction matters when the mainline has been reorganized since the branch was cut: a plain merge would faithfully reintroduce the branch's now-dead paths and deleted files (in this brain, a pre-reorg branch would resurrect `SWE/` paths since moved under `knowledge/`, and retired `log.md` files), whereas a transplant brings only the wanted content forward into the new shape. The stale branch is then deleted, not merged. Distinct from a [true merge](/beliefs/glossary/true-merge.md) (which wires a branch's real history into the target) — a transplant deliberately abandons that history because it is no longer compatible with the target's structure.

*Seen in:* [2026-07-13 orphaned-branch cleanup thread](/meta/threads/2026-07-13-orphaned-branch-cleanup-and-transplant-plan.md)
