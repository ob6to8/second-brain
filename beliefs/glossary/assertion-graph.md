---
id: sb:ac22a3
type: concept
title: assertion graph
description: The pre-OKF knowledge-base design this brain replaced — atomic claims (primitives backed by source evidence, compounds composing primitives via explicit deps) forming a DAG whose remnants live under deprecated/ pending migration.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, knowledge-management, deprecated]
sense: repo
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T18:20:51+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# assertion graph

The knowledge-base design this brain used before adopting OKF: knowledge decomposed into **assertions** — atomic claims — where *primitives* are backed by evidence links into captured sources and *compounds* compose primitives through explicit dependencies, the whole forming a directed acyclic graph from any claim back to its origins. Its machinery (shell tooling, schema, generated index) was deleted on 2026-07-11; its content (sources and assertions) sits under `deprecated/` pending migration into the bundle, where assertions map roughly onto the `claim` type and the [verified-by](/beliefs/glossary/verified-by.md) evidence machinery.

*Seen in:* [2026-07-11 deprecated-triage thread](/meta/threads/2026-07-11-deprecated-directory-triage-and-machinery-deletion.md)
