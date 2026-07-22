---
id: em:1b3c79
type: note
title: Future beliefs
description: A running scratch list of facts and observations about the brain's tooling and governance worth formalizing later (into a tutorial, policy, or concept).
tags: [meta, governance, scratch]
timestamp: 2026-07-22
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
- **"Distill, don't dump" was miscast — formalized 2026-07-22 as a doctrine.**
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
- **A rule over off-repo output must be made correct in the tooling it mandates,
  not merely asserted in prose — because it cannot be CI-gated.** Most of the
  brain's rules are enforced *structurally*: `mix brain.verify`, `route_tags`,
  `contract --check` each gate an in-repo artifact and fail CI on drift. But a
  rule governing output that leaves **no repo artifact** — a link, a phrasing, or
  a claim in a chat reply or PR body — has nothing for a verifier to check; it is
  runtime guidance a verifier cannot gate. Its reliability then rests on exactly
  two legs: (a) the tool it directs agents to must return the correct result *by
  construction*, and (b) the contract must forbid the by-hand shortcut that
  bypasses that tool. Asserting the rule harder in prose does **not** move
  reliability. Proof: the
  [response-resource-links](/meta/policy/response-resource-links.md) link bug
  (2026-07-22) — the contract already said "use `mix brain.url`", yet a dead Pages
  URL shipped, because the *tool* was wrong (not branch-aware) and the policy also
  taught a hand-mapping an agent could apply instead. The fix landed in the tool
  (liveness-aware `mix brain.url`) plus an explicit no-hand-construction clause,
  never in a sterner sentence.

  _Note — like the entry above, this is itself an **ought**, destined for
  [`doctrine`](/meta/doctrine/index.md). Descriptive premise underneath: an
  instruction an agent can satisfy *incorrectly while believing it complied* is
  effectively unenforced; only a correct tool or a CI gate closes that gap, and
  off-repo output admits only the former. Sibling of "an artifact states what it
  is" above — both are cases where the durable lever is structural (tool, commit
  graph), not exhortation._

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:1b3c79">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-22-qiju-thread-storage-and-fit-each-layer-doctrine (2026-07-22)

5 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:1b3c79`]**  (co-feeds: `em:bec37f`)

You're right to push, and part of what I told you earlier was sloppy. First, the correction: routing is *not* distillation. The thread body is verbatim; the doc-side route-tagged excerpt log *lifts the tagged regions whole* — verbatim excerpts, headers demoted. So the entire routing/route-tagging apparatus is **provenance wiring, not distillation**. If anyone claimed "the tags/ledger over the threads *are* the distillation," that claim is false — and I effectively made it. You cannot call expository/provenance layering over a verbatim record "distillation." Conceded.

What's actually going on: two artifacts, two policies, two senses of one word. **Knowledge documents** (governed by distill-dont-dump) genuinely distill — raw material goes to citations. **Thread docs** (governed by session-capture) are deliberately verbatim; the policy *explicitly narrows* the word: *"'Distilled' here means the noise is dropped, not that the kept text is condensed."* So the thread doc is a dump minus the noise — that's not a bug, it's the archive layer doing its job. The two layers serve opposite masters: knowledge wants concision + queryability; provenance wants fidelity (you cannot reconstruct "what did we decide and why" from a lossy summary — a condensed record is a *worse* record).

---

**[`em:1b3c79`]**

Done — added to `beliefs/future-beliefs.md`, with your two principles verbatim, and the bundle still verifies clean. On the substance, I agree with you, and your framing is sharper than mine last turn. My "distill vs. dump" split still smuggled in the false binary — you're right on both counts: thread docs aren't cleanly "dumps" (tool-noise is stripped), and knowledge docs aren't cleanly "distillations" — they're often *expansions*, with thread fragments acting as provenance rather than raw material being boiled down. And the deeper point: dump and distill aren't mutually exclusive and don't live on one axis — they describe different layers doing their jobs.

---

**[`em:1b3c79`]**

Both done. The doctrine now reads as a standing positive statement of the direction — the "why this replaces 'distill, don't dump'" section is gone, and the description/provenance/attribution and index entry no longer name what it replaced. The change record lives in git history where it belongs. And the belief: *An artifact states what it **is**, not what it replaced or changed from — the commit graph is the change-narrative layer.* I flagged the deliberate exception (a glossary entry *about* a retired term), cited this session's own first-draft doctrine as the failure case, and wrote the self-referential note: this belief is itself an **ought**, so when formalized it becomes a `doctrine`, never a `note`/`concept`. That connects it cleanly to the normative-conclusion / descriptive-premise distinction — a worked example of a belief that's an *ought*, which is exactly why it's doctrine-bound.

---

**[`em:1b3c79`]**

That's the right challenge — a per-session promise dies with this session, so the question is purely what structural thing a future session inherits. Two things changed, in order of strength. **1. The correctness now lives in the tool, not in agent memory.** The old contract *already* said "use `mix brain.url`" — the failure wasn't that I ignored it, it's that the tool itself returned the wrong URL (hard-coded to Pages, zero branch-awareness). A diligent future agent who ran it would *still* have gotten the 404. So the durable fix was making the tool correct by construction; the knowledge (branch vs main) is embedded in the tool, the only place it reliably persists. **2. The contract now forbids the thing I did** (hand-construction), compiled into `CLAUDE.md`. The honest ceiling: this rule governs off-repo output (chat, PR bodies) with no in-repo artifact to gate, so it can *never* be CI-verified like route-tags or contract-drift — its reliability rests forever on correct tooling + contract adherence. I'm the live proof prose alone is insufficient, which is exactly why the fix went into the tool.

---

**[`em:1b3c79`]**

Both done, committed and pushed. **1. Belief captured** — *A rule over off-repo output must be made correct in the tooling it mandates, not merely asserted in prose — because it cannot be CI-gated.* Grounded in the 2026-07-22 link bug as its proof case, flagged as an *ought* destined for doctrine, and linked as the sibling of the "artifact states what it is" belief — both cases where the durable lever is structural (tool, commit graph), not exhortation. **2. Policy demoted the hand-mapping** — `response-resource-links` now leads with "Get the URL from the tool, never by hand" and reframes `P.md → …P.html` as "what the site does at build time, not a recipe to apply in a response." The trap I fell into is now labeled as the trap, in the compiled contract every session reads.
