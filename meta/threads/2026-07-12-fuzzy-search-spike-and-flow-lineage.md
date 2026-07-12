---
type: reference
title: 2026-07-12-fuzzy-search-spike-and-flow-lineage
description: Located the "fuzzy search above grep" research spike (the vector-DB recall analysis → dedup-recall probe, already shipped as mix brain.dedup_probe), then designed and built flow-doc lineage — a canonical lineage frontmatter block per flow doc from which mix brain.lineage derives per-doc blockquotes and a cross-flow Mermaid+table index, --check-gated, with all eight flow docs retrofitted.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-12; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, flows, lineage, provenance, dedup, recall, fuzzy-search, tooling]
timestamp: 2026-07-12
pr: 56
---

# 2026-07-12-fuzzy-search-spike-and-flow-lineage

## Where this landed

Two connected matters. **First**, the operator asked whether an earlier research
spike — a fuzzy search sitting *above* lexical `grep` to raise system integrity —
could be found or replicated. It was found, and it had already shipped: the
[vector-DB recall analysis](/meta/analysis/vector-db-recall-for-the-scaling-bundle.md)
(which measured that grep misses ~6/14 natural-phrasing dedup queries — a *semantic*,
not typographic, failure) led to the
[dedup-recall-probe plan](/meta/plans/dedup-recall-probe.md) and the working
`mix brain.dedup_probe` tool. The live probe reproduced its baseline (plain 3/10,
expanded 10/10). The "fuzzy" layer is deliberately synonym-expanded intake dedup, not
a vector DB.

**Second**, that lookup motivated a general idea: make the *provenance arc* explicit
in flow docs, so a reader sees from the top that a problem identified in an `analysis`
led to a `plan`, was implemented in a PR, and now runs as this flow. This was
designed and fully built in-session as a
[flow-lineage plan](/meta/plans/flow-lineage-index.md): a canonical `lineage:`
frontmatter block per flow doc (scalar-or-list fields; analysis/plan/thread/pr), from
which `mix brain.lineage` materializes a per-doc blockquote and derives a standalone
cross-flow index ([`meta/flows/lineage.md`](/meta/flows/lineage.md) — Mermaid flowchart
+ table), `--check`-gated in CI and the pre-commit hook. All eight flow docs were
retrofitted, tracing **feature** lineage (problem → running system), not doc authorship.
The operator's answers to four design questions (frontmatter over prose; include the
thread; standalone index; both Mermaid and table; materialize the blockquote) were
delivered mid-session and corrected an earlier prose-only default the agent had built
against.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Find/replicate the "fuzzy search above grep" research spike | closed | [vector-db-recall-for-the-scaling-bundle](/meta/analysis/vector-db-recall-for-the-scaling-bundle.md) | - |
| Make the analysis→plan→PR→flow arc explicit in flow docs (design + build) | closed | [flow-lineage-index](/meta/plans/flow-lineage-index.md) | - |
| Feature-lineage vs. doc-authorship-lineage choice | closed | [flow-lineage-index](/meta/plans/flow-lineage-index.md) | Operator may prefer doc-authorship tracing; one edit per block if so |

## User

At a certain point, I did a research spike into a fuzzy search method that would sit above lexical search, i. e. GREP, and would increase the integrity of the system. Are you able to find that, or are you able to replicate this search?

## Assistant

<routes ref="/meta/analysis/vector-db-recall-for-the-scaling-bundle.md /meta/plans/dedup-recall-probe.md">
Yes — found it, and it's not just a memory: **the spike shipped as working tooling**, and I just ran it live above (plain 3/10, expanded 10/10 — matching the committed baseline).

## What you built

The "fuzzy search above grep, for integrity" research spike is a three-document arc plus real Elixir tooling. The through-line: intake dedup — finding the existing concept a new item should merge into — is the entry gate that protects the brain's integrity against duplicate/fragmented concepts, and it was silently guarded by lexical `grep`, which fails **semantically**.

**1. The analysis** — [`meta/analysis/vector-db-recall-for-the-scaling-bundle.md`](/meta/analysis/vector-db-recall-for-the-scaling-bundle.md) (2026-07-09)
The stress-test that started it. You asked whether a vector DB would improve recall as the bundle scales. The probe (run by hand against the live 39-concept corpus) **falsified the "no signal yet" premise**: grep already missed ~6 of 14 natural-phrasing dedup queries. Crucially, the failure is *vocabulary mismatch, not typos* — "lost in the middle" ≈ "context rot" share zero tokens, so typo-tolerant engines (Meilisearch/Typesense) can't bridge it. The verdict: **don't reach for a vector DB** at this scale; fix intake dedup instead, with zero new dependencies.

**2. The plan** — [`meta/plans/dedup-recall-probe.md`](/meta/plans/dedup-recall-probe.md) (`status: done`)
Turned the one-shot hand-run into a repeatable instrument, and shipped the tier-1 fix.

