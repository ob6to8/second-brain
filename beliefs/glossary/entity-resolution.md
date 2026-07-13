---
id: sb:990c2c
type: concept
title: entity resolution
description: Deciding when two differently-phrased items refer to the same underlying entity; for belief graphs, unifying equivalently-worded beliefs across documents to a single node — the hard, LLM-mediated core of cross-document comparison.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, epistemics, belief-decomposition, canonicalization, nlp]
sense: common
timestamp: 2026-07-11
attribution:
  when: 2026-07-13T20:34:46+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "extracted from the session's captured thread doc"
---

# entity resolution

The task of deciding when two differently-phrased items denote the same
underlying entity. Applied to belief graphs it becomes *entity resolution for
propositions*: unifying "apples are fruits" (doc A) and "an apple is a kind of
fruit" (doc B) to one node, so cross-document comparison and consensus/conflict
detection have a shared vocabulary to compare over. It is the single largest
design cost of a belief decomposer — fuzzy, LLM-mediated, and the same
canonical-identity lesson this brain learned with [stable ids](/beliefs/glossary/stable-id.md)
and route tags (join on ids, not free-text phrasings). Pairs with
[decontextualization](/beliefs/glossary/decontextualization.md): a belief must be made
self-contained before it can be resolved against another.

*Seen in:* [belief-decomposition analysis](/meta/analysis/belief-decomposition-derived-vs-authored.md), [2026-07-11 belief-decomposition thread](/meta/threads/2026-07-11-belief-decomposition-analysis-and-epistemic-prior-art.md)
