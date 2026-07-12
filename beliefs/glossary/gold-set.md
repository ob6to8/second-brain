---
id: sb:d9c5d9
type: concept
title: gold set
description: A curated set of queries each paired with the item(s) that should be returned — the ground truth an evaluation scores a retrieval or classification system against.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, evaluation, search]
timestamp: 2026-07-12
---

# gold set

For a [recall probe](/beliefs/glossary/recall-probe.md) the cases are natural-phrasing queries, each keyed to the acceptable target item(s), so [recall](/beliefs/glossary/recall.md) can be measured mechanically. The pairing is by stable identifier where possible (so it survives renames), and rows can be banded by role — straightforward positives, labeled negatives, and quarantined cases whose right answer is undefined. Distinct from a [golden test](/beliefs/glossary/golden-test.md), which pins a program's *output* against a stored snapshot rather than judging retrieval against known-correct answers.

*Seen in:* [2026-07-12 dedup recall probe thread](/meta/threads/2026-07-12-dedup-recall-probe-and-synonym-intake.md)

*See also:* [recall probe](/beliefs/glossary/recall-probe.md), [recall](/beliefs/glossary/recall.md), [deduplication](/beliefs/glossary/deduplication.md)
