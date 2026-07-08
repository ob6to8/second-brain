---
type: note
title: Verification flow — session capture, routing & route tags
description: How to drive one thread through /capture → routing ledger → route tags → excerpt log and confirm it ran correctly — who does what (operator invokes and ratifies; the agent executes every mechanical step), the gate suite, a check-by-check pass/fail table, and the editorial spot-checks the machine can't judge.
tags: [meta, governance, verification, capture, routing, route-tagging, workflow]
timestamp: 2026-07-09
---

# Verification flow — session capture, routing & route tags

A walkthrough for driving one thread through the capture / routing-ledger /
route-tagging flow and confirming it executed correctly. Companion to the
end-to-end guide [`meta/session-workflow.md`](/meta/session-workflow.md) (the
*why*) and the [`/capture` skill](/.claude/skills/capture/SKILL.md) (the agent's
step-by-step *procedure*). This page is the *did it work?* checklist.

## Who does what

The flow is **agent-executed**. The operator invokes and ratifies; the agent
performs every mechanical step — the [skill](/.claude/skills/capture/SKILL.md)
assigns all of its steps 1–5 to the agent.

| Actor | Does |
|-------|------|
| **Operator** | invokes `/capture` (and `/intake` first, if raw material must be filed); answers ratification questions — a **new top-level directory** or a **new `type`** need operator sign-off (contract §2 and §4); reviews the result |
| **Agent** | writes the distilled render; drafts the `## Routing` ledger; creates/updates the `concept` sinks and mints their ids (`mix brain.id`); tags the frozen body; runs `mix brain.route_tags --materialize`; runs the gates |

So the operator's hands-on part is short: **invoke, ratify any shape change,
review.** Everything under "The flow" below is the agent's.

## The flow (agent actions)

Resume the session so the agent holds the conversation, confirm `main` is merged
in, then invoke **`/capture`**. The agent then, per the skill:

1. **Renders** the distilled `## User`/`## Assistant` body — keeps every exchange,
   dropping only tool calls/results, reasoning, and short pre-tool narration
   (a block *both* `< ~300` chars *and* followed by a tool call).
2. Writes **frontmatter** + a short **narrative** section.
3. Drafts the **`## Routing` ledger** — one row per topic, pointers and states
   only.
4. **Routes each topic** — creates or updates the target `concept` doc and mints
   its `sb:` id. Filing into an existing domain is autonomous; a **new top-level
   directory or a new `type`** is a shape change the agent **proposes to the
   operator** and waits on.
5. **Tags the frozen body** with each concept's `sb:` id (plus optional path
   back-links), then runs `mix brain.route_tags --materialize` to write the
   excerpt logs.

## Verify

Run the gate suite (or just `./.githooks/pre-commit`, which mirrors CI):

```
mix format --check-formatted
mix compile --warnings-as-errors
mix brain.contract --check      # only relevant if policies changed
mix brain.registry --check      # must pass if new concept ids were minted
mix brain.verify                # ids, edges, grounding
mix brain.route_tags            # the 5 route-tag checks
mix test
```

**`mix brain.route_tags` is the primary oracle.** It prints all five checks; a
`:fail` fails the task, a `:warn` never does:

| Check | Level | Green means | If red |
|-------|-------|-------------|--------|
| **tag wellformedness** | fail | tags balanced, not nested, don't cross a `## User`/`## Assistant` boundary, non-empty refs, outside fenced code | fix the offending tag region |
| **ref resolution** | fail | every `sb:` id resolves to a concept, every path to a real file | mint the id / fix the path (or the concept doesn't exist yet) |
| **sink logs** | fail | every tagged concept has a dated block for this thread | run `mix brain.route_tags --materialize` |
| **log fidelity** | fail | each excerpt log **matches** its re-derivation from the tags | you edited a tagged paragraph without re-materializing → re-run `--materialize` |
| **ledger cross-check** | warn | every concept-routed ledger row is covered by ≥1 tag | a row points at a concept nothing tags — add a tag, or accept the warn |

Then **eyeball the three editorial things** the machine can't fully judge:

- **Ledger is pointers-only.** The `## Routing` cells hold links + states, never
  copied synthesized content (that lives in the concept).
- **Each concept picked up its block.** Open a routed-to concept and confirm its
  `## Thread excerpts — route-tagged log` now has a `### <thread-slug> (<date>)`
  block lifting the tagged regions.
- **Coverage.** Did every paragraph that genuinely feeds a matter get tagged?
  This is the one axis with no mechanical check — the ledger cross-check only
  catches whole *rows* with zero tags, and only warns.

## Gotchas

- **Context completeness.** `/capture` renders from the agent's live context; a
  long thread that was summarized/compacted yields a partial render (the skill
  flags gaps honestly rather than inventing dialogue). If the host `.jsonl`
  session log is available, the parse-the-log path is more complete.
- **Append-only + freeze.** Don't hand-edit a log block (let `--materialize` own
  it), and don't append to a concept whose matter is already resolved/frozen
  (freeze is per matter, not on archival).

## Reference instance

The green worked example to diff against: thread
[`2026-07-08-adopt-session-capture-routing-and-route-tags`](/meta/threads/2026-07-08-adopt-session-capture-routing-and-route-tags.md)
↔ concept `sb:d479e3`
([routing non-linear work sessions](/SWE/agentic-coding/context-engineering/routing-non-linear-work-sessions.md)).
Read them side by side to see the tag → log round trip you are reproducing.
