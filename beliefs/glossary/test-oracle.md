---
id: em:3d4be4
type: concept
title: test oracle
description: A source of ground truth, independent of the system under test, that decides whether an output is correct — the component whose independence, not the agent's competence, a verification gate's trust rests on.
provenance: "Agent-distilled glossary definition, Claude Code session"
verified: false
sense: common
tags: [testing, verification, trust]
timestamp: 2026-07-17
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

*Seen in:* [tier-3-4-interface-and-trust-determination](/meta/analysis/tier-3-4-interface-and-trust-determination.md), [2026-07-17 tier-3/4 interface and trust](/meta/threads/2026-07-17-tier-3-4-interface-and-trust-with-adoption-intake.md)

*See also:* [escape rate](/beliefs/glossary/escape-rate.md), [llm-as-judge](/beliefs/glossary/llm-as-judge.md), [gate suite](/beliefs/glossary/gate-suite.md)
