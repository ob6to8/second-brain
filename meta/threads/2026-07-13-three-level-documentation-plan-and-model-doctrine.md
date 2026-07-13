---
type: reference
title: 2026-07-13-three-level-documentation-plan-and-model-doctrine
description: Designed and ratified the three-level documentation plan (plain backstop / canonical technical / grounding tier one abstraction below the source, opt-in, one canonical level plus two anchored derivations) — plan persisted as accepted with execution deferred — and filed the capability-matched model selection doctrine, resolving where model-use guidance lives.
provenance: "Claude Code session, 2026-07-13; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, documentation, levels, doctrine, models, plans]
timestamp: 2026-07-13
pr: 67
---

# 2026-07-13-three-level-documentation-plan-and-model-doctrine

## Where this landed

The operator proposed presenting information at three levels — plain speak,
technical (the current register), and code — and the session converged on a
ratified design: opt-in per document, one canonical technical body plus two
anchored derivations (a plain-speak backstop for the operator in "constant
tutorial mode", and a grounding tier defined as *one level of abstraction below
whatever the source is*). The design was persisted as the
[three-level documentation plan](/meta/plans/three-level-documentation.md)
(`status: accepted`), with two pre-execution design findings recorded as binding
on the executing session (derived tiers as blockquote blocks because policy
bodies inline into `CLAUDE.md`; doctrine→policy grounding edges as path refs
because governance docs carry no `sb:` ids) — execution itself was explicitly
deferred on the operator's instruction. A follow-on question (should plans
instruct on model use?) resolved into the
[capability-matched model selection doctrine](/meta/doctrine/capability-matched-model-selection.md):
doctrine rather than policy, because selection is a runtime act enforceable only
through its attribution shadow. The session closed via `/create-pull-request`.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Three-level documentation design (plain / technical / grounding) | closed | [three-level-documentation plan](/meta/plans/three-level-documentation.md) | - |
| Executing the plan (policy doc, verifier rule, two pilots) | open | [three-level-documentation plan](/meta/plans/three-level-documentation.md) | Awaits an executing session running the plan's build order |
| Model-selection guidance: doctrine vs policy, enforceability | closed | [capability-matched-model-selection doctrine](/meta/doctrine/capability-matched-model-selection.md) | - |
| Attribution policy (provenance names the producing model) | paused | `unrouted` | Whether the operator ratifies the thin attribution policy proposed in the doctrine |


## User

<routes ref="meta/plans/three-level-documentation.md">
Consider this idea for the repo: information is presented at three different levels level one is plain speak. This is a plain spoken presentation of the concepts or ideas that should be intelligible to nontechnical users. Level two would be technical. Technical is the level at which the documentation is currently written at. It is terse, dense, information rich well-being abbreviated and intended for the reader to carry accompanying concepts in their mind to understand what's being said. I would say that this is generally the level at which the agent responds to me in these threads as well. The third level would be code. This would deal with actual implementation details related to the code itself. So if you're talking about a service, let's say, verifier service, the code version would present description of the actual code and what it's doing. What are your thoughts on this idea? If helpful, I could give an example, for instance, policy doctrine.
</routes>

## Assistant

<routes ref="meta/plans/three-level-documentation.md">
I like the idea, and the interesting thing is that the brain already half-believes it — the question is less "should levels exist" and more "where does each level live so they don't drift." Here's my read.

**It generalizes a motif that's already in the DNA.** `/summarize-technical` is exactly this ladder applied to external material: plain-language summary → glossary → integrated technical summary. `/elaborate` is the level-2→level-1 move applied to a single phrase. And the glossary exists so level-2 prose can stay terse while remaining one click from definitions. Your proposal takes that motif — which today only fires on *intake* — and makes it a structural property of the bundle's own documents. That's a coherent extension, not a new invention, which is a good sign.

**But the three levels are asymmetric, and treating them as three parallel renderings would fight the brain's strongest doctrine.** This repo is aggressively anti-drift: `CLAUDE.md` is compiled, the registry is compiled, route-tag logs are materialized and CI-fails on divergence, evidence narratives are derived on demand precisely so there's one source of truth. Three hand-maintained renderings of every concept is three copies to keep in sync — the exact failure mode the tooling exists to prevent. So I'd frame it this way:

