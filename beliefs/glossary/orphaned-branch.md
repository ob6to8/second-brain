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

**In this brain:** a remote session branch left lingering after its work concluded. Two kinds with opposite handling under the [git-branch-deletion policy](/meta/policy/git-branch-deletion.md): **merged-but-undeleted** (fully contained in the default branch's history, so deletable on sight — nothing is lost) and **unmerged** (carrying commits with no other home — never deleted without operator ratification). A *false* orphan is an unmerged branch whose content already landed on `main` via a different branch, making it superseded rather than stranded.

*Seen in:* [2026-07-11 branch-deletion/contract thread](/meta/threads/2026-07-11-branch-deletion-policy-and-contract-as-abstraction.md)
