---
type: analysis
title: "Decision records as an abstraction over development history: would a decision tree aid the agent and the operator?"
description: Investigates the operator's idea that all development history reduces to a series of decisions — finds the bundle already stores decision rationale across four distilled genres plus the commit graph but leaves unrouted decisions buried in verbatim thread bodies with no connected lineage view; the research literature (design-rationale tradition, LLM/ADR studies, structured agent memory) supports closing exactly those two gaps, and the recommended shape is decision extraction as a /capture step plus a compiled, CI-verified decision graph — a derived view, not a new document genre.
provenance: "Claude Code session (2026-07-20) — operator proposed viewing all work as a series of expandable decisions and asked what a decision-tree view would look like, whether it would aid LLM deduction of the why behind design, how it could aid the operator, and what research exists on decision structures for agentic reasoning"
tags: [meta, analysis, decision-records, design-rationale, session-capture, routing, provenance, agent-memory]
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T21:05:00Z
  channel: agent-authored
  agent: "Claude Code agent, decision-tree-dev-history session"
  why: "operator ratified persisting the decision-tree investigation so the reasoning and its research grounding survive the session"
  from: [/meta/threads/2026-07-20-decision-records-as-history-abstraction.md, /meta/threads/2026-07-20-code-as-compilation-target-and-dsp-testing-model.md]
---

# Decision records as an abstraction over development history

**Question.** The operator proposed that development history across the repo —
all work — can be boiled down to a series of decisions, and asked: given how
thread persistence and route tags currently route content up to documents, what
would it look like to view the design as a **decision record / decision tree**,
expandable into the rationale behind each decision and what was done? Would this
aid the LLM in deducing the *why* behind design? How could it aid the operator?
And has research been done on the efficiency and effectiveness of such
structures for agentic reasoning?

## Evidence 1: where the "why" lives today

The bundle's rationale machinery is rich but **tiered by distillation**, and the
tiers are disconnected:

| Surface | What "why" it holds | Distilled? |
|---|---|---|
| [doctrine](/meta/doctrine/index.md) | standing direction a change serves | yes (highest) |
| [analysis](/meta/analysis/index.md) | the reasoned judgment behind a decision | yes |
| [plan](/meta/plans/index.md) | decision to act + alternatives + build order | yes |
| [issue](/meta/issues/index.md) | the problem being fixed + how | yes |
| commit messages / merge graph | which session changed what, when | semi (prose) |
| thread verbatim bodies + route-tagged excerpt logs | the raw dialogue rationale for anything unrouted | **no — raw prose** |

Key observations from the live corpus:

1. **"Decision record" is already a named concept here — it maps onto `plan`.**
   The [controlled type vocabulary](/meta/policy/controlled-type-vocabulary.md)
   defines `plan` as "a design/decision record for a proposed change," and the
   [persist-plans policy](/meta/policy/persist-plans.md) reads like an ADR
   charter: alternatives weighed, rationale, status lifecycle, "done and
   superseded plans are kept — the decision history is the point." Plans in
   practice do this well (explicit option enumerations, "leaning" notes, scope
   boundaries, `attribution.from` back-links). Some self-label: the
   [swarm-eval harness plan](/meta/plans/inkling-beam-swarm-eval-harness.md)
   opens with "**Decision record.** All of the *why* lives in the analysis."

2. **Unrouted decisions are the gap.** The
   [routing ledger](/meta/policy/routing-ledger.md) is by design "a router,
   never a digest": it *names* a decision as a topic ("Agent-contract declined")
   but carries no rationale. In a representative thread
   ([2026-07-11 branch-deletion](/meta/threads/2026-07-11-branch-deletion-policy-and-contract-as-abstraction.md)),
   6 of 8 ledger rows are `unrouted` — for those strands the only record of the
   reasoning is the verbatim `## Assistant` prose, which an agent must parse
   whole to answer "why was that declined?"

3. **Route tags aggregate content, not decisions.** The
   [route-tagging](/meta/policy/route-tagging.md) excerpt logs lift verbatim
   paragraphs per concept — retrieval-friendly ("everything ever said about X")
   but still raw prose, with the parse cost multiplied across threads. No field
   for decision, alternatives, or status exists in the mechanism.

4. **The immutable record is unabstracted, as the operator observed.**
   Reconstructing a decision's lineage means hopping thread → `pr:` → merge
   commit → `git blame`, by convention. `mix brain.lineage` (from
   `attribution.from` + `pr:` edges) and the derived
   [dev-history](/meta/dev-history.md) mechanize fragments, but **nothing
   answers "what decision governs X, and why" as a single artifact**, and
   nothing connects doctrine → analysis → plan → PR → commit as one graph.

5. **"Decision tree" has zero hits anywhere in the repo** — the abstraction has
   never been proposed — while the vocabulary discussion in the
   [flows-genre thread](/meta/threads/2026-07-09-flows-genre-and-scenario-testing.md)
   already pushed back once on adding a redundant decision-record-shaped *type*.
   Any new layer must justify itself against the anti-fragmentation rule and
   the existing `plan`-as-decision-record convention.

## Evidence 2: the research

Three bodies of work bear directly on the questions asked (captured under
[design-rationale](/knowledge/knowledge-management/design-rationale/index.md)
and [agent-memory](/knowledge/SWE/agentic/agent-memory/index.md)):

1. **The classic design-rationale tradition** —
   [IBIS/gIBIS, QOC, DRL and the capture problem](/knowledge/knowledge-management/design-rationale/design-rationale.md).
   The operator's idea is a direct descendant of representing design as a graph
   of issues → considered positions → arguments → decision. That field
   established the representation's value and then **failed on economics**: the
   capture problem (the author of rationale pays its cost; others reap its
   benefit) killed every tool. An agent-operated brain **dissolves the capture
   problem** — the agent bears the authoring cost, at decision time, inside a
   capture motion it performs anyway. The old research's representation becomes
   newly applicable because its failure condition no longer holds.

