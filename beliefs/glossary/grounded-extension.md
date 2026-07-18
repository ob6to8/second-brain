---
id: em:fe0ebd
type: concept
title: grounded extension
description: In a Dung argumentation framework, the unique minimal (most skeptical) set of arguments that is admissible and self-defending — the arguments beyond dispute; the formal model of a consensus core.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, argumentation, dung, consensus, semantics]
sense: common
timestamp: 2026-07-11
attribution:
  when: 2026-07-13T20:23:58+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "extracted from the Dung argumentation-frameworks intake"
---

# grounded extension

In a Dung [argumentation framework](/beliefs/glossary/argumentation-framework.md), the
unique, ⊆-minimal complete extension: the least set of arguments that defends
itself against all attackers, computed as the least fixed point of the defense
operator. It is the *most skeptical* semantics — it accepts only what is
ultimately undisputed, leaving genuinely contested arguments out — which makes
it the natural formalization of a
[consensus core](/beliefs/glossary/consensus-core.md) when several artifacts' belief
systems are compared. Contrast the *preferred* extensions (maximal admissible
sets), which capture distinct credulous positions under mutual attack.

*Seen in:* [Dung frameworks reference](/knowledge/knowledge-management/argumentation/dung-abstract-argumentation-frameworks.md), [belief-decomposition analysis](/meta/analysis/belief-decomposition-derived-vs-authored.md)
