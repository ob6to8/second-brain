---
id: sb:4f4baf
type: concept
title: verification grounding
description: The rule that a `verified: true` agent statement must be backed by evidence — a non-empty `verified_by` pointing at captures — and never by its own `resource` link.
provenance: "Agent-distilled glossary definition, pointer to the defining doc"
verified: false
tags: [glossary, verification, identity]
sense: repo
timestamp: 2026-07-10
attribution:
  when: 2026-07-11T08:41:24+02:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# verification grounding

The rule that verification applies only to agent-authored statements and a `verified: true` one must carry a non-empty `verified_by` pointing at the captures that support it — never its own `resource` link, and never on a capture. Canonically defined by the [verification-grounding policy](/meta/policy/verification-grounding.md).

*Seen in:* [2026-07-05 OKF bootstrap thread](/meta/threads/2026-07-05-greenfield-okf-bootstrap-and-verification-layer.md)
