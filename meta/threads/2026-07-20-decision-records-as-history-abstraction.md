---
type: reference
title: 2026-07-20-decision-records-as-history-abstraction
description: Operator proposed that all development history reduces to a series of decisions and asked what a decision-tree view over the thread/routing machinery would look like, whether it would aid the LLM and the operator, and what research exists; the agent mapped the current rationale surfaces, swept the design-rationale and agent-memory literature, and — on the operator's "Agree proceed" — filed the analysis, the proposed decision-graph plan, and six research captures in two new subdirectories.
provenance: "Claude Code session, 2026-07-20; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, decision-records, design-rationale, session-capture, routing, agent-memory, analysis, plan]
timestamp: 2026-07-20
pr: 113
session: https://claude.ai/code/session_017QVqisck312JJ3o86iLVCk
---

# 2026-07-20-decision-records-as-history-abstraction

## Where this landed

The session opened as a design question: can the brain's development history be
abstracted into a series of expandable decisions — a decision tree — given that
today the immutable record (threads, PRs, git history) is unabstracted? The agent
mapped the current rationale machinery (finding `plan`/`analysis` already occupy
the decision-record slot, unrouted strands leave their rationale in verbatim
thread prose, and no view connects doctrine → analysis → plan → PR), swept three
research bodies (the IBIS/QOC design-rationale tradition and its capture problem;
the LLM/ADR measurements — post-hoc rationale recovery at ~0.27 precision, a
3–5-record neighborhood as optimal context; structured agent memory), and
recommended decision extraction as a `/capture` step plus a compiled, CI-verified
decision graph. The operator ratified ("Agree proceed"); the session filed
[the analysis](/meta/analysis/decision-records-as-history-abstraction.md), the
proposed [decision-graph plan](/meta/plans/decision-extraction-and-compiled-decision-graph.md)
(open questions Q1–Q4 awaiting ratification), and six research captures under two
new subdirectories
([design-rationale](/knowledge/knowledge-management/design-rationale/index.md),
[agent-memory](/knowledge/SWE/agentic/agent-memory/index.md)), then closed with
`/create-pull-request`. A side note: the alphaXiv PDF tool's permission dialog
looped despite repeated operator grants; the agent worked around it with direct
fetches.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Decision records as an abstraction over development history: current-machinery map, research grounding, assessment | closed | [decision-records-as-history-abstraction](/meta/analysis/decision-records-as-history-abstraction.md) | - |
| The decision-graph build: /capture-step minting + mix brain.decisions compiled view | paused | [decision-extraction-and-compiled-decision-graph](/meta/plans/decision-extraction-and-compiled-decision-graph.md) | Operator ratification of Q1–Q4 (record location; backfill; granularity rule; ledger-absorption alternative) |
| Design-rationale research intake (IBIS/QOC/capture-problem concept + four ADR/LLM paper captures) | closed | [design-rationale](/knowledge/knowledge-management/design-rationale/design-rationale.md) | - |
| Structured-agent-memory research intake (EXG experience graphs) | closed | [experience-graphs-exg](/knowledge/SWE/agentic/agent-memory/experience-graphs-exg.md) | - |
| alphaXiv PDF-tool permission dialog looping despite operator grants (worked around via direct fetch) | closed | unrouted | - |

## User

Consider this idea that development history across a repo and all work can be boiled down to a series of decisions. Examine how currently we are using thread persistence and routing tags to route up to concept documents or OKF documents. Consider what it might look like to create a decision tree instead, uh, whereas a way of visualizing and understanding work that has been done Currently, the immutable record is not abstracted. You can either parse the immutable record of thread documentation, or you can parse PRs, or you could parse the Git history. Beyond that, concepts are abstracted into documents and plans and etcetera, various types. What would it be like to view the design as a decision record which could be expanded into the rationale behind decisions and what was done. Um, would this aid the LLM in deducing the why behind design? How could it aid the operator? What could this look like? And has there been research done into this? as far as efficiency and effectiveness for agentic reasoning?

## Assistant

