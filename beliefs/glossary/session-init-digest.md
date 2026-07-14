---
id: em:6f2442
type: concept
title: session-init digest
description: A machine-compiled summary of a knowledge base's open work — open issues, open todos, active plans, and dangling thread strands — surfaced on demand by the /priorities skill and ending in a heuristic priority ranking for the agent to refine.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, session-init, hooks, tooling]
sense: repo
timestamp: 2026-07-12
attribution:
  when: 2026-07-11T19:30:56+02:00
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the captured sources cited in Seen in (backfilled)"
---

# session-init digest

A machine-compiled summary of a repository's open work, produced on demand so a
session can appraise what to work on against a single current picture. In this
brain it is `mix brain.session_init`, surfaced by the
[`/priorities`](/.claude/skills/priorities/SKILL.md) skill (it was originally
auto-injected at every session start via the SessionStart hook; that coupling
was retired in favor of the on-demand skill): a scan of open
issues, open todos, active plans, and dangling routing-ledger [strands](/beliefs/glossary/strand.md), ending in a
heuristic top-3 priority ranking that the agent is asked to refine with
judgment — the script ranks, the agent judges. The ranking order is: open
issues, in-progress plans, open todos, accepted plans, open strands, paused
strands, leftover dangling questions, proposed plans — newer first within a
class; canonically the `@weights` map in `lib/elixir_mind/session_init.ex`.
An explicit integer `priority:` frontmatter key on an issue/todo/plan pins it
above every heuristic class (1 = most urgent), the operator's manual override. Distinct from the
[digest](/beliefs/glossary/digest.md) sense used by the research inbox (a day's candidate
items); this one summarizes internal state, not external material.

*Seen in:* [2026-07-11 session-init thread](/meta/threads/2026-07-11-session-init-digest-and-priorities.md), [2026-07-12 priorities-skill thread](/meta/threads/2026-07-12-priorities-skill-and-persistence-listers.md)

## Thread excerpts — route-tagged log

Append-only, per-thread, date-stamped excerpts, generated from the `<routes ref="em:6f2442">` regions of the threads that fed this matter and re-derivable via `mix brain.route_tags` — never hand-edit.

### 2026-07-12-priorities-skill-and-persistence-listers (2026-07-12)

1 tagged region(s), lifted whole. Refs shown are the full ref-set of each region (this matter plus any it co-feeds).

**[`em:6f2442`]**  (co-feeds: `lib/elixir_mind/session_init.ex`)

Done. Pushed to `claude/priorities-skill-persistence-vmp9tn`.

**`/priorities` skill** — the on-demand successor to the session-start digest. It runs the existing `mix brain.session_init` (open issues, todos, active plans, dangling ledger strands + heuristic top-3) and has the agent relay it with its own judged appraisal. The ranking engine, class weights, and `priority:` escape hatch are unchanged — only *how it reaches a session* moved.
