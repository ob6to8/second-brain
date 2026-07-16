---
id: em:fd5a1e
type: concept
title: atomic fact
description: The decomposition unit of factuality evaluation — a short statement carrying a single independently checkable piece of information, extracted from a longer generation so each can be verified against a knowledge source on its own.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, evals, factuality, claim-decomposition, epistemics]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-11T20:14:11+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "extracted in the glossary run over the eight epistemic prior-art docs"
---

# atomic fact

Extraction is done by an LM, and the per-statement results are aggregated
mechanically. The granularity is
the whole method — real generations mix true and false, and only atomic
statements localize the error. The general belief-decomposition analogue is
the atomic belief node; extraction requires
[decontextualization](/beliefs/glossary/decontextualization.md) to keep meaning intact.

*Seen in:* [decompose-then-verify factuality reference](/knowledge/SWE/evals/decompose-then-verify-factuality.md), [belief-decomposition analysis](/meta/analysis/belief-decomposition-derived-vs-authored.md)
