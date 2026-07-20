---
type: plan
title: "Decision extraction at capture + a compiled decision graph over the brain's history"
description: Close the two gaps the decision-records analysis found — undistilled rationale for unrouted decisions and no connected lineage view — by minting per-decision records as a /capture step (statement, alternatives declined, distilled rationale, links) and compiling a CI-verified decision graph (mix brain.decisions) whose typed edges span doctrine → analysis → plan → PR, rendered as an expandable tree on the Pages site; a derived view in the route-tags mold, not a new authored history layer.
status: proposed
provenance: "Claude Code session (2026-07-20) — operator proposed the decision-tree view of development history and endorsed pursuing the differentiated shape recommended by the decision-records analysis ('Agree proceed'); design specifics below await ratification"
tags: [meta, plan, decision-records, decision-graph, session-capture, routing, derived-artifacts]
timestamp: 2026-07-20
attribution:
  when: 2026-07-20T21:05:00Z
  channel: agent-authored
  agent: "Claude Code agent, decision-tree-dev-history session"
  why: "persist the ratified direction and its design shape so a future session can execute it; graduated from the decision-records-as-history-abstraction analysis"
  from: [/meta/threads/2026-07-20-decision-records-as-history-abstraction.md]
---

# Plan — decision extraction at capture + a compiled decision graph

**Status:** `proposed`. The *direction* was operator-endorsed 2026-07-20 (the
analysis's recommendation, verbatim); the design specifics below — the record
shape, edge vocabulary, and storage location — are this plan's proposal and
await ratification before build. Grounding:
[decision-records as an abstraction over development history](/meta/analysis/decision-records-as-history-abstraction.md).

## Problem

The bundle's development history reduces, as the operator observed, to a series
of decisions — but that series is not abstracted anywhere. Routed decisions get
distilled rationale in plans/analyses; **unrouted decisions** (the majority of
routing-ledger rows in sampled threads) leave their why only in verbatim thread
prose; and no artifact connects doctrine → analysis → plan → PR → commit as one
navigable structure. An agent answering "why is X designed this way" must parse
raw threads and walk git history; the operator has no surface that shows the
brain's evolution *as decisions*, including the shape-affecting choices agents
made and the operator ratified only implicitly.

## The shape

Three coupled pieces, in the bundle's established derived-artifact mold:

1. **Decision minting at capture time.** `/capture` gains a step: after writing
   the routing ledger, extract the session's *decisions* — each as a small
   record carrying:
   - **statement** — the decision, one line;
   - **declined** — the alternatives considered and not taken (may be empty);
   - **rationale** — 2–4 sentences, distilled at the moment the reasoning is
     freshest;
   - **links** — the thread doc (anchor into the frozen body), the routed-to
     document if the strand was routed, and later the `pr:` (stamped by
     `/create-pull-request` in the same motion that stamps the thread).
   Decisions whose rationale already lives in a plan/analysis **point there**
   instead of duplicating it — the record carries distilled rationale only for
   what would otherwise be unrouted (anti-fragmentation).

2. **Typed edges make it a graph.** Each decision may reference:
   - `implements` — the doctrine (or policy) it serves;
   - `supersedes` — an earlier decision it reverses or replaces (the ADR
     supersession chain);
   - `refines` — a broader decision it narrows.
   Edges key on stable ids / decision keys, per the existing typed-edge rule
   (ids, not phrases, so cross-thread joins are exact).

3. **The compiled view.** `mix brain.decisions` materializes the graph:
   - a generated `meta/decisions.md` (or per-era pages) — the decision tree
     rooted in doctrine, one expandable node per decision, newest-first within
     branches;
   - each node expands to its rationale, and one more click reaches the
     verbatim excerpt via the thread anchor (the route-tag machinery's
     existing lift);
   - a `--check` mode wired into CI and the pre-commit hook beside
     `mix brain.route_tags`, so the view is structurally fresh — never a
     hand-kept log (the retire-hand-kept-logs lesson);
   - a Pages rendering, since the site is the operator's reading surface.

## Why this shape (decisions already made)

- **Derived view, not a new `type`.** A third authored history layer would
  collide with `plan` (already defined as the decision record for intended
  work) and the commit graph (the mechanical narrative). Compiling from
  capture-time records follows `CLAUDE.md`/`registry.md`/`dev-history.md`/route-tag
  precedent and survives the anti-fragmentation rule.
- **Capture-time, not post-hoc.** The TOSEM measurement (precision ~0.27 on
  post-hoc rationale recovery) makes reconstruction unreliable; minting at the
  moment of decision costs the agent almost nothing (it just distilled the
  session for the ledger anyway) and inverts the classic capture problem.
- **Small linked records, not aggregated prose.** The 3–5-record neighborhood
  result and the structured-agent-memory literature both favor exactly this
  retrieval shape for agent consumption.
- **Asserted, ratifiable.** Agent-distilled rationale is treated like any agent
  statement — asserted until the operator's editorial pass; the graph is an
  audit surface, not a source of truth that bypasses ratification.

## Open questions (operator input wanted)

1. **Where do decision records live?** (a) a `## Decisions` section inside the
   thread doc, beside `## Routing` (zero new files; graph compiled by scanning
   threads); (b) one small file per decision under `meta/decisions/`
   (governance namespace, no `em:` id); (c) frontmatter entries. Leaning:
   **(a)** — the decision is part of the session record, and the compiled view
   is the cross-thread join, mirroring how route tags live in threads and
   materialize into sinks.
2. **Retroactive extraction?** Should a one-time backfill mine the ~40 existing
   frozen threads for decisions (agent-proposed, operator-ratified in batches),
   or does the graph start from adoption day? Backfill quality is bounded by
   the post-hoc precision problem the analysis documents.
3. **Granularity rule.** What counts as a decision worth minting — proposal:
   anything the ledger would call a settled strand (a ratification, a declined
   alternative, a chosen design) but not mechanical choices with no considered
   alternative.
4. **Does the routing ledger absorb this instead?** A leaner variant adds a
   Decision column to the existing ledger rather than a new section. Declined
   in the proposal above (the ledger is deliberately pointers-only; rationale
   would break its router-never-digest contract) but recorded as the
   alternative.

## Scope boundary — what this does NOT touch

- No change to `/capture`'s verbatim-body contract, the ledger's four columns,
  or route-tag mechanics.
- No new controlled `type`; no `em:` ids on decision records.
- No confidence scores on decisions (consistent with the belief-layer plan's
  boundary).
- The graph never becomes the canonical home of rationale that belongs in a
  plan/analysis — it points.

## Build order (once ratified)

1. Ratify the open questions; amend the session-capture policy (+ this plan →
   `accepted`).
2. `/capture` skill: add the decision-minting step and the record format.
3. `ElixirMind.Decisions` + `mix brain.decisions` (materialize + `--check`),
   tests, CI + pre-commit wiring, Pages rendering.
4. Optional backfill pass per Q2's answer.
