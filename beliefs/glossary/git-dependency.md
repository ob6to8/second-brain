---
id: em:15fa92
type: concept
title: git dependency
description: A project dependency fetched directly from a git repository — pinned to a tag, branch, or commit in the build file — rather than resolved from a package registry, trading registry conveniences for zero publishing ceremony and private-repo access through existing authentication.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, tooling, dependency, git]
sense: common
timestamp: 2026-07-17
attribution:
  when: 2026-07-17T18:10:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-17 library spin-out spec thread"
---

# git dependency

In Mix the form is
`{:composable_beliefs_3, github: "ob6to8/composable-beliefs-3", tag: "v0.2.0"}`:
cutting a release is just `git tag` + push, and the dep's `Mix.Tasks.*`
modules become available in the consuming project exactly as a
[Hex](/beliefs/glossary/hex.md) package's would. The
[spin-out plan](/meta/plans/library-spin-out-and-dependency-distribution.md)
adopts this as Stage A of distribution — right while the library's API is
still moving and the repo may stay private — with Hex publication as the
Stage B end state.

*Seen in:* [2026-07-17 library spin-out spec thread](/meta/threads/2026-07-17-library-spin-out-spec.md)