- **Level 2 is the canonical source.** It's the level the docs are written at and the level we converse at; it stays the thing you edit.
- **Level 1 is a derived presentation.** A plain-speak rendering of level 2 for a reader without the accompanying concepts in their head. Because it's derivable, it's a candidate for generation rather than hand-keeping — either a materialized section (like the route-tagged logs: `mix brain.<something> --materialize`, CI checks freshness) or rendered only on the Pages site as a toggle, never committed at all.
- **Level 3 isn't really a rendering — it's a grounding link.** It only exists where there's code behind the concept, and it answers "what does the machine actually do." Your verifier example is perfect: `verification-grounding.md` already *gestures* at level 3 four times ("`mix brain.verify` rejects…", "machine-enforced, not editorial") but never shows the code side. The natural artifact is an `implemented_by:` frontmatter edge pointing at `lib/second_brain/verifier.ex` plus a section describing what the module checks — analogous to how route tags already use path refs as non-aggregating back-links to code.

**Not every doc has all three levels, and that's fine.** Doctrine deliberately *isn't* machine-enforced, so it has levels 1–2 and rarely 3. A machine-enforced policy has all three. Most knowledge concepts have 1–2. Making the levels opt-in per document (present where the audience or the code exists, absent otherwise) keeps the cost proportional.

**One question worth settling before any of this becomes policy: who is level 1 for?** In a personal brain the operator reads level 2 comfortably. The honest answers are probably (a) future-you skimming a domain you've been away from, and (b) readers of the published Pages site. If it's mostly (b), that argues for level 1 living in the site build rather than in the committed files — the bundle stays terse, the presentation layer softens it.

So my overall verdict: adopt the framing, but implement it as *one canonical level plus two anchored derivations*, not three parallel texts. Pilot it on a handful of docs where it earns its keep — the verification-grounding policy would be an ideal first subject, since it exercises all three levels.

And yes — your policy/doctrine example would be genuinely helpful, because doctrine is the case where I'm least sure what level 3 even means (a doctrine's "implementation" is arguably the policies that cite it, not code — which would make `implemented_by` an id-edge to policies rather than a path-edge to modules). If you sketch what you have in mind there, I can pressure-test the design against it, and if it holds we'd write it up as a `meta/plans/` entry for ratification.
</routes>

## User

<routes ref="meta/plans/three-level-documentation.md">
first regarding the policy doctrine example, I think, actually, what you point out is correct that implemented by would be an ID edged policies. So one way to look at it is the third tier would be one level of abstraction below whatever the source is. Agreed to make. levels opt in per document. Agreed to adopt framing but implement as one canonical level plus two anchored derivations. regarding who is level one for you may overestimate the technical understanding of the reader, especially in the case where the operator is coding along with the agent using natural language. Systems are being built that the operator does not understand. In many ways, the operator is learning the way the system works by using it. Imagine the operator user is in constant tutorial mode. It's easy for them to lose sight of what dense technical references are referring to or what concepts are being referred to. Yes. They can check the glossary, but even that leads to sometimes nested webs of concepts, and the intuition is lost. The level one is a fail safe backstop of sorts. In other words, if the user is failing to intuit the meaning of the level two, they can read the level one to gain insight into what the general thrust and meaning of whatever is being discussed is. This would also be a natural layer for someone serving the system. deciding whether or not they wish to adopt, uh, technical specificity and brevity are not our friend in that circumstance.
</routes>

## Assistant

<routes ref="meta/plans/three-level-documentation.md">
That clarification on level 1 is load-bearing — "operator in constant tutorial mode" changes my earlier recommendation, and your generalization of the third tier ("one level of abstraction below whatever the source is") cleans up the design nicely. Since we now have agreement on the core decisions, the persist-plans policy applies: I'll write this up as a plan under `meta/plans/` so the design survives this session. Let me first check the existing plan format.
</routes>

<routes ref="meta/plans/three-level-documentation.md">
The plan is persisted and pushed: `meta/plans/three-level-documentation.md` (status `proposed`), with the plans index updated, verifier and contract checks green, on branch `claude/three-level-docs-structure-eqptow`. Once it merges it will render at https://ob6to8.github.io/second-brain/meta/plans/three-level-documentation.html — until then the file on the branch is the reference.

Two of your points materially changed the design, and I want to flag how they're now baked in:

**Your level-1 rationale reversed my earlier recommendation.** I had suggested the plain tier might live only in the Pages site build. But a backstop only works if it's adjacent to the technical body *wherever* you're reading — repo checkout, chat, or site — and a site-only toggle covers just one of those. So the plan commits the plain tier as a `## Plain` section in the file itself, placed right after the frontmatter: the reader who's losing the thread meets it first, and the fluent reader skips a clearly-marked block at zero cost. I kept your framing almost verbatim in the problem statement — the tutorial-mode operator learning the system by using it, the glossary's nested webs where intuition gets lost, and the surveying reader for whom "technical specificity and brevity are not our friends" — because that rationale is the part a future session most needs to not re-derive.

