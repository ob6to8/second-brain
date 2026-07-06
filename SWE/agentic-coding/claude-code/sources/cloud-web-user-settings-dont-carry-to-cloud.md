---
id: sb:3f35e1
type: source
title: Claude Code on the web docs — user-level settings don't carry to cloud; hooks come from repo and org
description: Verbatim passages establishing that user-level ~/.claude settings and hooks don't carry over to cloud sessions, and that in the cloud, hooks come from the repository and from the organization's server-managed settings.
resource: https://code.claude.com/docs/en/claude-code-on-the-web#setup-scripts-vs-sessionstart-hooks
provenance: "Verbatim excerpts extracted from the resource URL (Anthropic, 'Use Claude Code on the web')"
tags: [claude-code, cloud, hooks, settings, server-managed-settings]
timestamp: 2026-07-06
---

# Claude Code on the web docs — user-level settings don't carry to cloud; hooks come from repo and org

Verbatim excerpts from Anthropic's official "Use Claude Code on the web"
documentation.

From **Setup scripts vs. SessionStart hooks**:

> SessionStart hooks can also be defined in your user-level `~/.claude/settings.json`
> locally, but user-level settings don't carry over to cloud sessions. In the
> cloud, hooks come from the repo and from your organization's [server-managed
> settings].

From **What's available in cloud sessions** (why repo config is available and
device/user config is not):

> Settings deployed to your device through MDM or managed settings files don't
> apply, because the session runs on an Anthropic-managed VM

## What these establish

There are (at least) two hook/settings origins in a cloud session: the
**repository** (`.claude/settings.json`, part of the clone, operator-editable) and
**Anthropic-side layers** — the user's own `~/.claude` settings do *not* carry
over; instead non-repo configuration arrives through org **server-managed
settings**. This grounds the forensic observation of a repo-tracked hook layer
versus a non-repo, environment-injected hook layer that a repository cannot reach
or fix.
