---
type: reference
title: 2026-07-09-testing-methodology-types-and-cb-epistemic-overlay
description: A session that filed an agent-facing Elixir testing methodology, ratified the `methodology` and `plan` types, derived the "type an edge only when a machine must traverse it" link principle, compared this bundle against the operator's Composable Beliefs repo, and filed the epistemic-overlay plan.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-09; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, testing, types, epistemics, composable-beliefs, edges, plan]
timestamp: 2026-07-09
session: https://claude.ai/code/session_017qb8ZQk2mq3QpS33rT8SZS
pr: 29
---

# Thread — testing methodology, methodology/plan types, and the Composable Beliefs epistemic-overlay plan

## Where this landed

The session opened on a concrete task — synthesize the two matklad testing
references already in the brain into an agent-facing testing methodology for this
repo's dependency-free Elixir tooling — and filed
[`elixir-second-brain-testing-methodology`](/SWE/testing/elixir-second-brain-testing-methodology.md)
(`em:d58da3`). Questioning its `type` led to ratifying a new **`methodology`**
type, adding reciprocal links to the two references, and aligning tags. A tangent
on why cross-links stay untyped prose produced a durable principle — **"type an
edge only when a machine must traverse it; prose carries the semantics humans
read, types carry the semantics machines act on"** — and a clean
policy/definition decomposition of it. The operator then pointed at their other
repo, **Composable Beliefs (CB)**, wondering if this brain was emergently veering
into its territory. A deep read confirmed it: this bundle has independently
re-grown CB's skeleton (OKF substrate, stable ids, evidence edges, compiled
contract, reserved index/threads). The diagnosis: CB is well-engineered but
carries three uncommitted purposes on one substrate; its four-type epistemic layer
(attestation/aggregation/inference/prescription) is the one genuinely universal
piece this brain already uses implicitly. That produced the **`plan`** type and
the first plan, [epistemic-overlay](/meta/plans/epistemic-overlay.md)
(`status: proposed`) — a frontmatter-native overlay that would promote the latent
epistemic structure, bounded explicitly against atomization and strength-as-count.
All work merged to `main` via PR #22; the plan is left proposed.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Testing methodology synthesized from the two matklad essays | closed | [testing methodology](/SWE/testing/elixir-second-brain-testing-methodology.md) | - |
| `methodology` type ratification; reciprocal links; tag alignment | closed | [type vocabulary](/meta/policy/controlled-type-vocabulary.md) | - |
| Typed vs untyped edges — "type an edge only when a machine must traverse it" | closed | [epistemic-overlay plan](/meta/plans/epistemic-overlay.md) | - |
| Decomposing the principle into one policy + two definitions with support edges | closed | `unrouted` | - |
| Composable Beliefs comparison and diagnosis (three uncommitted purposes) | closed | [epistemic-overlay plan](/meta/plans/epistemic-overlay.md) | - |
| `plan` type + the epistemic-overlay design | paused | [epistemic-overlay plan](/meta/plans/epistemic-overlay.md) | Accept the plan and start the first slice? Q1–Q4 (role source, edge shape, supersession-first, granularity guarantee) are open. |

## User

Read the two testing articles here, reference the fact this is an elixir app, and summarize the articles into a testing methodology that can be read by agents and applied to building a test suite for this app

## Assistant

