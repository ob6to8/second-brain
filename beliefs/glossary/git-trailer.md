---
id: em:816d17
type: concept
title: git trailer
description: A `Key: value` line in the trailing block of a git commit message — machine-parseable metadata (e.g. `Co-authored-by:`, `Signed-off-by:`, `Claude-Session:`) that travels inside the commit itself rather than in a sidecar file.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, git, provenance, metadata]
sense: common
timestamp: 2026-07-23
attribution:
  when: 2026-07-19T15:27:08Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-19 session-URL-persistence thread (the operator asked what a git trailer is)"
---

# git trailer

Modeled on email headers: a block of `Key: value` lines at the end of a commit
message. They are ordinary message text with no special storage, but git parses
the trailing block specially — `git interpret-trailers` reads and writes it, and
`git log --format='%(trailers:key=...)'` extracts a given key mechanically, so the
metadata is queryable without a separate file.

In this brain's git workflow the load-bearing instance is the **`Claude-Session:`**
trailer, which Claude Code injects automatically into commits it authors in a web
session, linking each commit to the cloud session's
[transcript](/beliefs/glossary/session-transcript.md) that produced it. That link is
what makes the commit graph a [provenance](/beliefs/glossary/provenance.md) layer and
is one reason merges must be [true merges](/beliefs/glossary/true-merge.md) — a squash
would abandon the trailered commits.

*Seen in:* [2026-07-19 session-URL-persistence thread](/meta/threads/2026-07-19-session-url-persistence-and-plan-vs-capture-policy.md), [2026-07-23 dev-history-drift thread](/meta/threads/2026-07-23-dev-history-drift-and-regeneration-flow.md)
