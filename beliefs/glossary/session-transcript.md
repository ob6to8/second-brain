---
id: em:4b1d6d
type: concept
title: session transcript
description: The full raw record of a Claude Code session, stored server-side on claude.ai and addressable by a per-session URL; it survives the session's ephemeral sandbox but is account-bound, agent-unreadable, and deletable.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, claude-code, provenance, session]
sense: common
timestamp: 2026-07-19
attribution:
  when: 2026-07-19T15:27:08Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-19 session-URL-persistence thread"
---

# session transcript

The complete, undistilled conversation of a Claude Code session — every message,
tool call, and result. For a cloud (web) session it lives on Anthropic's servers,
not in the session's container, so it persists after the sandbox is reclaimed and
can be reviewed, shared, or resumed from claude.ai. A session reads its own id from
`CLAUDE_CODE_REMOTE_SESSION_ID`; converting that id's `cse_` prefix to `session_`
yields its transcript URL.

Its persistence is real but weaker than the repo's own records: the URL is
**account-bound** (viewable only by the logged-in operator, so an agent cannot fetch
it), **deletable**, and retention-limited. That is why it is captured as the
`session:` frontmatter key on a thread doc — a full-fidelity *escape hatch* beside
the durable `pr:` anchor, never a replacement for it. Distinct from a thread doc,
which is the *distilled* record produced by [session capture](/beliefs/glossary/session-capture.md);
the transcript is the raw source the distillation is drawn from.

*Seen in:* [2026-07-19 session-URL-persistence thread](/meta/threads/2026-07-19-session-url-persistence-and-plan-vs-capture-policy.md)
