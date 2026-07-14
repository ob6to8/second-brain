---
id: em:40133e
type: concept
title: synonym expansion
description: Broadening a search query with alternate phrasings — synonyms, jargon and plain-language variants, acronyms and their expansions — so a lookup finds matches worded differently, bridging vocabulary mismatch without embeddings.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, search, intake]
sense: common
timestamp: 2026-07-12
attribution:
  when: 2026-07-12T14:08:49+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# synonym expansion

Broadening a search query with alternate phrasings — synonyms, jargon/plain-language variants, acronyms and their expansions — so a lookup surfaces items that use different words for the same idea. It targets the dominant failure of [lexical search](/beliefs/glossary/lexical-search.md), vocabulary mismatch (e.g. searching "context pollution" for a note titled "poisoning"), and recovers much of the recall that [semantic search](/beliefs/glossary/semantic-search.md) would — but with the model already in the loop generating the variants, so it adds no dependency. In this brain it is the tier-1 [deduplication](/beliefs/glossary/deduplication.md) fix at intake: generate 3–5 phrasings and search each before writing.

*Seen in:* [2026-07-12 dedup recall probe thread](/meta/threads/2026-07-12-dedup-recall-probe-and-synonym-intake.md)
