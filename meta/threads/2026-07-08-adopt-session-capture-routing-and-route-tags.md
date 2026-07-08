---
type: reference
title: Thread — adopt session capture, routing ledger, and route tags
description: The session that ported a session-capture skill, a per-thread routing ledger, and route-tagging (plus the mix brain.route_tags verifier) from the Composable Beliefs repo into this OKF bundle, adapting cb's flat slugs and belief ids to this bundle's sb: id model. Outcome: the /capture skill, three session-workflow policies, and the verifier wired into CI.
provenance: "Claude Code session (Claude Opus 4.8), 2026-07-08; distilled render — substantive responses only, reasoning/tool calls/narration stripped"
tags: [meta, thread, capture, routing, route-tagging, workflow]
timestamp: 2026-07-08
---

# Thread — adopt session capture, routing ledger, and route tags

Distilled render: substantive responses only. Reasoning, tool calls, and short
pre-tool narration are stripped; operator messages are kept as said. This is the
first worked example of the `/capture` workflow it documents.

## Where this landed

The session ported four things from the Composable Beliefs (`cb`) repo into this
bundle, at the OKF floor only (the belief DAG was out of scope): a **session
capture** skill, a per-thread **routing ledger**, the **concept-doc excerpt log**,
and **route tags** with an Elixir verifier. The one non-mechanical decision was
the mapping from cb's flat proto-belief slugs and `cb:bNNN` belief ids onto this
bundle's deep tree and `sb:` stable ids — resolved by making the **`sb:` id** the
aggregating route-tag ref and a **path** the non-aggregating back-link, and by
keeping threads under `meta/threads/` (governance) as tag *sources* while `concept`
docs are the sinks. Delivered: the `/capture` skill, three `session-workflow`
policies, `SecondBrain.RouteTags` + `mix brain.route_tags`, and CI wiring.

## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| Non-linear sessions and per-topic routing as a technique | closed | [routing non-linear work sessions](/SWE/agentic-coding/context-engineering/routing-non-linear-work-sessions.md) | - |
| OKF mapping & scope confirmation (brain.* not okf.*; no `thread` type) | closed | `unrouted` | - |
| Four adoption decisions (tag syntax, sink ref, thread home, ledger location) | closed | `unrouted` | - |
| Port of `route_tags.ex` → `mix brain.route_tags` | closed | `unrouted` | Verifier + skill code lives in the repo, not a concept |
| Backfill existing threads/concepts to the new convention | paused | `unrouted` | Operator to work backwards once the reference round trip is accepted |

## User

You are working in my second brain, which is an OKF bundle. Port a capability
from another repo of mine into this bundle, adapting it to OKF vocabulary:
session capture as a skill, a routing ledger, proto-belief documents (as OKF
`concept` docs), and route tags plus an Elixir verifier. The belief graph is out
of scope. Read the reference repo first and report the OKF mapping.

## Assistant

I read the reference reading list and this bundle's tooling. The mapping, adapted
to *this* bundle rather than cb's: a cb proto-belief document maps to an OKF
`concept` doc (already in the controlled vocabulary); a cb thread maps to a thread
doc under `meta/threads/`; a route-tag ref maps to a concept's stable `sb:` id or
a code path; and `mix cb.verify.route_tags` maps to a new `mix brain.route_tags`.

Two divergences from the task's assumptions surfaced. First, this bundle has **no
`mix okf.*` tasks** — everything is `mix brain.*`, so the port is
`mix brain.route_tags`, not `mix okf.route_tags`. Second, this bundle has **no
`thread` type**: threads live in `meta/threads/` typed `reference`, in the
governance namespace, outside the knowledge bundle. And where cb resolves refs by
flat slug because all its docs share one directory, this bundle spreads concepts
across a deep tree and gives each a stable `sb:` id — so the idiomatic aggregating
ref here is the `sb:` id, matching the contract's rule that typed edges reference
ids, not paths.

<routes ref="sb:d479e3 lib/second_brain/route_tags.ex">

The core idea being adopted is worth stating independently of the tooling: a
single working session is non-linear — it opens many matters, pauses some on open
questions, and routes each matter's synthesized content into a durable per-topic
page. Two mechanisms manage that. The **routing ledger** is a per-thread table of
pointers and states — never content — so the session is resumable from the table
instead of from memory; it stays a router, not a digest, precisely because
content is homed in the per-topic pages and only *pointed at* here. **Route tags**
then mark each region of the frozen session with the page(s) it feeds, and those
marks materialize an append-only, dated excerpt log into each page — making the
routing auditable, because what a page left out is now a visible tag boundary
rather than a hidden editorial cut. A verifier re-derives each log from the
current tags and fails on divergence, so the log is structural, not a copy someone
must remember to refresh.

</routes>

## User

All four recommended. (Tag syntax `<routes ref="...">` verbatim; sink ref is the
`sb:` id; threads in `meta/threads/` as `type: reference`; in-doc `## Routing`.)

## Assistant

Built in the suggested order. `SecondBrain.RouteTags` ports the five checks — tag
wellformedness, ref resolution, sink logs, log fidelity, and the ledger
cross-check (warn) — with `classify_ref/1` reduced to two kinds: `sb:` id (the
aggregating sink, resolved via the identity registry) and path (a back-link that
must exist but accretes no log). `derive_block/3` keeps cb's exact block format so
the log is re-derivable. `mix brain.route_tags` runs the checks (exiting non-zero
on failure, warnings non-fatal), and `--materialize` writes each fed concept's
log section from the tags so it is generated, not hand-kept. I also landed the
`/capture` skill, three `session-workflow` policies, and wired the task into CI
and the pre-commit hook beside `mix brain.verify`.
