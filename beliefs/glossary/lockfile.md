---
id: em:6a6b46
type: concept
title: lockfile
description: A generated, committed file (mix.lock, package-lock.json, Cargo.lock) recording the exact resolved version and checksum of every dependency in a project, so every fetch reproduces the same tree regardless of when or where it runs.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, tooling, dependency, reproducibility]
sense: common
timestamp: 2026-07-17
attribution:
  when: 2026-07-17T18:10:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-17 library spin-out spec thread"
---

# lockfile

The lockfile is what softens the loss of the tooling's
[dependency-free](/beliefs/glossary/dependency-free.md) property in the
[spin-out plan](/meta/plans/library-spin-out-and-dependency-distribution.md):
once `mix.exs` pulls the library as a dep, a fresh sandbox needs one
`mix deps.get` — but the committed `mix.lock` pins precisely what that fetch
returns, CI caches it, and the SessionStart hook can run it so agents never
notice the step. It also carries the integrity half of the argument against
vendoring: a checksum-verified lock is stronger than a hand-copied archive.

*Seen in:* [2026-07-17 library spin-out spec thread](/meta/threads/2026-07-17-library-spin-out-spec.md)
