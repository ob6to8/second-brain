---
id: em:4c6c63
type: concept
title: vendoring
description: Copying a dependency's source into a consumer's own tree so the consumer is self-contained and immune to upstream change, at the price of manual update propagation and drift between copies.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, dependencies, packaging, duplication]
sense: common
timestamp: 2026-07-17
attribution:
  when: 2026-07-17T20:30:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-17 vercel-eve comparison thread"
---

# vendoring

The canonical version lives in one upstream repository; each consumer holds a
snapshot, and fixes flow by pull (re-install or re-copy), not push. Eve's skill
distribution works this way — `npx skills add` copies a skill into each agent's
directory, so a deployed agent cannot drift at runtime, and keeping a fleet's
copies current is an operational discipline rather than a framework guarantee.
This bundle takes the opposite stance for knowledge: the
[update-in-place policy](/meta/policy/update-in-place.md) forbids copies (a
stale copy of knowledge is a bug, not an isolation guarantee), and necessary
derived copies are [generated artifacts](/beliefs/glossary/generated-artifact.md)
checked against their source.

*Seen in:* [2026-07-17 vercel-eve comparison thread](/meta/threads/2026-07-17-vercel-eve-comparison-and-jido-host-plan.md), [vercel-eve-comparison analysis](/meta/analysis/vercel-eve-comparison.md)
