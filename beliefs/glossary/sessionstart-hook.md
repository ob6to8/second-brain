---
id: em:71f38a
type: concept
title: SessionStart hook
description: A hook that runs automatically at the start of an agent/CLI session to provision or validate the environment — and, via its stdout, brief the agent — before the user interacts.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, claude-code, tooling, ci]
sense: common
timestamp: 2026-07-12
attribution:
  when: 2026-07-11T08:41:24+02:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# SessionStart hook

A hook that runs a script at the start of every session to provision or warm the environment — install a toolchain, prime a build cache, check tool availability — so later commands "just work" in a fresh, ephemeral sandbox. It may run synchronously (blocking session start) or asynchronously. Beyond provisioning, its stdout is injected into the session's context, so it can also brief the agent — e.g. emit a [session-init digest](/beliefs/glossary/session-init-digest.md) of open work.

*Seen in:* [2026-07-05 OKF bootstrap thread](/meta/threads/2026-07-05-greenfield-okf-bootstrap-and-verification-layer.md), [2026-07-09 GitHub Pages thread](/meta/threads/2026-07-09-github-pages-knowledge-base-site.md), [2026-07-11 session-init thread](/meta/threads/2026-07-11-session-init-digest-and-priorities.md), [2026-07-12 priorities-skill thread](/meta/threads/2026-07-12-priorities-skill-and-persistence-listers.md)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:71f38a">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-12-priorities-skill-and-persistence-listers (2026-07-12)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:71f38a`]**  (co-feeds: `.claude/hooks/session-start.sh`)

**The hook** — one caveat worth flagging: you said "delete the hook," but the SessionStart hook did *two* jobs — emit the digest *and* install/warm Elixir in remote (Claude-on-web) sandboxes. That toolchain bootstrap is what makes `mix brain.*` — including the new `/priorities` skill itself — work at all in a fresh remote session. Deleting it entirely would break the very skill I was building. So I **removed the digest emission** (the "priorities work" is now skill-only, as you wanted) and **kept the toolchain bootstrap**, with a one-line `run /priorities` pointer. If you'd rather the file be gone completely and are fine expecting Elixir to be pre-present, say so and I'll delete it.