**3. The eval + tooling** (all built, on `main`):
- [`meta/evals/dedup-probe.md`](/meta/evals/dedup-probe.md) — the id-keyed gold set (14 seed probes → `sb:` ids, with `target`/`negative`/`quarantine` bands and synonym-expansion variants)
- [`SecondBrain.DedupProbe`](/lib/second_brain/dedup_probe.ex) + [`mix brain.dedup_probe`](/lib/mix/tasks/brain.dedup_probe.ex) — the offline, deterministic, zero-dep probe (plain + `--expanded` + `--update-baseline`)
- The **tier-1 fix landed in [`/intake`](/.claude/skills/intake/SKILL.md)**: dedup now requires the agent to generate 3–5 alternate phrasings and grep each, and every intake auto-harvests a gold row from your actual phrasing.

## The core finding, in one line

The measured recall gap is the whole point:

| mode | recall | what it means |
|------|--------|---------------|
| **plain** (grep as-is) | **3/10** | what mechanical lexical search actually recovers |
| **expanded** (synonym-expanded dedup) | **10/10** | what the tier-1 "use the LLM in the loop as the semantic layer" fix recovers |

So the "fuzzy search above lexical" is deliberately **not a vector DB** — it's synonym-expanded query generation at intake, with the probe as the quantified trigger for tier-2 (cached embeddings, brute-force cosine, still no DB) *only if the plain figure starts degrading as the corpus grows*.
</routes>

## Note

_The remainder of the first reply (a note on the fresh spike branch and offered next steps) is omitted here; it was superseded immediately by the second matter._

## User

Given that it takes research, such as we've done here, to investigate the source of development spikes emerging from analyses that lead to plans such as what was described here, could it be worth making this explicit in, let's say, flow documents so that you could read the associated flow document and it could be described from the beginning that an idea or a problem was identified within an analysis document which led to a plan which was implemented in this PR and then leads to this flow? Something like this.

## Assistant

This is a genuinely good instinct, and part of it is already latent in the docs — it's just not surfaced consistently.

The arc you're describing already exists as a chain of citations, just scattered and one-directional:

- The **flow** (`dedup-recall-probe.md` §4) points back to *"the [plan] holds the reasoning… the [vector-DB recall analysis] holds the evidence that started it."*
- The **plan** (`Status & provenance`) points back to the analysis and says it *"executes recommendation 1"* of it.
- The **analysis** stands at the head with no forward pointer to what it caused.

So today you can walk the chain backward if you already know to look, but there's no single place that shows the whole arc **problem → plan → PR → running system** at a glance, and the forward direction (analysis → "here's what I became") is missing entirely.

## Assistant

<routes ref="/meta/plans/flow-lineage-index.md">
## The proposal: a standardized "Lineage" header on flow docs

A flow doc gets a short, consistently-placed blockquote right under the title — a one-line walk of the arc from problem-identified to running-system, with each hop a link.

Why this shape fits the bundle's grain:

- **It closes the loop.** The backward links already exist (flow→plan→analysis); this adds the one missing edge — the analysis/plan gaining a *forward* pointer to what they became — and puts the whole chain in one glance instead of three hops.
- **Points, doesn't restate** — the discipline the flows genre already follows. It's four links and a clause, not a retelling.
- **Heterogeneous by design.** Not every flow has the full chain. `session-capture` and `render-contract` predate the analysis→plan discipline; the flows genre *itself* came from the flows-genre plan with no upstream analysis. So the header omits absent hops and can note "no originating analysis — emerged directly as a plan." Honest gaps beat forced ones.
- **It's a genre-convention change**, so it belongs codified in `meta/flows/index.md` (the genre definition) and noted in the flows-genre plan — and, per the contract, that's a change to the *shape* of the brain that you ratify, which is exactly what you're doing here.

One connection worth flagging: this is a lightweight, prose version of what the epistemic-overlay plan (`proposed`) wants to make a first-class typed graph (analysis *inspires* plan, plan *implemented-by* PR). I'd treat this flow-header convention as the pragmatic now-move and let it inform that plan later, rather than building the graph machinery for this.
</routes>

## User

_[operator attached a screenshot of their in-app answers to the two design questions]_ You can See what my responses actually were here, and they were different from your recommended

## Assistant

Thank you — that's an important correction. Your actual answers were **not** my defaults. Let me read them precisely:

- **Encoding:** *"What if we do frontmatter, and then a registry/index can be derived which acts as a flowchart of sorts? Also we need to include the thread"* → **frontmatter as canonical**, a **derived index/flowchart** generated from it, and the **thread** included in the chain.
- **Scope:** *"Begin with this step, then make a plan to retrofit all flow docs"* → do the reference instance now, then **persist a plan** for the full retrofit + the derived index.

So I got both wrong. Let me correct: convert the reference instance to frontmatter, include the thread, and write the retrofit plan.

## Assistant

<routes ref="/meta/plans/flow-lineage-index.md">
Corrected and pushed. Here's what changed once I could read your actual answers.

## What your answers changed

