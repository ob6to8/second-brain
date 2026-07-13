---
id: sb:2df1e2
type: concept
title: content-word containment
description: A lightweight lexical-overlap score — the fraction of one text's unique content words (after normalization and stopword removal) that also appear in a reference text — used to flag near-restatements without any semantic model.
provenance: "Agent-distilled glossary definition; coined for the mix brain.glossary repetition check"
verified: false
tags: [glossary, verification, dedup, text-comparison]
timestamp: 2026-07-13
---

# content-word containment

The scoring measure of `mix brain.glossary`'s repetition check: each glossary body sentence is scored against its entry's `description`, failing at ≥ 72%, warning at 55–72%, and skipping sentences under 8 content words. Deliberately asymmetric — it asks how much of the *sentence* is already in the reference, not the reverse — so a long description cannot inflate a short sentence's score. Vocabulary overlap is not meaning: a paraphrase evades it, which is why the [single-overview convention](/beliefs/glossary/single-overview-convention.md) keeps an editorial bar above this mechanical floor.

*Seen in:* [2026-07-13 glossary single-overview thread](/meta/threads/2026-07-13-glossary-single-overview-dedup-and-check.md)
