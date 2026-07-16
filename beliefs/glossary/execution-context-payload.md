---
id: em:34e823
type: concept
title: Execution Context Payload (ECP)
description: This brain's coined standard for the minimal packet a fresh-context executor receives to start a plan's workstream cold — a thin pointer packet into the ratified plan on disk (plan ref, workstream id, scope + reading allowlist, deliverable contract, verification commands), not the deliberation history that produced the plan.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, agents, orchestration, execution, delegation]
sense: repo
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T14:21:49Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term coined in the 2026-07-16 Workflow-driven plan-execution convention analysis as the standard cold-start payload"
---

# Execution Context Payload (ECP)

Coined in this brain's proposed
[Workflow-driven plan-execution convention](/meta/analysis/executing-ratified-plans-via-workflow-fan-out.md):
the minimal, uniform packet a
[fresh-context](/beliefs/glossary/fresh-context-execution.md) executor receives to
start one of a ratified plan's workstreams cold. Its defining move is that it is a
**thin pointer packet into the plan on disk**, not a re-transcription of the
session that produced the plan — viable because the persist-plans policy already
makes the plan outlive its session. Five fields: `plan_ref` (the plan doc's path
in the checkout), `workstream_id` (which workstream to run), the scope + **reading
allowlist** (its hard bounds — what it may and must not open), the deliverable
contract (what to return, with a schema when structured), and the verification
commands (the gate/residue checks to self-certify before returning). The operating
contract loads automatically, so it is excluded; so is the deliberation history.
The **context-fit assertion** it encodes — that a workstream is executable from
the plan text plus the bundle it may read, nothing session-only — is what the
convention's pre-execution readiness gate checks.

*Seen in:* [executing-ratified-plans-via-workflow-fan-out analysis](/meta/analysis/executing-ratified-plans-via-workflow-fan-out.md), [2026-07-16 Workflow-driven plan-execution thread](/meta/threads/2026-07-16-workflow-driven-plan-execution-convention.md)

*See also:* [fresh-context execution](/beliefs/glossary/fresh-context-execution.md), [Workflow (orchestration tool)](/beliefs/glossary/workflow-tool.md), [plan (type)](/beliefs/glossary/plan-type.md)
