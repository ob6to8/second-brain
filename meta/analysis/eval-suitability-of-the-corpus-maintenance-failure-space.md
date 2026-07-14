---
type: analysis
title: "Is the corpus-maintenance failure space rich content for evals? Yes — ground truth is constructible"
description: The 500+ concept failure chain decomposes into measurable eval tasks (dedup recall, fan-out completeness, filing consistency, capacity curves, longitudinal corpus-health) because the operator owns the corpus and can construct ground truth; the hard part is that "is this a duplicate" is policy-relative, not factual — expanded here into seven named sources of fuzziness.
provenance: "Claude Code session (Claude Fable), 2026-07-10 — operator asked whether the failure space identified in the field-comparison analysis is rich content for evals; the session response is preserved verbatim at operator request, with the semantic-ground-truth fuzziness expanded"
tags: [meta, analysis, evals, benchmarks, dedup, recall, ground-truth, corpus-health, failure-modes]
timestamp: 2026-07-10
attribution:
  when: 2026-07-10T19:10:01+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-10-field-comparison-evals-and-cb-overlay-execution-path.md]
---

# Is the corpus-maintenance failure space rich content for evals?

**Question.** The [field-comparison analysis](/meta/analysis/comparison-with-the-2026-second-brain-field.md)
modeled the five-stage failure chain that kills advisory knowledge systems past
~500 concepts. Is that failure space a rich one for evals — i.e. content for evals?

**Bottom line.** Yes, unusually so, because evals are normally starved by the cost
of ground truth and here ground truth is *constructible*: the operator owns the
corpus, can synthesize it at any scale, inject known defects, and measure
avoidance/detection/repair. Every stage of the chain except trust collapse maps to
a measurable task, and the eval prerequisites (stable ids, deterministic verifiers,
replayable git history, frozen verbatim threads) already exist in this bundle as
side effects of its design. The genuinely hard part is that the central gold-set
judgment — "is this a duplicate" — is policy-relative rather than factual; its
fuzziness is decomposed in the final section.

## The session response (verbatim)

The following is the assistant response that prompted this filing, reproduced
verbatim (it addresses the operator as "you"; the closing offer was answered by
commissioning this doc and the [dedup recall probe plan](/meta/plans/dedup-recall-probe.md)).

