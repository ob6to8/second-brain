---
id: sb:6f2442
type: concept
title: session-init digest
description: A machine-compiled summary of a knowledge base's open work — open issues, open todos, active plans, and dangling thread strands — surfaced on demand by the /priorities skill and ending in a heuristic priority ranking for the agent to refine.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, session-init, hooks, tooling]
timestamp: 2026-07-12
---

# session-init digest

A machine-compiled summary of a repository's open work, produced on demand so a
session can appraise what to work on against a single current picture. In this
brain it is `mix brain.session_init`, surfaced by the
[`/priorities`](/.claude/skills/priorities/SKILL.md) skill (it was originally
auto-injected at every session start via the SessionStart hook; that coupling
was retired in favor of the on-demand skill): a scan of open
issues, open todos, active plans, and dangling routing-ledger [strands](/glossary/strand.md), ending in a
heuristic top-3 priority ranking that the agent is asked to refine with
judgment — the script ranks, the agent judges. The ranking order is: open
issues, in-progress plans, open todos, accepted plans, open strands, paused
strands, leftover dangling questions, proposed plans — newer first within a
class; canonically the `@weights` map in `lib/second_brain/session_init.ex`.
An explicit integer `priority:` frontmatter key on an issue/todo/plan pins it
above every heuristic class (1 = most urgent), the operator's manual override. Distinct from the
[digest](/glossary/digest.md) sense used by the news inbox (a day's candidate
items); this one summarizes internal state, not external material.

*Seen in:* [2026-07-11 session-init thread](/meta/threads/2026-07-11-session-init-digest-and-priorities.md)