2. **LLMs and design rationale / ADRs.**
   - [LLMs recovering design rationale (TOSEM 2025)](/knowledge/knowledge-management/design-rationale/llms-recovering-design-rationale.md):
     post-hoc reconstruction of rationale achieves recall 0.63–0.72 but
     **precision ~0.27**, with 1.6–3.2% of generated arguments potentially
     misleading. This is the strongest empirical argument for the proposal:
     **rationale recorded at decision time is worth far more than rationale
     reconstructed later** — and agent-authored rationale needs the operator's
     editorial pass (the bundle's existing asserted-not-verified stance).
   - [Context strategies for ADR generation (2026)](/knowledge/knowledge-management/design-rationale/context-strategies-for-adr-generation.md):
     across 750 repositories, a **3–5-record recency window of related prior
     decisions** is the optimal LLM context; context engineering, not model
     scale, dominates. A decision node's value to an agent is mostly its local
     neighborhood — exactly what a graph structure makes cheap to fetch.
   - [AgenticAKM (2026)](/knowledge/knowledge-management/design-rationale/agentic-architecture-knowledge-management.md):
     multi-agent workflows generating ADRs from repositories beat naive
     prompting — decision-record authorship is tractable agent work.
   - [Architecture Without Architects (2026)](/knowledge/knowledge-management/design-rationale/architecture-without-architects.md):
     agents make architectural decisions "almost no one reviews as such"
     ("vibe architecting"); its proposed remedy is precisely decision records
     plus review tooling — the operator-side case for a decision audit surface.

3. **Structured memory for agentic reasoning.**
   [EXG experience graphs (2026)](/knowledge/SWE/agentic/agent-memory/experience-graphs-exg.md)
   and the converging 2026 literature (graph memory, event-centric "logic map"
   memory, episodic-memory reasoning) find that **agents reason better and
   cheaper over distilled, linked records than over raw trajectories**, with
   measured performance-efficiency gains over reflection- and
   unstructured-memory baselines. A thread body is a raw trajectory; a decision
   graph is the distilled-and-linked form this literature favors.

## Findings

1. **The idea is sound, and most of a decision-record system already exists in
   disconnected pieces.** What's missing is not a place to store decisions —
   `plan`/`analysis`/`doctrine`/`issue` are that. It is two specific things:
   **(a) distilled rationale for decisions that never got routed** (today
   verbatim-thread-only), and **(b) a single connected lineage view** — the
   tree — spanning doctrine → analysis → plan → PR → commit.

2. **It would aid the LLM, measurably.** A session answering "why is X this
   way" would retrieve a handful of small decision records (the empirically
   optimal 3–5-record neighborhood) instead of parsing multi-thousand-token
   verbatim threads. The reconstruction cost is paid once at capture rather
   than on every future session, and the low-precision result shows the
   re-derivation it replaces is not just expensive but unreliable.

   *A live example of the missing lineage view:* the four 2026-07-20
   **code-as-derived-artifact** sessions — the
   [intent-is-source](/meta/doctrine/intent-is-the-source.md),
   [regenerate-the-change](/meta/doctrine/regenerate-the-change-not-the-system.md),
   and [comprehension-of-generated-code](/meta/doctrine/comprehension-of-generated-code.md)
   doctrines, plus this analysis — are one decision neighborhood: sibling facets of
   a single question, each a child of
   [engineer-as-orchestrator](/meta/doctrine/engineer-as-orchestrator.md). They were
   connected after the fact by hand-authored cross-links (each doctrine's *Sibling
   directions* section); a compiled decision graph is exactly what would surface
   that neighborhood automatically rather than depending on whoever notices the
   adjacency.

3. **It would aid the operator as an audit and navigation surface.** A
   browsable why-map of the brain's evolution; supersession trails showing
   which beliefs were revised and when; and — per the vibe-architecting
   concern — a review surface for decisions agents made that were ratified
   only implicitly.

4. **The repo's own doctrine points to a derived view, not a new genre.** The
   established pattern for exactly this kind of artifact is
   compiled-and-CI-verified (`CLAUDE.md`, `meta/registry.md`,
   [dev-history](/meta/dev-history.md), route-tag logs), and the
   retire-hand-kept-logs lesson is that hand-maintained history layers rot. A
   third *authored* rationale layer would collide with plans and the commit
   graph; a **compiled decision graph** whose nodes point into the existing
   genres does not.

5. **Risks are real but nameable.** Anti-fragmentation: decision records must
   *point to* plans/analyses where those exist, carrying distilled rationale
   only for what would otherwise be unrouted. Confabulation: agent-distilled
   rationale is asserted, operator-ratifiable — never gospel. Staleness: the
   graph must be generated and `--check`-gated or it becomes the next
   hand-kept log.

## Recommendation

Pursue the differentiated version: **decision extraction as a `/capture` step
plus a compiled, CI-verified decision graph** — not an imported ADR directory.
Concretely: `/capture` mints per-decision records (statement, alternatives
declined, 2–4 sentence rationale, links to thread/routed doc/PR) beside the
routing ledger it already writes; typed edges (`implements` a doctrine,
`supersedes` a decision, `refines`) key on stable ids; `mix brain.decisions`
materializes the graph view and verifies it in CI like route tags. Ratified
into the [decision-graph plan](/meta/plans/decision-extraction-and-compiled-decision-graph.md),
which carries the design detail and open questions.