> Yes — unusually rich, and for a structural reason: **evals need ground truth, and
> in this failure space you own the corpus, so ground truth is constructible rather
> than collected.** Most agentic evals are starved by the cost of knowing the right
> answer; here you can synthesize corpora at any scale, inject known defects, and
> measure whether the agent avoids, detects, or repairs them. Almost every stage of
> the failure chain decomposes into a measurable task:
>
> **Stage-by-stage eval mapping**
>
> - **Dedup recall (stage 2)** — the one already specified in your vector-DB
>   analysis: a fixed set of `(natural-phrasing query → expected concept id)` pairs,
>   scored as recall@k. It generalizes nicely: take any existing concept, have a
>   model rephrase its subject in disjoint vocabulary, and test whether intake
>   surfaces the original. That's an adversarial-paraphrase dedup benchmark you can
>   grow mechanically as the corpus grows.
> - **Fan-out completeness (stage 3)** — the most novel one. Inject a source that
>   materially bears on N known concepts (updates, contradicts, extends), and
>   measure how many of the N the agent actually touches. Karpathy's arithmetic says
>   one source should touch 10–15 pages; nobody measures whether an agent does. Call
>   it cross-reference recall. Precision matters too — touching 40 pages to update 5
>   is its own failure.
> - **Filing consistency (stage 4)** — intake the same item k times (or via k
>   parallel agents) against the same tree: does it land in the same directory, with
>   the same type, merged into the same concept? Inter-run agreement is a clean
>   scalar. A companion metric: taxonomy stability under a 100-document stream — how
>   many new-directory proposals versus filings into existing structure.
> - **Capacity curve (stage 1)** — the trigger itself is measurable. Run the same
>   dedup/filing probes against synthesized corpora of 50, 200, 500, 2,000 concepts
>   and find where quality bends. That converts "roughly 500+" from a guess into a
>   measured, per-model number — and it's an *operational* variant of
>   needle-in-a-haystack: not "can you find the fact" but "does your maintenance
>   behavior degrade when you can't."
> - **Contradiction detection** — seed known contradicting pairs, measure lint
>   recall. Stage 5 (trust collapse) isn't directly evaluable since it's human
>   behavior, but its leading indicator — known-item retrieval recall — is exactly
>   the probe above.
>
> **The headline eval** is longitudinal: replay a stream of N documents through
> intake and plot corpus-health metrics — duplicate rate, orphan rate, broken links,
> contradiction count, index freshness — as a function of N. Degradation *curves*,
> not point scores. And it sets up the experiment the whole enforcement bet rests
> on: same agent, same document stream, one run with the structural gates and repair
> loop, one run advisory-only. If the curves diverge, you've measured the thing the
> analysis doc could only argue.
>
> **This repo is unusually well-positioned to build these**, because the eval
> prerequisites already exist as side effects of the design: stable ids give you
> durable gold-label targets (a path-keyed gold set would rot on every rename); the
> deterministic verifiers give you free health metrics; git history is a
> *replayable real intake stream* (151 commits of actual filing decisions to re-run
> under new policies); and the frozen verbatim threads are real session data, not
> synthetic prompts. The main hard part is semantic ground truth — "is this a
> duplicate" has fuzzy edges, so gold sets need adjudication (or an LLM judge you
> periodically audit), and purely synthetic corpora won't capture real vocabulary
> drift the way your own replayed history will.
>
> Two honest framings of "content," and both hold. As **internal tooling**, this is
> the judgment-side complement to your scenario tests — scenario tests pin the
> deterministic spine, these evals measure the quality of the judgment calls CI
> can't check, and a `mix brain.recall_probe` fits the existing task pattern at zero
> dependencies. As **content for the world**: the survey found nobody in the field
> has benchmarks for knowledge-base *maintenance* — the entire public memory-eval
> landscape (LongMemEval, LoCoMo, needle-in-haystack variants) measures answering
> questions over histories, not keeping a corpus healthy under sustained agent
> writes. eugeniughelbur's retrieval evals are the closest thing and they're still
> read-side. A "corpus health under agent maintenance" benchmark would be a
> genuinely unoccupied niche, and this repo's failure-chain analysis is effectively
> its design document already.
>
> If you want to pursue it, the natural first step is the one already recommended:
> ship the dedup recall probe, since it's the smallest eval, guards the known
> unguarded gate, and its harness (gold pairs keyed on `em:` ids + a scoring task)
> is the substrate every later eval reuses. Happy to draft that as a plan doc or
> start building the probe — say which.

## The fuzzy edges, expanded

The verbatim response compressed the hard part into one sentence: *"'is this a
duplicate' has fuzzy edges, so gold sets need adjudication (or an LLM judge you
periodically audit), and purely synthetic corpora won't capture real vocabulary
drift the way your own replayed history will."* Unpacked, the fuzziness has seven
distinct sources — and each dictates a concrete property the gold set must have.

**1. Duplication is a spectrum, not a predicate.** Between "exact restatement" and
"unrelated" lie at least three distinct bands: *same subject, different facet* (two
notes on git branches — one on fetch semantics, one on rebase workflow); *subsumption*
(one note's scope strictly contains the other's); and *adjacent-but-distinct*
(two notes that share vocabulary but answer different questions). The merge
threshold — which bands count as "duplicate, should have merged" — is an editorial
choice. The live bundle demonstrates this: sixteen files legitimately coexist under
`SWE/agentic/agentic-loop/` because they are distinct *captures* of distinct
sources on one subject, while "context rot" and "lost in the middle" are one
phenomenon under two names and should never become two concepts. No similarity
score locates that line; only a policy does.

**2. Granularity is taxonomy-relative.** Whether two notes are "one concept" depends
on the altitude the taxonomy has chosen for that region of the tree. A brain that
files at the altitude of "agent loops" has one concept where this bundle has
sixteen. Since the tree *is* the taxonomy here and it evolves, the same pair of
texts can be a duplicate at one point in the bundle's history and legitimately
separate after a split. Consequence: gold labels are judgments *about this bundle's
current merge policy*, not facts about the texts — and the gold set must be
re-adjudicated when the taxonomy's altitude in a region changes.

