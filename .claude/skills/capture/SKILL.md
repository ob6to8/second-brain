---
name: capture
description: Render the current session into a thread doc under meta/threads/ — keep every retained exchange verbatim, dropping only tool calls, reasoning, and short pre-tool narration — then a routing ledger and route tags over the frozen body. Use at session close, or when the operator says "capture this" / "capture the session".
---

# /capture — freeze a session into a verbatim, routed thread doc

Turn the current working session into one **thread** record: a clean read of
what was actually said, a per-thread **routing ledger** of where each topic
went, and **route tags** that materialize each topic's excerpts into the
`concept` docs they feed.

This is **on-demand**, run **once at session close** (or when asked) — not a
per-turn hook. It is the brain's session-persistence skill: it keeps substantive
exchanges **verbatim** (only tool-call noise stripped) and **routes** — it strips
noise, it does not summarize what it keeps.

## File

- **Path**: `meta/threads/YYYY-MM-DD-<slug>.md` — date first (threads are
  time-ordered), then a kebab-case slug for what the session accomplished.
- **Title = the filename stem.** The frontmatter `title` (and the body `# H1`)
  is exactly the filename without `.md` — e.g. `2026-07-09-flows-genre-and-scenario-testing`:
  date-prefixed kebab-case, **no `Thread` prefix, no em-dashes, no spaces**.
- **Type**: `reference`, governance namespace (`meta/`) — **no `sb:` id**; the
  registry and `mix brain.verify` ignore it. Threads are tag *sources*; the
  `concept` docs they route to (which carry `sb:` ids) are the sinks.
- **Update in place**: if this session already has a thread file, regenerate that
  same file — do not create a second one.

## Frontmatter

```yaml
type: reference
title: <YYYY-MM-DD-kebab-slug>   # = filename stem; no "Thread", no em-dashes, no spaces
description: <one sentence: what the session covered and where it landed>
provenance: "Claude Code session (<model name(s)>), <date>; verbatim retained messages — tool calls, tool results, reasoning, and short pre-tool narration stripped"
tags: [meta, thread, <topic tags>]
timestamp: <ISO 8601 date>
```

## Build the doc, in this order

### 1. The render (keep/strip rules)

Render the conversation as `## User` / `## Assistant` sections. **Keep every
exchange** — operator messages and assistant responses — and drop *only* the
noise, reproducing **everything kept verbatim** (the delivered text, never
summarized or paraphrased). There are exactly three drops:

- **Tool calls and tool results** — always dropped.
- **Reasoning / thinking blocks** — always dropped.
- **Short pre-tool narration** — an assistant text block that is *both* under
  ~300 chars *and* followed by a tool call later in the same turn ("Let me check
  X", "Now running…"). This is the *only* text drop, and it fires only on that
  conjunction.

Everything else is kept: any block **≥ ~300 chars** (even mid-turn, before a
tool call); any block **in isolation** — nothing after it in the turn calls a
tool, e.g. the turn's closing reply or a standalone short remark — **even when
short**; and **all** text in a turn that makes no tool calls. Operator messages
are kept as said, dropping only empty ones and `<…>`-prefixed system reminders /
slash-command wrappers. If part of the conversation was summarized away and is no
longer available, say so in an italic note — never invent dialogue.

This is the exact rule from Composable Beliefs' `transcript_hook.py` (a block is
dropped iff `len(strip) < 300 and followed_by_tool`), so a short statement is
dropped *only* as a pre-tool lead-in — never in isolation.

Two ways to produce it. **Parse-the-log** is the most faithful when a host
session log is available (e.g. `~/.claude/projects/<project>/<session>.jsonl`):
extract the verbatim text blocks and apply the drop rule mechanically, so the
retained text is exact. **Render-from-context** otherwise — you hold the
conversation, so reproduce the delivered text verbatim; never paraphrase from
memory.

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

- Never invent, embellish, or summarize — retained operator messages and agent
  responses are reproduced **verbatim**; dropping noise is the only editing, and
  it neither adds nor condenses what remains.
- The excerpt log is **append-only** and generated; let `--materialize` own it.
- A concept freezes excerpt acceptance when its matter resolves (per matter, not
  on archival) — do not append to a resolved matter's log.

## See also

[meta/flows/session-capture.md](/meta/flows/session-capture.md) — the end-to-end
flow (pipeline, data model, touch-sequence, actor boundaries, gate suite, and the
scenario test), for the *why* behind this procedure.
