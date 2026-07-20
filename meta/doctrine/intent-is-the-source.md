---
type: doctrine
title: "Intent is the source; artifacts are derived — and opacity is earned by the oracle"
description: The brain's direction for its own tooling — development happens at the level of ratified intent (policies, invariants, specs, tests), and every downstream artifact, the code included, is a derived, machine-checked product; an artifact may become invisible to the operator only to the degree a mechanical oracle covers its behavior, so generated code is held as a regenerable cache kept inspectable until the oracle earns its opacity.
provenance: "Claude Code session (Claude Fable), 2026-07-20 — distilled from the operator's proposal that code, and even the implementation language, should be an implementation detail regenerable from invariants/specs/tests/intention maps; ratified this session as the third doctrine document"
tags: [meta, doctrine, direction, intent-as-source, generated-artifacts, oracles, verification, dark-factory, regeneration]
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T19:22:12Z
  channel: agent-authored
  why: "operator proposed the direction, the session's assessment bounded it, and the operator ratified persisting it as standing doctrine"
  agent: "Claude Code agent, code-is-an-implementation-detail session"
  from: [/meta/threads/2026-07-20-intent-as-source-and-dark-factory-pricing.md]
---

# Intent is the source; artifacts are derived — and opacity is earned by the oracle

This is a **standing direction** for how the brain's own machinery is built and
judged, sitting one shelf from
[the engineer as orchestrator](/meta/doctrine/engineer-as-orchestrator.md): where
that doctrine names the *human's* role (direct, ratify, evaluate — never type),
this one names the *artifact's* status. It is the why behind the compiled
contract and the generated registries, and the reference a future "regenerate
the toolchain" plan would cite.

## The direction

**The human-ratified layer of this system is intent — policies, invariants,
specifications, tests, doctrine — and everything downstream of it is a derived
artifact.** The operator ratifies the shape of the brain, never its compiled
forms; agents produce the artifacts; machines check that artifact and intent
have not diverged. Code — including the choice of Elixir — is in principle one
more such artifact: the durable asset is the intent layer, and the
implementation is a product of it that could be regenerated, even in another
language, without the operator's ratified world changing.

The bundle already practices this where derivation is deterministic:
`CLAUDE.md` is compiled from `meta/policy/` and CI fails on drift;
`meta/registry.md` is compiled from per-file ids; the route-tagged logs inside
documents are re-derived by the verifier, which converts their freshness from
procedural to structural. The direction commits the brain to extending that
pattern — never retreating from it.

## The boundary: opacity is earned, not assumed

An artifact may become **invisible** to the operator only to the degree that a
mechanical oracle covers its behavior. Deterministic compilation earns full
opacity (a `--check` gate proves faithfulness). Generative derivation —
spec-to-code through an agent — does not yet: specs and tests underdetermine
behavior, regeneration varies everything unpinned, and no `--check` exists for
faithfulness-to-intent. So generated code is held as a **regenerable cache**:
derived in status, committed and inspectable in practice, precisely because the
oracle is partial. The honest formulation: *the code is derived, and we keep it
readable because our verification layer cannot yet make it safely opaque.*

## What it commits the brain to

- **Ratchet the oracle, and let opacity follow.** Invest continuously in the
  spec/test layer — policies as the holdout spec held outside the
  implementation, conformance tests derived from policies rather than from the
  code, traceability from each `mix brain.*` task to the policy it enforces —
  so artifacts become *more* regenerable over time. Regenerability is a forcing
  function: anything that cannot be regenerated from the intent layer is an
  undocumented decision.
- **The interface is the ratified thing, not the implementation.** The
  operator-facing surface is the policy corpus plus the command vocabulary
  (`mix brain.verify`, `mix brain.contract`, …). A language or implementation
  swap is a ratifiable plan like any shape change, safe exactly to the degree
  the oracle has been ratcheted up.
- **Match the acceptance criterion to the genre.** Statistical acceptance
  (satisfaction sampling, the dark-factory mode) is legitimate for surfaces
  whose failures are observable and forgivable; the brain's integrity layer —
  the verifiers that *are* the oracle — demands boolean conformance and stays
  on the inspectable side of the ratchet indefinitely. Who verifies the
  verifier is the one question this doctrine never lets an agent wave away.

## Standing against this direction

The dark-factory wave is the strong-form experiment on this doctrine's endpoint,
and its evidence is weighed in
[what the dark-factory wave prices about intent-as-source](/meta/analysis/dark-factory-oracle-pricing-intent-as-source.md),
grounded in the captured
[StrongDM software-factory reference](/knowledge/SWE/agentic/adoption/strongdm-software-factory.md).
That analysis is the applicability judgment; this doctrine is the fixed
direction it judges against.
