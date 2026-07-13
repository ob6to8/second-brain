---
id: sb:649457
type: reference
title: "When F1 fails: granularity-aware evaluation for dialogue topic segmentation (Michael Coen)"
description: Standard boundary-based F1/W-F1 metrics for dialogue topic segmentation conflate boundary placement quality with segmentation granularity; the paper separates boundary scoring from boundary selection and shows that sweeping boundary density changes W-F1 more than switching segmentation methods does.
resource: https://arxiv.org/pdf/2512.17083
provenance: "Distilled from Michael Coen, arXiv:2512.17083v3 [cs.CL], preprint (under review), fetched 2026-07-06"
tags: [dialogue-systems, topic-segmentation, evaluation-methodology, context-engineering, conversational-memory, arxiv]
timestamp: 2026-07-06
attribution:
  when: 2026-07-07T21:40:04+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# When F1 fails: granularity-aware evaluation for dialogue topic segmentation (Michael Coen)

**Michael Coen** (independent researcher), "When F₁ Fails: Granularity-Aware
Evaluation for Dialogue Topic Segmentation", arXiv:2512.17083v3 [cs.CL], preprint
under review, 31 Dec 2025. *(Summarized — a dense empirical paper with many
tables; full text at the resource link.)*

## Summary

Imagine chatting with a customer-service bot across a long conversation that
drifts from booking a restaurant, to dietary questions, to confirming details.
A "topic segmenter" is the part of a system that decides where one topic ends
and another begins in that conversation — useful because it lets a chat system
compress or set aside older topics once they're done, so it doesn't run out of
room to keep track of things as the conversation grows. The usual way
researchers check whether a topic segmenter works well is to compare its guessed
dividing lines against a human's guessed dividing lines and boil the comparison
down to a single accuracy-like score. This paper argues that single score is
misleading, because it can be high for two very different reasons: either the
model is genuinely finding the right dividing lines, or it just happens to guess
roughly the right *number* of dividing lines the human did, even if the specific
spots are wrong or reflect an entirely different (finer or coarser) sense of
what counts as a "topic change." Those two situations look identical under the
usual scoring, but they mean very different things about whether the model
actually works. The paper's fix is to stop reporting just the one score, and
instead separately report how many dividing lines were guessed relative to the
human count, plus how well the guessed segments line up with the human ones
structurally — not just whether individual guesses hit the exact same spots.
Testing this across eight conversation datasets and several segmentation
methods, the authors find that simply changing how aggressively a model guesses
dividing lines swings its accuracy score more than switching to a completely
different modeling approach does — meaning a lot of reported "improvements" in
this research area may really be different tuning choices wearing the same
disguise.

## Key terms

- **Boundary** — a single candidate dividing line between two adjacent turns in
  a conversation, marking a possible topic change.
- **Gold boundary / gold annotation** — the human-labeled "correct" set of
  boundaries a system's guesses are compared against.
- **F1** — the standard accuracy measure combining precision (of guessed
  boundaries, how many were actually correct) and recall (of correct boundaries,
  how many were actually guessed) into one number.
- **Window-tolerant F1 (W-F1)** — a looser version of F1 that counts a guess as
  correct if it falls near a gold boundary (within a small tolerance window),
  rather than requiring an exact match, so harmless off-by-one placements aren't
  punished.
- **Boundary placement / localization** — whether guessed boundaries sit at the
  same conversational positions as gold boundaries; the thing F1/W-F1 is
  supposed to measure.
- **Segmentation granularity** — how fine or coarse a topic-division scheme is:
  a granular segmenter marks many small subtopic shifts, a coarse one marks only
  major topic changes.
- **Boundary density / annotation regime** — how many boundaries, in total, a
  segmenter (or a gold annotation) produces relative to conversation length,
  reflecting its implicit choice of granularity.
- **BOR (Boundary Over-segmentation Ratio)** — predicted boundary count divided
  by gold boundary count: a direct, explicit measure of density mismatch. Above
  1 means over-segmenting, below 1 means under-segmenting, around 1 means
  matched density.
