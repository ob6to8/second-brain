---
id: em:760063
type: concept
title: "Nyquist–Shannon sampling theorem"
description: The result that a signal containing no frequencies at or above half the sampling rate — a band-limited signal — is fully determined by its discrete samples and can be reconstructed from them exactly.
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

# Nyquist–Shannon sampling theorem

The band-limit is the load-bearing precondition: without it, content above the
half-rate ([Nyquist](/beliefs/glossary/aliasing.md)) frequency cannot be recovered
and instead corrupts the reconstruction. The theorem is what makes the gaps between
samples an illusion — ideal (sinc) reconstruction fills them in — and is the exact
point where the analogy to software testing breaks: program behavior has no
band-limit (a single input can flip it arbitrarily), so no sampling rate guarantees
reconstruction, and an invariant is the closest thing to installing the missing
band-limit — a global constraint that folds the whole domain at once rather than a
denser set of samples.

*Seen in:* [2026-07-20 code as compilation target and DSP testing model](/meta/threads/2026-07-20-code-as-compilation-target-and-dsp-testing-model.md)

*See also:* [aliasing](/beliefs/glossary/aliasing.md), [inter-sample peak](/beliefs/glossary/inter-sample-peak.md), [quantization](/beliefs/glossary/quantization.md)
