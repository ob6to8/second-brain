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

Its defining move — pointing *into* the plan rather than copying the reasoning
around it — is viable only because the persist-plans policy already guarantees the
plan outlives the session that wrote it, so `plan_ref` resolves to a real file the
[fresh-context](/beliefs/glossary/fresh-context-execution.md) executor can open.
The five fields divide into a locator (`plan_ref`, `workstream_id`), the
executor's hard bounds (scope and a **reading allowlist** naming what it may and
must not read), and its exit contract (the deliverable schema, plus the
gate/residue commands it runs to self-certify). The operating contract is excluded
because it loads automatically; the deliberation history is excluded on purpose.
What the packet encodes is a **context-fit assertion** — that the workstream is
executable from the plan text plus the bundle it may read, nothing session-only —
and checking that assertion before any executor spawns is the job of the
convention's pre-execution readiness gate.

*Seen in:* [executing-ratified-plans-via-workflow-fan-out analysis](/meta/analysis/executing-ratified-plans-via-workflow-fan-out.md), [2026-07-16 Workflow-driven plan-execution thread](/meta/threads/2026-07-16-workflow-driven-plan-execution-convention.md)

*See also:* [fresh-context execution](/beliefs/glossary/fresh-context-execution.md), [Workflow (orchestration tool)](/beliefs/glossary/workflow-tool.md), [plan (type)](/beliefs/glossary/plan-type.md)
