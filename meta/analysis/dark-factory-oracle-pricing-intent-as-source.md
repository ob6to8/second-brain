---
type: analysis
title: "What the dark-factory wave prices about intent-as-source: StrongDM's software factory as the strong-form experiment"
description: Reads StrongDM's software factory (no human-written or human-reviewed code) against the intent-is-the-source doctrine and finds it a point-by-point confirmation rather than a refutation — each of its innovations (holdout scenarios, digital twins, satisfaction metrics) patches one named objection to code-as-implementation-detail, proving the endpoint is buyable with an industrial oracle and statistical correctness; locates the generalization boundary (observable, forgivable failures; no audit demand; oracle economics) and places this brain's verifier core on the boolean-conformance side of it while its peripheral surfaces qualify, with the policies-as-holdout-spec structure already in place.
provenance: "Claude Code session (Claude Fable), 2026-07-20 — operator asked what the code-is-an-implementation-detail assessment says for the software-factory/dark-factory wave (StrongDM); web-grounded via Simon Willison's 2026-02-07 write-up; ratified for persistence alongside the intent-is-the-source doctrine"
tags: [meta, analysis, dark-factory, software-factory, intent-as-source, oracles, verification, holdout-scenarios, satisfaction-metrics, autonomy, regeneration]
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T19:22:12Z
  channel: agent-authored
  why: "persists the session's judgment on where the dark-factory pattern does and does not apply to this brain, so the doctrine it tests carries its evidence"
  agent: "Claude Code agent, code-is-an-implementation-detail session"
  from: [/meta/threads/2026-07-20-intent-as-source-and-dark-factory-pricing.md]
---

# What the dark-factory wave prices about intent-as-source: StrongDM's software factory as the strong-form experiment

**Question.** The
[intent-is-the-source doctrine](/meta/doctrine/intent-is-the-source.md) holds
that development belongs at the level of ratified intent, with code a derived
artifact — but bounds the endpoint: generated code stays inspectable until a
mechanical oracle earns its opacity. What does the current wave of software
factories — StrongDM's
[no-humans-write-or-review-code pipeline](/knowledge/SWE/agentic/adoption/strongdm-software-factory.md)
chief among them — say about that direction and that boundary? Does a shipped
[dark factory](/beliefs/glossary/dark-factory.md) for software refute the
boundary, and what follows for this brain?

**Bottom line.** The dark-factory wave is the strong form of intent-as-source
actually shipped, and its architecture **confirms the doctrine's framework
point by point**: each of StrongDM's key innovations exists to patch one of the
named objections to invisible code, and each patch is a concession that the
objection was real. What the factory proves is that the endpoint is *buyable* —
with an industrialized oracle, statistical rather than boolean correctness, and
a domain whose failures are observable and forgivable. That prices the boundary
rather than dissolving it: the durable-asset claim is vindicated commercially
(their moat is the scenario library and the twins, not the code), human review
moves up a level rather than disappearing, and this brain's integrity core sits
squarely on the boolean-conformance side of the line while its peripheral
surfaces qualify for the factory treatment today.

## 1. The objection→patch mapping

The doctrine's boundary rests on four objections to spec-to-code opacity. The
factory answers three of them with engineering and deprioritizes the fourth —
and the shape of each answer is the confirmation:

1. **Tests underdetermine behavior, and an agent writing both code and tests
   Goodharts the oracle** → **holdout scenarios.** Behavioral specs are kept
   outside the agents' development context, a train/validation split imported
   from ML. The spec lives in a separate, human-governed namespace — which is
   structurally what this bundle's `meta/policy/` already is.
2. **A spec precise enough for faithful regeneration is code** → **don't
   attempt a complete spec.** The scenarios stay partial; the compensation is
   massive empirical measurement — digital twins exist to make the observable
   behavior surface enormous. The unpinned remainder is *allowed to drift*.
3. **The determinism gap: no mechanical `--check` for spec-faithfulness** →
   **satisfaction metrics.** The deepest move: concede that correctness of
   generated systems cannot be boolean, and redefine acceptance as the fraction
   of observed scenario trajectories that likely satisfy the user. This is
   quality control by instrumented sampling — the same acceptance apparatus the
   [tier-3/4 trust analysis](/meta/analysis/tier-3-4-interface-and-trust-determination.md)
   derives independently as the sampled defect-escape rate, and the reason
   "factory" is the honest metaphor.
