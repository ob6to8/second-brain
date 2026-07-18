---
id: em:056746
type: concept
title: label (ATMS)
description: The set of minimal consistent environments attached to a belief — every combination of assumptions from which it follows; kept consistent, sound, complete, and minimal by the ATMS, making context membership a subset test.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, epistemics, atms, truth-maintenance]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-11T20:14:11+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "extracted in the glossary run over the eight epistemic prior-art docs"
---

# label (ATMS)

The ATMS holds four invariants over a label's [environments](/beliefs/glossary/environment-atms.md):
**sound** — the belief really follows from every one; **complete** — any
environment entailing the belief is a superset of one already listed;
**minimal** — no listed environment contains another; **consistent** — none is
self-contradictory. Precomputing labels this way is what turns a
context-membership query into a cheap superset check and makes multi-context
reasoning practical.

*Seen in:* [de Kleer 1986 capture](/knowledge/knowledge-management/knowledge-representation/de-kleer-1986-an-assumption-based-tms.md), [TMS reference](/knowledge/knowledge-management/knowledge-representation/truth-maintenance-systems.md)
