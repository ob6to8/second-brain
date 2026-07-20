---
id: em:c9e142
type: concept
title: aliasing
description: The distortion in which frequency content above half the sampling rate, when under-sampled, folds down and masquerades as a lower frequency that was never present in the original signal.
provenance: "Agent-distilled glossary definition, Claude Code session"
verified: false
sense: common
tags: [glossary, dsp, signal-processing, sampling, testing]
timestamp: 2026-07-20
attribution:
  when: 2026-07-20
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-20 code-as-compilation-target-and-dsp-testing-model thread"
---

# aliasing

What makes it dangerous rather than merely lossy is that the folded-down artifact is
indistinguishable from genuine low-frequency content, so the record looks coherent
while describing something that was never there; the standard defense is an
anti-aliasing filter that band-limits before sampling. Used as a model of testing,
it names the failure worse than a coverage gap — an under-sampled suite that does not
just miss cases but manufactures a false-but-coherent picture of a program's
behavior, every check green.

*Seen in:* [2026-07-20 code as compilation target and DSP testing model](/meta/threads/2026-07-20-code-as-compilation-target-and-dsp-testing-model.md)

*See also:* [Nyquist–Shannon sampling theorem](/beliefs/glossary/nyquist-shannon-sampling-theorem.md)
