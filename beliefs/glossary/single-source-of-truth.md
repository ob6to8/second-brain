---
id: sb:8ea139
type: concept
title: single source of truth
description: The design guarantee that a given fact lives in exactly one authoritative place, with every other appearance either generated from it or pointing at it — the only structural (not behavioral) defense against stale copies.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, principles, provenance, compiled-artifacts]
sense: common
timestamp: 2026-07-13
---

# single source of truth

The design guarantee that a given fact lives in exactly one authoritative place, and every other appearance is either *generated* from it or a *pointer* to it. It is the structural enforcement of [DRY](/beliefs/glossary/dry.md): a "never cite the copy" rule is behavioral and can regress, but a system with no copy cannot serve a stale one. This brain implements it with [compiled artifacts](/beliefs/glossary/compiled-contract.md) (`CLAUDE.md`, the registry, route-tagged excerpt logs — regenerated and CI-checked) and [pointer entries](/beliefs/glossary/pointer-entry.md); retiring the hand-kept logs made git's commit graph the sole change record on the same grounds.

*Seen in:* [2026-07-11 deprecated-triage thread](/meta/threads/2026-07-11-deprecated-directory-triage-and-machinery-deletion.md), [2026-07-13 response-resource-links thread](/meta/threads/2026-07-13-response-resource-links-policy-and-site-config.md) (the site base URL sourced once from config)
