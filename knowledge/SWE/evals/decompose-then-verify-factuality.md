---
id: sb:d6cb97
type: reference
title: "Decompose-then-verify factuality evaluation (FActScore, SAFE)"
description: "The LLM-evals literature that atomizes long-form generations into individual facts, verifies each against a knowledge source, and aggregates mechanically — FActScore (EMNLP 2023) and SAFE/LongFact (NeurIPS 2024) validate the pattern at scale."
provenance: "Distilled from the FActScore and SAFE arXiv abstracts (2305.14251, 2403.18802), fetched 2026-07-11; layered breakdown via /summarize-technical"
tags: [evals, llm, factuality, fact-checking, claim-decomposition, atomic-facts, benchmarks]
timestamp: 2026-07-11
attribution:
  when: 2026-07-11T09:07:29+00:00
  channel: intake
  agent: "Claude Code agent, /intake"
  why: "operator-directed prior-art capture for the belief-decomposition assessment; body later restructured via /summarize-technical"
---

# Decompose-then-verify factuality evaluation (FActScore, SAFE)

## Summary

How factually accurate is a long, AI-written answer? Judging the whole text
at once fails for a simple reason: real generations are *mixtures* — mostly
true with false details woven in — so a single pass/fail verdict throws away
exactly the information that matters. Two papers established the now-standard
alternative: break the text into its smallest independently checkable
statements, check each one against a trusted source, and report the fraction
that hold up.

The first (2023) did this for machine-written biographies, checked against an
encyclopedia. Human annotators scored thousands of statements, revealing that
a leading chatbot's biographies were only about 58% supported. The expensive
human pipeline (the full study would have cost ~$26,000) was then automated:
a system that looks up relevant passages and asks a strong language model to
judge each statement matched the human scores to within 2%, making it cheap
to rank thirteen models on 6,500 generations.

The second (2024) generalized from biographies to open-ended questions on 38
topics, and replaced the fixed encyclopedia with live web search. Its checker
splits an answer into statements, *rewrites each so it stands alone* (a
pronoun-laden fragment can't be checked out of context), then runs multiple
rounds of search and reasoning per statement. It agreed with paid human
annotators 72% of the time — and when they disagreed, the machine was right
three times out of four — at one-twentieth the cost. The paper also
introduced a score balancing accuracy against saying enough: precision alone
rewards a model for answering in one timid sentence.

## Key terms

- **Atomic fact** — the decomposition unit: a short statement carrying a
  single piece of checkable information, extracted from the generation by a
  language model. The whole method rests on this granularity.
- **Knowledge source** — the ground the checking is done against (Wikipedia
  in FActScore; Google Search results in SAFE). "Factual" always means
  *supported by the designated source*, not true in the abstract.
- **Supported / not-supported / irrelevant** — the per-fact label set: backed
  by the source, contradicted-or-unbacked, or not actually about the
  question.
- **FActScore** — the metric of the first paper (Min et al., EMNLP 2023): the
  percentage of a generation's atomic facts supported by the knowledge
  source. Also the name of its released tool (`pip install factscore`).
- **Retrieve-then-verify estimator** — the automation: retrieve passages
  relevant to each atomic fact, then have a strong LM judge support — the
  combination that hit < 2% error against human FActScores.
- **Decontextualization (self-containment revision)** — SAFE's rewrite step:
  each extracted fact is revised to stand alone before checking, because
  atomic statements ripped from context ("he won it twice") are unverifiable
  as-is. The step any decomposer needs.
- **SAFE (Search-Augmented Factuality Evaluator)** — the second paper's
  checker (Wei et al., NeurIPS 2024): split → decontextualize → relevance
  check → iterative search-and-reason per fact → label.
- **LongFact** — that paper's benchmark: thousands of GPT-4-generated
  open-ended prompts across 38 topics, for eliciting long-form factual
  responses.
- **F1@K** — the aggregate: harmonic mean of factual precision (fraction of
  supplied facts supported) and recall against K, a stipulated
  facts-per-response target — penalizing both fabrication and under-informing.
- **LLM-as-judge** — the general pattern both papers instantiate: model
  judgments substituting for human annotation, validated by measured
  agreement with (and occasional superiority over) crowdworkers.

## Technical summary

FActScore defines long-form factual precision as the fraction of a
generation's atomic facts supported by a fixed knowledge source, with
atomic-fact extraction performed by an LM. On people-biography generation
against Wikipedia, human annotation established FActScores for
state-of-the-art models (ChatGPT ≈ 58% supported; GPT-4 and ChatGPT above
public models, Vicuna/Alpaca the strongest public ones), and a
retrieve-then-verify estimator reproduced the human metric with < 2% error,
scaling to 6,500 generations from 13 LMs at negligible cost relative to the
~$26k human equivalent.

SAFE extends the pattern to open domains: for each response to a LongFact
prompt, an LM splits the response into individual facts, decontextualizes
each into a self-contained claim, filters for relevance, and then iteratively
issues Google Search queries and reasons over results to label the claim
supported / not-supported / irrelevant. Against ~16k human-annotated facts,
SAFE matches crowdworkers 72% of the time and wins 76% of adjudicated
disagreements at > 20× lower cost. F1@K aggregates per-fact labels into a
response score balancing precision against recall-at-K; benchmarking 13
models across four families found larger models generally more factual.

The transferable result: **local LLM judgments per atomic claim, global
mechanical aggregation** — the decompose-then-verify pattern is validated,
cheap, and *better-than-crowdworker* reliable at the per-edge granularity a
belief graph needs. What these papers do for one edge type (claim ↔ evidence
support) the belief-decomposition idea extends to entailment and conflict
edges, and their aggregation (a score) generalizes to structural audits —
groundedness floors and [consensus cores](/beliefs/glossary/consensus-core.md) —
computed over the same local verdicts.

## Why it is in this brain

This is the empirically validated core of the belief-decomposition idea, and
SAFE's self-containment revision is the canonical answer to the
decontextualization problem any artifact decomposer must solve. See the
[belief-decomposition analysis](/meta/analysis/belief-decomposition-derived-vs-authored.md)
and the [derived analysis-mode plan](/meta/plans/belief-decomposition-analysis-mode.md).

# Citations

- Min et al., *FActScore: Fine-grained Atomic Evaluation of Factual Precision
  in Long Form Text Generation* (EMNLP 2023):
  <https://arxiv.org/abs/2305.14251>
- Wei et al., *Long-form factuality in large language models* (NeurIPS 2024):
  <https://arxiv.org/abs/2403.18802>