This is a design question about the brain itself, so I'll ground the answer in two passes: first, a look at how the current thread → routing → document pipeline actually preserves (or fails to preserve) decision rationale; second, a sweep of the research literature on design-rationale capture and decision records as an aid to agentic reasoning. Then I'll synthesize what a decision-record layer could look like here.

## User

Granted

## User

Granted

## User

Granted

## User

Pdf tool keeps appearing and i keep approving

## Assistant

The alphaXiv permission dialog was stuck in a loop on the harness side despite your grants — sorry for the noise. I switched to fetching the papers directly, which worked, and I now have everything: a full map of the current rationale machinery (from a repo exploration pass) plus the research literature. Here's the synthesis.

## TL;DR

The idea is sound and the research supports it — but the interesting finding is that the brain already has most of a decision-record system in *disconnected pieces*. `plan` is literally defined in the contract as a "design/decision record," and `analysis`, `doctrine`, and `issue` each carry a slice of "why." What's missing is not a place to store decisions; it's two specific things: **distilled rationale for decisions that never got routed into a document** (today they exist only as verbatim prose inside thread bodies), and **a single connected view** — the tree — spanning doctrine → analysis → plan → PR → commit. The research says both gaps are worth closing: LLMs are demonstrably bad at *reconstructing* rationale after the fact, and structured decision/experience graphs measurably beat raw-trajectory memory for agentic reasoning.

<routes ref="/meta/analysis/decision-records-as-history-abstraction.md">
## What exists today, and where the "why" actually lives

The current pipeline preserves rationale at very different fidelities:

