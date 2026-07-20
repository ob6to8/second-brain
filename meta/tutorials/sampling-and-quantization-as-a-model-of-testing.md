---
type: tutorial
title: "Sampling and quantization as a model of software testing"
description: A signal-processing reading of what a test suite does to a program's behavior — tests sample a continuous behavior-signal at discrete input points (the sampling axis) and pin each observation only to a finite precision (the quantization axis); develops both axes, the concept mapping, dither and aliasing, and the one place the analogy breaks — code has no band-limit, so unlike audio no sampling rate guarantees reconstruction, which is exactly why invariants (the band-limit) matter.
provenance: "Claude Code session, 2026-07-20 — expanded from the sampling intuition in the code-as-natural-language-compilation-target analysis at operator request, adding the quantization axis the original question named but the analysis left undeveloped"
tags: [meta, tutorial, testing, verification, dsp, sampling, quantization, nyquist, aliasing, dither, invariants, specs]
timestamp: 2026-07-20
attribution:
  when: 2026-07-20
  channel: agent-authored
  agent: "Claude Code agent, in-session authoring"
  why: "authored at operator request (\"Proceed with tutorial\") to give the DSP-as-testing analogy a standalone home, developing both the sampling and quantization axes"
  from: [/meta/threads/2026-07-20-code-as-compilation-target-and-dsp-testing-model.md]
---

# Sampling and quantization as a model of software testing

A program has a **true behavior** — the output it produces for every input it could
ever receive. Think of that as a continuous signal defined over the whole input
domain: a surface you can never see all of at once. A test suite is an *instrument*
pointed at that signal. Like every instrument that turns a continuous quantity into
a finite record, it loses information in exactly two independent ways, and digital
signal processing already has precise names for both:

- **Sampling** — you only read the signal at discrete points (which *inputs* you
  test), leaving everything between the samples unobserved.
- **Quantization** — each reading is captured only to a finite precision (how
  *sharply* each test pins the output), leaving everything below that resolution
  invisible.

These are orthogonal. A suite can sample densely but quantize coarsely (thousands of
inputs, each barely checked), or sample sparsely but quantize finely (three inputs,
each pinned to the exact bit). They fail differently, and confusing them is why "add
more tests" so often fails to catch the bug it was aimed at. This tutorial develops
each axis, then the one place the whole analogy breaks — and that break is the
useful part.

## Axis 1 — sampling: which inputs you look at

A test is a **sample**: the value of the behavior-signal at one point in the input
domain. Coverage — the metric everyone reaches for — is nothing more than *sample
density*. Between two samples, the signal is unconstrained: the program can do
anything, and the sample values alone give you no way to know what.

**Inter-sample peaks** are the sharp edge of this. In audio, the reconstructed analog
waveform can rise *above* the highest digital sample — a true-peak "over" sits
between samples, so a meter that reads only the sample values reports clean while the
signal actually clips. The software analog is exact: any figure you compute only at
tested points — maximum latency observed, peak memory, "worst case we've seen" — can
systematically **under-report the real extremum**, because the real worst case lives
in a gap you never sampled. Green suite, hidden over.

### Where audio is saved and code is not

Here is the theorem that makes audio tractable and has no software equivalent. The
**Nyquist–Shannon sampling theorem** says that if a signal is *band-limited* — it
contains no frequencies at or above half the sample rate — then the discrete samples
determine the continuous signal *perfectly*. The values between samples are not lost;
they are recovered exactly by reconstruction (ideally, sinc interpolation), and even
the inter-sample peak is fully encoded in the samples. Given the band-limit, the
gaps are an illusion and the finite record *is* a complete representation of the
infinite one.

Program behavior has **no band-limit.** It can change arbitrarily on a single input
with no neighborhood — `if (x == 42) launch_missiles()` is a spike of infinitely high
frequency sitting between two test points, and **no sample rate reaches it.** This is
the whole reason audio reconstruction is a solved linear problem and exhaustive
testing is undecidable-hard. Between audio samples the signal is constrained by
physics (band-limited transducers); between test points the program is constrained by
*nothing*.

### The band-limit for code is the invariant

So the productive question is: what would install a band-limit on program behavior —
a prior strong enough to let a finite set of observations constrain the whole domain?
The answer names why specs pair *invariants* with *tests*:

- A **test is a sample** — one point in the time domain.
- An **invariant is a band-limit** — a constraint stated in the "frequency domain."
  *The output is always sorted* does not pin one input; it folds the entire domain at
  once. It is not a denser sample, it is a *different kind* of constraint — global
  and analytic — exactly as Nyquist's band-limit is a global spectral condition
  rather than a pile of extra samples.
- A **type is a coarse band-limit** — it forbids whole regions of the signal before
  you sample at all.

To the degree you can state enough global constraints, sampling starts to *determine*
behavior and the gaps close; to the degree you cannot — and the `x == 42` spike
proves you cannot in general — the gaps stay real and unbounded.

### Aliasing: the failure that lies

Under-sampling does not merely lose information; it **manufactures false
information.** In DSP, a frequency above the Nyquist limit does not vanish when
under-sampled — it *folds down* and reappears as a lower frequency that was never in
the signal, indistinguishable from real content. A too-coarse test suite does the
same: it does not just leave gaps, it produces a **false-but-coherent model** of the
program. Everything passes, the pattern looks regular, and the un-sampled behavior
folds into an appearance of correctness that isn't there. This is worse than a known
hole — it is confident, wrong belief, and it is the specific danger of trusting a
suite (or a regenerate-to-green loop) whose sampling you never justified.

## Axis 2 — quantization: how sharply each reading pins the value

