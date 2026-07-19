---
type: reference
title: 2026-07-11-belief-decomposition-analysis-and-epistemic-prior-art
description: Assessed the operator's idea of decomposing artifacts into belief DAGs, filed it as an analysis (derive-the-graph-not-author-it) + a proposed analysis-mode plan, intook the prior art (TMS, Toulmin, FActScore/SAFE, GSN, FOL/OWL, Dung) as references and primary-source captures, glossaried it all (34 terms), and recorded two governing principles plus a phrase-type deferral.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-11; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, epistemics, belief-decomposition, prior-art, glossary, argumentation, knowledge-representation, evals]
timestamp: 2026-07-11
session: https://claude.ai/code/session_01YFjcju6GNnQgLsJ5EQvdJP
pr: 73
---

# 2026-07-11-belief-decomposition-analysis-and-epistemic-prior-art

## Where this landed

The session opened with the operator floating a semiformal epistemic structure —
artifacts decomposed into atomic *beliefs* (attestations + inferences) in a DAG,
overlaid for logical audit, cross-document consensus/conflict examination, and
evals. The assessment placed it as the **third iteration** of the operator's own
lineage (the deprecated assertion graph → Composable Beliefs → the proposed
epistemic-overlay plan) and identified the one commitment neither prior version
made: **derive the belief graph, never author it.** That became a filed
[analysis](/meta/analysis/belief-decomposition-derived-vs-authored.md) and a
proposed [analysis-mode plan](/meta/plans/belief-decomposition-analysis-mode.md).

