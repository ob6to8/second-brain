---
id: em:1b3c79
type: note
title: Future beliefs
description: A running scratch list of facts and observations about the brain's tooling and governance worth formalizing later (into a tutorial, policy, or concept).
tags: [meta, governance, scratch]
timestamp: 2026-07-21
attribution:
  when: 2026-07-09T12:18:50+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# Future beliefs

A holding pen for small, true observations about how the brain works that are
worth remembering but not yet formalized into a tutorial, policy, or concept.

- Policies derive their `id` from filename (`ElixirMind.Policy.load!/1` sets
  `id = Path.basename(path, ".md")`), not from a frontmatter field.
- **LLM judgments stay local to edges; structure stays global and mechanical.**
  The design principle for any semiformal epistemic layer: the LLM answers
  small, cacheable, per-edge questions (assertion, entailment, conflict), and
  deterministic graph algorithms compute the global properties (groundedness,
  conflict sets, consensus, blast radius). See the
  [belief-decomposition analysis](/meta/analysis/belief-decomposition-derived-vs-authored.md).
- **Derive the graph, never author it.** The governing boundary for
  belief-graph work: the belief graph is a derived, regenerable analysis
  artifact — cached at most — while the artifact stays the sole source of
  truth. Authored belief stores accrue unbounded maintenance debt (the failure
  mode of both prior iterations). Same discipline as the compiled contract and
  registry. See the
  [belief-decomposition analysis](/meta/analysis/belief-decomposition-derived-vs-authored.md).
- **A `phrase`-type above the glossary was considered and deferred**
  (2026-07-11). The idea: a `type` for multi-word idioms/principles that aren't
  concept definitions (the future-beliefs entries are the closest case).
  Deferred because the `type` axis distinguishes *epistemic role*, not lexical
  length, and the glossary already holds multi-word terms comfortably; a
  `phrase` type would be the first keyed on surface form. Revisit only if a
  concrete need with real examples emerges — then propose for ratification like
  any new type.
- **"Distill, don't dump" is miscast and slated for retirement/rewrite**
  (proposed 2026-07-21). The slogan reads as a single dump-vs-distill axis, but
  the two are neither accurate nor mutually exclusive here: thread docs are
  near-*dumps* (verbatim, only tool-noise stripped) and knowledge docs are
  near-*distillations* — yet really *expansions* of thread fragments, which
  function as provenance. Dump and distill also operate at *different levels of
  the system*, so pitting one against the other misdescribes the architecture.
  Proposal: strip the `distill, don't dump` doctrine
  ([`meta/policy/distill-dont-dump.md`](/meta/policy/distill-dont-dump.md),
  compiled into `CLAUDE.md` §3) and rewrite it around fitness-for-purpose per
  layer — likely as a `doctrine` (a standing direction) rather than a mechanical
  `policy`. The two principles that should anchor the replacement:
  - Knowledge wants concision + queryability → distill hard, cite the raw.
  - Provenance wants fidelity → you cannot reconstruct "what did we actually
    decide, what got rejected, and why" from a lossy summary. A condensed record
    is a worse record.
  Worth preserving in the rewrite: the one still-valid injunction the old slogan
  carried — on intake, don't file the raw paste *as* the document; capture the
  knowledge and cite the source.
