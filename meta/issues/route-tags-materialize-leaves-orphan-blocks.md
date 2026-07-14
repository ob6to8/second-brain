---
type: issue
title: "route_tags: materialize cannot remove orphaned excerpt blocks"
description: Removing or re-pointing a route tag leaves the sink's now-orphaned excerpt block in place — mix brain.route_tags fails on it, but --materialize never deletes blocks, so the only fix is hand-editing a section the policy says never to hand-edit.
status: resolved
provenance: "Claude Code session, 2026-07-11 — top-down code review of the toolchain"
tags: [meta, issue, route-tagging, materialize, tooling]
timestamp: 2026-07-12
attribution:
  when: 2026-07-11T07:13:22+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
  from: [/meta/threads/2026-07-12-code-review-flows-hardening-and-elaborations.md]
---

# `route_tags`: materialize cannot remove orphaned excerpt blocks

## Resolution (2026-07-12)

Fixed by P1 of the
[code-review toolchain hardening plan](/meta/plans/code-review-toolchain-hardening.md):
`materialize/1` now projects the tags in both directions — it also visits every
sink that carries a log section but no longer appears among the feeding pairs
and removes the section, unconditionally (the design question below was settled
as *no flag*: the tags are the single source of truth and the PR diff is the
review point). Pinned by two scenario tests in
[capture_scenario_test.exs](/test/elixir_mind/capture_scenario_test.exs)
(full-orphan removal; a still-fed sink dropping one thread's stale block).

## Summary

`ElixirMind.RouteTags.materialize/1` regenerates the excerpt-log section of
every sink that **currently** has feeding threads — it groups the live
`feeding_pairs` by sink and rewrites those sections
([route_tags.ex](/lib/elixir_mind/route_tags.ex), `materialize/1`). A sink
that *used to* be fed but no longer is (a tag removed or re-pointed during a
capture correction, or its thread deleted) is simply not visited: its stale
section, or a stale per-thread block within a still-fed section, stays on
disk.

`run_checks/1` then correctly flags it — the `log fidelity` check reports
"block for `<slug>` but the thread no longer tags this sink" (an **orphan**)
and fails the task, CI, and the pre-commit hook. But the tool offers no way to
*fix* it: `--materialize` won't delete the block, and the section's own header
text says "never hand-edit". The only remedy today is exactly the hand-edit
the convention forbids.

Partial case: if the sink still has *other* feeding threads, `materialize`
rewrites the whole section from the current tags, which incidentally drops the
orphan block — the gap bites only when a sink loses its **last** feeding
thread (the whole section becomes an orphan and nothing regenerates or removes
it).

## Reproduce

1. In a thread under `meta/threads/`, delete (or re-point) the only
   `<routes ref="em:xxxxxx">` region feeding some sink.
2. `mix brain.route_tags --materialize` — the sink is untouched (no feeding
   pairs group to it).
3. `mix brain.route_tags` — `log fidelity` fails with the orphan message; no
   tool path clears it.

## Direction

`materialize/1` should also visit sinks that carry a log section but no longer
appear in `feeding_pairs`, and remove the section (or the individual orphaned
block) — making materialization a true projection of the current tags, in both
directions. One design question to settle: whether removing a *whole* section
should require a flag (it deletes visible content from a concept doc), or
whether "the log is generated, never hand-kept" already licenses it
unconditionally. Interacts with the
[route-tagging policy's](/meta/policy/route-tagging.md) freeze-on-resolution
rule: a frozen matter's log must not silently lose blocks — freezing is
editorial today, so the tool cannot distinguish a frozen sink from a stale one.
