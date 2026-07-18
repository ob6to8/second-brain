---
id: em:ae9b26
type: concept
title: red test
description: A test that constructs a known-bad input and asserts the check flags it — proving the detector actually fires, where a green test only proves good input passes.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, testing]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-12T09:10:24+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# red test

Without the red side, a check that silently stopped detecting anything would
still count as "fully tested". In this repo's
suites every verifier and route-tag failure mode carries one (e.g. a capture
marked `verified: true` is rejected; an unresolved ref fails resolution), and
each new gate lands with its red test in the same commit.

*Seen in:* [code-review toolchain hardening plan](/meta/plans/code-review-toolchain-hardening.md), [intake flow](/meta/flows/intake.md)
