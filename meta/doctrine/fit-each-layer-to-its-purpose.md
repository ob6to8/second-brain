---
type: doctrine
title: "Fit each layer to its purpose: distill the knowledge, preserve the record"
description: The brain's direction for how much of the raw material each layer keeps — judged by the function that layer must serve, not by one global standard. The knowledge layer optimizes for concision and queryability (distill hard, cite the raw); the provenance/record layer optimizes for fidelity (keep it verbatim-minus-noise, because a condensed record is a worse record).
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-21 — ratified by the operator as a standing doctrine"
tags: [meta, doctrine, direction, filing, provenance, distillation, fitness-for-purpose, retention]
timestamp: 2026-07-21
attribution:
  when: 2026-07-21T00:00:00Z
  channel: agent-authored
  why: "the operator ratified persisting this per-layer retention direction as standing doctrine"
  agent: "Claude Code agent, qiju-thread-storage session"
---

# Fit each layer to its purpose: distill the knowledge, preserve the record

This is a **standing direction** for one recurring decision the brain makes
everywhere: *how much of the raw material does this artifact keep?* The answer is
not a single virtue applied uniformly. It is set by the **function the layer must
serve** — and the brain runs two layers whose functions pull in opposite
directions.

## The direction

**Judge each layer's retention by its purpose, not by one global standard.**

- **The knowledge layer wants concision + queryability.** A document a reader or
  agent consults to *understand a subject* is fit for purpose when it is a clean,
  distilled statement of the knowledge: a clear title, a one-sentence
  `description`, a body that carries the idea and nothing else. Here you
  **distill hard and cite the raw** — the original material lives in a `resource`
  URI or under `# Citations`, never as the whole document. A document that dumps
  its raw source is a *worse* knowledge document: it buries the signal it exists
  to surface.

- **The provenance/record layer wants fidelity.** A record kept to answer *what
  did we actually decide, what got rejected, and why* is fit for purpose only if
  it is faithful. You **cannot reconstruct** that from a lossy summary — a
  condensed record is a *worse* record. So the thread doc keeps every substantive
  exchange verbatim, stripping only mechanical noise (tool calls, reasoning,
  short pre-tool narration), and the session URL sits behind it as the
  full-fidelity escape hatch. Faithful retention here is not sloppiness; it is
  the whole job.

The two layers are complementary, not competing. The verbatim record is what
*licenses* aggressive distillation elsewhere: you can boil the knowledge doc down
to its essence precisely because the faithful record survives if the distillation
later turns out to have dropped something. Dumping (minus noise) into the archive
and distilling into the knowledge base are the right tools for two different jobs.

## Relationship to policy

This doctrine is the *why*; a
[`policy`](/beliefs/glossary/policy-type.md) implements it as the *what you must
do*. The direction runs one way — doctrine informs policy, not the reverse:

- [capture-knowledge-cite-the-source](/meta/policy/capture-knowledge-cite-the-source.md)
  implements the **knowledge-layer** half at every filing into the bundle.
- [session-capture](/meta/policy/session-capture.md) implements the
  **record-layer** half: verbatim retention, noise stripped, with `pr:`/`session:`
  anchors.

## Grounding

This direction rests on two descriptive premises, recorded as
[future beliefs](/beliefs/future-beliefs.md): the knowledge layer's fitness is
concision + queryability, and the record layer's is fidelity. The is-to-ought
structure by which those premises ground this normative direction is examined in
[the is-to-ought layer analysis](/meta/analysis/is-to-ought-belief-grounds-doctrine.md).