- **Routed strands are in good shape.** When a session's strand gets routed to a [plan](https://ob6to8.github.io/elixir-mind/meta/policy/persist-plans.html) or analysis, the distilled why survives — plans here genuinely function as ADRs (alternatives weighed, explicit "leaning," scope boundaries, status lifecycle, `attribution.from` back to the thread). Some even self-label: the inkling-swarm plan opens with "*Decision record. All of the why lives in the analysis…*"
- **Unrouted strands are the gap.** In a representative thread ([2026-07-11 branch-deletion](https://ob6to8.github.io/elixir-mind/meta/threads/2026-07-11-branch-deletion-policy-and-contract-as-abstraction.html)), 6 of 8 ledger rows are `unrouted`. The [routing ledger](https://ob6to8.github.io/elixir-mind/meta/policy/routing-ledger.html) is by design "a router, never a digest" — it *names* the decision ("Agent-contract declined") but the why lives only in the verbatim `## Assistant` turns. An agent asking "why was that rename declined?" must parse the whole body.
- **Route tags aggregate content, not decisions.** The excerpt logs lift verbatim paragraphs per concept — a scrapbook of everything ever said about X, which is retrieval-friendly but still raw prose, with the parse cost multiplied across threads.
- **The immutable record is, as you say, unabstracted.** Reconstructing a decision's lineage means hopping thread → `pr:` → merge commit → `git blame`, all by convention. `mix brain.lineage` and `meta/dev-history.md` mechanize fragments of this, but nothing answers "what decision governs X, and why" as one artifact.
- One notable negative result: "decision tree" has **zero hits** anywhere in the repo — this abstraction has never been proposed, though the vocabulary discussion in the flows-genre thread already pushed back once on a redundant decision-record-shaped type.
</routes>

## Has there been research? Yes — three relevant bodies

<routes ref="em:2e4803 /meta/analysis/decision-records-as-history-abstraction.md">
**1. Classic design-rationale research (1980s–90s).** Your idea is a direct descendant of IBIS (Rittel), gIBIS (Conklin & Begeman, 1988), QOC (MacLean et al., 1991), and DRL (Lee, 1991): representing design as a graph of *issues → considered positions → arguments → decision*. That field's famous failure mode is the **capture problem** (Grudin): rationale capture died in practice because the person who bears the documentation cost isn't the one who benefits. This is the most important frame for your idea — **an agentic brain dissolves the capture problem**, because the agent bears the authoring cost and does so at decision time. The old research established the representation is valuable; it failed on economics that no longer apply here.
</routes>

<routes ref="em:ce51fc em:4f5372 em:6d6425 em:7fa867">
**2. LLMs and design rationale / ADRs (current).** Directly on your "would this aid the LLM" question:

- [Using LLMs in Generating Design Rationale for Software Architecture Decisions](https://arxiv.org/abs/2504.20781) (TOSEM 2025) measured how well LLMs *reconstruct* rationale post-hoc: recall 0.63–0.72 but **precision only ~0.27**, with 1.6–3.2% of generated arguments potentially misleading. This is the strongest empirical argument for your proposal: inferring the why after the fact is lossy and partly confabulated, so **rationale recorded at decision time is worth far more than rationale reconstructed later** — and it also warns that agent-authored rationale needs the operator's editorial pass (your existing `verified` ethos, applied to decisions).
- [Context Matters: Context Strategies for Automated ADR Generation](https://arxiv.org/abs/2604.03826) (2026, 750-repo corpus) found context engineering — not model scale — is the dominant factor, and that a **small window of 3–5 related prior decision records** is the optimal context. That's a concrete design datum: a decision node's value to an agent is mostly in its local neighborhood, which is exactly what a tree/graph structure makes cheap to fetch.
- [AgenticAKM](https://arxiv.org/abs/2602.04445) (2026) shows multi-agent workflows generating ADRs from repos beat naive prompting; [Architecture Without Architects](https://arxiv.org/abs/2604.04990) (2026) argues agents now make architectural decisions "almost no one reviews as such" — an operator-side argument for a decision view as an *audit surface*.
</routes>

<routes ref="em:221e3e">
**3. Structured memory for agentic reasoning (very current).** [EXG: Self-Evolving Agents with Experience Graphs](https://arxiv.org/abs/2605.17721) (2026) shows organizing accumulated successes/failures into a relational graph yields better performance-efficiency trade-offs than reflection- and unstructured-memory baselines; a cluster of 2026 papers (graph memory, event-centric "logic map" memory, episodic-memory reasoning) converges on the same result: **agents reason better and cheaper over distilled, linked records than over raw trajectories.** Thread bodies are raw trajectories; a decision graph is exactly the distilled-and-linked form this literature favors.
</routes>

<routes ref="/meta/plans/decision-extraction-and-compiled-decision-graph.md">
## What it could look like here

The repo's own doctrine points away from a new document genre and toward a **derived view** — the pattern already used for `CLAUDE.md`, `meta/registry.md`, `dev-history.md`, and the route-tag logs. A sketch consistent with existing machinery:

1. **Mint decisions at capture time.** `/capture` already writes a per-strand ledger; extend it with (or add beside it) a **Decisions** section: one record per decision the session made — the statement, the alternatives declined, a 2–4 sentence distilled rationale, and links (thread anchor, routed doc if any, later stamped `pr:`). This closes the unrouted-rationale gap at the moment the reasoning is freshest, at near-zero marginal cost — the agent just distilled the session anyway.
2. **Edges make it a tree.** Each decision references what it `implements` (a doctrine), `supersedes` (an earlier decision — ADR practice's supersession chain), or `refines`. Keyed on stable ids, per the existing typed-edge rule. The result is a DAG rooted in doctrine, with leaves touching PRs/commits.
3. **Compile the tree; verify it in CI.** A `mix brain.decisions` task materializes the graph view (and a Pages page — an expandable tree where each node opens into rationale, and one more click reaches the verbatim excerpt via the existing route-tag machinery). Same generated-artifact + `--check` discipline as route tags, so the view can't drift — which matters, because the repo already learned (retire-hand-kept-logs) that hand-kept history layers rot.

**How it aids the LLM:** a session answering "why is X this way" retrieves 3–5 small decision records instead of parsing multi-thousand-token verbatim threads — the exact context shape 2604.03826 found optimal, with the token cost of reconstruction paid once at capture instead of every session. **How it aids you:** a browsable why-map of the whole brain's evolution, a supersession trail showing which beliefs were revised and when, and — per the Architecture-Without-Architects concern — a review surface for decisions the agents made that you ratified only implicitly.

**The honest risks:** it's a third rationale layer next to plans and the commit graph, so the anti-fragmentation rule applies — the cleanest resolution is that decision records *point to* plans/analyses when those exist and carry distilled rationale only for what would otherwise be unrouted; and the low-precision finding means agent-distilled rationale should be treated like `claim`s — asserted, operator-ratifiable — not gospel.

My assessment: worth pursuing, and the differentiated version — "decision extraction as a `/capture` step + compiled, CI-verified decision graph" — fits this repo's grain far better than an imported ADR directory would. If you want, I can persist this as a `type: analysis` doc (with the research citations as captures) so the reasoning survives this session, and/or draft it into a `type: plan`.
</routes>

Sources: [LLMs Generating Design Rationale (arXiv 2504.20781)](https://arxiv.org/abs/2504.20781) · [Context Matters: ADR Generation (arXiv 2604.03826)](https://arxiv.org/abs/2604.03826) · [AgenticAKM (arXiv 2602.04445)](https://arxiv.org/abs/2602.04445) · [Architecture Without Architects (arXiv 2604.04990)](https://arxiv.org/abs/2604.04990) · [EXG: Experience Graphs (arXiv 2605.17721)](https://arxiv.org/abs/2605.17721)

## User

Agree proceed

## Assistant

Conventions are clear. I'll file the paper captures under two new subdirectories (`knowledge/knowledge-management/design-rationale/` and `knowledge/SWE/agentic/agent-memory/` — both under established domains, so autonomous), plus the analysis and plan. Let me fetch the one paper I haven't processed yet, and get the current time.

Done — everything is persisted, verified, and pushed to `claude/decision-tree-dev-history-nf2hsn` (commit `c74a512`, 15 files, all gates green: `brain.verify`, `brain.route_tags`, `brain.contract --check`, 177 tests passing).

What landed:

**The analysis** — [decision-records-as-history-abstraction](https://ob6to8.github.io/elixir-mind/meta/analysis/decision-records-as-history-abstraction.html) — the persisted form of the investigation: the six-surface map of where the "why" lives today, the two gaps (unrouted decisions' rationale trapped in verbatim thread bodies; no connected doctrine → analysis → plan → PR lineage view), the research grounding, findings, and the recommendation.

**The plan** — [decision-extraction-and-compiled-decision-graph](https://ob6to8.github.io/elixir-mind/meta/plans/decision-extraction-and-compiled-decision-graph.html), `status: proposed`. It records the direction you endorsed plus the design shape: `/capture` mints per-decision records (statement, alternatives declined, 2–4 sentence rationale, links) beside the routing ledger; `implements`/`supersedes`/`refines` edges keyed on stable ids; `mix brain.decisions` materializing a CI-`--check`-gated tree rendered on the Pages site. It carries four open questions for your ratification before build — most importantly **where records live** (my leaning: a `## Decisions` section in the thread doc, mirroring how route tags live in threads and compile into sinks) and **whether to backfill** the ~40 existing frozen threads (bounded by the post-hoc precision problem).

**The research grounding**, filed as bundle documents in two new subdirectories: [knowledge-management/design-rationale](https://ob6to8.github.io/elixir-mind/knowledge/knowledge-management/design-rationale/index.html) (the IBIS/QOC/capture-problem concept plus the four ADR/LLM paper captures) and [SWE/agentic/agent-memory](https://ob6to8.github.io/elixir-mind/knowledge/SWE/agentic/agent-memory/index.html) (the EXG experience-graphs capture) — six minted ids, indexes and registry updated. The Pages URLs go live once this merges to `main`.

The two advisory warnings about missing `attribution.from` on the analysis and plan are expected — the back-link gets stamped automatically when `/create-pull-request` captures this session's thread. That's the natural next step whenever you're ready: it will freeze this conversation as the thread doc, glossary it, stamp the `from` links, and open the PR.
