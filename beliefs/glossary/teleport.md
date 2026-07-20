---
id: em:f5710f
type: concept
title: teleport
description: Moving a Claude Code cloud session into a local terminal with `claude --teleport`, carrying the session's context so the work continues locally.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, claude-code, session]
sense: common
timestamp: 2026-07-19
attribution:
  when: 2026-07-19T15:27:08Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-19 session-URL-persistence thread (session-resume mechanics)"
---

# teleport

One of the ways to continue an existing session: rather than resuming it in the web
UI, `claude --teleport <session-id>` pulls a cloud session down into the local
terminal with its [transcript](/beliefs/glossary/session-transcript.md) as context, so
the same conversation carries on locally. Commits made after the move are ordinary
local commits — they carry no `Claude-Session:` trailer, since the work past the
teleport point no longer runs on the cloud session it came from.

*Seen in:* [2026-07-19 session-URL-persistence thread](/meta/threads/2026-07-19-session-url-persistence-and-plan-vs-capture-policy.md)
