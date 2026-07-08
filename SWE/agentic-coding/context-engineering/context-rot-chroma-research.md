---
id: sb:77d68a
type: reference
title: "Context rot — LLM performance degrades non-uniformly as input length grows (Chroma)"
description: Chroma tested 18 frontier models and found performance degrades unevenly as context length increases, even on simple tasks, and models sometimes perform better on shuffled than logically coherent long contexts — evidence that bigger context windows don't remove the need for careful context curation.
resource: https://www.trychroma.com/research/context-rot
provenance: "Distilled from Kelly Hong, Anton Troynikov, Jeff Huber, Chroma Research, 2025-07-14"
tags: [llm-inference, context-engineering, context-rot, long-context, evaluation-methodology, agentic-loop]
timestamp: 2026-07-06
---

# Context rot — LLM performance degrades non-uniformly as input length grows (Chroma)

**Kelly Hong, Anton Troynikov, Jeff Huber**, Chroma Research, 2025-07-14.
*(Summarized — full report and interactive results at the resource link.)*

## Summary

It's tempting to assume a model treats every token in its context window the
same way, so a bigger window just means "more room" with no downside. Chroma
tested that assumption directly across 18 frontier models (Claude, GPT, Gemini,
and Qwen variants) on tasks as simple as finding one planted fact in a long
document, and found the assumption is false: **performance degrades unevenly as
input gets longer, even on tasks that should be trivial regardless of length.**
Two results stand out. First, how similar the planted fact is in wording to the
question matters — the less directly it matches, the faster performance falls
off as the surrounding text grows. Second, and more surprising: models sometimes
do *worse* on a long document that reads as one coherent, logically connected
piece than on the same content with sentences shuffled into a meaningless order.
That's the opposite of what you'd expect if length alone were the problem — it
suggests models are especially thrown off by long, coherent-looking text that
demands sustained tracking of relationships across it. The takeaway the authors
draw is that simply making context windows bigger does not solve the underlying
problem; what actually matters is curating *what* goes into the context and
*how* it's arranged, not just how much of it there is room for.

## Key terms

- **Context window** — the fixed span of input tokens a model processes at once
  when generating a response.
- **Needle-in-a-haystack (NIAH) task** — a test format where one target fact
  (the "needle") is planted inside a much longer document (the "haystack"), and
  the model is asked to retrieve it — a standard way to probe long-context
  retrieval ability.
- **Needle-question similarity** — how closely the planted fact's wording
  matches the phrasing of the question asked about it; low similarity forces
  the model to do semantic matching rather than near-exact text matching.
- **Distractor** — additional planted content, similar to but distinct from the
  target needle, designed to compete with it for the model's attention.
- **Haystack structure (coherent vs. shuffled)** — whether the surrounding
  filler text reads as a normal, logically connected document, or as the same
  sentences randomly reordered into incoherent text.
- **Context rot** — this report's name for the overall phenomenon: the
  non-uniform, often counter-intuitive performance degradation that emerges as
  input length grows, as distinct from a model simply "running out of room."

## Technical summary

Chroma's Context Rot study evaluates 18 frontier models (Claude Opus 4/Sonnet
4/Haiku 3.5, GPT-4.1/4o/o3, Gemini 2.5 Pro/Flash/2.0 Flash, Qwen3 variants)
across NIAH-style retrieval, LongMemEval conversational QA, and a repeated-words
task, varying input length, needle-question semantic similarity, distractor
count, and haystack coherence. The central finding is that **performance is not
a uniform function of input length**: degradation is steeper when
needle-question similarity is low (forcing semantic rather than lexical
matching), compounds with additional distractors, and — counter-intuitively —
is often *worse* on logically coherent haystacks than on the same content with
sentence order shuffled, implying that sustained relational tracking over
coherent long text is itself a source of difficulty distinct from raw length.
The authors conclude that *"what matters more is how information is
presented... making effective context engineering essential for reliable
performance,"* directly contradicting the assumption that larger context
windows reduce the need for curation — if anything, the evidence points the
other way.

## Relation to other captures

Empirically corroborates the core thesis of
[Effective context engineering for AI agents](/SWE/agentic-coding/agentic-loop/effective-context-engineering-for-agents.md)
(Anthropic) — see that concept's currency-check section for how this research
bears on the essay's continued accuracy. Also relevant to
[the dialogue topic segmentation paper](/SWE/agentic-coding/context-engineering/granularity-aware-evaluation-for-dialogue-topic-segmentation.md),
which studies a different flavor of the same underlying question: how a long
interaction should be structured/divided so a model can use it well.

# Citations

Kelly Hong, Anton Troynikov, Jeff Huber, "Context Rot: How Increasing Input
Tokens Impacts LLM Performance", Chroma Research, 2025-07-14 —
<https://www.trychroma.com/research/context-rot>
