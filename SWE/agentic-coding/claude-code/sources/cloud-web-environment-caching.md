---
id: sb:eb418b
type: source
title: Claude Code on the web docs — environment caching (filesystem snapshots)
description: Verbatim passages establishing that Anthropic snapshots the filesystem per environment after the setup script runs, reuses the snapshot for later sessions, captures files not processes, and rebuilds on config change or after roughly seven days.
resource: https://code.claude.com/docs/en/claude-code-on-the-web#environment-caching
provenance: "Verbatim excerpts extracted from the resource URL (Anthropic, 'Use Claude Code on the web')"
verified: true
tags: [claude-code, cloud, caching, snapshots, environments, warm-start]
timestamp: 2026-07-06
---

# Claude Code on the web docs — environment caching (filesystem snapshots)

Verbatim excerpts from Anthropic's official "Use Claude Code on the web"
documentation, section **Environment caching**.

> The setup script runs the first time you start a session in an environment.
> After it completes, Anthropic snapshots the filesystem and reuses that snapshot
> as the starting point for later sessions. New sessions start with your
> dependencies, tools, and Docker images already on disk, and the setup script
> step is skipped.

> The cache captures files, not running processes. Anything the setup script
> writes to disk carries over. Services or containers it starts don't [...]

> The setup script runs again to rebuild the cache when you change the
> environment's setup script or allowed network hosts, and when the cache reaches
> its expiry after roughly seven days. Resuming an existing session never re-runs
> the setup script.

Related, from **Run tests, start services, and add packages**:

> The pulled images are saved in the [cached environment], so each new session has
> them on disk.

## What these establish

Provisioned state is cached **per environment**, not per repo or per session:
the filesystem is snapshotted after the first session's setup script and reused
as the warm starting point for subsequent sessions. This grounds "container
images are pre-baked and cached across sessions (warm starts)", "the cache key is
the environment", "per-environment snapshot", and the **invalidation policy**
(rebuild on setup-script/allowed-host change or ~7-day expiry). Because the cache
captures the on-disk filesystem — including the cloned repo — anything baked into
it is **frozen at snapshot time**.
