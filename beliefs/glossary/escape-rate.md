---
id: em:c106a0
type: concept
title: escape rate
description: The fraction of defective outputs that pass through a verification gate undetected — the false-negative rate that measures how far a reviewer can trust an automated check.
provenance: "Agent-distilled glossary definition, Claude Code session"
verified: false
sense: common
tags: [verification, quality, trust, metrics]
timestamp: 2026-07-17
attribution:
  when: 2026-07-17T18:24:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-17 tier-3/4 interface-and-trust thread"
---

# escape rate

Borrowed from software quality's *defect escape rate*, the metric is estimated by
**sampling the work a gate has already passed** and checking a fraction of it by an
independent standard — which is why the sample rate can never fall to zero without the
number becoming an assertion rather than a measurement. It is the load-bearing signal
for whether an autonomous loop has earned trust: an architect withdraws a unit of human
supervision and watches whether the rate stays flat or climbs as load rises. A stable,
low value under withdrawn supervision is the empirical signature of a reached autonomy
tier; any upward drift is a demotion signal that supervision be added back. Its
credibility depends entirely on the independence of the [test oracle](/beliefs/glossary/test-oracle.md)
doing the checking.

*Seen in:* [tier-3-4-interface-and-trust-determination](/meta/analysis/tier-3-4-interface-and-trust-determination.md), [2026-07-17 tier-3/4 interface and trust](/meta/threads/2026-07-17-tier-3-4-interface-and-trust-with-adoption-intake.md)

*See also:* [test oracle](/beliefs/glossary/test-oracle.md), [monitor by exception](/beliefs/glossary/monitor-by-exception.md), [gate suite](/beliefs/glossary/gate-suite.md)
