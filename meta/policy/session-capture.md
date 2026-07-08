---
type: policy
title: Session capture
description: The /capture skill renders a working session into a distilled thread doc under meta/threads/, on demand — every exchange kept minus tool-call noise and short pre-tool narration, then a routing ledger and route tags.
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
- **A distilled render, not a verbatim dump.** Keep **every exchange** and drop
  *only*: tool calls and results; reasoning/thinking; and an assistant text block
  that is *both* under ~300 chars *and* followed by a tool call (short pre-tool
  narration). Everything else is kept — any longer block, any block *in isolation*
  (nothing after it in the turn calls a tool: a closing reply or standalone remark)
  **even when short**, and all text in a tool-less turn. Operator messages are kept
  as said, minus empty ones and `<…>`-prefixed system/slash wrappers. The drop rule
  is exactly cb `transcript_hook.py`'s `len < 300 and followed_by_tool`. `/capture`
  is the sole session-persistence skill: it distills rather than dumping a raw
  transcript.
- **The output is a thread doc** at `meta/threads/YYYY-MM-DD-<slug>.md`,
  `type: reference`, in the governance namespace (no `sb:` id). It carries, in
  order: frontmatter, a short narrative section (what the session was, where it
  landed), the **routing ledger** (`## Routing`), then the `## User`/`##
  Assistant` render body. Route tags are applied last, over the now-frozen body.
- **Freeze then tag.** Because capture runs once at close, the body is frozen
  when written; tagging and ledger upkeep are one finalization motion over that
  frozen body, not a per-turn rewrite.
