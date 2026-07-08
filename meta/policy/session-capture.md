---
type: policy
title: Session capture
description: The /capture skill renders a working session into a distilled thread doc under meta/threads/, on demand — substantive responses only, then a routing ledger and route tags.
section: session-workflow
order: 1
status: active
tags: [meta, governance, threads, capture, workflow]
timestamp: 2026-07-08
---
A working session (a **thread**) is non-linear: it touches many matters, pauses
some on open questions, and routes each matter's synthesized content into a
durable per-topic page. **`/capture`** freezes that session into a readable
record so it can be resumed from the record instead of from memory.

- **On demand, not a hook.** Capture is an agent-invoked skill you run once, at
  session close (or when you say "capture this") — never a per-turn hook. See
  `.claude/skills/capture/SKILL.md`.
- **A distilled render, not a verbatim archive.** For each assistant turn keep
  **only the substantive response** and drop the noise: reasoning, tool calls
  and results, and the short "let me check X" narration that precedes a tool
  batch (a text block under ~300 chars that is followed by a tool call). Longer
  blocks, and any block not followed by a tool (the turn's closing response),
  are kept; turns with no tool calls keep all their text. Drop system reminders
  and slash-command wrappers. `/capture` is the sole session-persistence skill:
  it distills rather than dumping a raw verbatim transcript.
- **The output is a thread doc** at `meta/threads/YYYY-MM-DD-<slug>.md`,
  `type: reference`, in the governance namespace (no `sb:` id). It carries, in
  order: frontmatter, a short narrative section (what the session was, where it
  landed), the **routing ledger** (`## Routing`), then the `## User`/`##
  Assistant` render body. Route tags are applied last, over the now-frozen body.
- **Freeze then tag.** Because capture runs once at close, the body is frozen
  when written; tagging and ledger upkeep are one finalization motion over that
  frozen body, not a per-turn rewrite.
