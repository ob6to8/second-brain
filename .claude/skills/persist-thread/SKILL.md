---
name: persist-thread
description: Archive the current operator–agent conversation into meta/threads/ as a date-prefixed markdown record — exchanges only, verbatim, no tool calls. Use when the operator asks to save, persist, or archive this thread/conversation/session.
---

# /persist-thread — archive the current conversation

Save the current session's conversation as a thread record under `meta/threads/`.
Threads are part of the governance namespace (`meta/`), **not** the knowledge
bundle — no stable `sb:` id is minted, and the registry/verifier ignore them.

## File

- **Path**: `meta/threads/YYYY-MM-DD-<descriptive-slug>.md` — date first (threads
  are inherently time-ordered, so the date prefix is correct per the filing
  conventions), then a kebab-case slug describing what the thread accomplished.
- **Update in place**: if this session already has a thread file (from an earlier
  `/persist-thread` in the same conversation), extend/regenerate that same file —
  do not create a second archive for one session.

## Frontmatter

```yaml
type: reference
title: Thread — <descriptive name>
description: <one sentence: what the conversation covered/accomplished>
provenance: "Claude Code session (<model name(s)>), <date>; operator messages and agent responses verbatim; tool calls, tool outputs, and brief in-progress status notes omitted"
tags: [meta, thread, <topic tags>]
timestamp: <ISO 8601 date>
```

## Content rules

1. **Exchanges only, verbatim.**
   - Operator messages: **verbatim**, including typos.
   - Agent responses: **verbatim** — the actual delivered text of each turn, not
     summaries or paraphrases. Preserve markdown structure (tables, code blocks,
     headings) exactly.
2. **Omit entirely**: tool calls, tool outputs/results, and brief between-tool
   status notes ("Now running…", "Let me check…"). System/webhook events that
   drove a turn get a one-line italic stage note, e.g. *(Webhook: PR #1 merged.)*
3. **When a turn's displayed text came in parts** (an up-front analysis, then a
   closing summary after implementation), include **both**, in order, separated
   by a stage note like *(after implementation)*.
4. **Interactive question cards** (AskUserQuestion) aren't full messages: compress
   to an italic note giving the question and the operator's answer, e.g.
   *(Scope question: … Operator answered: **"Move literally everything."**)*
5. **Turn headings**: number every exchange sequentially with a short descriptive
   title — `## 3 — Ratify defaults; oversized links`. Separate exchanges with
   `---`. Mid-turn operator interjections ("Proceed", "Commit before proceeding")
   stay inside the exchange as an italic note rather than getting their own number.
6. Open the body with a short preamble stating the verbatim/omission rules, so a
   future reader knows exactly what the record does and doesn't contain.

## After writing

1. Add/update the entry in `meta/threads/index.md` (create it if missing): link +
   one-line description.
2. Append a dated entry to `meta/log.md`.
3. Run the gates before committing: `./.githooks/pre-commit` (or at minimum
   `mix brain.contract --check && mix brain.registry --check && mix brain.verify
   && mix test`). Threads carry frontmatter but live outside the bundle, so no
   `mix brain.id` / registry changes are expected — if the verifier complains, the
   file is in the wrong place.
4. Commit (and push / open a PR only if the operator asked).

## Rules

- Never invent or embellish content — if part of the conversation is no longer
  available (e.g. summarized away), say so honestly in a stage note rather than
  reconstructing dialogue that wasn't there.
- The record is append/extend-only across a session: regenerating it to improve
  fidelity is fine; silently dropping earlier exchanges is not.
