---
id: em:f6c3c2
type: concept
title: "eve (Vercel agent framework)"
description: Vercel's open-source, TypeScript-native agent framework (June 2026) in which an agent is a directory of files — instructions, tools, skills, subagents, channels, connections — auto-discovered by name and compiled into a durable service on Vercel's runtime.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, eve, vercel, agents, framework, typescript]
sense: common
timestamp: 2026-07-20
attribution:
  when: 2026-07-17T20:30:00Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-17 vercel-eve comparison thread"
---

# eve (Vercel agent framework)

Pitched as "Like Next.js for web apps, but for agents": the framework owns the
plumbing the way Next.js owns routing, and "a file's name and place in the tree
are its definition." `agent/instructions.md` is the always-on system prompt;
`agent/tools/*.ts` each define one typed action (the filename becomes the
model-facing tool name); `agent/skills/*` hold on-demand markdown procedures
kept out of the always-on prompt; `agent/channels/*` are platform entry points
(HTTP, Slack, cron). Sessions run on Vercel Workflows —
[durable execution](/beliefs/glossary/durable-execution.md) by event-log replay
— with sandboxed compute, declarative human-approval gates (`needsApproval`),
OpenTelemetry tracing, and evals as defaults. The BEAM-native counterpart in
this brain's evaluations is [Jido](/beliefs/glossary/jido.md), a framework you
host yourself.

Its eval story is the exemplar of the continuous-automated model —
[regression testing](/beliefs/glossary/regression-testing.md) transplanted onto
agent behavior: scored rubric suites as files in the agent's own directory, run
locally, in CI as a deploy gate, and on a schedule against the deployed agent.
The harness-and-ledger analysis reads that shape as all-harness-no-ledger —
trend lines without [adjudication](/beliefs/glossary/adjudication.md) or lineage
records underneath, and an answer key living inside the directory the agent
itself reads.

*Seen in:* [2026-07-17 vercel-eve comparison thread](/meta/threads/2026-07-17-vercel-eve-comparison-and-jido-host-plan.md), [vercel-eve-comparison analysis](/meta/analysis/vercel-eve-comparison.md), https://vercel.com/blog/introducing-eve, [2026-07-20 evals and observation-records thread](/meta/threads/2026-07-20-evals-harness-ledger-and-observation-records.md), [harness-and-ledger analysis](/meta/analysis/harness-and-ledger-as-eval-infrastructure.md)