Sampling is about *where* you look. Quantization is about *how precisely* you record
what you see. A digital sample is not the exact analog value — it is rounded to the
nearest of a finite set of levels, and the number of levels is the **bit depth**.
Everything finer than one level (one LSB, least-significant bit) is lost as
**quantization error**.

An assertion is a quantizer. It does not capture the output exactly; it pins it only
to the resolution the assertion can distinguish:

- `assertTrue(x > 0)` is **1-bit** quantization — it sorts every output into just two
  buckets, positive or not. Enormous quantization error: any two positive outputs are
  indistinguishable to it, so a bug that turns `3` into `999` passes untouched.
- `assertEqual(x, 3.14159)` is **high bit-depth** — it pins the value to a fine
  resolution, and errors smaller than its tolerance are the only ones it misses.

The residual an assertion cannot see is its **quantization error**, and the smallest
defect it can resolve is its **noise floor** — the software version of a converter's
signal-to-noise ratio. Bugs that live *under the LSB* of your assertions — real, but
finer than any check distinguishes — are invisible no matter how densely you sample.
This is why adding more test cases (denser sampling) does nothing for a suite whose
assertions are coarse (shallow quantization): you are reading a weak signal at more
points but still rounding every reading to the same crude levels. The
[independence and completeness of the oracle](/beliefs/glossary/test-oracle.md) is
what sets this floor.

### Dither: why randomized inputs beat fixed ones

DSP has a counterintuitive fix for coarse quantization: **dither** — add a small
amount of random noise *before* quantizing. It sounds like vandalism (deliberately
adding noise), but it works, because it **decorrelates the quantization error from
the signal.** Without dither, a low-level signal quantized coarsely produces a fixed,
structured distortion — the same error in the same place every time, which the ear
hears as harmonic distortion. With dither, that structured error is spread into
benign broadband noise, and signals *below* one LSB become encodable on average.

The testing analog is **randomized / property-based / fuzz** inputs. Fixed
example-based tests quantize the behavior at the same handful of points every run, so
a systematic blind spot sits in the same place forever — a structured, repeatable
hole, the distortion of a dither-less quantizer. Randomizing the inputs spreads that
blind spot around: the hole is no longer always in the same place, so a defect that a
fixed suite would miss *every* time now gets hit *some* fraction of the time and
surfaces statistically. Property-based testing is dither for your oracle — it trades
a fixed, invisible error for a spread-out, detectable one.

## The two axes together

Total fidelity of a test suite is bounded by **both** axes at once, and they do not
substitute for each other:

| Signal processing | Software testing / specification |
|---|---|
| Continuous signal | A program's true behavior over the whole input domain |
| One sample | One test case (one input point) |
| Sample rate / density | Coverage of the input domain |
| Inter-sample peak | A worst case that falls between tested inputs |
| Band-limit (Nyquist condition) | An invariant — a global constraint folding the whole domain |
| Reconstruction (sinc interpolation) | Inferring untested behavior from what is pinned |
| Aliasing | A suite that looks coherent but models a program that isn't there |
| Bit depth | How sharply an assertion pins an output |
| Quantization error / under the LSB | Defects too fine for any assertion to distinguish |
| Dither | Randomized / property-based inputs decorrelating the blind spot |
| Noise floor / SNR | The smallest defect the oracle can resolve |

The two failure modes are genuinely different. A suite with **dense samples and
coarse quantization** (many inputs, weak assertions) exercises the whole domain but
certifies almost nothing at each point — high coverage, low confidence, the classic
"green but meaningless" suite. A suite with **sparse samples and fine quantization**
(few inputs, exact assertions) certifies its points to the bit but says nothing about
the vast unsampled remainder — a precise measurement of three places on an unmapped
surface. Real assurance needs both: enough samples to cover the domain *and* enough
bit depth to make each one mean something — plus, where you can state them, the
invariants that act as a band-limit and let the samples reach beyond themselves.

## Where the analogy earns its keep, and where it breaks

It earns its keep by making three things precise that "we need more tests" blurs
together: *coverage* is only the sampling axis; *assertion strength* is a separate
quantization axis that more coverage cannot buy; and *invariants* are neither — they
are a band-limit, a third kind of thing that changes what the samples are able to
prove.

It breaks at exactly one load-bearing point, and the break is the lesson: **audio has
Nyquist and code does not.** A band-limited signal is fully recoverable from its
samples; program behavior is not band-limited, so no amount of sampling or bit depth
*guarantees* you have the whole signal. Invariants are the attempt to install the
missing band-limit, and they are only ever partial. That gap between "sampled" and
"determined" is the space every escaped bug lives in — and the reason a codebase is
never simply *reconstructable* from a finite suite the way a waveform is from its
samples.

## Why this sits in the brain

This tutorial is the full form of the sampling intuition used in
[Code as a natural-language compilation target](/meta/analysis/code-as-natural-language-compilation-target.md),
which argues that a specification selects an *equivalence class* of programs rather
than one program. The two axes here are two ways of asking *how tightly the class is
pinned*: sampling density and assertion depth both narrow it, invariants narrow it
globally, and whatever is left un-pinned is exactly what regeneration is free to vary
— the concern of the
[regenerate-the-change-not-the-system doctrine](/meta/doctrine/regenerate-the-change-not-the-system.md).
The oracle-completeness point — a checker resolves only what its bit depth and
band-limit allow — is the same boundary the
[intent-is-the-source doctrine](/meta/doctrine/intent-is-the-source.md) draws as
*opacity is earned by the oracle*: an artifact may go unread only to the degree the
oracle pins its behavior, which in this reading means only to the degree you have
sampled densely enough, quantized finely enough, and band-limited with enough
invariants to leave nothing that matters unresolved.
