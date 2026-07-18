---
id: em:43bac4
type: concept
title: monitor by exception
description: A supervision posture in which the operator is surfaced only the cases that need human judgment while the system handles the rest autonomously, inverting who initiates each interaction.
provenance: "Agent-distilled glossary definition, Claude Code session"
verified: false
sense: common
tags: [supervision, autonomy, interface, management]
timestamp: 2026-07-18
attribution:
  when: 2026-07-17T18:24:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-17 tier-3/4 interface-and-trust thread"
---

# monitor by exception

A restatement of management-by-exception for autonomous agent fleets, and the posture
that reshapes the interface at high autonomy tiers. Under full review the human initiates
every turn and reads everything; here the system initiates most turns and the human reads
only the escalations — the same polarity flip that turns a chat *terminal* into an
*inbox*. The realized surface is therefore a telemetry dashboard (aggregate health,
including the [escape rate](/beliefs/glossary/escape-rate.md)) fused to an exception queue
where the cases needing judgment land. It presupposes a system calibrated to escalate the
ambiguous rather than plow through it, since an agent that never asks for a human is
merely confident, not trustworthy.

*Seen in:* [tier-3-4-interface-and-trust-determination](/meta/analysis/tier-3-4-interface-and-trust-determination.md), [2026-07-17 tier-3/4 interface and trust](/meta/threads/2026-07-17-tier-3-4-interface-and-trust-with-adoption-intake.md), [2026-07-18 observer-subagent-pattern intake](/meta/threads/2026-07-18-observer-subagent-pattern-intake.md)

*See also:* [escape rate](/beliefs/glossary/escape-rate.md), [maturity model](/beliefs/glossary/maturity-model.md), [observer agent](/beliefs/glossary/observer-agent.md)
