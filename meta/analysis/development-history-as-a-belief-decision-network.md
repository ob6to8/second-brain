---
type: analysis
title: "Development history as a belief–decision network: an interpretive audit layer over the immutable record"
description: Evaluates modeling repo progress on two axes — decisions and the beliefs that license them — as a derived audit layer over the unabstracted immutable record (git/PRs/threads); finds the payoff is truth-maintenance over design (staleness cascades onto decisions, an interpretive "why", structural fragility ranking, a contested-vs-load-bearing heatmap), that it is the capstone of the four already-open belief-line plans rather than a new store, and that the LLM-reasoning benefit is a live hypothesis (CB's own C1/C2 falsification) not settled prior art.
tags: [analysis, beliefs, decisions, provenance, epistemic-overlay, truth-maintenance, design-rationale, composable-beliefs, agentic-reasoning, elixir-mind]
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T00:00:00Z
  channel: agent-authored
  agent: "Claude Code session, operator dialogue on decision-tree dev history and the belief×decision two-axis model"
  why: "operator asked whether development history could be abstracted from the immutable record into a decision tree, then into a two-axis network of decisions and beliefs, and whether auditing it deepens codebase understanding and aids agentic reasoning — with the research prior art"
---

# Development history as a belief–decision network

An interpretive audit layer over the immutable record.

## The question

Three escalating framings from one operator dialogue:

1. **Decision abstraction.** All development and repo progress can be read as *a
   series of decisions with recorded reasoning*. The immutable record today is
   **not abstracted**: you can parse thread docs, PRs, or git history, but the
   *decisions and their why* are not a first-class, walkable layer over them.
   Could a "decision tree" be that layer?
2. **Two axes.** Decisions do not float free — *decisions happen because beliefs
   exist*, and *beliefs change over time as data changes*. So progress is
   better modeled on **two axes, decisions × beliefs**, joined by a causal edge.
3. **The audit.** In what way would auditing a network of beliefs and decisions
   yield deeper understanding of a codebase and a project — for the LLM (the
   *why* behind design) and for the operator — and has this been researched?

## 1. Current state — the record is immutable but unabstracted

The bundle already runs a deliberately layered provenance stack (see the
[session-capture](/meta/policy/session-capture.md),
[merge-strategy](/meta/policy/merge-strategy.md), and
[routing-ledger](/meta/policy/routing-ledger.md) policies):

- **git → PR → thread → route-tagged concept.** Commits carry a `Claude-Session`
  trailer; true merges keep branch commits reachable; the thread doc
  (`meta/threads/`) freezes the session verbatim with a `## Routing` ledger and
  `<routes ref="em:…">` tags that aggregate into each sink concept's
  `## Thread excerpts — route-tagged log`.
- **The one existing abstraction is mechanical.**
  [`derived-dev-history`](/meta/plans/derived-dev-history.md) (`status: done`)
  compiles [`meta/dev-history.md`](/meta/dev-history.md) from the first-parent
  merge graph: one section per PR, bulleted with raw commit subjects. It is
  *what changed*, deliberately un-editorialized — **not** *why*.
- **Decision records exist, but the abstraction leaks.** A `type: plan` is
  defined as "a design/**decision** record" and a `type: analysis` as a
  "**decision**-support write-up." But — the operator's key observation — **not
  every decision emerges from a plan.** A plan appears only when a decision is
  big and forward-looking enough to *pre-register* before a fresh-context agent
  executes it. Most decisions are made the other way round: *inline, mid-thread,
  retrospectively justified*, and they land scattered across routing-ledger
  strands (a `closed` row is a resolved decision), route-tagged rationale
  paragraphs, `analysis` recommendations, one-sentence preamble edits, or
  nothing durable but the thread body. A decision layer that only reads `plan`
  docs would capture the decisions someone *remembered to pre-register* — the
  same selection bias that hollows out any hand-kept log.

So the decision axis must be **harvested from both sources**: the
pre-registered layer (plans/analyses, whose "Ratified decisions" / "Decision N"
sections are high-fidelity nodes) *and* the emergent layer (thread routing
ledgers + route tags). The ledger already models the open end of the tree for
free: a `paused`/`open` strand with a **dangling question is an unmade
decision** — an open node.

## 2. The two-axis model

The axes are dual, joined by one causal edge:

```
decision ──predicated-on──▶ belief ──grounded-in──▶ evidence
                              │
                              └──superseded-by──▶ new data
```

**"Belief" carries two senses here, and decisions rest on both** — the dialogue's
"decisions happen because beliefs exist" spans the pair:

- **Operator value-laden prior** — the proposed
  [`belief` type](/meta/plans/belief-type-and-beliefs-namespace.md): "held
  *true enough to guide action* even where unverifiable" ("prefer depth and
  trust over maximum reach"). Some forks are driven by these.
- **Evidence-grounded proposition** — Composable Beliefs' (cb's)
  attestation/aggregation/inference, and this bundle's `claim`/`concept` +
  [`verified_by`](/beliefs/glossary/verified-by.md) evidence edges. Other forks
  are driven by these.

