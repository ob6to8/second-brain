---
type: policy
title: Persist plans
description: Any design or implementation plan the agent produces and the operator approves must be persisted as a type:plan doc under meta/plans/, not left in chat or the scratchpad.
section: filing
order: 7
status: active
tags: [meta, governance, plans, persistence]
timestamp: 2026-07-09
---
**Persist plans; don't leave them in the conversation.** A design spec or
implementation plan is a durable record of *decisions and their rationale* — the
shape of a change, the alternatives weighed, and the build order. That record must
survive the session that produced it. Chat scrolls off and the agent scratchpad is
session-isolated and reclaimed, so a plan that lives only there is lost the moment
the session ends.

- **When.** Whenever the operator approves a plan of any substance — a new
  subsystem, a genre or policy change, a multi-step build — persist it before
  acting on it. A throwaway one-liner is not a plan; a design worth a review pass
  is.
- **Where.** As a `type: plan` document under [`meta/plans/`](/meta/plans/index.md)
  (governance namespace — no `sb:` id, outside the identity registry, like
  `tutorials` and `threads`). Filename is a kebab-case slug of the title.
- **What it holds.** The problem, the decisions and their reasoning, the artifact
  shape, and the build order — plus any commissioned design review (e.g. a
  research spike) recorded with its verdict, so the *why-it's-shaped-this-way*
  travels with the plan. Deferred phases (things planned but not yet built) stay in
  the same doc under an explicit "deferred" heading until they graduate into their
  own plan when built.
- **Lifecycle.** A plan carries a `status` (`proposed` · `accepted` · `in-progress`
  · `done` · `superseded`). Done and superseded plans are kept, not deleted — the
  decision history is the point.
- **Reserved files.** After adding or updating a plan, update
  [`meta/plans/index.md`](/meta/plans/index.md), same as any filed document.
