---
id: sb:00e798
type: concept
title: hot module reload
description: A dev-server technique that swaps changed modules into a running app in place, updating the live view on each edit without a full page reload or losing state.
provenance: "Agent-distilled glossary definition"
verified: false
tags: [glossary, web, tooling, dev-server, hmr]
sense: common
timestamp: 2026-07-13
attribution:
  when: 2026-07-13
  channel: glossary
  agent: "Claude Code agent, /add-to-glossary"
  why: "term surfaced by the 2026-07-13 artifacts-concept-and-anthropic-node-restructure thread"
---

# hot module reload

A development-server technique (HMR — also "hot reloading") that injects changed
modules into an already-running application in place, so the browser view updates
on each save without a full page reload and without discarding runtime state.
Provided by dev servers like Vite and webpack-dev-server, it is the local
edit→see-it-instantly loop a developer would use to reproduce the fast iteration
of a Claude [artifact](/beliefs/glossary/artifact.md) — the difference being
infrastructure (a localhost process tied to one machine and session), not the
reload mechanism itself.

*Seen in:* [2026-07-13 artifacts-concept-and-anthropic-node-restructure thread](/meta/threads/2026-07-13-artifacts-concept-and-anthropic-node-restructure.md)
