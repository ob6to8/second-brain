---
id: sb:a9113e
type: concept
title: orphaned branch
description: In this brain's git workflow, a remote session branch left lingering after its work concluded — merged-but-undeleted (deletable on sight) or unmerged (never deleted without operator ratification); distinct from git's own parentless orphan branch.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, git, branches, workflow]
timestamp: 2026-07-11
---

# orphaned branch

In this brain's git workflow, a remote session branch left lingering after its work concluded. Two kinds with opposite handling under the [git-branch-deletion policy](/meta/policy/git-branch-deletion.md): **merged-but-undeleted** (fully contained in the default branch's history, so deletable on sight — nothing is lost) and **unmerged** (carrying commits with no other home — never deleted without operator ratification). A *false* orphan is an unmerged branch whose content already landed on `main` via a different branch, making it superseded rather than stranded. Distinct from git's own *orphan branch* (`git checkout --orphan`), a branch that starts with no parent history.

*Seen in:* [2026-07-11 branch-deletion/contract thread](/meta/threads/2026-07-11-branch-deletion-policy-and-contract-as-abstraction.md)