The prior art the assessment leaned on was then intaken: five `reference`
captures (TMS, Toulmin, decompose-then-verify factuality, assurance cases/GSN,
FOL/OWL) given three-part `/summarize-technical` breakdowns, three primary-source
captures (Doyle 1979, de Kleer 1986, GSN Standard v1), and — closing the one gap
from the opening assessment — Dung's abstract argumentation frameworks (reference
+ source capture, the latter flagged as non-verbatim beyond its abstract). The
whole cluster was glossaried (34 new terms), `/summarize-technical` was amended so
key-terms link to glossary entries, and two governing principles ("LLM judgments
stay local to edges; structure stays global and mechanical"; "derive the graph,
never author it") plus a considered-and-deferred `phrase`-type decision landed in
`meta/future-beliefs.md`. Shipped across five commits on
`claude/epistemic-artifact-beliefs-eirk0n`.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Belief-decomposition idea → assessment: it's iteration three of the lineage; the load-bearing move is derive-not-author; prior art validates the parts; LLM-local-edges architecture; belief identity is the hard problem; application ranking (evals > cross-corpus audit > prose-lens > code) | closed | [analysis: belief decomposition, derived vs authored](/meta/analysis/belief-decomposition-derived-vs-authored.md) | - |
| The concrete build: a read-only decompose/canonicalize/judge/audit tool storing no belief nodes | closed | [plan: belief decomposition as a derived analysis mode](/meta/plans/belief-decomposition-analysis-mode.md) | Open questions deferred to a future session: cache policy, canonicalization strategy, first corpus, whether v1 includes a decomposition-stability self-check |
| Epistemic prior-art capture — TMS/Toulmin/FActScore-SAFE/GSN/FOL-OWL/Dung references + Doyle/de Kleer/GSN/Dung source captures | closed | [analysis: belief decomposition, derived vs authored](/meta/analysis/belief-decomposition-derived-vs-authored.md) | GSN captured at V1 (V3 registration-gated); Dung source definitions are standard formulations, not verbatim from the paper body |
| Glossary accretion (34 terms across the epistemic docs) + `/summarize-technical` key-terms→glossary-link amendment | closed | [glossary hub](/glossary.md) | - |
| Governing principles (derive-not-author; LLM-judgments-local-to-edges) and the deferred `phrase`-type decision | closed | [future-beliefs](/meta/future-beliefs.md) | Revisit a `phrase`-type only if a concrete need with real examples emerges |

## Render

## User

Consider the following idea: Decomposing artifacts, such as what are found in this repo, into a set of beliefs which would be the name for a data type. A belief would represent an atomic statement. Apples are fruits, for example, or fruits reproduce. These could be called attestations, A primary atomic type. Another type, which we could call inference, would be, in this example, apples reproduce. The idea I am working towards is, is there a semiformal epistemic structure That can be overlaid over documents or artifacts, and provide an agentic system the ability to audit the logical nature of an artifact statement, whether a document or code, and compare the epistemic substrate and belief system of documents and code. There could be a method of consensus evaluation and conflict examination, between like documents. There could be the construction of graphs and subgraphs as you possibly compose belief systems out of composites and components. I'm imagining this to be a directed acyclic graph. Some problems I could imagine this solving is taking prose based interaction between agents and operators and formalizing it to the degree to which you can, creating code based checks on logical flows and conflicts that still require the interpretation of the LLM but gives a structure on which that interpretation can be flowed through. I could imagine it. aiding in the audibility of large collections of artifacts and knowledge bases, acting in a way as a searchability matrix, and semantic and intention specification substrate. I could imagine this coming in use for evals. What are your thoughts?

## Assistant

<routes ref="meta/analysis/belief-decomposition-derived-vs-authored.md">
This idea has deep roots in your own history — the brain's records show it's actually the *third* iteration of it, and they contain a diagnosis of what went wrong the first two times. That context shapes my thoughts considerably, so let me lay it out honestly.

## Where you've been with this

1. **The deprecated assertion-graph** (plan 003, executed 2026-03) was precisely this: atomic claims, `primitive` vs `compound` tiers, evidence edges to sources, `deps` + `implication` on compounds, a generated DAG index, even `contested.sh` for conflict detection. It now lives in `deprecated/`.
2. **Composable Beliefs** formalized it into the four-operation ontology — attestation, aggregation, inference, prescription — which your "attestation/inference" framing here matches almost exactly. Per your own plan doc, CB "became overwhelming": ~400 atomized belief files, a `kind` field that sprawled to 40+ values, atomization that was "bottomless."
3. **This brain's proposed response** (`meta/plans/epistemic-overlay.md`, status: proposed) keeps the four roles but draws a hard line: *no atomization* — "the pull toward atomization will be constant and each step will feel justified; that pull is what made CB bottomless. Hold the line at concept-granularity."

So the honest first question about this new articulation is: is it re-litigating that boundary, or is it something structurally different? I think it's genuinely different, for one specific reason.

## The load-bearing distinction: beliefs as storage vs. beliefs as derived analysis

Both prior iterations made atomic beliefs the **authored storage substrate** — humans and agents create and *maintain* belief files. That's where the maintenance debt came from: every atomized claim is a file someone must keep true, deduplicate, and re-link forever. The store grows without bound because decomposition has no natural floor.

What you're describing now — an epistemic structure **overlaid on artifacts** to audit them, compare them, and check consensus — doesn't require beliefs to be stored at all. The belief graph can be a **derived, regenerable intermediate representation**, like a compiler IR: computed from the artifact when you want to audit it, discarded or cached afterward, never hand-maintained. The artifact stays the source of truth; the graph is a lens.

This is exactly the discipline this repo already runs on: `CLAUDE.md` compiled from policies, `meta/registry.md` compiled from frontmatter, route-tag logs re-derived by the verifier which "fails on divergence." A belief decomposition that's *generated, not hand-kept* escapes the CB failure mode entirely, because decomposition instability (the same document atomizing differently across runs) becomes a tolerable analysis artifact rather than corruption of your store. I'd say this is the single decision that determines whether the idea works: **derive the graph, never author it.**
</routes>

## Prior art worth mining

You're re-deriving several established lines, which is good news — parts of this are validated:

- **Truth Maintenance Systems** (Doyle 1979; de Kleer's ATMS) are literally this: a bipartite DAG of belief nodes and *justification* nodes, with dependency tracking and assumption environments. The ATMS "environment" concept solves a problem you'll hit immediately: two documents can each be internally coherent while mutually contradictory, so beliefs need context labels; you compare belief *sets*, you don't merge them into one inconsistent soup.
- **Dung's abstract argumentation frameworks** formalize your "consensus evaluation and conflict examination": an attack relation over arguments, with semantics (admissible, preferred, grounded extensions) that compute which subsets can rationally stand together. One key lesson: **support edges can be a DAG, but conflict edges can't be forced acyclic** — mutual attack is common and the semantics resolve it. So: DAG for derivation, a separate symmetric conflict relation on top.
- **Toulmin's model** argues the *justification* — premises → conclusion, licensed by a warrant — should be the first-class object, not just the belief. This matters for consensus: the same conclusion reached via two independent justifications is epistemically stronger, and only a bipartite graph can represent that.
- **Claim decomposition for evals is already validated**: FActScore, SAFE, and the decompose-then-verify fact-checking literature do exactly "atomize → check each claim with an LLM → aggregate mechanically," and it measurably beats holistic judging. Your evals intuition is the most de-risked application on the list.
- **Assurance cases (GSN)** in safety-critical software are the code-facing version: structured claim trees over artifacts, with evidence leaves.

## The architecture I'd endorse

Your instinct about the LLM's role is the right one, and worth stating as a principle: **LLM judgments stay local to edges; structure stays global and mechanical.** The LLM answers small cacheable questions — "does this passage assert this belief?", "do these premises entail this conclusion?", "do these two beliefs conflict?" — and deterministic graph algorithms compute the global properties: ungrounded inferences, minimal inconsistent subsets, consensus cores, blast radius of a retracted premise. That's what makes it *semiformal* in a useful way: full FOL/OWL formalization is too brittle for real prose, pure holistic LLM judgment doesn't compose or audit, and this middle layer gives you incremental recheck (only re-judge the dirty subgraph) and an audit trail per edge.

The hardest unsolved problem is **belief identity**. Cross-document comparison only works if "apples are fruits" from document A and "an apple is a kind of fruit" from document B unify to the same node. That's entity resolution for propositions — fuzzy, LLM-mediated, and it makes your "searchability matrix" statistical rather than exact. It's the same lesson this brain already learned with route tags: cross-thread joins must key on canonical ids, not free-text phrasings. Expect canonicalization to consume more design effort than the graph itself. Relatedly, atomic claims ripped from context change meaning ("this improves performance" — of what, under which conditions?), so decomposition needs a decontextualization step, which the claim-extraction literature treats as its own stage.

On **code**: I'd aim the belief layer not at code semantics itself — types, tests, and formal verification already do that with real oracles — but at the claims *about* code: design docs, ADRs, comments, commit messages versus what the implementation actually does. "Does the artifact's stated belief system match the artifact?" is a genuinely underserved audit, and it's assurance-case-shaped.

## Where it could land in this brain

<routes ref="meta/plans/belief-decomposition-analysis-mode.md">
The nice resolution: this doesn't have to conflict with the epistemic-overlay plan's no-atomization boundary. That plan governs the **storage model** (concepts stay whole; frontmatter edges at concept granularity). What you're describing is an **analysis mode** — a `mix brain.beliefs <path>`-style tool that decomposes an artifact (or two, for comparison) into a derived graph, runs the audit, and reports — writing nothing into the bundle except perhaps a filed `analysis` document of its findings. Derived overlay on top, bounded store underneath. That would make this the first version of the idea in your lineage that gets atomization's benefits without inheriting its maintenance debt.
</routes>

If you want to take this further, the natural next steps would be filing this articulation (it sharpens the "derived vs. authored" distinction, which the proposed plan doesn't state), or sketching the analysis-mode tool as a plan — but that's your call.

## User

resources related to the truth maintenance system / Toulmin's model / FActScore, SAFE, and the decompose-then-verify fact-checking literature / asssurance cases (GSN) / FOL/OWL
/add-to-glossary bipartite, ungrounded inferences, minimal inconsistent subsets, consensus cores, blast radius of a retracted premise (note - we may need to look at introducing some sort of type above glossary, like "phrase"
There is a future-beliefs doc - add this to it "LLM judgments stay local to edges; structure stays global and mechanical"

I agree with all of us

I would suggest committing both an analysis, which depends on and links to the previous epistemic ones this expands on, as well as a plan, that also links. Is that your thinning as well?

## Assistant

I'm on board with the whole slate — and yes, analysis + plan is my thinking too (I'll explain the split when I report back). Let me first read the current state of the relevant files: the future-beliefs doc, glossary conventions, the meta tree, and where in the taxonomy the reference captures should land.

## Assistant

Done and pushed to `claude/epistemic-artifact-beliefs-eirk0n` (commit `88da044`, 24 files, all verifiers green). No PR opened since you didn't ask for one.

**On your question — yes, analysis + plan was exactly my thinking, and here's the split I used:** the *analysis* holds the reasoned judgment (the lineage, the derived-vs-authored finding, the prior-art assessment) so the conclusion persists even if the work is never built; the *plan* holds only the intended work, and explicitly `depends on` the analysis rather than restating it. They cross-link each other and both link the epistemic-overlay plan and deprecated plan 003.

**What was filed:**

- **Analysis** — `meta/analysis/belief-decomposition-derived-vs-authored.md`: "derive the graph, never author it," with the three-iteration lineage and application ranking.
- **Plan (proposed)** — `meta/plans/belief-decomposition-analysis-mode.md`: a read-only `mix brain.beliefs`-style pipeline (decompose → canonicalize → judge edges → mechanical audit), scope-bounded to store no belief nodes, so it upholds the epistemic-overlay plan's no-atomization boundary rather than fighting it. Open questions flagged for you: cache policy, canonicalization strategy, first corpus, and whether v1 includes a decomposition-stability self-check.
- **Five references, three new subdirectories** (all under established domains, so autonomous per the taxonomy protocol): `knowledge-management/knowledge-representation/` (truth maintenance systems; FOL & OWL), `knowledge-management/argumentation/` (Toulmin model; assurance cases/GSN), `SWE/evals/` (decompose-then-verify factuality: FActScore + SAFE). All fetched from primary/encyclopedic sources, distilled, links persisted.
- **Five glossary terms** — bipartite graph, blast radius (of a retracted premise), consensus core, minimal inconsistent subset, ungrounded inference — each its own concept file with a minted id and *Seen in:* citations into the analysis and references.
- **future-beliefs** now records *"LLM judgments stay local to edges; structure stays global and mechanical."*

**On the "phrase" type idea:** I'd hold off. Looking at what we just added, each entry — even "blast radius of a retracted premise" — still names one reusable concept, and the glossary already comfortably holds multi-word terms ("proto-belief document", "tree is the taxonomy"). The type axis in this bundle distinguishes *epistemic role*, not lexical length, and a `phrase` type would be the first entry keyed on surface form. If a real need emerges (say, idioms/principles that aren't definitions — the future-beliefs entries are the closest case), I'd propose it then with concrete examples. Your call — a new type needs your ratification anyway, so nothing was created.

One honest caveat on the intake: the five references were distilled from encyclopedic articles and paper abstracts, not full paper reads. If you want the deeper treatment (e.g. `/summarize-technical` over the FActScore or SAFE papers themselves), that's a natural follow-up.

## User

Add "derive the graph, never author it" to future beliefs

/summarize-technical for those rederences

## Assistant

Both done and pushed (commit `6ce5486`, all verifiers green).

<routes ref="beliefs/future-beliefs.md">
**future-beliefs** now carries the second principle: *"Derive the graph, never author it"* — recorded with its rationale (authored belief stores accrue unbounded maintenance debt; same discipline as the compiled contract and registry) and a link back to the analysis, alongside its sibling *"LLM judgments stay local to edges."* The meta log entry was extended to cover both.
</routes>

**`/summarize-technical` ran over all five references**, replacing each flat body in place with the three-part structure — plain-language summary → key terms → technical summary — with ids, `resource` links, and the cross-links that anchor the glossary's *Seen in:* citations all preserved:

- **TMS** — now covers the actual mechanics: support-list justifications with IN/OUT lists (the non-monotonic part), well-founded support, dependency-directed backtracking, and the ATMS label/environment/nogood/context machinery.
- **Toulmin** — adds field-dependent vs. field-invariant standards and the reception history, and the technical summary reads the layout explicitly as graph structure (warrant = justification node, qualifier = edge confidence, rebuttal = defeat condition).
- **Assurance cases/GSN** — full element vocabulary (goals, strategies, solutions, undeveloped entities, SupportedBy/InContextOf, modules/away goals, patterns) and the key observation that structural completeness is a syntactic, mechanically checkable property while leaf adequacy stays expert judgment.
- **FOL/OWL** — the metatheorems now do real work (completeness, compactness, Löwenheim–Skolem, semidecidability), plus the DL/Full split, correspondence theorem, and the EL/QL/RL complexity guarantees.
- **FActScore/SAFE** — the full SAFE pipeline (split → decontextualize → relevance → iterative search-and-reason → label), the F1@K definition, and the retrieve-then-verify estimator detail.

One honesty note, flagged in each doc's provenance and the root log: the Wikipedia articles on TMS and GSN turned out to be thin on mechanics, so those two breakdowns are supplemented from the standard literature (Doyle 1979, de Kleer 1986, the GSN Community Standard) — well-established material, but not re-fetched from a primary source this session. If you want them fully source-grounded, pointing `/intake` at the Doyle/de Kleer papers or the GSN standard PDF would let those graduate to proper `source` captures.

## User

Yes, do a proper /intake on those

Should "key terms" be glossary links?

How much of a lift to parse these new docs for glossary additions?

## Assistant

Intake done and pushed (commit `4325f69`, all verifiers green). Now the answers to your two questions.

**The intake.** Three `type: source` captures now hold verbatim key passages, each with the official DOI/URL as `resource`:

- `doyle-1979-a-truth-maintenance-system` — transcribed from the *Readings in Nonmonotonic Reasoning* scan (the original AIJ paper): nodes/justifications, in/out, SL-justifications with inlist/outlist, well-founded support, the assumption definition, dependency-directed backtracking.
- `de-kleer-1986-an-assumption-based-tms` — from de Kleer's own scanned copy: the formal environment/context/label definitions (including the consistent/sound/complete/minimal label properties), nogoods, and the subset-test context membership line.
- `gsn-community-standard` — one honest caveat: scsc.uk openly serves only **Version 1 (2011)**; V3 is registration-gated. I captured V1 (the founding standard, and the edition the reference already cites as the 2011 standardization) with V3 noted in provenance. The capture also flags a real terminology collision it surfaced: a GSN "justification" is a rationale annotation, not the TMS sense — in GSN the inferential role is the *strategy*.

**Should key terms be glossary links?** Link them, don't replace them — the two structures do different jobs. A key-terms section is *source-local*: it defines the term as that source uses it, ordered to unlock that doc's technical summary in place. The glossary is *cross-domain canonical*. So the right form is: keep the local definition, and link the term name to its glossary entry where one exists (the breakdowns already do this ad hoc — `bipartite graph`, `consensus core`, etc.). Collapsing key terms to bare glossary links would break the layered-breakdown contract (section 2 must bridge section 1 to section 3 without leaving the page) and would erase per-source nuance — the GSN-vs-TMS "justification" collision is a live example of why one canonical definition can't serve both. The reverse direction is already policy: a term canonically defined *in* a reference gets a glossary **pointer entry**, not a duplicate. If you want this codified, it's a one-line amendment to the `/summarize-technical` skill ("link key-term names to existing glossary entries") — say so and I'll make it.

**Lift for glossarying the new docs?** Small — it's exactly what `/add-to-glossary` exists for, and the breakdowns have pre-done the hard part (term selection and definitions are sitting in the key-terms sections). Roughly 45 candidate terms across the five references plus the three source captures; after dedup against the 73 existing entries and the selection bar, I'd expect **20–30 new term files**, a good fraction as pointer entries deferring to the references (FActScore, SAFE, LongFact, GSN, warrant, environment/label/nogood…). One invocation, no design decisions, all mechanical after extraction — the only judgment call is pointer-vs-full-entry per term. Ready to run it whenever you say.

## User

Agreed re: key terms. Yes to one line amendment

Proceed with glossarying docs

## Assistant

<routes ref="em:0b648f">
Done — both pieces committed and pushed (`9665b73`, all verifiers green). The glossary run over the eight epistemic docs added **29 term files**, taking the glossary from 78 to 107 terms.

**New full entries (20):**

- *TMS cluster:* non-monotonic reasoning, dependency-directed backtracking, well-founded support, environment (ATMS), label (ATMS), nogood, paraconsistency
- *Multi-sense entries:* **justification** and **assumption** — each with numbered TMS / GSN / Toulmin senses, since the same word means structurally different things across the three literatures (the collision the source captures surfaced)
- *Argumentation:* warrant, defeasibility
- *Logic:* entailment (logical consequence), semidecidability, soundness and completeness, description logic, ontology (knowledge representation)
- *Evals:* atomic fact, decontextualization, LLM-as-judge, F1@K

**Pointer entries (9)** — terms canonically defined in the filed references, per the pointer rule: truth maintenance system, Toulmin model, assurance case, Goal Structuring Notation, first-order logic, OWL, FActScore, SAFE, decompose-then-verify. Each gives a one-paragraph gloss and defers to its reference.

**No merges needed** into pre-existing entries — the five terms from earlier today (bipartite graph, ungrounded inference, etc.) already carried the right citations, and nothing in the new docs added a genuinely new sense to older entries.

The **`/summarize-technical` amendment** is also in: key-terms sections now link term names to existing glossary entries while keeping their source-local definitions — codifying exactly the split we agreed on (glossary = cross-domain canonical; key terms = how *this* source uses the word). The new entries' cross-links (e.g. warrant → justification, nogood → minimal inconsistent subset, SAFE → decontextualization → atomic fact) mean the epistemics vocabulary now forms a small connected subgraph of its own, which is fitting.

One scan-worthy spot for you: the multi-sense **justification** and **assumption** entries are where I exercised the most editorial judgment — worth a glance to confirm the sense boundaries read right to you.
</routes>

## User

We are going to wrap this thread. I believe there is analysis and recommendations about belief structures that may not be persisted in a plan or analysis?

## Assistant

Read the analysis in full and cross-checked it against the opening assessment. The mapping is clean — Findings 1–5 cover the lineage, derived-vs-authored, prior art, architecture principle, belief-identity problem, and application ranking; the plan carries the pipeline, scope boundaries, and open questions. Almost everything substantive landed.

**One genuine gap: Dung's abstract argumentation frameworks.** In my opening assessment I named it as a peer prior-art line alongside TMS, Toulmin, FActScore/SAFE, GSN, and FOL/OWL — and it's arguably the *most* on-point one, because your original framing centered on "consensus evaluation and conflict examination," and Dung frameworks (attack relations over arguments; admissible/preferred/**grounded** extensions computing which subsets can rationally co-stand) are precisely the formalism for that. But it was the only line that didn't make your intake list, so:

- It has **no reference capture**, unlike the other five.
- The analysis compresses it to a half-sentence ("Dung-style semantics resolve it") in Finding 3, and the consensus-core / defeasibility glossary entries lean on "grounded extension" / "attack edges" with nothing to cite.

That's an asymmetry worth closing — the load-bearing claim that *conflict is a separate, possibly-cyclic relation while derivation is the DAG* rests on Dung, and it's currently ungrounded.

A smaller, non-belief-structure loose end: my recommendation to **defer the `phrase` type** (your "type above glossary" note) also lives only in chat — a considered-and-deferred governance decision with no home.

How would you like to close these before we wrap?

## User

Ask questions here in the thread - no tool

## Assistant

Understood — I'll ask in the thread instead of using the question tool. Two decisions before I proceed:

**1. Dung / abstract argumentation frameworks — how deep?**
- **(a) Full intake** — a `reference` under `knowledge-management/argumentation/` (peer to Toulmin), wired into the analysis Finding 2 as a sixth prior-art line, plus 1–2 glossary entries (argumentation framework, grounded extension) and citations added to the existing `consensus-core` / `defeasibility` entries that currently lean on Dung terms with nothing to cite. This is my recommendation — it's genuinely a peer to the five captured lines and your original "consensus evaluation and conflict examination" framing rests on it.
- **(b) Reference + primary source** — same as (a) plus a verbatim `source` capture of Dung's 1995 paper (like we did for Doyle/de Kleer/GSN). More thorough, but I couldn't find an open-access PDF in the search — I'd be distilling from the abstract + encyclopedic coverage, so the `source` capture would be thinner than the TMS ones. I'd lean against unless you want it.
- **(c) Deferred note only** — just add a "Deferred prior art" line to the analysis flagging Dung as unfiled, no capture.

**2. The `phrase`-type deferral** — my recommendation to hold off on a "type above glossary" until a concrete need emerges currently lives only in chat. Add a one-line `meta/future-beliefs.md` entry recording it as considered-and-deferred? (Yes / no.)

My default if you just say "proceed": **1(a) + yes to 2**, then update logs, verify, commit, and push — and we're wrapped. Which way do you want it?

## User

1- b, with a note that it is not the paper verbatim

2. Yes, add. Is the discussion about phrase-type itself persisted as an analysis?

## Assistant

On your question first: **no — the phrase-type discussion is not persisted as an analysis.** It lives only in this chat. The future-beliefs note I'm adding will capture the *conclusion* (considered, deferred, propose on concrete need) but not the reasoning. If you want the "why" preserved durably I can spin a short `analysis` doc — I'll flag that decision at the end so it doesn't block the Dung work.

## Assistant

The gaps are closed and pushed (`61e7696`, all verifiers green). Here's where the belief-structures work now stands:

**Dung — full intake (option 1b), done.**
- **Reference** — `dung-abstract-argumentation-frameworks`, three-part layered like its argumentation peers. The technical summary makes the load-bearing point explicit: Dung is the *missing half* of the belief-graph structure — support is a DAG, conflict is a separate possibly-cyclic attack relation, and grounded/preferred extensions compute exactly the consensus-core / rival-camps answers a naive DAG can't.
- **Source capture** — `dung-1995-acceptability-of-arguments`, holding the **genuinely verbatim abstract** (I found it), with a prominent fidelity note — at the top, in `description`, and in `provenance` — that the definitions are standard formulations, *not* transcribed from the paper body, since I couldn't access the PDF. Exactly the "not verbatim" flag you asked for.
- **Wiring:** two new glossary terms (argumentation framework, grounded extension); `consensus-core` and `defeasibility` now cite Dung instead of dangling; the analysis gained a sixth prior-art bullet and the conflict-not-a-DAG-edge correction now links Dung. The epistemics subgraph is fully grounded — no more citations pointing at un-filed formalisms.

**Phrase-type deferral — recorded** in `meta/future-beliefs.md`: the idea, the reasoning for deferring (the `type` axis is epistemic role, not lexical length), and the revisit condition.

**On your question — should the phrase-type reasoning be its own `analysis`?** The future-beliefs note now carries both the conclusion *and* a compressed version of the "why," so it's no longer chat-only. My read: a full `analysis` doc would be over-weight for a one-factor deferral (an analysis is for a question investigated *against evidence* — this is a governance judgment call, not an evidence probe). The future-beliefs entry is the right altitude. But it's a genuine judgment and I'll defer to you: if you'd like the reasoning preserved as a standalone `meta/analysis/` doc, say so and I'll write it — otherwise I'd consider this settled.

That's everything I can see unpersisted from the thread. When you're ready to wrap, `/create-pull-request` will capture this session, glossary the thread doc, and open the PR in one motion.
