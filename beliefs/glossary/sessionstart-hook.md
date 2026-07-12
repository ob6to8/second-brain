---
id: sb:71f38a
type: concept
title: SessionStart hook
description: A hook that runs automatically at the start of an agent/CLI session to provision or validate the environment — and, via its stdout, brief the agent — before the user interacts.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, claude-code, tooling, ci]
timestamp: 2026-07-11
---

# SessionStart hook

A hook that runs a script at the start of every session to provision or warm the environment — install a toolchain, prime a build cache, check tool availability — so later commands "just work" in a fresh, ephemeral sandbox. It may run synchronously (blocking session start) or asynchronously. Beyond provisioning, its stdout is injected into the session's context, so it can also brief the agent — e.g. emit a [session-init digest](/beliefs/glossary/session-init-digest.md) of open work.

*Seen in:* [2026-07-05 OKF bootstrap thread](/meta/threads/2026-07-05-greenfield-okf-bootstrap-and-verification-layer.md), [2026-07-09 GitHub Pages thread](/meta/threads/2026-07-09-github-pages-knowledge-base-site.md), [2026-07-11 session-init thread](/meta/threads/2026-07-11-session-init-digest-and-priorities.md)
