---
id: em:cac45f
type: concept
title: inter-sample peak
description: A peak in the reconstructed continuous signal that rises above every stored sample value, so a meter reading only the samples reports a level lower than the true analog peak — a true-peak "over".
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

# inter-sample peak

Because the true maximum falls *between* the samples, it is recovered only by
reconstructing (oversampling) the waveform, and a signal that reads at or under full
scale on a sample-peak meter can still clip a downstream converter. As a model of
testing it is the reason a metric computed only at tested points — worst-case
latency, peak memory, "the worst we've seen" — can systematically under-report the
real extremum, which lives in an input the suite never [sampled](/beliefs/glossary/nyquist-shannon-sampling-theorem.md).

*Seen in:* [2026-07-20 code as compilation target and DSP testing model](/meta/threads/2026-07-20-code-as-compilation-target-and-dsp-testing-model.md)

*See also:* [Nyquist–Shannon sampling theorem](/beliefs/glossary/nyquist-shannon-sampling-theorem.md)
