---
id: sb:ff1ede
type: concept
title: force-with-lease
description: A safer git force-push (`git push --force-with-lease`) that overwrites the remote branch only if its current tip still matches what the pusher last saw, refusing the push if someone else advanced it in between.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, git]
sense: common
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T00:00:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the branch-lifecycle tutorial and main-catchup thread"
---

# force-with-lease

A guarded variant of `git push --force`. A plain force-push overwrites the remote branch unconditionally, silently discarding any commits someone else pushed since you fetched; `--force-with-lease` first checks that the remote tip is still the value you last observed (your "lease" on it) and refuses the push otherwise. It is the safe way to replace a branch's history — for example when a session [restarts its designated branch](/meta/tutorials/branch-lifecycle-across-merged-prs.md) from the default branch and must overwrite a stale, already-merged remote tip — because it fails loudly instead of clobbering unseen work.

*Seen in:* [2026-07-13 branch-lifecycle tutorial and main catch-up](/meta/threads/2026-07-13-branch-lifecycle-tutorial-and-main-catchup.md)
