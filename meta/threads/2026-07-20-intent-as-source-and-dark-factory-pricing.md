---
type: reference
title: 2026-07-20-intent-as-source-and-dark-factory-pricing
description: Assessed the operator's proposal that code — and the implementation language — is a derived implementation detail regenerable from intent (agree on direction, bound the endpoint by oracle strength), read the StrongDM software-factory/dark-factory wave against that framework as its strong-form experiment, and on ratification persisted the pair — the intent-is-the-source doctrine and the dark-factory oracle-pricing analysis — plus a reference capture of the Willison write-up.
provenance: "Claude Code session (Claude Fable 5), 2026-07-20; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, intent-as-source, doctrine, dark-factory, software-factory, oracles, verification, regeneration]
timestamp: 2026-07-20
pr: 112
---

# 2026-07-20-intent-as-source-and-dark-factory-pricing

## Where this landed

The session began with the operator proposing that code — including the choice of
Elixir — should be an implementation detail: development conducted entirely at the
level of invariants, specs, tests, and intention maps, with the compiled artifact
regenerable and invisible to the operator. The assessment agreed with the
direction (the bundle already derives its artifacts from ratified intent) and
bounded the endpoint (opacity must be earned by a mechanical oracle; generated
code stays an inspectable regenerable cache). A follow-up read the software
factory / dark-factory wave — StrongDM's no-humans-write-or-review-code pipeline —
against that framework and found each factory innovation patches one named
objection, pricing the boundary rather than dissolving it. The operator ratified
persisting the results:
the [intent-is-the-source doctrine](/meta/doctrine/intent-is-the-source.md), the
[dark-factory oracle-pricing analysis](/meta/analysis/dark-factory-oracle-pricing-intent-as-source.md),
and the
[StrongDM software-factory reference](/knowledge/SWE/agentic/adoption/strongdm-software-factory.md)
(em:efab03), all shipped with index, glossary Seen-in, and registry updates on
this session's branch.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Code as an implementation detail: direction, objections, ratchet synthesis | closed | [intent-is-the-source](/meta/doctrine/intent-is-the-source.md) | - |
| Dark-factory wave (StrongDM) read against the framework | closed | [dark-factory-oracle-pricing-intent-as-source](/meta/analysis/dark-factory-oracle-pricing-intent-as-source.md) | - |
| StrongDM software-factory mechanics capture | closed | [strongdm-software-factory](/knowledge/SWE/agentic/adoption/strongdm-software-factory.md) | - |
| Spec→code traceability raised, not filed: each `mix brain.*` task citing the policy it enforces; policy-derived conformance/property tests | open | unrouted | Should either graduate to a todo or plan? |

## User

Consider the idea that code is an implementation detail, And whether a repo or a project should be written in Elixir as it is here or as binary should be an implementation detail. the operator should have no awareness or understanding of the compiled format. All development should take place from the place of invariants, specs, tests, decision trees, intention maps, belief networks, whatever kind of system allows for expression of guardrails and direction that would allow for accurate regeneration of whatever the code artifact format is. Pros and cons, agreement disagreement?

## Assistant

This is a question worth answering from the repo's own evidence, because elixir-mind has already run this experiment at the document layer — so here's my assessment.

**TL;DR: I agree with the direction and disagree with the endpoint.** "Development happens at the level of intent, artifacts are derived" is already this brain's proven operating pattern — but "the operator should have no awareness of the compiled format" only works when derivation is *deterministic*. For code generated from specs it isn't, and the gap between those two is exactly where I'd push back.

### Where I agree — and where the repo already does this

The pattern you're describing is not hypothetical here; it's the house style:

