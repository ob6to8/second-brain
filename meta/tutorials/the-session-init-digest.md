---
type: tutorial
title: The session-init digest — how open work finds a fresh session
description: How mix brain.session_init compiles the brain's open work (issues, todos, active plans, dangling ledger strands) into a digest injected at session start via the SessionStart hook, how the heuristic top-3 ranking and its class weights work, the operator's priority escape hatch, and why the script ranks but the agent judges.
tags: [meta, tooling, elixir, session-init, digest, priorities, hooks, workflow]
timestamp: 2026-07-12
---

# The session-init digest — how open work finds a fresh session

Every fresh agent session starts blind: it has the contract and whatever the
operator types, but no memory of the issue left open on Tuesday or the plan
ratified but never started. The brain's answer is **`mix brain.session_init`**
([`SecondBrain.SessionInit`](/lib/second_brain/session_init.ex)) — a
point-in-time scan of open work, rendered as markdown and injected into the
session's opening context by the SessionStart hook. Nothing about it is stored;
it is recomputed from the live tree on every session start, so it can never go
stale the way a hand-kept "current status" page would.

## The four sources — all already maintained by policy

The digest invents no bookkeeping. It reads exactly the surfaces that existing
policies already require to be kept current, which is what makes it free:

1. **Open issues** — `meta/issues/*.md` with `status: open`.
2. **Open todos** — `meta/todos/*.md` with `status: open`.
3. **Active plans** — `meta/plans/*.md` with `status` in
   `proposed` / `accepted` / `in-progress` (done and superseded plans are
   history, not work).
4. **Dangling strands** — rows in the `## Routing` ledger of every thread doc
   under `meta/threads/` whose state is `open`/`paused`, **or** whose Dangling
   column carries a question. That second clause matters: a `closed` strand can
   still leave deferred work dangling ("resolved, but the operator still owes a
   decision on X"), and the digest refuses to let a closed checkbox hide it.

Each source list is sorted newest first. The scanner is a tolerant consumer per
[OKF conformance](/meta/policy/okf-conformance.md): an unparseable file or a
malformed ledger row is skipped, never fatal — a broken thread doc must not be
able to take down every future session's startup.

A fifth section appears only when non-empty: the **docs-freshness warnings**
from `SecondBrain.Links` (unresolved internal links, index-coverage gaps).
These warnings also print in `mix brain.verify` output and CI logs, but an
operator working purely in the Claude app never reads either surface — the
digest is what actually reaches them, relayed by the session agent. A clean
tree omits the section entirely, so the digest carries no permanent noise.

## The heuristic top-3 — the script ranks, the agent judges

The digest ends with a ranked top-3, computed from fixed class weights
(lower = more urgent):

| Weight | Class | Rationale |
|--------|-------|-----------|
| 0 | open issue | tracked problems outrank new work |
| 1 | plan `in-progress` | finish what is started |
| 2 | open todo | an explicitly recorded task |
| 3 | plan `accepted` | ratified, awaiting execution |
| 4 | strand `open` | live work left unrouted or unresolved |
| 5 | strand `paused` | blocked on a dangling question |
| 6 | strand `closed`-but-dangling | deferred work left behind |
| 7 | plan `proposed` | awaiting the operator's decision, not the agent's |

Two refinements keep the ranking honest:

- **Recency breaks ties.** Each source list arrives newest-first and the sort
  is stable, so within a class newer items outrank older ones with no extra
  bookkeeping.
- **Strand↔doc dedup.** A ledger strand whose *Routed to* column points at a
  doc already picked (say, the plan in slot 2) is the **same matter** seen from
  two surfaces; the reducer skips it rather than letting one piece of work
  occupy two of the three slots.

The digest closes with an agent note asking the session agent to open with its
*own* top-3 appraisal, using the heuristic as a starting point. This division
is deliberate: the script's ranking is deterministic and cheap but ignorant of
semantics (it cannot know that today's operator request makes strand #4 moot);
the agent's judgment is informed but unanchored without a baseline. The script
ranks, the agent judges — same shape as the route-tag verifier owning log
fidelity while coverage stays editorial.

## The escape hatch — `priority:` frontmatter

When the class weights get it wrong, the operator overrides them: an issue,
todo, or plan may carry an integer `priority:` frontmatter key (1 = most
urgent). Flagged items rank **above every heuristic class**, ordered among
themselves by the integer. Strands cannot be flagged — they are ledger rows
with no frontmatter of their own; flag the doc the strand routes to instead.

## Where it runs

The SessionStart hook runs `mix brain.session_init` and echoes its output into
the fresh session's context — the same hook that installs Elixir in
Claude-on-web sandboxes (see
[why the toolchain runs offline](/meta/tutorials/why-the-toolchain-runs-offline.md);
the digest, like every `mix brain.*` task, needs no network). It can also be
run by hand mid-session for a fresh look at the open-work state.

## Why this exists — the anti-drift angle

The [field-comparison analysis](/meta/analysis/comparison-with-the-2026-second-brain-field.md)
names *invisible degradation* as a root cause of second-brain death: nothing
announces that work fell through a crack until retrieval visibly fails. Open
issues, accepted-but-unstarted plans, and dangling ledger questions are exactly
the items that die of silence between sessions. The digest converts "remember
to check what's open" from a discipline into a structural property of session
start — the same procedural→structural move the gate suite makes for bundle
validity. It is a *reader*, not a gate: it enforces nothing, changes no files,
and costs one scan per session.
