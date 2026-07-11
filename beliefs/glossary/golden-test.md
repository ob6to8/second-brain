---
id: sb:61877f
type: concept
title: golden test (snapshot test)
description: A test that pins a transform's output by comparing it against a pre-recorded "expected" artifact checked into the repo, flagging any drift — including a wrong-but-internally-consistent change that self-consistency checks miss.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, testing]
timestamp: 2026-07-10
---

# golden test (snapshot test)

A test that pins a transform's output by comparing it against a pre-recorded "golden"/"expected" artifact checked into the repo, catching any change in output — including a wrong-but-internally-consistent one that self-consistency checks miss. The golden file is often regenerated behind an update flag (e.g. `UPDATE_GOLDEN`).

*Seen in:* [2026-07-09 flows-genre thread](/meta/threads/2026-07-09-flows-genre-and-scenario-testing.md), [2026-07-09 testing-methodology thread](/meta/threads/2026-07-09-testing-methodology-types-and-cb-epistemic-overlay.md)