**Your "one level of abstraction below the source" generalization is now the definition of tier 3.** I renamed it from "code" to the *grounding* tier, since it's relative: a policy grounds into the code that enforces it (path refs), a doctrine grounds into the policies that implement it (`sb:` id edges). The proposed mechanism is an `implemented_by:` frontmatter field accepting both — which deliberately mirrors the route-tag ref rule (a ref is an `sb:` id or a path), so it's an existing pattern reused rather than a new one invented. Target resolution is mechanically checkable by the verifier; plain-section faithfulness has no oracle and stays editorial, like route-tag coverage.

The plan names two pilots — the verification-grounding policy (full three tiers) and the engineer-as-orchestrator doctrine (plain section + id edges to its implementing policies) — and leaves open for your ratification: the section names (`## Plain` / `## Grounding` are placeholders), whether the plain tier gets any staleness signal, and site styling. Say the word and I'll flip it to `accepted` and execute the build order, or adjust the shape first if any of it reads wrong.
</routes>

## User

It's the fact that levels one and three are derived from two documented in the plan? Understood on pilots. Agreed on all changes

## Assistant

<routes ref="meta/plans/three-level-documentation.md">
Yes — it's documented in two places in the plan: the "The three levels" section closes with the asymmetry statement ("Level 2 is canonical and hand-written. Level 1 is a *derived presentation* of level 2. Level 3 is an *anchored edge* downward plus optional prose"), and Decision 2 makes it binding: "The technical body remains the single source of truth. The plain tier is regenerated from it; the grounding tier points below it. Neither may fork into an independently drifting account."

With your agreement on all changes, the plan is ratified — I'll flip it to `accepted` and execute the build order: the policy doc, the verifier rule for `implemented_by` resolution with tests, the two pilots, then gates and push. Starting with the codebase surfaces I need to touch.
</routes>

## User

<routes ref="meta/plans/three-level-documentation.md meta/doctrine/capability-matched-model-selection.md">
Again, commit to plan, do NOT implement

Also - should the plan instruct on what models to use at what times? Or Is it enough to be saved in the doctrine?
</routes>

## Assistant

<routes ref="meta/plans/three-level-documentation.md meta/doctrine/capability-matched-model-selection.md">
Done — plan only. I reverted the implementation I'd started (verifier rule, registry field — the working tree is back to exactly what's committed; all 126 tests and the verifier pass untouched), and committed the ratified plan to the branch. The plan is now `status: accepted` with execution explicitly deferred to a future session, and the plans index moved it into "Accepted / In progress."

The brief reconnaissance did surface two constraints before you stopped me, and I recorded them in the plan as binding **design findings** rather than losing them: first, the contract compiler inlines policy bodies verbatim into `CLAUDE.md`, so a `## Plain` heading inside a policy would break the compiled contract's heading structure — the derived tiers are therefore blockquote blocks (`> **In plain terms:** …` at the top, `> **Grounding:** …` at the bottom), which inline safely and typographically encode "subordinate to the canonical body." Second, governance docs carry no `sb:` ids (the registry deliberately excludes `meta/`), so a doctrine's `implemented_by` edges to its policies must be path refs, not id edges — which is exactly the ref rule route tags already use.

On your model question — my position, now also filed in the plan's open questions: **the plan should not instruct on model selection; the standing layer should.** A plan is a one-off change record — it flips to `done` and its guidance gets buried, which is the wrong home for anything an agent needs to consult *recurringly*. Model-per-motion guidance (say, a cheaper model re-rendering plain blocks, a stronger one writing canonical bodies or making verification judgments) is standing direction, so it belongs in doctrine — or in a policy if you want it enforceable rather than advisory — and plans would merely cite it, the same way they cite engineer-as-orchestrator today. Right now no such doctrine exists; if you want one, that would be a new `meta/doctrine/` doc for you to ratify, and I'd keep this plan's only reference to it a citation.
</routes>

## User

<routes ref="meta/doctrine/capability-matched-model-selection.md">
Yes, create the model doctrine document - should it be doctrine or policy? Or both? Is it in fact enforceable?
</routes>

## Assistant

<routes ref="meta/doctrine/capability-matched-model-selection.md">
Direct answer first: **doctrine now, not policy — because selection itself is not enforceable, but it has an enforceable shadow that could become a policy later.**

