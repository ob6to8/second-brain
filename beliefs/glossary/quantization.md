---
id: em:ca9f72
type: concept
title: quantization
description: The mapping of a continuous quantity onto a finite set of discrete levels, discarding everything finer than one level — the bit depth setting the resolution — as quantization error.
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

# quantization

It is the amplitude-axis counterpart to [sampling](/beliefs/glossary/nyquist-shannon-sampling-theorem.md)'s
time axis: sampling chooses *where* the signal is read, quantization chooses *how
precisely* each reading is kept, and the residual below one least-significant bit
sets a noise floor beneath which detail is simply invisible. As a model of testing
it maps to assertion strength — a weak check (`assertTrue(x > 0)`) is coarse,
one-bit quantization that lets large errors pass, while an exact check pins the
value to a fine resolution — and explains why adding test cases (denser sampling)
never compensates for shallow assertions (coarse quantization).

*Seen in:* [2026-07-20 code as compilation target and DSP testing model](/meta/threads/2026-07-20-code-as-compilation-target-and-dsp-testing-model.md)

*See also:* [dither](/beliefs/glossary/dither.md), [Nyquist–Shannon sampling theorem](/beliefs/glossary/nyquist-shannon-sampling-theorem.md)
