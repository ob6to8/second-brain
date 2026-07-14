---
id: em:7580df
type: concept
title: shallow clone
description: A git clone truncated to a limited commit depth (e.g. fetch-depth 1 in CI checkouts), which breaks tooling that derives views from full history unless the history is fetched or the tooling guards for it.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, git, ci]
sense: common
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T17:18:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-13 derived-dev-history thread"
---

# shallow clone

A git clone whose history is truncated to a limited depth rather than fetched
in full — the default for CI checkouts (`actions/checkout` fetches depth 1)
and common in sandboxes. `git rev-parse --is-shallow-repository` detects the
state, and `git fetch --unshallow` completes the history. Tooling that derives
views from history — like `mix brain.dev_history` reading the
[first-parent](/beliefs/glossary/first-parent-history.md) merge graph — would
silently truncate its output on a shallow clone, so it must either fetch full
history (`fetch-depth: 0` in the workflows) or guard: the dev-history task
skips its check and refuses to write when the clone is shallow.

*Seen in:* [2026-07-13 derived-dev-history thread](/meta/threads/2026-07-13-derived-dev-history-from-merge-graph.md)