The reasoning: model selection is a *runtime act* — it happens in the moment an agent spawns a subagent or the operator opens a session, and it leaves no committed artifact for `mix brain.verify` or CI to gate. You cannot write a machine-enforceable rule over something the repo never sees. What the repo *does* see is **attribution**: the `provenance` field already names the producing model by convention ("Claude Opus 4.8, chat thread"), and commit trailers do the same. Attribution is checkable; selection is only auditable *through* attribution. So the durable direction (match the model tier to the weight of the motion) is doctrine, and the one genuinely enforceable fragment (provenance must name the producing model) could graduate into a thin policy later if you want the doctrine auditable — I'll propose that inside the doctrine rather than creating a policy unilaterally, since new contract rules are yours to ratify.

Creating it now — `meta/doctrine/` exists, so filing there is autonomous. Checking the index format first:
</routes>

<routes ref="meta/doctrine/capability-matched-model-selection.md">
The doctrine is filed and pushed: `meta/doctrine/capability-matched-model-selection.md`, with the doctrine index updated and the plan's open question marked resolved by citation. Verifier and contract checks are green; the branch now carries three commits (plan, ratification with design findings, doctrine).

To recap the judgment call you asked about — **doctrine, not policy, and not both yet**:

- **Doctrine** because the direction is durable while any concrete mapping is not. The doc states the principle — match the model tier to the epistemic weight of the motion — with three "concentrate the strongest model" conditions (output becomes canonical, a judgment is rendered, errors are silent) and three "delegate down" conditions (the motion is derivational, a mechanical oracle exists, the work is high-volume and low-stakes per item). It deliberately binds no current model names to motions, since that mapping dies with each model generation; agents apply the principle against whatever tiers exist at run time. It's framed as the model-layer application of engineer-as-orchestrator: strong-model attention is allocated the way your own attention is.

- **Not enforceable as such**, and the doc says so explicitly: selection is a runtime act (a session's model, a subagent spawn) that the repository never records as a checkable artifact, so no verifier rule can gate it. What *is* enforceable is its shadow — **attribution**. The `provenance` field already names the producing model by convention, and that's mechanically checkable. The doctrine proposes the future path: a thin attribution policy ("agent-authored governance and statement documents record the producing model in `provenance`") that would make the doctrine auditable after the fact. I left that policy uncreated since new contract rules are yours to ratify — say so and it becomes a one-policy addition plus a contract recompile.

- The three-level plan now instructs on models only by citing the doctrine — plain-tier re-rendering is named there as a delegate-down derivational motion, canonical bodies and verification judgments stay with the strongest tier — which keeps plans free of guidance that would be buried when they flip to `done`.
</routes>

## User

Is the plan finished and persisted? Is there anything in the thread that has not been captured? Are we ready to close?

## Assistant

Here's the closing audit:

**Is the plan finished and persisted?** Persisted, yes — [three-level-documentation](https://ob6to8.github.io/second-brain/meta/plans/three-level-documentation.html) is complete as a decision record: ratified decisions, the two pre-execution design findings (blockquote tiers, path refs for governance targets), the resolved model question pointing at the new doctrine, and a build order for the executing session. It sits at `status: accepted` — "finished" as a plan, deliberately unexecuted per your instruction. The [capability-matched-model-selection doctrine](https://ob6to8.github.io/second-brain/meta/doctrine/capability-matched-model-selection.html) is likewise filed and indexed. The working tree is clean, all three commits are pushed, and the verifier, contract check, and test suite are green. (Those live URLs resolve once the branch merges.)

**Is anything not yet captured?** Two things, both belonging to the close motion itself:

1. **The session thread.** The plan and doctrine absorbed the *decisions*, but the verbatim exchange — your level-1 rationale ("constant tutorial mode", the backstop framing), the "one abstraction below the source" generalization, the doctrine-vs-policy reasoning — exists only in this conversation. That's exactly what `/capture` persists as a thread doc under `meta/threads/`, with its routing ledger and route tags.
2. **The PR.** The branch's three commits are pushed but no pull request exists, and per the git workflow the merge is the record — plus the thread doc's `pr:` anchor can only be stamped once a PR number exists.

**Are we ready to close?** Yes — everything decided in this session is durably filed; only the close motion remains. `/create-pull-request` does all of it in one pass: runs `/capture`, glossaries the captured thread, and opens the PR. Invoking it is the authorization, so I've held off — say the word and I'll run it.
