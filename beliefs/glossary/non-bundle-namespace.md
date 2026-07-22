---
id: em:54995c
type: concept
title: non-bundle namespace
description: A top-level directory excluded from the identity registry, so its docs carry no `em:` ids and skip verification (like `meta/`, `inbox/`, and `survey/`).
provenance: "Agent-distilled glossary definition, pointer to the defining doc"
verified: false
tags: [glossary, namespaces, identity]
sense: repo
timestamp: 2026-07-22
attribution:
  when: 2026-07-11T08:41:24+02:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# non-bundle namespace

Its whole subtree opts out of identity: no `em:` ids are minted and the verifier skips it, unlike the bundle concepts that must be identified and checked. Explained in the [bundle-scope tutorial](/meta/tutorials/bundle-scope-and-non-bundle-namespaces.md). Instances: `meta/` (governance), the [inbox namespace](/beliefs/glossary/inbox-namespace.md) (`/research` candidate feeds), and the [survey tier](/beliefs/glossary/survey-tier.md) (`survey/` bookmark registers) — each mirrors the others in the tooling (`Registry` exclusion, `Attribution` exemption, `Orphans` anchoring).

*Seen in:* [2026-07-09 news-inbox thread](/meta/threads/2026-07-09-home-page-news-filter-inbox.md), [2026-07-22 survey-tier thread](/meta/threads/2026-07-22-survey-tier-and-bookmarks-register.md)
