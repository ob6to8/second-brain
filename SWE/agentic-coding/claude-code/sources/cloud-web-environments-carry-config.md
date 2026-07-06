---
id: sb:863b32
type: source
title: Claude Code on the web docs — environments carry config; each session gets a fresh VM
description: Verbatim passages establishing that a cloud environment controls network access, environment variables, and the setup script, and that each session runs in a fresh Anthropic-managed VM with the repository cloned.
resource: https://code.claude.com/docs/en/claude-code-on-the-web#the-cloud-environment
provenance: "Verbatim excerpts extracted from the resource URL (Anthropic, 'Use Claude Code on the web')"
verified: true
tags: [claude-code, cloud, environments, configuration, vm]
timestamp: 2026-07-06
---

# Claude Code on the web docs — environments carry config; each session gets a fresh VM

Verbatim excerpts from Anthropic's official "Use Claude Code on the web"
documentation.

From **The cloud environment**:

> Each session runs in a fresh Anthropic-managed VM with your repository cloned.

From **Configure your environment**:

> Environments control network access, environment variables, and the setup
> script that runs before a session starts.

> Add an environment [...] The dialog includes name, network access level,
> environment variables, and setup script.

From **Setup scripts vs. SessionStart hooks** (what a setup script is attached
to):

> | Attached to | The cloud environment | Your repository |

## What these establish

The **environment** is the configuration carrier — it owns the network-access
level, environment variables, and the setup script. A **session** runs inside a
VM provisioned from that environment, starting from a fresh clone of the repo.
This grounds the "sessions run inside an environment; the environment carries
network policy, env vars, and setup scripts" part of the unit model.