4. **Provenance, audit, reviewability** → **unpatched, deprioritized.**
   Tolerable for a SaaS product whose failures surface to users and can be
   shipped over; disqualifying where an auditor needs "why does this line
   exist" answered. This is the objection that bounds the pattern's spread into
   regulated domains.

## 2. What the factory demonstrates beyond the mapping

- **Human review moved up a level; it did not disappear.** Someone authors and
  curates scenarios, judges satisfaction dashboards, and decides what
  "satisfying" means. That is the
  [engineer-as-orchestrator doctrine](/meta/doctrine/engineer-as-orchestrator.md)
  implemented literally: the human artifact is the spec corpus and the
  acceptance judgment, never the diff.
- **The durable IP inverts.** The generated codebase is disposable; the moat is
  the scenario library and the twins. The intent layer is the asset —
  intent-as-source's central claim, validated commercially.
- **The oracle is where the capex went.** Twins, observability, self-healing
  harness: the factory *is* the verification plant; generation is the cheap
  part. At $1,000+/day/engineer in tokens, regeneration-instead-of-caching is
  currently bought, not free — their bet is that token prices fall faster than
  oracle costs rise.

## 3. The generalization boundary

The pattern fits software whose correctness is (a) **observable end-to-end from
outside**, (b) **tolerable statistically** rather than needed absolutely, and
(c) economically worth a very expensive oracle. Product surfaces, integration
glue, internal tools: yes. It fits badly where defects are invisible to
instrumentation until they compound (integrity and security layers), where
external consumers depend on unspecified behavior that regeneration silently
changes (platforms and libraries — Hyrum's law), or where audit demands
line-level answers. On
[Cherny's adoption ladder](/knowledge/SWE/agentic/adoption/steps-of-ai-adoption.md)
the factory is a lived step-4 case study — and its constraint set is a preview
of what step 4 charges for admission.

## 4. What follows for this brain

1. **The rarest component is already here.** A holdout spec held in a
   human-ratified namespace outside the implementation is `meta/policy/`
   verbatim. Most teams attempting the pattern must invent that layer; here it
   is the founding structure. Going darker means deriving scenario-style
   conformance tests *from the policies, independently of `lib/`* — so the
   implementation cannot teach to its own tests —
   for which `test/elixir_mind/contract_scenario_test.exs` is the
   proto-version.
2. **The verifier core is the wrong genre for satisfaction metrics.**
   `brain.verify` and `brain.route_tags` *are* the oracle; a verifier that is
   97% satisfying silently corrupts the bundle at 3%, with nobody reading the
   code by premise. StrongDM can be probabilistic because their failures
   surface to users; an integrity layer needs boolean conformance. The split:
   the verifier core stays a regenerable-but-readable cache indefinitely, while
   peripheral surfaces (the site renderer, digest formatting) are legitimately
   factory-able today. This is the same auditor-independence line the
   [dark-factory epistemic-base analysis](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
   draws for the runtime scenario: the factory's auditor must never depend on
   the factory.
3. **The economics scale down but do not vanish.** At personal-brain scale the
   equivalent of their bet is the doctrine's ratchet: invest in the spec/test
   layer continuously, regenerate opportunistically, and let opacity follow the
   oracle rather than precede it.

The wave, in short, does not refute the doctrine's boundary — it *prices* it.
The remaining question was never philosophy; it is oracle engineering.

# Citations

- [StrongDM's software factory (Simon Willison, 2026-02-07)](/knowledge/SWE/agentic/adoption/strongdm-software-factory.md)
  — the captured primary write-up all factory mechanics here derive from.
- [Intent is the source; artifacts are derived](/meta/doctrine/intent-is-the-source.md)
  — the doctrine this analysis tests; ratified the same session.
- [Dark-factory epistemic-base scenario](/meta/analysis/dark-factory-epistemic-base-beam-jido.md)
  — the runtime-side sibling: what this brain would need *under* a dark
  factory; this analysis is the artifact-side complement (what a dark factory
  says about the brain's own code).
- [Tier-3/4 interface and trust determination](/meta/analysis/tier-3-4-interface-and-trust-determination.md)
  — independently derives the sampled-escape-rate acceptance apparatus that
  satisfaction metrics instantiate.
- Secondary landscape context (unfiled): MindStudio and HackerNoon dark-factory
  explainers; Cow-Shed on five automation levels in audit/banking/legal.
