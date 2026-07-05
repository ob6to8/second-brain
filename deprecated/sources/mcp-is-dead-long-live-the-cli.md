---
type: source
source_type: article
title: "MCP is dead. Long live the CLI."
url: "https://ejholmes.github.io/2026/02/28/mcp-is-dead-long-live-the-cli.html"
aliases: []
tags: [mcp, cli, llm-tooling, shell]
authors: ["Eric Holmes"]
date_published: "2026-02-28"
date_captured: "2026-03-03"
summary: >
  Argues MCP provides no real-world benefit over CLIs for LLM tool integration. LLMs are trained on CLI patterns, CLIs offer superior debugging transparency (same input/output for human and agent), composability (pipes, jq, grep), and battle-tested auth. Recommends building good APIs and good CLIs — agents will figure it out.
related:
  - "[[cli-mcp-conversation]]"
---

## Key Arguments

### LLMs already know CLIs
Trained on millions of man pages, Stack Overflow answers, and shell scripts. No special interface needed.

### Debugging transparency
With CLIs, you can run the same command yourself and see exactly what the agent saw. Same input, same output, no mystery.

### Composability
CLI output can be piped through jq, chained with grep, redirected to files. MCP forces choosing between context-window bloat or building custom filtering into servers.

### Auth is already solved
Existing CLI tools use battle-tested auth flows — SSO, profiles, kubeconfig — that work identically for humans and agents.

### MCP operational friction
Startup failures, flaky initialization, repeated re-authentication across tools, coarse-grained permissions (all-or-nothing vs granular CLI allowlisting).

## Limitation

Argues "just build good CLIs" but doesn't address how non-Claude-Code clients discover and invoke those CLIs without MCP's schema convention. The interop gap remains unaddressed.
