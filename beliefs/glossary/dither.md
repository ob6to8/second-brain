---
id: em:5d59f3
type: concept
title: dither
description: Low-level noise added to a signal before quantization to decorrelate the quantization error from the signal, trading structured distortion for benign broadband noise and letting detail below one level survive on average.
provenance: "Agent-distilled glossary definition, Claude Code session"
verified: false
sense: common
tags: [glossary, dsp, signal-processing, quantization, testing]
timestamp: 2026-07-20
attribution:
  when: 2026-07-20
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-20 code-as-compilation-target-and-dsp-testing-model thread"
---

# dither

Deliberately adding noise to improve fidelity is counterintuitive, but without it a
coarsely [quantized](/beliefs/glossary/quantization.md) low-level signal produces a
fixed, signal-correlated error the ear hears as harmonic distortion; dithering
spreads that error into unstructured noise instead. As a model of testing it is the
case for property-based or randomized inputs over fixed examples: fixed cases leave
a systematic blind spot in the same place every run, while randomizing the inputs
scatters it so a defect that a fixed suite would miss every time surfaces
statistically.

*Seen in:* [2026-07-20 code as compilation target and DSP testing model](/meta/threads/2026-07-20-code-as-compilation-target-and-dsp-testing-model.md)

*See also:* [quantization](/beliefs/glossary/quantization.md)