- **Boundary scoring vs. boundary selection** — the paper's key structural
  split. *Scoring* assigns a continuous "how likely is this a boundary" number
  to every candidate position; *selection* is a separate step — a threshold `τ`
  plus a minimum spacing `g` between accepted boundaries — that turns those
  scores into an actual, finite set of guessed boundaries. Separating them makes
  density (BOR) something you can control and report directly, instead of an
  accidental side effect of wherever the threshold happened to land.
- **Purity** — whether each guessed segment draws its turns mostly from a single
  gold segment; low purity means a guessed segment is a jumble crossing multiple
  gold topics.
- **Coverage** — whether each gold segment is captured mostly by a single
  guessed segment; low coverage means one gold topic got chopped into many
  fragmented guessed segments.
- **Density–quality curve** — a plot made by sweeping the selection threshold
  `τ` (holding the scoring model fixed) and tracking how W-F1 changes purely as
  a function of boundary density (BOR) — used to show how much of a method's
  apparent accuracy is really just a byproduct of how many boundaries it happens
  to output.

## Technical summary

Dialogue topic segmentation is standardly evaluated with boundary-matching F1
or its window-tolerant variant (W-F1), scoring guessed boundaries against gold
annotations. The paper's central claim is that this conflates boundary
placement (localization) with segmentation granularity: because the annotation
regime implicitly fixes a boundary density, a segmenter whose output density
happens to match gold density — regardless of true localization accuracy — can
score competitively on F1/W-F1, as demonstrated by density-matched non-semantic
baselines (random, periodic). A worked example makes the failure concrete: gold
marks one coarse topic boundary in a 12-turn dialogue; the model correctly also
detects three finer subtopic transitions within that span, but under exact-match
F1 those three correct detections count as false positives (precision 1/4,
F1 = 0.40) — a granularity mismatch, not a placement error, that standard F1
cannot distinguish from genuine failure. To make density an explicit,
controllable variable, the paper separates boundary scoring (a continuous
per-position relevance score) from boundary selection (a threshold `τ` plus
minimum spacing `g` converting scores into discrete boundaries), and reports BOR
alongside purity and coverage as segment-alignment diagnostics — jointly
distinguishing calibrated, oversegmentation, granularity-mismatch,
undersegmentation, and detection-failure regimes. Empirically, density–quality
curves constructed by sweeping `τ` over a fixed scoring model show that changes
in boundary density (BOR) produce substantially larger swings in W-F1 than
switching between structurally distinct segmentation methods does — a pattern
confirmed by re-evaluating published methods (TextTiling, a BERT-NSP coherence
scorer "CSM") under one shared canonicalized pipeline, and by auditing runnable
SuperDialseg leaderboard comparisons, where reported F1/W-F1 deltas coincide
with large ΔBOR shifts rather than genuine placement improvements. The paper's
own DistilBERT-based scorer, trained via synthetic splice-pretraining →
supervised fine-tuning → temperature calibration and evaluated across all eight
datasets, outperforms baselines at matched BOR and maintains high purity even
when oversegmenting relative to gold, indicating it subdivides within gold
segments rather than cutting across them.

## Relation to other captures

Motivated by the same problem space as
[Conversation Tree Architecture](/knowledge/SWE/agentic/context-engineering/conversation-tree-architecture.md)
(structuring dialogue history to avoid context pollution) and
[Anthropic's context engineering](/knowledge/SWE/agentic/agentic-loop/effective-context-engineering-for-agents.md)
(curating what stays in context) — this paper instead attacks how we'd know
whether a segmentation method used for that structuring is *any good* in the
first place. The paper is itself motivated by building *Episodic*, a
topic-structured conversational memory system, where boundary density directly
governs the context assembled for the LLM.

## Datasets and reproducibility

Evaluated across 8 dialogue datasets spanning explicit segmentation annotation
(DialSeg711, SuperDialseg, TIAGE, QMSum) and repurposed labels treated as
boundaries (MultiWOZ domain changes, DailyDialog topic labels, Taskmaster
task/subtask changes, Topical-Chat topic labels). Reference implementation and
paper source at <https://github.com/mhcoen/episodic>.

# Citations

Michael Coen, "When F₁ Fails: Granularity-Aware Evaluation for Dialogue Topic
Segmentation", arXiv:2512.17083v3 [cs.CL], 2025-12-31 —
<https://arxiv.org/pdf/2512.17083>
