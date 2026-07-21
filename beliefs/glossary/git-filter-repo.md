---
id: em:8272bc
type: concept
title: git filter-repo
description: A history-rewriting tool that extracts or restructures a git repository by replaying its commits through path and content filters — the standard way to split a subdirectory out into its own repository while keeping that subtree's commit history.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, git, tooling, migration]
sense: common
timestamp: 2026-07-17
attribution:
  when: 2026-07-17T18:10:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-17 library spin-out spec thread"
---

# git filter-repo

The
[spin-out plan](/meta/plans/library-spin-out-and-dependency-distribution.md)'s
migration step 1 uses it to create `composable-beliefs-3` from this repo's
`lib/`, `test/`, `mix.exs`, and workflow files — so the library's own
commit → session provenance travels to its new home instead of starting from
an orphan initial commit. Crucially the rewrite happens only in the extracted
copy: this repo's history is untouched, which is what keeps its cited SHAs
and `pr:` anchors intact, per the
[merge-strategy policy](/meta/policy/merge-strategy.md)'s
provenance-layer reasoning.

*Seen in:* [2026-07-17 library spin-out spec thread](/meta/threads/2026-07-17-library-spin-out-spec.md)
