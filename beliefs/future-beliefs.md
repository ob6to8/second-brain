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
- **"Distill, don't dump" was miscast — formalized 2026-07-21 as a doctrine.**
  The slogan read as a single dump-vs-distill axis, but the two are neither
  accurate nor mutually exclusive here: thread docs are near-*dumps* (verbatim,
  only tool-noise stripped) and knowledge docs are near-*distillations* — yet
  really *expansions* of thread fragments, which function as provenance. Dump and
  distill also operate at *different levels of the system*, so pitting one
  against the other misdescribed the architecture. Resolved by retiring the
  slogan and creating the doctrine
  [fit each layer to its purpose](/meta/doctrine/fit-each-layer-to-its-purpose.md),
  anchored on two descriptive premises:
  - Knowledge wants concision + queryability → distill hard, cite the raw.
  - Provenance wants fidelity → you cannot reconstruct "what did we actually
    decide, what got rejected, and why" from a lossy summary. A condensed record
    is a worse record.
  The old policy became
  [capture-knowledge-cite-the-source](/meta/policy/capture-knowledge-cite-the-source.md)
  (the knowledge-layer filing rule the slogan validly carried); the is-to-ought
  structure of the move is recorded in the
  [is-to-ought analysis](/meta/analysis/is-to-ought-belief-grounds-doctrine.md).
- **An artifact states what it *is*, not what it replaced or changed from — the
  commit graph is the change-narrative layer.** A document should read as a
  standing statement of its current shape and rationale. It must not narrate its
  own genesis or supersession: "this retires X", "previously Y", "reframed from
  Z", "formerly the … slogan" all belong in the commit message and git history —
  which already carry the change, cited by SHA — not in the artifact body or
  frontmatter. In-artifact change-narration is redundant on write and goes stale
  as the thing it references recedes. This generalizes the principle already held
  for logs — [no hand-kept `log.md`](/meta/policy/reserved-filenames.md), the
  [true-merge commit graph as the single provenance layer](/meta/policy/merge-strategy.md)
  — from logs to artifact bodies at large. Deliberate exception: a glossary entry
  *about* a retired term, where explaining that the term is retired *is* the
  entry's subject, not gratuitous self-narration. Recurring failure mode: agents
  write "what this replaces" into the very artifact being created (this session's
  first draft of the fit-each-layer doctrine did exactly that).

  _Note — this belief is itself an **ought** (a prescriptive/normative rule), not
  a descriptive observation like the entries above it. So when formalized it
  becomes a [`doctrine`](/meta/doctrine/index.md) (or a `policy` implementing
  one), never a `note`/`concept` — see [normative conclusion](/beliefs/glossary/normative-conclusion.md)
  vs. [descriptive premise](/beliefs/glossary/descriptive-premise.md). The
  descriptive premise underneath it: the commit graph already records what
  changed, so in-artifact change-narration is duplicative and staleness-prone._