**3. Duplication is type-relative.** A `reference` capture of an article and a
`concept` distilled from it can share nearly all their semantic content and are
*not* duplicates — same text, different epistemic role; the type vocabulary makes
that distinction on purpose (capture vs statement). Likewise a `source` extract and
the `claim` it grounds. Any naive embedding-similarity judge flags exactly these
legitimate pairs as its highest-confidence "duplicates." Dedup judgment — human,
LLM, or mechanical — must be type-aware, and the gold set must include such pairs
as *labeled negatives* or the eval will reward the wrong behavior.

**4. Duplication is time-relative.** New material that supersedes an old claim
poses merge-or-new-concept: update-in-place says merge, but when the old statement
should remain on record as *what was believed then*, the right act is a new concept
plus a supersession link — a mechanism this bundle does not have yet (it is the
named gap in the [epistemic overlay plan](/meta/plans/epistemic-overlay.md)). Until
supersession exists, the gold answer for "new evidence contradicting an existing
concept" is genuinely undefined, and the gold set should quarantine such cases
rather than force a label.

**5. Recall gold pairs are query-relative.** A `(query → expected id)` pair assumes
one right answer, but a natural phrasing is often legitimately answered by several
concepts at different specificity ("agent memory" touches four files in this bundle,
none wrongly). Scoring against a single id under-credits a searcher that surfaces a
better-but-unlabeled match. The gold format therefore needs *sets* of acceptable
ids per query, plus an adjudication note saying why — and id-keying, which survives
renames, still does not survive concept *merges*: when two acceptable targets merge,
the row needs human re-adjudication, not mechanical rewriting.

**6. LLM judges drift and must carry their own audit trail.** An LLM judge's
operative notion of "same subject" is not stable across model versions, prompt
revisions, or even temperature — the eval's measuring instrument changes under you
between runs. Mitigation is procedural: pin the judge configuration per gold-set
version, keep a small human-adjudicated calibration subset, re-run the judge against
it on any change, and record adjudication decisions *in* the gold set (which is why
it should be a versioned, prose-bearing document in the governance namespace, not a
bare data file — the same provenance habit as everywhere else in this bundle).

**7. Synthetic corpora share their generator's vocabulary.** An LLM asked to
paraphrase a concept "in different vocabulary" produces model-typical paraphrases —
drawn from the same distribution the intake agent's own embedding of the subject
lives in. That makes synthetic dedup pairs systematically *easier* than the real
event, which is cross-register drift: an arXiv abstract, a practitioner tweet,
official documentation, and the operator's own shorthand naming one idea four
unrelated ways ("lost in the middle" / "context rot" / "long-context degradation"
/ "context pollution" — the measured misses in the
[vector-DB analysis](/meta/analysis/vector-db-recall-for-the-scaling-bundle.md) were
all of this kind). The only source that captures the true register spread is the
bundle's own replayed history: git commits as a real intake stream, frozen threads
as real operator phrasings. Synthetic corpora remain useful for *scale* (the
capacity-curve eval needs 2,000 concepts that don't exist yet); they are unreliable
for *difficulty*.

**The constructive flip.** This fuzziness is a cost, but not only a cost: building
the gold set *forces the merge policy to become explicit*. Every adjudicated edge
case (facet vs duplicate, capture vs statement, merge vs supersede) is a policy
decision currently living implicitly in agent judgment, extracted into a reviewable
artifact. The eval is a policy-elicitor before it is a metric — which is the same
move this bundle has made everywhere else: convert an implicit promise into an
inspectable structure.

## Disposition

The first slice is specified in the
[dedup recall probe plan](/meta/plans/dedup-recall-probe.md), which encodes the
gold-set properties this analysis dictates: id-keyed rows with acceptable-id *sets*,
adjudication notes, labeled type-aware negatives, quarantine for
supersession-undefined cases, and harvesting real operator phrasings at intake time
rather than synthesizing queries.
