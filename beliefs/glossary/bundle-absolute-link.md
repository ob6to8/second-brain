---
id: em:79ca74
type: concept
title: bundle-absolute link
description: A markdown link whose target begins at the bundle root with a leading slash (e.g. /beliefs/glossary/route-tag.md), so it resolves identically from any document in the bundle.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, cross-linking, okf]
sense: repo
timestamp: 2026-07-16
attribution:
  when: 2026-07-12T19:22:43+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# bundle-absolute link

The leading slash is what distinguishes it from a relative link, whose target
depends on the linking file's own location; the canonical form is
`[route tag](/beliefs/glossary/route-tag.md)`. The
[cross-linking policy](/meta/policy/filenames-and-cross-linking.md) prefers this
form for prose links between concepts *inside* the bundle; a separate
[response-resource-links policy](/meta/policy/response-resource-links.md) governs
links in *delivered responses*, which instead cite the resource's live site URL so
a reader in chat can click through. The trade-off surfaced by directory
refactors: bundle-absolute links break when the *target* moves (they encode the
path, not the [stable id](/beliefs/glossary/stable-id.md)), whereas relative
links between files that move *together* survive — which is why a root
reorganization repoints live documents' absolute links but leaves frozen thread
bodies on their historical paths.

*Seen in:* [2026-07-12 root-reorganization thread](/meta/threads/2026-07-12-root-reorganization-knowledge-and-beliefs.md), [filenames-and-cross-linking policy](/meta/policy/filenames-and-cross-linking.md), [2026-07-13 response-resource-links thread](/meta/threads/2026-07-13-response-resource-links-policy-and-site-config.md)
