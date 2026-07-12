---
id: sb:f8ae3a
type: concept
title: auto-intake
description: The /news step that files its featured items into the bundle via /intake in the same run, moving the operator from a pre-intake gate to a post-intake editorial role.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, news, intake, automation]
timestamp: 2026-07-12
---

# auto-intake

The step where [`/news`](/.claude/skills/news/SKILL.md) files each of its **featured** items into the bundle by running [`/intake`](/.claude/skills/intake/SKILL.md) in the same run — rather than leaving them as candidates for a human to pick. Its premise is that the [featuring](/glossary/featuring.md) gates are already the quality filter, so a featured item needs no second pre-intake gate; the operator's contribution moves to the *post-intake editorial* pass (prune, relabel, merge). It is bounded to the known tree — items needing a new top-level directory are **deferred** for ratification, never filed autonomously — prefers update-in-place on a `relates to sb:` hint to keep [residual fragmentation](/glossary/residual-fragmentation.md) small, and tags what it files `auto-intake` so the editorial queue is one query. The digest itself stays a non-bundle record; only its featured items acquire ids. The tradeoff it accepts is [cognitive debt](/glossary/cognitive-debt.md): the corpus can grow faster than the operator internalizes it.

*Seen in:* [auto-intake-featured-news plan](/meta/plans/auto-intake-featured-news.md), [2026-07-12 news auto-intake thread](/meta/threads/2026-07-12-news-auto-intake-featured-items.md)

*See also:* [featuring](/glossary/featuring.md), [deduplication](/glossary/deduplication.md), [residual fragmentation](/glossary/residual-fragmentation.md), [cognitive debt](/glossary/cognitive-debt.md)