- `CLAUDE.md` is compiled from `meta/policy/*` — nobody edits the artifact, and `mix brain.contract --check` fails CI on drift.
- `meta/registry.md` is compiled from per-file ids; the route-tagged logs inside documents are materialized from tags and re-derived by the verifier, which "converts freshness from procedural to structural."
- The [engineer-as-orchestrator doctrine](https://ob6to8.github.io/elixir-mind/meta/doctrine/engineer-as-orchestrator.html) explicitly commits the brain to "agent coordination over hand-implementation" and "evaluation over production."

And crucially: the ~6,600 lines of Elixir under `lib/` are *already* downstream artifacts in spirit. `brain.verify`, `brain.route_tags`, `brain.attribution` exist only to enforce rules whose canonical statements live in `meta/policy/`. The policies are the spec; the code is its mechanization. So the claim "the real source of truth is the intent layer" is not aspirational here — it's descriptively true. If an agent rewrote the whole toolchain in Rust tomorrow and every policy check still passed, you arguably shouldn't care. That's the strong version of your argument, and it's substantially right.

Concrete pros of going further in this direction:

1. **The durable asset is portable.** Languages, runtimes, and dependency ecosystems churn; invariants don't. Elixir 1.14/OTP 24 will age; "every bundle doc carries an immutable `em:` id" won't.
2. **It matches the labor model.** You ratify shape; agents implement. Regeneration-from-spec is just that division of labor taken to its limit.
3. **It forces the spec layer to be honest.** Anything you can't regenerate from the specs is, by definition, an undocumented decision. Aiming at regenerability is a forcing function for making intent explicit — valuable even if you never actually regenerate.

### Where I disagree

**1. The determinism gap is the whole ballgame.** `policies → CLAUDE.md` works as an invisible compilation because the compiler is deterministic: same input, same output, and `--check` can mechanically detect divergence. `spec → code` via an agent is generation, not compilation — every regeneration yields a *different* artifact, and there is no `--check` for "is this code a faithful realization of the intent?" The only mechanical oracle you have is the test suite, which brings us to:

**2. Specs and tests underdetermine behavior.** The test suite here is ~2,900 lines pinning ~6,600 lines of implementation. Everything not pinned — error message wording, edge-case handling, ordering, performance, what happens on malformed input the tests never imagined — is free to silently change on each regeneration. This is Hyrum's law inverted: normally consumers depend on unspecified behavior; here the *bundle itself* does. And this repo is the worst possible place for silent behavioral drift, because the code is the integrity layer. A subtly wrong regenerated `brain.verify` doesn't crash — it quietly stops catching a class of corruption, and by your own premise nobody is reading the code to notice.

**3. A spec precise enough for faithful regeneration *is* code.** This is the classic Jack Reeves argument ("the code is the design"). Decision trees, intention maps, and belief networks specified at the fidelity needed to pin down `route_tags.ex`'s 662 lines of parsing, materialization, and divergence-checking would converge on… an implementation, expressed in a language worse than Elixir at expressing it. The choice isn't "intent layer vs. code layer" — it's *where on the precision spectrum the human-ratified layer sits*, and there's a floor below which "spec" is just code with extra steps.

**4. It breaks this repo's provenance model.** The commit graph is your provenance layer: blame answers "which session changed this and why," and true-merge exists specifically to keep cited SHAs reachable. Wholesale regeneration makes diffs meaningless (everything changed, nothing changed) and severs line-level history. Reviewability of the artifact is load-bearing here in a way it isn't for a typical app.

**5. The language already leaks into the contract — by design.** The contract names `mix brain.verify`, `mix brain.id`, `mix brain.url`; the skills invoke them; CI and the pre-commit hook are written against them. Making the language a true implementation detail requires the spec layer to also specify the *operational interface* (command names, hook wiring, CI shape). Doable — the command names are actually a decent stable interface already — but it's more spec surface than "invariants and tests" suggests.

<routes ref="meta/doctrine/intent-is-the-source.md">
### Where I'd land

The right synthesis, I think: **code as a regenerable cache, not an invisible binary.** Treat regenerability as a ratchet, not a switch:

- **Keep the artifact committed, readable, and diffed** — precisely because your verification layer is not (and can't cheaply become) complete enough to make it safely opaque. The honest formulation is: *"the code is derived, and we keep it inspectable because our oracle is partial."*
- **Strengthen spec→code traceability** so the cache is *increasingly* regenerable: each `mix brain.*` task should cite the policy it enforces (some do implicitly; make it structural), and the test suite should keep growing toward executable-spec status — `contract_scenario_test.exs` is already the right genre; property-based tests over the frontmatter/verifier invariants would extend it.
- **Let the interface, not the implementation, be the ratified thing.** The operator-facing surface is the policy corpus plus the command vocabulary. If an agent someday proposes "regenerate the toolchain in language X," that's a ratifiable plan like any shape change — and the migration is safe exactly to the degree the spec/test layer has been ratcheted up. Your ideal becomes reachable *as a consequence* of doing the above, rather than a premise adopted before the oracle can support it.
</routes>

One meta-note: this idea is a natural `type: doctrine` candidate — a standing direction ("intent is the source; artifacts are derived and machine-checked") that sits exactly one shelf over from engineer-as-orchestrator, with this discussion as the analysis behind it. Doctrine is operator-ratified, so I haven't filed anything; if you want it persisted (as a doctrine, an analysis, or both), say the word and I'll draft it on this branch.

## User

What does this say for the current wave of software factory/dark factory approaches like strong.ai?

## Assistant

StrongDM's "software factory" (the write-up that named this wave — often shorthanded as strong.ai) turns out to be almost a controlled experiment on exactly the argument from last turn, so here's the short version first.

**TL;DR: The dark-factory wave is the strong form of your proposal actually shipped — and its architecture confirms the framework point by point, because every one of StrongDM's key innovations exists to patch one of the objections I raised.** What they prove is that "code nobody reads" is reachable *if* you industrialize the oracle and accept statistical rather than boolean correctness. That doesn't dissolve the boundary I drew; it locates it precisely — and it puts elixir-mind's integrity layer on the far side of it.

<routes ref="em:efab03">
### What StrongDM actually built

Their rules are absolute: code must not be written *or reviewed* by humans. A three-person team runs agents that plan, implement, test, and ship. The load-bearing pieces: **holdout scenarios** — end-to-end behavioral specs kept *outside* the codebase and outside the agents' development context, like an ML validation set; **digital twins** — agent-built behavioral clones of Okta, Slack, Jira, etc., so behavior can be exercised at volumes production APIs won't allow; and **satisfaction metrics** — instead of boolean test results, "what fraction of observed trajectories through the scenarios likely satisfy the user?" Reported cost: $1,000+/day per engineer in tokens.
</routes>

<routes ref="meta/analysis/dark-factory-oracle-pricing-intent-as-source.md">
### The mapping to last turn's objections

Each objection got an engineering answer — and each answer is a concession that the objection was real:

- **"Tests underdetermine behavior, and an agent writing both code and tests will Goodhart the oracle"** → holdout scenarios. They solved teach-to-the-test by importing the train/validation split from ML. Notably, the spec lives in a separate, human-governed namespace — which is exactly what `meta/policy/` already is in this repo.
- **"A spec precise enough for faithful regeneration is code"** → they don't attempt a complete spec. They keep the spec partial and compensate with *massive empirical measurement* (the twins exist to make the observable behavior surface huge). The unpinned remainder is allowed to drift.
- **"The determinism gap: no mechanical `--check` for spec-faithfulness"** → satisfaction metrics. This is the deepest move: they *concede* that correctness of generated systems can't be boolean and redefine acceptance as statistical — which is what an actual lights-out factory does (acceptable defect rates, instrumented sampling), and is why "factory" is the honest metaphor.
- **"Provenance, audit, reviewability"** → unsolved, just deprioritized. Fine for a SaaS product whose failures are visible and recoverable; this is the objection that doesn't get a patch, and it's why the same pattern gets much harder in regulated domains (audit, banking, legal — where the analysis pieces on this wave focus).
</routes>

### What it says more broadly

**Human review didn't disappear — it moved up a level.** Someone authors and curates the scenarios, judges the satisfaction dashboards, and decides what "satisfying the user" means. That's your [engineer-as-orchestrator doctrine](https://ob6to8.github.io/elixir-mind/meta/doctrine/engineer-as-orchestrator.html) implemented literally: the human's artifact is the spec corpus and the acceptance judgment, never the diff. Relatedly, the durable IP inverts: their moat isn't the codebase (disposable, regenerable) but the scenario library and the twins — the intent layer is the asset, which is the "durable asset is portable" pro from last turn, validated commercially. And **the oracle is where the capex went**: the twins, the observability, the self-healing harness. The factory *is* the verification apparatus; code generation is the cheap part.

**Where it generalizes and where it doesn't.** The pattern fits software whose correctness is (a) observable end-to-end from the outside, (b) tolerable to get statistically rather than absolutely, and (c) economically worth a very expensive oracle. SaaS product surfaces, integration glue, internal tools: yes. It fits badly where defects are invisible to instrumentation until they compound (integrity/security layers), where external consumers depend on unspecified behavior that regeneration silently changes (platforms, libraries — Hyrum's law), or where an auditor needs "why does this line exist" answered (regulated domains).

### What it says back to this repo

Three concrete readings:

1. **Elixir-mind already has the dark-factory's rarest component.** The holdout spec held in a human-ratified namespace outside the implementation — that's `meta/policy/` verbatim. Most teams attempting this have to invent that layer; here it's the founding structure. Going darker would mean deriving scenario-style conformance tests *from the policies, independently of `lib/`* (so the implementation can't teach to its own tests) — `contract_scenario_test.exs` is the proto-version of exactly that.

2. **But the brain's core code is the wrong genre for satisfaction metrics.** `brain.verify` and `brain.route_tags` *are* the oracle — a verifier that's 97% satisfying silently corrupts the bundle at 3%, and the whole premise is that nobody's reading the code to catch it. StrongDM can be probabilistic because their failures surface to users; a knowledge base's integrity layer needs boolean conformance. So the split I'd draw: the verifier stays on the "regenerable cache, kept readable" side of the ratchet indefinitely, while peripheral surfaces (the site renderer, the digest formatting) are legitimately dark-factory-able today.

3. **The economics footnote matters.** $1,000/day/engineer says regeneration-instead-of-caching is currently bought, not free. Their bet is token prices fall faster than oracle costs rise. For a personal brain the equivalent bet is smaller but real: the ratchet position — invest in the spec/test layer continuously, regenerate opportunistically — is the same trade at hobbyist scale.

So: the wave doesn't refute last turn's disagreements; it *prices* them. The endpoint is buyable — with an industrial oracle, statistical correctness, and a domain whose failures are observable and forgivable. Your proposal is right about which layer is the asset; StrongDM is the demonstration that the remaining question was never philosophy, it's oracle engineering.

Sources: [How StrongDM's AI team build serious software without even looking at the code — Simon Willison](https://simonwillison.net/2026/Feb/7/software-factory/), [The Dark Factory Pattern — HackerNoon](https://hackernoon.com/the-dark-factory-pattern-moving-from-ai-assisted-to-fully-autonomous-coding), [Dark Factories: The Five Levels of AI Automation — Cow-Shed](https://www.cow-shed.com/blog/dark-factories-five-levels-ai-automation-transform-audit-banking-legal), [What Is a Dark Factory? — MindStudio](https://www.mindstudio.ai/blog/what-is-dark-factory-autonomous-ai-codebase)

If you want this thread persisted, it's a natural pair: the doctrine draft from last turn plus a `meta/analysis/` doc on dark-factory applicability to this brain, with the Willison piece captured as a `reference`.

## User

Agree, proceed

## Assistant

Ratified and shipped. Everything is committed and pushed to `claude/code-implementation-detail-b6pxht` (commit `035d054`), with all gates green — `mix brain.verify`, `mix brain.route_tags`, `mix brain.contract --check`, and 177/177 tests passing.

Three artifacts, filed per the update-in-place check (the existing dark-factory material turned out to be complementary, not duplicative — the prior analysis covers the *runtime* scenario, this pair covers the *artifact* question):

- **Doctrine** — `meta/doctrine/intent-is-the-source.md`: "Intent is the source; artifacts are derived — and opacity is earned by the oracle." Filed as the artifact-layer sibling of engineer-as-orchestrator: the ratified layer is intent, code is a derived artifact, and generated code stays an inspectable regenerable cache until a mechanical oracle earns its opacity.
- **Analysis** — `meta/analysis/dark-factory-oracle-pricing-intent-as-source.md`: the StrongDM objection→patch mapping, the generalization boundary, and the split for this brain (verifier core stays boolean-conformance and readable; peripheral surfaces are factory-able).
- **Reference** — `knowledge/SWE/agentic/adoption/strongdm-software-factory.md` (`em:efab03`): the Willison write-up captured and distilled, filed beside the Cherny adoption ladder as a lived step-4 case study.

The doctrine, analysis, and adoption indexes are updated, the dark-factory glossary term gained the two new *Seen-in* citations, and the registry is regenerated. Once merged, the pages will be live at [the doctrine](https://ob6to8.github.io/elixir-mind/meta/doctrine/intent-is-the-source.html), [the analysis](https://ob6to8.github.io/elixir-mind/meta/analysis/dark-factory-oracle-pricing-intent-as-source.html), and [the reference](https://ob6to8.github.io/elixir-mind/knowledge/SWE/agentic/adoption/strongdm-software-factory.html).

One expected loose end: the analysis carries the advisory `attribution lacks from` warning because this session's thread doc doesn't exist yet — `/create-pull-request` will run `/capture`, stamp the thread path into both governance docs' `from`, and glossary the thread. Say the word when you want the PR opened.

## User

Push then /create-pull-request
