---
id: em:1f7dca
type: concept
title: source of truth
description: The single authoritative representation of some data or state from which every other copy or view is derived, so that any reconciliation question resolves to exactly one place.
provenance: "Agent-distilled glossary definition — surfaced in the localized-code-conversation session"
verified: false
tags: [glossary, data-architecture, provenance, derivation]
sense: common
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T20:52:33Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-20 localized-code-conversation thread"
---

# source of truth

The design lever is *which* representation holds that status, because the choice
fixes the direction everything else is derived in — and derivation is not
symmetric. In this brain the frozen linear thread is the source and the per-document
excerpt logs are a regenerable projection off it (via
[route tags](/beliefs/glossary/route-tag.md), rebuilt by
[materialize](/beliefs/glossary/materialize.md)); deriving the topical view from the
chronological source is a lossless selection, whereas the reverse — reassembling a
chronology from scattered per-location fragments — loses adjacency. Choosing the
source is therefore prior to choosing the presentation.

*Seen in:* [2026-07-20 localized-code-conversation thread](/meta/threads/2026-07-20-localized-code-conversation-and-comprehension-doctrine.md), [localized-code-conversation analysis](/meta/analysis/localized-code-conversation-vs-linear-thread.md)
