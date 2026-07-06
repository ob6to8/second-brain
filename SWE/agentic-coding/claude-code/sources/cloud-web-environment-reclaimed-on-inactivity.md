---
id: sb:3420c8
type: source
title: Claude Code on the web docs — environments are reclaimed after inactivity
description: Verbatim passages establishing that cloud sessions stop after a period of inactivity and the underlying environment is reclaimed, and that the VM clones from GitHub rather than the local machine so local commits must be pushed first.
resource: https://code.claude.com/docs/en/claude-code-on-the-web#environment-expired
provenance: "Verbatim excerpts extracted from the resource URL (Anthropic, 'Use Claude Code on the web')"
verified: true
tags: [claude-code, cloud, ephemeral, lifecycle, environments]
timestamp: 2026-07-06
---

# Claude Code on the web docs — environments are reclaimed after inactivity

Verbatim excerpts from Anthropic's official "Use Claude Code on the web"
documentation.

From **Environment expired**:

> Cloud sessions stop after a period of inactivity and the underlying environment
> is reclaimed. From a local terminal, this surfaces as `Could not resume session
> ... its environment has expired. Creating a fresh session instead.`

From **From terminal to web** (why unpushed local state is invisible to the VM):

> The session clones your current directory's GitHub remote at your current
> branch, so push first if you have local commits, since the VM clones from
> GitHub rather than your machine.

## What these establish

The environment/container is **ephemeral**: after inactivity it is reclaimed, and
resuming provisions a fresh one. Combined with the fact that the VM's contents
derive from GitHub (not the local machine), this grounds "the container is
ephemeral — reclaimed after inactivity; unpushed commits die with it."