<routes ref="em:d58da3">
I read the two testing articles already in the brain, grounded them in this repo's actual Elixir tooling, and filed a synthesized methodology. I produced `SWE/testing/elixir-second-brain-testing-methodology.md` — an agent-facing methodology that maps each principle onto this app's real modules rather than restating theory: **Purity → ExUnit mechanics** (`Frontmatter`/`Policy` are pure → `async: true`; the IO-touching `Registry`/`Contract`/`Verifier` → `async: false` + `@moduletag :tmp_dir`); **Features-not-code** (assert on the verifier's error strings and rendered output, not private helpers; inject the `root` arg instead of mocking `File`); **The `check` chokepoint** (the existing `write_concept`/`write_policy` fixture builders, promoted to `test/support/` when shared); **Golden/snapshot tests** (the `write`→`check`→drift round-trip for the generated `CLAUDE.md` and `meta/registry.md`); and a **generative ladder** (properties for `mint`/frontmatter round-trip, exhaustive enumeration for the `type` vocabulary — flagging that StreamData would be a new dependency needing ratification). Plus a concrete 7-step checklist and treating `mix brain.*`/`mix format --check` as part of the suite.
</routes>

I minted the id, updated the testing `index.md` and `log.md`, regenerated `meta/registry.md`, and verified everything: 14 tests pass, `brain.verify`/`registry --check`/`contract --check`/`format --check` all green. Committed and pushed.

One note per the operating contract: this stayed within the existing `SWE/testing/` directory, so no taxonomy change needed ratification. I filed it as `type: note` (an authored synthesis, `verified: false`) rather than `claim`/`concept` — let me know if you'd prefer it typed differently.

## User

What about the type being "methodolody"?
How will it be linked to the two testing articles, and how will they link to it?
What tags might it have?
How would it become verified?

## Assistant

Good questions — these four probe exactly where this doc sits awkwardly against the contract. Let me answer each honestly, because two of them touch the *shape* of the brain (which is your call to ratify, not mine).

**1. Type — should it be `methodology`?** Right now it's `note`, and `note` is a slightly loose fit. The controlled vocabulary defines `note` as "a distilled idea, observation, or thought" — but this is a *repeatable procedure*, prescriptive guidance meant to be applied. That's a different animal from a note, and also from `concept` (a mental model/definition) and `snippet` (a single reusable fragment). The contract's own rule: *"If nothing fits, propose a new type rather than forcing a bad one"* — and new types need your ratification. There's a real case for `methodology`.

**2. Linking — to the articles, and back.** This → articles is already done, as untyped prose markdown links (intro + Citations), using bundle-absolute paths. Articles → this is *not yet reciprocal* — the clean fix is a one-line "Applied in:" prose link in each reference pointing at this doc. Note the one *typed* edge in this bundle — `verified_by` — is not for this relationship; it's strictly evidence. So "this is derived from those" stays a prose link, deliberately.

**3. Tags.** Current: `[testing, software-engineering, elixir, exunit, test-strategy, methodology]`. One inconsistency: both source references use `test-design`, and I used `test-strategy` — I should align to the established tag so the three files cluster. My recommendation: `[testing, software-engineering, test-design, elixir, exunit]`.

**4. How it becomes verified.** Per the contract, `verified: true` is eligible here (the note has no `resource`), and requires a non-empty `verified_by` of existing ids that jointly support it. But a methodology has two different claim-classes: **Fidelity** ("this faithfully distills matklad's essays") → grounded by `verified_by: [em:a5ea86, em:73115b]`; and the **app-mapping** ("`Frontmatter` is pure → `async: true`") → not supported by matklad at all, but capturable as `type: source` snippets of the code. And a legitimate third answer: a methodology is prescriptive, and `verified` speaks to checked-against-evidence factual claims, so `verified: false` may simply be its correct resting state.

## User

*methodology

## Assistant

<routes ref="em:d58da3">
You ratified `methodology`, so I minted it and wired everything through the four questions you raised. **1. Type — now `methodology`.** Added to the controlled vocabulary in `meta/policy/controlled-type-vocabulary.md`, recompiled `CLAUDE.md`, and retyped the doc `note` → `methodology`. **2. Linking — now reciprocal.** The methodology already linked to both articles; I added an "Applied in:" back-link to each reference (`em:a5ea86`, `em:73115b`), kept as untyped prose links. **3. Tags — aligned.** `test-strategy` → `test-design` and dropped `methodology` as a tag since it's now the type. Final: `[testing, software-engineering, test-design, elixir, exunit]`. **4. Verification — left at `verified: false`.** I didn't force it; the path stays open (`verified_by` the two references for fidelity, or `type: source` code captures for the mapping).
</routes>

Also relabeled the index section Notes → Methodologies. All checks green (14 tests, `contract`/`registry --check`, `verify`, `format`), committed as `6dfaaae` and pushed. One note: `methodology` is now a permanent addition to the type vocabulary — every future agent will see it in `CLAUDE.md` and can file playbooks/SOPs under it.

## User

Why are we forced to keep links untyped prose?

## Assistant

We're not, actually — and that's the useful correction. Read literally, the contract sets up **two** edge mechanisms and only calls *one* of them untyped: **Body prose links** — untyped, path-based ("Links are untyped edges; the prose carries the meaning"); and **Frontmatter edges** — typed, id-based. Today there's exactly one (`verified_by`), but `stable-identity.md` says it in as many words: *"Structured frontmatter references (`verified_by`, and future typed edges) point at stable ids."*

So typed edges already exist and more are explicitly anticipated. The question isn't "why are we forbidden" — it's "where's the line between what earns a type and what stays prose." That line is drawn on one criterion: **Typedness is reserved for edges a machine needs to act on.** `verified_by` is typed because tooling consumes it: it flips `verified: true`, `mix brain.verify` enforces that its targets resolve, and `mix brain.evidence` derives the verification narrative from it. A "derived from" / "applied in" link has no machine consumer, so making it typed would buy nothing and cost duplication (the sentence already says the relationship better than a label could), infrastructure, and a brittleness tradeoff (prose links tolerate breakage; typed edges get enforced).

So the design is: **prose by default, typed when tooling must traverse it.** It's a deliberate cost/benefit line, not a prohibition. When *would* a relationship graduate to a typed edge? When you want a machine to walk it — e.g. a `supersedes` edge so tooling could auto-flag deprecated concepts. At that point you'd propose it exactly like we proposed `methodology`.

## User

Ok makes sense
It seems what you just stated is worthy of a concept doc type "methodology" itself. Or some other type?

## Assistant

Right instinct to interrogate the type — but no, this one isn't a `methodology`. That's the sharp distinction we just drew: a `methodology` is a *prescriptive, repeatable procedure* ("to do X, follow these steps"). What I stated is a **design principle plus its rationale** — a mental model explaining *why the system is shaped the way it is*. Different category.

There are actually two separable things: **1. The transferable principle → `concept`.** "Type an edge only when a machine must traverse it; prose carries the semantics humans read, types carry the semantics machines act on." That's a general knowledge-representation idea. **2. The governing rule for *this* brain → `policy` (and it mostly already exists).** The normative version is a governance rule, which is what `policy` is for; but per update-in-place, it's a clarifying sentence that belongs folded into the existing `meta/policy/stable-identity.md`, not a new doc.

## Assistant

Fair — you were asking a typing question, not asking me to file anything. To land it plainly: **It's not a `methodology`.** A methodology is a prescriptive procedure. What I described is a design principle and its rationale — a mental model of *why* the system is shaped this way. That's a **`concept`**, or, in its normative "this is the rule here" form, a **`policy`** — and as policy it already half-lives in `meta/policy/stable-identity.md`. The general test that decides it: does the doc tell you *how to carry out a recurring task* (methodology), *what something is / how to think about it* (concept), or *a rule for how the brain operates* (policy)?

## User

I would argue that "Type an edge only when a machine must traverse it; prose carries the semantics humans read, types carry the semantics machines act on" conflated "policy" and "definitions", ie.

1. Type an edge only when a machine must traverse it - (policy)

2. prose carries the semantics humans read (definition)

3. types carry the semantics machines act on (definition)

1 would be linked supportively to/by 2 and 3

## Assistant

Agreed — and the conflation was real. My one-liner welded a *directive* to its *grounds* and called the weld a single "principle." Your cut is cleaner: **1** → `policy` (normative — it tells an agent what to *do*); **2** → `concept` (descriptive — it defines what a prose link is *for*); **3** → `concept` (same shape). And the structural point you're really making is the good one: **1 is *derived from* 2 and 3, not independent of them.** The rule *falls out* of the two definitions. So the edge is `1 ──grounded-by──▶ {2, 3}`.

Here's the part that closes the loop: that "grounded-by / supported-by" edge is **the same shape as `verified_by`.** `verified_by` is *statement ← supported by ← evidence captures*. Yours is *policy ← supported by ← definitions*. Both are justification edges. So apply our own criterion: should `1 ← {2,3}` be typed? Only if a machine must traverse it. Today nothing does → prose. But it's a genuine candidate — the day we want tooling to flag a derived policy for re-review when one of its grounding definitions changes, `grounded_by` earns typing exactly the way `verified_by` did. Your split doesn't just separate the three docs correctly; it predicts where the *next* typed edge would come from.

## User

Examine another repo i have built. I wonder if we are emergently finding ourselves  veering into its territory. I shifted dev focus away from it because I got overwhelmed and couldn't figure out if I was spinning my wheels. I wanted to rebuild something simpler from first principles to try and isolate the essential functionality. And here we are

https://github.com/composablebeliefs/composable-beliefs

## Assistant

<routes ref="/meta/plans/epistemic-overlay.md">
Yes. You're not veering *near* its territory — you've independently re-grown its skeleton. This isn't a vague resemblance. Same substrate (Elixir, mix task suite, ~zero deps, deterministic, offline read path), same `CLAUDE.md` compiled from source, same OKF bundle, same controlled type vocab (`source`/`concept`/`reference`/`index`/`thread`…), same immutable-capture `source`, same reserved per-directory `index`, same `meta/threads/` + persist-thread concept, same evidence-edge model (`verified_by` ≈ CB `deps`), same derived-not-stored verification, same stable-immutable ids. From a clean start. The tell is in your last two messages, not just the repo: two turns ago you decomposed one sentence into "1 = prescription, 2 & 3 = definitions, and 1 is supported by 2 and 3" — and CB's own `types.md` has a "Descriptive vs. Prescriptive Distinction," and its four structural types are Attestation → Aggregation → Inference → Prescription. You reinvented your own epistemic ontology, live, without invoking it.
</routes>

<routes ref="/meta/plans/epistemic-overlay.md">
So: wheel-spinning, or signal? **Signal. Emphatically.** Independent convergence from a deliberately simpler starting point is triangulation — it's evidence you found the essential structure, not evidence you wasted months. But here's the distinction that matters: second-brain re-grew the skeleton, not the musculature — and the musculature (the six self-enforcing contracts, cross-ruler corroboration, run manifests, the eval-ledger domain, BEAM federation) is exactly what overwhelmed you, and it's almost all the *eval-methodology application*, not the knowledge core. The overwhelm wasn't a design failure in the substrate; it was a scoping failure. And the principle we derived this session — "type an edge only when a machine must traverse it" — is the exact governor whose absence overwhelmed CB.
</routes>

## User

Yes proceed with that
Is your initial impression that cb is overengineered, or that its engineering purpose is scattered or underspecified? Or - is it eval tailored, where conpreshensiveness is required? Or...?

## Assistant

<routes ref="/meta/plans/epistemic-overlay.md">
I read the real thing — 392 active beliefs, 73 modules, 29 mix tasks, the schema verifier, the frontmatter spec. None of your options exactly — but the closest is **"purpose scattered,"** with a correction about *which layer*. The engineering is not overengineered and not under-engineered — it's genuinely good (`CB.Schema.Verifier.check/1` is pure, collection-agnostic, and dogfoods; the eval rigor is justified and correctly opt-in per `tiers.md`). And the README's purpose is sharp. **But the repository is three projects fused at one substrate**: (1) an eval evidence ledger [the README], (2) general knowledge management [the entire `okf/` sub-project], (3) a theory of agent persistent identity [`composable-beliefs-thesis.md`]. Of 392 beliefs only ~10 touch eval rigor; the graph is overwhelmingly CB reasoning about its *own design*. `type` is a disciplined closed enum of 4; `kind` sprawled to 40+ values. The precise answer: **substrate-generality outrunning any one committed application** — which is exactly why it was impossible to feel done. second-brain is the resolution: it committed to purpose #2 at the lightest tier and stopped generalizing.
</routes>

Then the port/merge map: the 1:1 concepts (OKF bundle ⇄ `okf/` tier; `sb:` ids ⇄ `namespace:local`; `verified_by` ⇄ `deps`; derived verification ⇄ "derived, not stored"; `source` ⇄ attestation; `policy` ⇄ prescription; reserved `index`/`threads` both sides; the CI gate suites). The one live divergence: second-brain **edits in place**; CB **supersedes** (`superseded_by` + staleness propagation). CB-only (contracts, two-axis type/kind, atomized JSON nodes, eval rigor, codepath) all trace to purposes #1/#3. second-brain-only, and a genuine simplification: the document *is* the concept; one `type` axis; evidence edges restricted to verification, gated by "type an edge only when a machine traverses it"; zero deps; one committed purpose.

## User

I think this is a good analysis. At the same time it may be leaving something on the table. The four type enum layer, attestation, aggregation, inference, and prescription are an epistemic layer that allows for the decomposition of concepts and to create a network of conceptual deps. The second brain is currently a mapped set of concepts. What's to stop a shared epistemic substrate to exist above it in the manner of these categories which would allow for explorability across resources, and machine checkable strength measured by number of connections?

## Assistant

<routes ref="/meta/plans/epistemic-overlay.md">
You've caught a real flaw in my previous turn: I lumped the `type` axis (the four epistemic operations) in with the `kind` junk drawer and waved both off as "anti-port." That was wrong. The four-type layer is the one piece of CB that belongs to *none* of its three scattered purposes and is genuinely universal — and second-brain is already running a degenerate, unacknowledged version of it (`source` ≈ attestation; `verified_by` aggregating captures ≈ aggregation; a grounded `claim`/`concept` ≈ inference; `policy`/`methodology` ≈ prescription). We did it live two conversations ago. So: what's to stop it? Nothing structural — and it clears the gate we set, because you found the machine consumer I said didn't exist: explorability and integrity checking. This is the legitimate graduation the rule was designed to permit.
</routes>

<routes ref="/meta/plans/epistemic-overlay.md">
But two hard pushes. **Push 1 — "strength by number of connections" is the one part I'd stop.** Count-of-connections measures how much has been *written*, not how *true* — it rewards the verbose and is trivially gamed. CB itself refused this ("structural support replaces confidence scores"). Keep groundedness as an *integrity floor*, not a score; and don't conflate out-degree → sources (groundedness) with in-degree ← dependents (importance/blast-radius). It's matklad's *extent*: observe, don't optimize. **Push 2 — the granularity fork decides whether this is "second-brain grows a spine" or "second-brain becomes CB v2."** Overlay on whole concepts (frontmatter-native, document-is-the-concept survives) vs atomize into nodes (CB's path, the road to 399 belief files). Your word was "above," which reads as the overlay. Hold that line and it stays finishable.
</routes>

