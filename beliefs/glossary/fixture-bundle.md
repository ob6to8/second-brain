---
id: em:7f58e2
type: concept
title: fixture bundle
description: The small demo OKF collection that ships inside the spun-out library repo, exercising every schema feature under its own cb: id namespace, serving simultaneously as the library's test fixture, its demonstration content, and the proof that no bundle-specific constant remains hardcoded.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, testing, architecture, spin-out]
sense: repo
timestamp: 2026-07-17
attribution:
  when: 2026-07-17T18:10:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-17 library spin-out spec thread"
---

# fixture bundle

Today the library's tests can only run against the operator's live personal
data — one of the
[separation plan](/meta/plans/separate-okf-bundle-and-elixir-mind-library.md)'s
core arguments for the split. The
[spin-out plan](/meta/plans/library-spin-out-and-dependency-distribution.md)
gives the replacement a double duty: because its documents mint ids under
`cb:` rather than `em:`, a green test run against it *is* the acceptance test
of the Phase 3 configurability audit — hardcoded `em:` assumptions cannot
survive contact with a non-`em:` corpus.

*Seen in:* [2026-07-17 library spin-out spec thread](/meta/threads/2026-07-17-library-spin-out-spec.md)
