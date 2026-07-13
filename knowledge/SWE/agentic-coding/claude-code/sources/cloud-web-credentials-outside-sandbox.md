---
id: sb:564b8e
type: source
title: Claude Code on the web docs — credentials and signing keys never inside the sandbox
description: Verbatim passages establishing that sensitive credentials such as git credentials or signing keys are never inside the sandbox, authentication is handled through a secure proxy with scoped credentials, and pushes are restricted to the current working branch.
resource: https://code.claude.com/docs/en/claude-code-on-the-web#security-and-isolation
provenance: "Verbatim excerpts extracted from the resource URL (Anthropic, 'Use Claude Code on the web')"
tags: [claude-code, cloud, credentials, signing, security, proxy, isolation]
timestamp: 2026-07-06
attribution:
  when: 2026-07-06T00:37:33+00:00
  channel: backfill
  agent: "reconstructed by mix brain.attribution --backfill, 2026-07-13"
---

# Claude Code on the web docs — credentials and signing keys never inside the sandbox

Verbatim excerpts from Anthropic's official "Use Claude Code on the web"
documentation.

From **Security and isolation**:

> **Credential protection**: sensitive credentials such as git credentials or
> signing keys are never inside the sandbox with Claude Code. Authentication is
> handled through a secure proxy using scoped credentials.

From **GitHub proxy**:

> Inside the sandbox, the git client authenticates using a custom-built scoped
> credential. This proxy: [...] Restricts git push operations to the current
> working branch for safety [...]

## What these establish

Signing keys and git credentials are deliberately kept **out of the sandbox**;
the git client uses a scoped credential that a proxy translates at the boundary.
This grounds the forensic observation that the in-session signing key is empty
and local commits are unsigned until push — signing/credential material lives at
the proxy, not in the container.