The audit story differs by sense, which is most of the design: a prior is
*retired/refiled* (binary, no oracle); a grounded proposition is *superseded
when its evidence changes* (mechanical cascade). The
[epistemic-overlay plan](/meta/plans/epistemic-overlay.md) already proposes the
four cb operations at *concept* granularity (**Prescription** is a
decision-shaped node), and the belief-type plan **explicitly defers the exact
cross-axis edge** this analysis is about: "*Typed edges from beliefs (e.g. a
plan's frontmatter citing the belief ids it serves, mirroring `verified_by`) —
belongs to the epistemic overlay design space, not here.*" The proposal here is
to build that deferred edge, over *both* belief senses, and attach the
**decision** as the thing on its licensed end.

## 3. Why the linkage yields understanding — truth maintenance over design

A decision justified by belief-premises, where retracting a premise re-opens the
justification, is a **truth-maintenance system** (§6) applied to *development
history*. Four audits fall out that the flat immutable record structurally
cannot provide:

1. **Staleness cascade onto decisions (the killer feature).** When a belief is
   superseded because data changed, *every decision predicated on it lights up
   as "re-examine."* Worked example from this repo's own history: the brain
   believed *"this environment's GitHub credential cannot delete refs (403)"*;
   that belief licensed the decision *"record deletion as an operator step, file
   a todo."* The day a session establishes the credential **can** delete, the
   belief is superseded and — in a belief→decision graph — the stale todo and
   the choice behind it surface **automatically**. Today they simply rot. This
   is cb's staleness-cascade applied to *decisions*, and it is the mechanism the
   three immutable layers cannot supply because none of them records
   *predicated-on*.
2. **An interpretive "why", not a "what".** `git blame` and `dev-history` answer
   who/when/what; the belief→decision walk answers *under what beliefs the
   choice made sense* — the only thing that lets anyone judge whether it still
   does. This is the abstraction the operator identified as missing.
3. **Structural fragility ranking.** A decision resting on many independent
   *verified* beliefs is robust; one resting on a single unverified `claim` is
   fragile — computable from dependency structure, exactly as cb "replaces
   confidence scores with structural support." Yields a query: *"decisions
   standing on retracted or never-verified beliefs"* — i.e. **epistemic debt,
   ranked**, a technical-debt register grounded in erosion of *rationale* rather
   than of code.
4. **Contested-vs-load-bearing heatmap.** Beliefs superseded repeatedly mark
   unstable, contested regions of the design; beliefs that never move are the
   load-bearing axioms — candidates for [`doctrine`](/meta/doctrine/index.md).
   Belief-revision *frequency* is a map of where the project's understanding is
   still settling.

## 4. Would it aid the LLM in deducing the *why*?

Plausibly yes, but **unproven** — and the honest framing matters:

- **Mechanism.** Deducing "why is it shaped this way" is today a retrieval-and-
  *infer* pass over threads/PRs. A belief→decision graph converts it to
  *traversal* of the actual justification structure — cheaper, and auditable.
  More importantly it lets an agent **know when its own reasoning rests on a
  superseded belief** (dependency-directed, not vibes) — the same discipline cb
  uses to keep a compiled `CLAUDE.md`'s rules honest under staleness.
- **Evidence.** This is a *live hypothesis, not settled prior art.* Composable
  Beliefs states it as its own **falsification condition**: "*If C2 [the
  structure-aware agent] does not outperform C1 [flat-instruction agent], the
  thesis needs revision.*" I found no measured result that decision/rationale
  provenance improves LLM code-understanding accuracy specifically (the one
  targeted paper probe this session failed on a flaky connection; treat the
  absence as *not-yet-checked*, not *absent*). Confidence: **medium** on the
  mechanism, **low** on quantified benefit.

## 5. How it aids the operator

- A **queryable why**: "what beliefs does this subsystem rest on, and which have
  eroded?" — decision provenance you can walk, not reconstruct.
- An **epistemic-debt ledger** (§3.3): standing decisions whose grounding is
  retracted or never verified, surfaced the way the
  [`/priorities`](/meta/policy/skills-registry.md) digest surfaces open work.
- **Decision re-litigation triggers** (§3.1): the brain nags when *new data
  undermines an old choice*, closing the gap the current dangling-question
  ledger only half-covers.
- **Onboarding / comprehension**: the human-payoff design-rationale research
  supports (modestly — §6) that recorded rationale aids comprehension of *why*,
  which is where new readers and future agents are weakest.

## 6. Prior art

The bundle has already run the deep spike
([2026-07-11](/meta/threads/2026-07-11-belief-decomposition-analysis-and-epistemic-prior-art.md));
this analysis situates the *decision* axis in it.

- **Truth-Maintenance Systems** — Doyle 1979 (JTMS); de Kleer's ATMS. The direct
  ancestor: a **bipartite graph of belief and justification nodes with
  dependency-directed revision.** A decision is a derived node; its beliefs are
  premises; retract a premise and the justification is revisited. This *is* §3.1.
  Confidence: **high** (foundational, well-established).
