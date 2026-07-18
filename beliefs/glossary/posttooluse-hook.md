---
id: em:1ddce3
type: concept
title: PostToolUse hook
description: A Claude Code lifecycle hook that fires after a tool call completes; its exit code and stdout/stderr feed back into the session, so exit 2 (or a `block` JSON payload) injects the hook's output as context on the model's next turn — the mechanism a post-edit linter uses to surface failures to the agent.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, claude-code, hooks, agents, linter-loop]
sense: common
timestamp: 2026-07-16
attribution:
  when: 2026-07-16T07:00:26Z
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-16 thread on the mechanics of a build-agent linter loop"
---

# PostToolUse hook

A Claude Code lifecycle hook (configured in
`.claude/settings.json`) that runs a shell command *after* a tool call completes.
Like all Claude Code hooks it communicates back through its process result rather
than any side channel: **exit code 2 signals "block/problem," and the harness feeds
the hook's stderr back to the model as a context message**; alternatively the hook
prints JSON on stdout (e.g. `{"decision": "block", "reason": …}` or an
`additionalContext` field) that the harness turns into a context message. Either
way the text becomes a new entry in the conversation the model sees on its next
inference.

This is the mechanism that closes an agent-in-the-loop lint/fix cycle: a
`PostToolUse` hook that runs a linter after every `Edit`/`Write`, exits 2 on
failure, and puts the failure output on stderr will inject that failure into the
session — the agent reads it as a fresh problem and fixes it, re-triggering the
hook, until the check passes silently. Its sibling the **Stop hook** fires when the
agent tries to end its turn and can likewise `block` to force another turn (e.g. if
gates are still red), preventing a premature "done." Distinct from the
[SessionStart hook](/beliefs/glossary/sessionstart-hook.md), which runs once at
session start to provision the environment.

*Seen in:* [2026-07-16 Jido-caveats thread](/meta/threads/2026-07-16-jido-caveats-and-build-agent-linter-loop.md)

*See also:* [SessionStart hook](/beliefs/glossary/sessionstart-hook.md), [gate suite](/beliefs/glossary/gate-suite.md)
</content>
