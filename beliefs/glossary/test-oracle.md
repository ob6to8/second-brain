---
id: em:3d4be4
type: concept
title: test oracle
description: A source of ground truth, independent of the system under test, that decides whether an output is correct — the component whose independence, not the agent's competence, a verification gate's trust rests on.
provenance: "Agent-distilled glossary definition, Claude Code session"
verified: false
sense: common
tags: [testing, verification, trust]
timestamp: 2026-07-20
attribution:
  when: 2026-07-17T18:24:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-17 tier-3/4 interface-and-trust thread"
---

# test oracle

The independence requirement is what makes it load-bearing for autonomous loops: when
the same model both produces and checks the work, its blind spots are shared across both
roles, so the loop can reinforce its own errors instead of catching them. Trustworthy
gates therefore route judgment through a checker that fails for reasons the generator
cannot talk its way past — a compiler or type checker, a build that breaks, a
human-written specification, or a different model prompted to refute. The strength of an
[escape rate](/beliefs/glossary/escape-rate.md) as a trust signal is bounded by how
independent this checker actually is.

Its *completeness* matters as much as its independence: the intent-as-source
doctrine makes oracle coverage the price of artifact opacity — a generated
artifact may go unread only to the degree the oracle pins its behavior, and
where coverage is partial the artifact must stay inspectable. Industrializing
the oracle ([holdout scenarios](/beliefs/glossary/holdout-scenario.md), digital
twins, [satisfaction metrics](/beliefs/glossary/satisfaction-metric.md)) is what
the software-factory wave spends its capital on.

Oracles are also the scarce resource of eval design — constructible
[ground truth](/beliefs/glossary/ground-truth.md) makes them cheap, which is this
bundle's structural advantage. They need not be answer keys: the
[routing ledger](/beliefs/glossary/routing-ledger.md)'s per-strand bookkeeping acts
as a *completion* oracle for multi-step agent work, judging whether everything
started was finished and accounted for rather than whether a specific output
matched.

*Seen in:* [tier-3-4-interface-and-trust-determination](/meta/analysis/tier-3-4-interface-and-trust-determination.md), [2026-07-17 tier-3/4 interface and trust](/meta/threads/2026-07-17-tier-3-4-interface-and-trust-with-adoption-intake.md), [2026-07-20 intent-as-source and dark-factory pricing](/meta/threads/2026-07-20-intent-as-source-and-dark-factory-pricing.md), [2026-07-20 code as compilation target and DSP testing model](/meta/threads/2026-07-20-code-as-compilation-target-and-dsp-testing-model.md), [2026-07-20 evals and observation-records thread](/meta/threads/2026-07-20-evals-harness-ledger-and-observation-records.md), [harness-and-ledger analysis](/meta/analysis/harness-and-ledger-as-eval-infrastructure.md)
