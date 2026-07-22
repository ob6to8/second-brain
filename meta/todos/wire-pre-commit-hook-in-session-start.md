---
type: todo
title: "Auto-wire the pre-commit hook in session-start.sh (git config core.hooksPath .githooks)"
description: The pre-commit gate exists at .githooks/pre-commit but is opt-in per clone and is not enabled in fresh web-session sandboxes, so its local-first benefit is unrealized in the dominant flow; have the session-start hook set core.hooksPath so every session gets the local gate automatically.
status: open
provenance: "Claude Code session (2026-07-22) — surfaced by the version-control workflow audit"
tags: [meta, todo, git, pre-commit, hooks, ci, session-start]
timestamp: 2026-07-22
attribution:
  when: 2026-07-22T00:00:00Z
  channel: agent-authored
  agent: "Claude Code agent, version-control-audit session"
  why: "the audit's highest-leverage quick win — a one-line change that makes the local-first gate real for web sessions"
---

# Auto-wire the pre-commit hook in `session-start.sh`

The [gate suite](/meta/tutorials/the-gate-suite-and-where-it-runs.md) has a local
pre-commit surface ([`.githooks/pre-commit`](/.githooks/pre-commit)), but it is
enabled per clone with `git config core.hooksPath .githooks`. Fresh **web-session
sandboxes** clone the repo without that config, so the hook never runs there and a
red gate is only discovered in CI — the "run cheap checks locally first" benefit is
lost for the brain's dominant flow.

**Task.** In [`.claude/hooks/session-start.sh`](/.claude/hooks/session-start.sh), set
`git config core.hooksPath .githooks` (guarded to run only inside the repo, and
harmless if already set) so every session gets the local gate wired automatically.

**Done when.** A fresh session has `core.hooksPath` pointing at `.githooks`, a commit
that would fail a gate is caught locally before a PR is opened, and the hook still
degrades gracefully when `mix` is absent (it already exits `0` in that case).

Surfaced by the
[version-control audit](/meta/analysis/version-control-workflow-vs-trunk-based-reference.md).
