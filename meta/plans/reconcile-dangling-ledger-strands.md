---
type: plan
title: "Reconcile dangling routing-ledger strands into tracked work"
description: A sweep that reviews every pending routing-ledger strand across meta/threads and reconciles each into a first-class todo/plan/issue or an explicit close — closing the gap where deferred work lives only inside frozen thread bodies and recurs forever in /priorities without ever being promoted or retired.
status: proposed
provenance: "Claude Code session, 2026-07-13 — operator asked, after noticing two offered intakes tracked only as paused ledger strands, for a plan to scan all routing ledgers for danglers needing promotion to todos/plans"
attribution:
  when: 2026-07-13T00:00:00Z
  channel: agent-authored
  agent: "Claude Code agent, dangling-strand reconciliation session"
  why: "persists the design for reconciling routing-ledger danglers into tracked work per the persist-plans policy, so the freezing question and tool shape survive the session"
  from: [/meta/threads/2026-07-13-track-intake-todos-and-strand-reconciliation-plan.md]
tags: [meta, plan, tooling, routing-ledger, priorities, provenance]
timestamp: 2026-07-13
---

# Reconcile dangling routing-ledger strands into tracked work

## Problem

A captured thread's [`## Routing` ledger](/meta/policy/routing-ledger.md) records
one row per topic with a `State` (`open`/`paused`/`closed`) and a `Dangling`
question. Rows that are `open`/`paused`, or `closed` with a leftover `Dangling`
cell, are **deferred work that lives only inside a frozen thread body**.

`ElixirMind.SessionInit` (surfaced by [`/priorities`](/.claude/skills/priorities/SKILL.md))
already *scans* for these — `dangling_strands/1` collects pending rows across
`meta/threads/*.md` and folds them into the priority ranking. But scanning is
not reconciliation. There is no step that, for each strand, decides *this
becomes a todo / a plan / an issue, or is closed* — so a strand:

- **recurs forever** in every `/priorities` run until someone happens to act on
  it, with no memory that it was already considered; and
- **is still losable** — the work is a row buried in one thread's ledger, not a
  first-class item in `meta/todos/` or `meta/plans/`. This session is the proof:
  two offered intakes sat as `paused` strands and were nearly dropped until the
  operator asked where they were tracked.

The two surfaces — thread ledgers (where deferred work is *born*) and
todos/plans/issues (where open work is *tracked*) — never converge.

## The core design tension: freezing vs. state mutation

The [session-capture policy](/meta/policy/session-capture.md) freezes a thread
body at capture; the [route-tagging policy](/meta/policy/route-tagging.md) treats
the frozen body as an auditable record. So the plan must resolve: **when a
strand is promoted to a todo, may its ledger `State` be flipped `open` →
`closed` in the already-captured thread, or is the thread immutable?**

Two candidate answers, to be ratified before building:

1. **Reconciliation edit (mutate the ledger).** Permit a *narrow* post-capture
   edit to the `State`/`Dangling` cells of a ledger row — not the body prose —
   when a strand is promoted or resolved, leaving a pointer to where it went.
   Pro: the ledger stays truthful; `/priorities` stops re-surfacing it. Con: it
   dents the freeze invariant and needs the route-tag verifier to tolerate
   ledger-only edits.
2. **Dedup by back-link (leave the thread frozen).** Never touch the thread;
   instead teach `dangling_strands/1` to treat a strand as resolved when a
   `todo`/`plan`/`issue` carries an `attribution.from` back to that thread
   *and* names the strand. Pro: respects freezing, reuses the
   [attribution](/meta/policy/resource-attribution.md) `from` edge. Con: needs
   per-strand identity (a thread has many strands; `from` is thread-granular),
   so it likely needs a strand anchor (e.g. a slug/ordinal per row).

The freezing question is the plan's central open question; the tool shape below
is deliberately agnostic to which answer wins.

## The shape of the change

1. **`mix brain.strands`** (`ElixirMind.Strands`, factoring the existing
   `SessionInit.dangling_strands/1`): list every pending strand across
   `meta/threads/*.md` — thread, topic, state, routed-to, dangling — and, for
   each, its **reconciliation status**: already promoted (a todo/plan/issue
   back-links it) vs. un-promoted. Read-only; the reconciliation *decision*
   stays an agent+operator judgment, not an automated file-writer.
2. **A reconciliation motion**, documented as the disposition step: for each
   un-promoted strand, either `/todo create …` / file a plan or issue (with
   `attribution.from` citing the source thread), or mark it closed per the
   ratified freezing answer. Mirrors the branch-triage todo's "each ends
   merged, superseded, or explicitly retired — none left in limbo" discipline.
3. **`/priorities` integration**: once resolution is representable (either
   answer above), `dangling_strands/1` filters out reconciled strands, so the
   digest shows only genuinely-pending work and the list monotonically shrinks
   as strands are dispositioned.

## Scope boundaries (explicitly out)

- **No auto-promotion.** The tool reports and the agent/operator disposition;
  it never files todos/plans on its own — "is this strand real open work or
  session chatter" is a judgment call, like intake dedup.
- **No new gate.** This is an on-demand review sweep, not a CI check. A strand
  left un-reconciled is a warning at most, never a build failure (coverage of
  deferred work has no mechanical oracle, same as route-tag coverage).
- **Not a `/priorities` rewrite.** `/priorities` keeps its role; this factors
  out and extends the strand-scanning it already does.

## Open questions (resolve before building)

- **The freezing answer** (§ core tension) — mutate the ledger cell, or dedup by
  back-link? Everything else depends on it.
- **Strand identity** — if dedup-by-back-link wins, strands need a stable
  per-row anchor so a `from` edge can name *which* strand it discharges.
- **Retroactive sweep** — a one-time pass over all existing thread ledgers to
  reconcile the backlog, or only forward from adoption?

## Build order (after the freezing question is ratified)

1. Ratify the freezing answer and, if needed, the strand-anchor convention.
2. Factor `dangling_strands/1` into `ElixirMind.Strands`; add `mix brain.strands`
   with the reconciliation-status column.
3. Wire the resolution representation into `SessionInit` so reconciled strands
   drop out of `/priorities`.
4. Run the retroactive sweep (if ratified), dispositioning the current backlog —
   starting with this session's two intake todos as the worked example.
