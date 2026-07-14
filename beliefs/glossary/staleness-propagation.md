---
id: em:1e9cde
type: concept
title: staleness propagation
description: Following dependency edges outward when a source or premise changes, so every statement resting on it is flagged for re-verification instead of silently continuing to claim support that no longer holds.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, epistemics, verification, dependencies]
sense: common
timestamp: 2026-07-14
attribution:
  when: 2026-07-12T09:05:38+00:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# staleness propagation

Following dependency edges outward when a source or premise changes: every statement whose support chain passes through the changed node — here, via [`verified_by`](/beliefs/glossary/verified-by.md) edges — gets flagged for re-verification, instead of silently continuing to claim support that no longer holds. It is the dynamic counterpart of an [epistemic overlay](/beliefs/glossary/epistemic-overlay.md): the graph makes "what rests on this?" answerable, and staleness propagation is the event flow that acts on the answer when a premise moves.

*Seen in:* [CB epistemic-overlay stabilizer analysis](/meta/analysis/cb-epistemic-overlay-as-failure-chain-stabilizer.md), [dark-factory scenario analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md), [Loomkin analysis](/meta/analysis/loomkin-as-existence-proof.md) (Loomkin's `requires`/`blocks` → `upstream_uncertainty` cascades as a working reference implementation)
