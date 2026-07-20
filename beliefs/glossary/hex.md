---
id: em:11642d
type: concept
title: Hex
description: The package manager of the Erlang/Elixir ecosystem — a public registry (hex.pm) of versioned, checksummed packages that Mix and rebar3 resolve and fetch as dependencies, with API docs published alongside on hexdocs.pm.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, elixir, tooling, dependency]
sense: common
timestamp: 2026-07-17
attribution:
  when: 2026-07-17T18:10:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-17 library spin-out spec thread"
---

# Hex

Publishing is public by default — private packages require a paid
organization — which is why the
[spin-out plan](/meta/plans/library-spin-out-and-dependency-distribution.md)
stages distribution: a [git dependency](/beliefs/glossary/git-dependency.md)
pinned to release tags while `composable-beliefs-3` is private and its API is
settling, graduating to a Hex release only with a deliberate go-public
decision. A release on the registry is immutable and checksum-verified, and
consumers resolve it by semantic-version requirement
(`{:composable_beliefs_3, "~> 1.0"}`) recorded in the project's
[lockfile](/beliefs/glossary/lockfile.md).

*Seen in:* [2026-07-17 library spin-out spec thread](/meta/threads/2026-07-17-library-spin-out-spec.md)