| Fork | My wrong default | Your answer | Now built |
|---|---|---|---|
| **Encoding** | prose blockquote only | **frontmatter canonical + a derived registry/index acting as a flowchart** | `lineage:` frontmatter is the source of truth; the blockquote and a cross-flow flowchart are *derived* from it |
| **The chain** | analysis → plan → PR | *"also include the thread"* | analysis → plan → **thread** → PR → flow |
| **Scope** | dedup instance + convention, backfill later | *"begin with this step, then make a plan to retrofit all"* | dedup instance done + a persisted `type: plan` for the full retrofit |

The reference instance (`meta/flows/dedup-recall-probe.md`) now carries the canonical `lineage:` block, the plan (`meta/plans/flow-lineage-index.md`, `status: in-progress`) captures the frontmatter schema + the derived flowchart tooling + the retrofit, and four open questions remained for you to ratify before I built the tooling.
</routes>

## User

Can you expand on number one I'm not following? Number two, yes, stand alone. Number three, agree both. Number four, materialize.

Are you asking me whether you should ex... execute the plan here and now?

## Assistant

Good — let me clear up #1, lock in the rest, and answer your direct question.

## Expanding on #1 (field multiplicity)

The question is just: **can each lineage field hold more than one value, or exactly one?**

It comes up because a flow doesn't always trace to a single analysis, single plan, single thread, single PR. Real cases:

- **The dedup flow already has two relevant PRs** — the analysis landed in **PR #25**, the implementation in **PR #50**.
- **A flow built across several sessions** — the flows genre itself was built over multiple threads. Its `thread:` would need to be a *list*.
- **Two upstream analyses feeding one plan** — possible, though rarer.

**My lean: allow scalar-or-list per field** — a bare value when there's one (keeps the common case clean), a YAML list when there are genuinely several. The `mix brain.lineage` parser normalizes both.

## The rest, locked in

- **#2 flowchart location** → standalone generated `meta/flows/lineage.md` ✓
- **#3 Mermaid vs table** → both (Mermaid flowchart + table fallback) ✓
- **#4 per-doc blockquote** → materialize (generated, not hand-kept) ✓

## Your direct question — yes

Yes, that's exactly what I was asking: **execute the plan now, in this session, vs. leave it filed as the record for a later one.** I can build it here and now — `lib/second_brain/lineage.ex` + `mix brain.lineage` (`--check`/`--materialize`), the test, CI wiring, retrofit all 7 remaining flow docs, generate `meta/flows/lineage.md`, run the gates.

If you're good with the **scalar-or-list** lean for #1, say go and I'll execute the whole thing this session.

## User

Scalar and list and I'm good with you executing the whole thing this session if you think your context is large enough for it.

## Assistant

Key finding before I write code: the bundle's `SecondBrain.Frontmatter` parser is deliberately **flat** — it doesn't parse nested YAML maps. So the `lineage:` block needs its own small parser inside the new module (which also lets me handle the scalar-or-list requirement cleanly). The nested block is still valid YAML and harmless to every existing consumer (flow docs live under `meta/`, which the registry/verify scanners already exclude). Good — that shapes the design.

## Assistant

<routes ref="/meta/plans/flow-lineage-index.md lib/second_brain/lineage.ex">
Executed and pushed. The whole thing shipped this session.

## What got built

**Tooling** — `mix brain.lineage` (`--materialize` / `--check`), backed by `SecondBrain.Lineage` and pinned by `test/second_brain/lineage_test.exs` (8 tests). It:
- parses each flow doc's `lineage:` block — a small **nested-YAML reader**, because the bundle's own `Frontmatter` parser is flat and can't do nested maps (a real constraint I hit mid-build),
- **materializes a per-doc blockquote** between markers at the top of each flow doc,
- **derives `meta/flows/lineage.md`** — a Mermaid `flowchart LR` *plus* a dependency-free table.

**Fields are scalar-or-list** as you asked — a bare value for the single-hop case, a YAML list when a flow was built across sessions (e.g. site-build's `pr: [26, 28]`).

**Retrofit** — all 8 flow docs now carry a `lineage:` block and generated blockquote.

**Gate** — `mix brain.lineage --check` is wired into `ci.yml` and the pre-commit hook, right beside the contract/registry drift gates. All gates green: 116 tests, contract/registry/verify/route_tags/lineage checks, and the site build (307 pages).

## Two judgment calls I made for you (both easily reversed)

1. **Feature lineage, not doc-authorship.** The research turned up that most flows have *two* provenance layers — the PR that built the feature, and the later PR (#48) that wrote the flow doc in a batch. I recorded the **feature** arc (problem → running system), matching the dedup instance and your mental model of "implemented in this PR." If you'd rather trace when each *page* was written, it's one edit per block.

2. A couple of thread `title:` fields are literally their filename slug, so those labels read as dates. The chart/table pick up whatever title the thread carries — fixable by improving those threads' titles, not the tooling.

The bug the test caught along the way (`:plan` and `:pr` both hashing to node id `f0p`, colliding in the chart) is fixed and regression-pinned.
</routes>
