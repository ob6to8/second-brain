---
id: em:ad34c1
type: concept
title: bundle manifest
description: The knowledge-base repo's config/config.exs in its post-spin-out role — the one place a bundle declares everything about itself that the shared library must not hardcode, including id prefix, site and repo URLs, excluded directories, and the controlled type and channel vocabularies.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, architecture, configuration, spin-out]
sense: repo
timestamp: 2026-07-17
attribution:
  when: 2026-07-17T18:10:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term coined by the 2026-07-17 library spin-out spec thread"
---

# bundle manifest

Coined in the
[spin-out plan](/meta/plans/library-spin-out-and-dependency-distribution.md)
as the target of the parent plan's Phase 3 configurability audit: every
bundle-specific constant lifted out of library code lands here, making the
library generic over N bundles. The design keeps governance where it belongs
— the library enforces that a document's `type` is *in the declared list*,
while *what the list contains* remains a per-bundle, operator-ratified act.
The existing `site_base_url`/`repo_url` entries are the pattern the rest of
the surface (notably the `em:`
[id prefix](/beliefs/glossary/stable-id.md)) follows.

*Seen in:* [2026-07-17 library spin-out spec thread](/meta/threads/2026-07-17-library-spin-out-spec.md)