## User

Pull main and merge into branch
Then yes, create the plan, to be stored in meta/plans, and the doc should be of type "plan" (new type if plan type does not exist yet)

## Assistant

Both done. **Merge:** pulled `origin/main` (which had moved well ahead — it already ratified `knowledge-management/`, added the `tutorial` and `issue` types, an `inbox/` namespace, and notably adopted a session-capture/route-tags workflow *from Composable Beliefs* "at the OKF floor, belief DAG out of scope" — so you'd already started this exact port consciously). Only `log.md` conflicted; resolved newest-first, keeping both histories. All gates green (69 tests). **The plan:** ratified a new `plan` type (design/decision record with a `status`, distinct from `issue`=a problem and `methodology`=a repeatable how-to) and created the `meta/plans/` namespace. Filed `meta/plans/epistemic-overlay.md` (`status: proposed`) capturing the whole thread as an executable design — frontmatter-native overlay, `mix brain.graph` as the machine consumer, explicit scope boundaries (atomization out, strength-as-count out, contracts/eval/codepath out, a second `kind` axis out), and four open questions for you. It's `proposed`, not `accepted` — nothing executes until you decide.

## User

Commit

## Assistant

Nothing to commit — the working tree is clean and the branch is already in sync with the remote. Everything from this session is committed and pushed. If you made a local edit you want committed, let me know what changed — but as it stands there are no pending changes.

## User

Auto-suggest is showing "Accept the epistemic-overlay plan and start the first slice", what is it referring to?

## Assistant

That's a harness-generated follow-up suggestion — the UI reading the plan I just filed and proposing the obvious next move. It refers to `meta/plans/epistemic-overlay.md`, which currently sits at `status: proposed`. Taking it would mean two things: **1. "Accept the plan"** — flip proposed → accepted, move it under "Accepted / In progress" in the index, and log it (a governance act, your call). **2. "Start the first slice"** — decide Q1/Q2 (role source, edge shape), backfill deps on a few concepts (the testing methodology + its two references are the ready-made worked example), and ship `mix brain.graph` read-only. My honest recommendation: don't take it wholesale yet — the plan has four open questions, and Q1/Q2 are genuine forks that change the frontmatter surface; I'd want your answers before writing code.

## User

Leave it proposed. Commit and push
Anything left on this branch?

## Assistant

The plan stays `proposed` — no edit needed there. And there's nothing to commit or push: working tree is clean and the branch is already in sync with the remote. Everything from this session is committed and pushed. The only thing *not* done (deliberately) is opening a PR — I haven't been asked to, and per your instructions I won't unless you want one.

## User

Create pr

## Assistant

A PR already exists and was **merged** — no new PR is needed (and GitHub blocked the duplicate because there's nothing left to merge). **PR #22** was opened and merged into `main` between our last commit and now. It carried the full branch: the testing methodology, the `methodology` and `plan` types, `meta/plans/` + the epistemic-overlay plan, and the merge of prior main. So everything from this session is now on `main`. One thing worth noting per the operating contract: since this branch's PR is now merged, it's considered finished — if you want further work, I'd start the designated branch fresh from the new `main` rather than stacking onto the merged history.
