---
id: em:efab03
type: reference
title: "StrongDM's software factory: serious software without looking at the code (Simon Willison)"
description: StrongDM's three-person AI team runs a "non-interactive development" pipeline where humans neither write nor review code — holdout scenarios kept outside the dev context, agent-built digital twins of external services, and probabilistic satisfaction metrics replace human code review as the acceptance oracle.
resource: https://simonwillison.net/2026/Feb/7/software-factory/
provenance: "Distilled from Simon Willison, Simon Willison's Weblog, 2026-02-07, reporting StrongDM's internal software factory"
tags: [dark-factory, software-factory, ai-agents, autonomous-coding, holdout-scenarios, digital-twins, verification, oracles, adoption]
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T19:22:12Z
  channel: intake
  agent: "Claude Code agent, code-is-an-implementation-detail session"
  why: "ratified for capture as the grounding source of the intent-as-source ratification pair (doctrine + dark-factory applicability analysis)"
---

# StrongDM's software factory: serious software without looking at the code (Simon Willison)

StrongDM publicly revealed a deliberately constrained experiment running since
mid-2025: a three-person team (a CTO, a senior engineering manager, one new
hire) operating a **dark factory** for software — a pipeline whose foundational
rules are absolute: *code must not be written by humans* and *code must not be
reviewed by humans*. Agents plan, implement, test, debug, and ship; the humans
author specifications and judge outcomes.

The load-bearing mechanisms:

- **Holdout scenarios.** Behavioral specifications — end-to-end user stories —
  are maintained *outside* the codebase and withheld from the agents'
  development context, exactly like a validation set in machine learning. The
  agents develop without knowing what they will be measured against, which
  defeats the Goodhart failure of an agent that writes both the code and the
  tests teaching to its own test suite. Scenarios are the ultimate arbiter and
  never enter the development loop.
- **Digital twins.** Agents build behavioral clones of the external services the
  product integrates with (Okta, Slack, Jira, and others), replicating APIs and
  edge cases, so behavior can be exercised at volumes production APIs and rate
  limits would never allow. The twins are what make the observable behavior
  surface large enough to substitute for reading the code.
- **Satisfaction metrics, not boolean tests.** Because agents write both code
  and tests, acceptance shifts from pass/fail to a probabilistic question: of
  all observed trajectories through all scenarios, what fraction likely satisfy
  the user? Correctness becomes statistical — quality control by instrumented
  sampling, as in a physical lights-out factory — rather than absolute.
- **Supporting plant.** An observability layer and a self-healing debugging
  system; the team also trained dozens of StrongDM's senior engineers on the
  paradigm.

Stated costs and limits: token spend exceeding $1,000/day per engineer, with
open questions about sustainability and competitive differentiation. The
durable assets are notably not the generated code (disposable, regenerable) but
the scenario library and the twins — the specification and verification plant.

# Citations

- Simon Willison, "How StrongDM's AI team build serious software without even
  looking at the code", 2026-02-07 — the `resource` URL.

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:efab03">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-20-intent-as-source-and-dark-factory-pricing (2026-07-20)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:efab03`]**

**What StrongDM actually built**

Their rules are absolute: code must not be written *or reviewed* by humans. A three-person team runs agents that plan, implement, test, and ship. The load-bearing pieces: **holdout scenarios** — end-to-end behavioral specs kept *outside* the codebase and outside the agents' development context, like an ML validation set; **digital twins** — agent-built behavioral clones of Okta, Slack, Jira, etc., so behavior can be exercised at volumes production APIs won't allow; and **satisfaction metrics** — instead of boolean test results, "what fraction of observed trajectories through the scenarios likely satisfy the user?" Reported cost: $1,000+/day per engineer in tokens.
