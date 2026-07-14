---
id: sb:048bca
type: concept
title: deploy gating
description: Making a deployment conditional on prior verification passing, so only a validated artifact is published; when a check fails the publish is skipped and the last good deploy stays live (fails safe).
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, ci, deployment]
sense: common
timestamp: 2026-07-10
attribution:
  when: 2026-07-11T08:41:24+02:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# deploy gating

Making a deployment conditional on prior verification/integrity checks passing, so only a validated artifact is ever published. When a check fails the publish is skipped and the last good deploy stays live — the pipeline fails safe rather than shipping a broken build.

*Seen in:* [2026-07-09 live-render thread](/meta/threads/2026-07-09-live-render-appraisal-and-pages-hardening.md)
