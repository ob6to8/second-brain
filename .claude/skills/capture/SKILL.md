---
name: capture
description: Render the current session into a distilled thread doc under meta/threads/ — substantive responses only (reasoning/tool-calls/narration stripped) — then a routing ledger and route tags over the frozen body. Use at session close, or when the operator says "capture this" / "capture the session".
---

# /capture — freeze a session into a distilled, routed thread doc

Turn the current working session into one **thread** record: a clean read of
what was actually said, a per-thread **routing ledger** of where each topic
went, and **route tags** that materialize each topic's excerpts into the
`concept` docs they feed.

This is **on-demand**, run **once at session close** (or when asked) — not a
per-turn hook. It is the brain's session-persistence skill: it **distills**
(substantive exchanges, tool-call noise stripped) and **routes**, rather than
dumping a raw verbatim transcript.

## File

- **Path**: `meta/threads/YYYY-MM-DD-<slug>.md` — date first (threads are
  time-ordered), then a kebab-case slug for what the session accomplished.
- **Type**: `reference`, governance namespace (`meta/`) — **no `sb:` id**; the
  registry and `mix brain.verify` ignore it. Threads are tag *sources*; the
  `concept` docs they route to (which carry `sb:` ids) are the sinks.
- **Update in place**: if this session already has a thread file, regenerate that
  same file — do not create a second one.

## Frontmatter

```yaml
type: reference
title: Thread — <descriptive name>
description: <one sentence: what the session covered and where it landed>
provenance: "Claude Code session (<model name(s)>), <date>; distilled render — substantive responses only, reasoning/tool calls/narration stripped"
tags: [meta, thread, <topic tags>]
timestamp: <ISO 8601 date>
```

## Build the doc, in this order

### 1. The render (keep/strip rules)

Render the conversation as `## User` / `## Assistant` sections. For **each
assistant turn keep only the substantive response** and drop the noise:

- Drop all reasoning/thinking, all tool calls, and all tool results.
- Drop short **pre-tool narration** — a text block **under ~300 chars that is
  followed by a tool call** ("Let me check X", "Now running…"). Keep longer
  pre-tool blocks (a real analysis given before the action) and **any block not
  followed by a tool** (the turn's closing response).
- A turn with **no tool calls** keeps all its text.
- Drop system reminders and slash-command wrappers (anything that reads as a
  `<…>`-prefixed system block).
- Operator messages are kept as said. If part of the conversation was summarized
  away and is no longer available, say so in an italic note — never invent
  dialogue.

Two ways to produce it: **render-from-context** (preferred — you hold the
conversation, so write the render applying the rules above), or **parse-the-log**
if a host session log is available (apply the same rules).

### 2. Narrative section

A short `## Where this landed` (or similar): one paragraph on what the session
was, and the settled outcomes — enough for a future reader to orient without
replaying the render.

### 3. Routing ledger

A `## Routing` table, per the routing-ledger policy — **pointers and states
only, never synthesized content**:

```
## Routing

| Topic | State | Routed to | Dangling |
|---|---|---|---|
| <one line> | open\|paused\|closed | [<concept>](/path/to/concept.md) or `unrouted` | <open question or -> |
```

One row per topic the session touched. `Routed to` links a `concept` doc by
bundle-absolute path (or `unrouted`). State (`open`/`paused`/`closed`) describes
the strand; routed-to describes dispatch — they are independent.

### 4. Route tags over the frozen body

Now that the render is frozen, mark each region that feeds a concept:

```
<routes ref="sb:4c9e1f lib/foo.ex">
... the paragraph(s), lifted whole ...
</routes>
```

- Ref a concept's **`sb:` id** (the aggregating sink — grep the target concept's
  frontmatter, or `meta/registry.md`, for its id). A **path** ref is an optional
  non-aggregating back-link (code/file) — it gets no log.
- Per-paragraph, multi-ref on one region; never nest; never cross a
  `## User`/`## Assistant` boundary. Tag whole — no trimming inside a region.
- Every concept a `## Routing` row routes to should be covered by at least one
  tag (the verifier warns otherwise).

### 5. Materialize the excerpt logs and verify

Each tagged concept carries a `## Thread excerpts — route-tagged log` section.
**Do not hand-write it** — generate it:

```
mix brain.route_tags --materialize   # writes each fed concept's log section from the tags
mix brain.route_tags                 # verify: wellformedness, refs, sink logs, fidelity
```

If a target concept has no log section yet, `--materialize` adds one. Re-run
after any tag edit so the log stays re-derivable.

## After writing

1. Update `meta/threads/index.md`: link + one-line description.
2. Append a dated entry to `meta/log.md` (and to the nearest `log.md` of any
   concept whose excerpt log changed).
3. Run the gates before committing: `./.githooks/pre-commit` (or at minimum
   `mix brain.contract --check && mix brain.registry --check && mix brain.verify
   && mix brain.route_tags && mix test`).
4. Commit (and push / open a PR only if the operator asked).

## Rules

- Never invent or embellish — distillation drops noise, it does not add content.
- The excerpt log is **append-only** and generated; let `--materialize` own it.
- A concept freezes excerpt acceptance when its matter resolves (per matter, not
  on archival) — do not append to a resolved matter's log.
