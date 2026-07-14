---
id: em:b467a5
type: concept
title: council round
description: A structured, adversarial, multi-agent review of drafted work, run as comments on a draft PR through four motions (open, review, respond, close), gated on every finding receiving a disposition, and distilled into a curated target document.
provenance: "Agent-distilled glossary definition; pointer to the suitability analysis"
verified: false
tags: [glossary, review, adversarial, pr-workflow]
sense: repo
timestamp: 2026-07-13
attribution:
  when: 2026-07-13T20:28:57+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-13 council-round-suitability-evaluation thread"
---

# council round

A structured, adversarial, multi-agent review of drafted work, run at the gate
between *committed to a branch* and *merged*. The [draft pull
request](/beliefs/glossary/draft-pull-request.md) is the chamber: reviewer subagents
post ID'd findings as PR comments (never committed files), the author replies
to each with a [disposition](/beliefs/glossary/disposition.md), and the round can only
close once no finding lacks one — the settled outcome is then distilled into a
[distillation target](/beliefs/glossary/distillation-target.md), with the raw exchange
cited by PR link and commit SHA only. Evaluated for this bundle in
[council-round-suitability](/meta/analysis/council-round-suitability.md)
(verdict: integrate as a `/council` skill after four ratified bindings).

*Seen in:* [2026-07-13 council-round thread](/meta/threads/2026-07-13-council-round-suitability-evaluation.md), [council-round-suitability analysis](/meta/analysis/council-round-suitability.md)
