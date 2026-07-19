---
type: policy
title: Plan ahead or capture after
description: A prospective plan doc is warranted only when work is deferred, cold-context, or a cross-session build order; work executed in-session needs no plan — its commit graph and thread capture are the durable record.
section: filing
order: 8
status: active
tags: [meta, governance, plans, threads, workflow, handoff]
timestamp: 2026-07-19
attribution:
  when: 2026-07-19T15:27:08Z
  channel: agent-authored
  agent: "Claude Code agent, session-transcript-persistence session"
  why: "operator asked for a policy capturing the plan-vs-thread decision matrix surfaced deciding whether the session-URL backfill needed a plan doc or could run inline"
---
**Two records of a change sit in different tenses.** A `type: plan`
([persist-plans](/meta/policy/persist-plans.md)) is **prospective** — decisions
and their rationale written *before* the work, so a session that lacks the
context can execute it. A thread doc
([session-capture](/meta/policy/session-capture.md)) is **retrospective** — the
frozen record of what a session *actually did*, produced at its close. The
commit graph ([merge-strategy](/meta/policy/merge-strategy.md)) is the third
layer: the durable *what-changed*, cited by SHA. Choosing between "persist a
plan" and "just do it" is choosing whether the work needs the prospective
artifact or whether the retrospective ones suffice.

**Default: execute in-session; the commit and the capture are the record.** When
this session holds the context and can finish the work, a plan doc is a
redundant third copy of decisions the commit message and thread render already
carry. Persisting one then is pure overhead, and worse, it *invites* a future
session to re-derive settled work.

**Escalate to a prospective plan when any of these hold:**

- **Deferred.** The work will not run in this session. Whatever context justified
  it goes cold the moment the session ends, so the decisions must be written down
  to survive — this is the core [persist-plans](/meta/policy/persist-plans.md)
  case.
- **Cold-context handoff.** The work will be executed by a *fresh* agent that
  does not share this session's reasoning. A plan is the context-transfer
  vehicle; without it the fresh agent restarts the thinking (and may re-land on a
  worse answer).
- **Cross-session build order.** The work is large enough to span sessions and
  needs an explicit sequence — a new subsystem, a genre or policy change, a
  multi-step migration — where the *order* itself is a decision worth recording.
- **Substantial standalone design.** The decisions and alternatives are weighty
  enough to deserve a first-class, queryable doc rather than being buried in a
  thread render, *even if* the work also runs now.

**The discriminator is context-transfer, not effort.** A mechanical task is not
plan-worthy merely because it touches many files, once its approach is decided
and validated in-session — hand a fresh agent a fully-solved task and the plan
adds nothing but a re-derivation risk. Conversely, a small but *deferred* or
*cold-handoff* decision is plan-worthy precisely because its context will not
survive. Ask "will the executor share this session's context?" — if yes, execute
and let the commit and capture record it; if no, persist the plan first.