- **AGM belief revision** (Alchourrón–Gärdenfors–Makinson 1985) — the formal
  theory of how a belief set changes under new, possibly contradicting data.
  Grounds "beliefs change over time as data changes." Confidence: **high**.
- **Design-rationale capture** — IBIS / gIBIS (Kunz & Rittel; Conklin),
  **QOC** (MacLean & Bellotti, Questions-Options-Criteria), DRL (Jintae Lee),
  Compendium. Four decades of work on recording *why*. The consistent finding is
  the **capture-cost problem**: rationale tooling fails to get adopted because
  the cost of authoring the structure exceeds its immediate payoff, and what is
  captured then goes stale. Any decision-tree here must clear that bar — which is
  the whole reason for the derive-don't-author constraint (§7). Confidence:
  **high** on the failure pattern.
- **Architecture Decision Records** (Nygard 2011; MADR) — the lightweight modern
  descendant (context/decision/consequences/status). Cheap enough to adopt, but
  **manual and per-decision**, so it inherits the same selection bias as a
  hand-kept log: it records the decisions someone chose to write up. This is
  exactly the leak §1 identifies in over-relying on `plan` docs.
- **Toulmin** (argument structure → the graph must be bipartite) and **Dung's
  abstract argumentation** (the grounded extension as a consensus core) — the
  argumentation side, already intaken.
- **Decompose-then-verify** (FActScore, SAFE) and **assurance cases / GSN** —
  the evals-facing and safety-critical applications, with the Haddon-Cave
  caution that argument structure audits *coherence, not truth*.
- **Empirical status.** Human-side: recorded rationale modestly aids
  comprehension but adoption is the perennial blocker (design-rationale
  literature). LLM-side: **thin/unmeasured** — the C1/C2 experiment (§4) is the
  cleanest statement of the open question, and it is the sibling repo's, not a
  published result.

## 7. The governing constraint — derive, don't author

Earned across **three iterations** (see
[belief-decomposition-derived-vs-authored](/meta/analysis/belief-decomposition-derived-vs-authored.md)):
an early assertion graph and **Composable Beliefs itself** both died of the same
cause — atomic beliefs as an *authored* store: cb "became overwhelming: ~400
atomized belief files and a `kind` field sprawled to 40+ values; its atomization
pull was 'bottomless.'" The keystone: **"the belief graph must be a derived,
regenerable analysis artifact, never an authored store."** The decision network
must obey the same guardrails the brain has converged on:

- **Derive the graph, never author it.** The decision nodes are *harvested* from
  plans/analyses and thread ledgers/tags; the edges to beliefs are *proposed*
  candidates the operator ratifies — never a hand-maintained decision store.
- **One `deps` edge kind; types live on nodes.** No second `kind` axis.
- **No confidence scores** — a belief's standing is binary (held / retired), a
  decision's grounding is structural. "Edge count measures how much has been
  written, not how true."
- **The document is the node.** Reuse existing concepts/plans/analyses as nodes;
  do not split a JSON belief store from the OKF artifacts (the mistake cb made).
- **LLM judgment stays local to edges; structure stays global and mechanical.**
  Harvesting a decision and its belief-predicates *from prose* is inference, not
  the mechanical projection `git log --first-parent` gives — that inference is
  the one place the LLM earns its keep and the one place the layer can go wrong,
  so it is an edge-level, ratifiable, regenerable judgment, never baked into a
  store.

## Recommendation

**Model it, and build it as a derived audit overlay — but as the capstone of the
belief line, not ahead of it.** Concretely:

1. **Sequence after the belief axis exists.** The cross-axis edge is meaningless
   until there is a belief layer to point at. Ratify + build
   [belief-type](/meta/plans/belief-type-and-beliefs-namespace.md) and the
   [epistemic-overlay](/meta/plans/epistemic-overlay.md) /
   [belief-decomposition analysis mode](/meta/plans/belief-decomposition-analysis-mode.md)
   first; this overlay is their synthesis.
2. **Harvest decisions from both layers** (§1): plans/analyses as high-fidelity
   nodes; thread routing strands (`closed` = decided, `dangling` = open node) +
   route-tagged rationale as the emergent tissue.
3. **Add the deferred typed edge** (§2) — a decision citing the belief id(s) it
   rests on, mirroring `verified_by` — over both belief senses.
4. **Materialize as a read-only walker + audit render** — a `mix brain.*` task in
   the family of `dev_history` / `route_tags` / `lineage`, with an
   audit-tree render mirroring cb's `mix cb.render.audit` (decision at root, walk
   down through beliefs to grounding evidence, superseded nodes struck through).
   Its highest-value query is the **staleness/epistemic-debt report** (§3.1/§3.3).
5. **Do not** author a decision store, add confidence scores, or atomize — the
   three failure modes §7 is built to avoid.

The idea is sound and unusually well-fitted to this brain: it is the one edge its
own design already drew a box around and deferred, and it turns the existing
immutable record from something you *parse* into something you can *audit for
why*. What is genuinely unproven is the quantified agentic-reasoning payoff —
which this repo, uniquely, is positioned to *measure* rather than assume.
