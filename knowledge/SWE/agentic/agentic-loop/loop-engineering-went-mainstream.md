---
id: em:01bb9a
type: reference
title: "Loop engineering went mainstream (Sébastien Dubois)"
description: The frontier has shifted from prompt-writing to "loop engineering" — designing the harness of triggers, validators, and stopping conditions that governs an agent's autonomous read-act-verify-decide cycle.
resource: https://www.dsebastien.net/loop-engineering-went-mainstream/
provenance: "Distilled from Sébastien Dubois, dsebastien.net, 2026-07-04"
tags: [agentic-loop, ai-agents, loop-engineering, harness-design, autonomous-agents, validation]
timestamp: 2026-07-06
attribution:
  when: 2026-07-06T15:34:55+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# Loop engineering went mainstream (Sébastien Dubois)

Dubois marks a shift from optimizing single prompts to engineering the loop around
the model: *"Design the system, not just the message."* He notes figures like
Boris Cherny, Jensen Huang, and Andrew Ng publicly moving beyond direct prompting
toward loop architecture, arguing the bottleneck is no longer model capability but
the harness — triggers, validators, stopping conditions, and budgeting. With
long task horizons (10+ hours) now feasible, the constraint becomes control-flow
infrastructure. The agentic loop here is a decision cycle — read state, act,
verify, decide whether to continue — distinct from dumb cron scheduling because the
agent actively evaluates whether outcomes justify proceeding. Critical requirements
include deterministic validation gates (so agents don't reinforce their own
errors), budget constraints, and elevating rather than removing humans, who move
from executing tasks to strategic oversight. Loop engineering treats agentic
systems as first-class engineering problems demanding architectural discipline.

# Citations

Sébastien Dubois, "Loop Engineering Went Mainstream", 2026-07-04 —
<https://www.dsebastien.net/loop-engineering-went-mainstream/>
