---
id: sb:862098
type: concept
title: stemming
description: Reducing inflected word forms to a shared base ("actors" → "actor", "owns" → "own") so surface variants of the same word match during text comparison or search.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, search, text-comparison, information-retrieval]
timestamp: 2026-07-13
---

# stemming

Full stemmers (Porter and kin) handle rich morphology; the `mix brain.glossary` repetition check uses a deliberately naive plural-only stem — strip a trailing "s" — because its inputs are short single sentences and over-stemming would cost more precision than the richer morphology recovers.

*Seen in:* [2026-07-13 glossary single-overview thread](/meta/threads/2026-07-13-glossary-single-overview-dedup-and-check.md)
