---
type: source
source_type: conversation
title: "CLI-MCP: Why CLIs Subsume MCP and the Convention That Bridges Them"
url: ""
aliases: []
tags: [cli, mcp, shell, tool-discovery, llm-tooling, architecture]
authors: []
date_published: ""
date_captured: "2026-03-03"
summary: >
  Socratic investigation of MCP vs CLI for LLM tool integration. Concludes that MCP's capabilities (tool discovery, typed schemas, structured invocation) are not unique to the protocol — a well-structured CLI with a schema subcommand and optional serve mode subsumes MCP entirely. Proposes CLI-MCP: a shell-based convention where tools are standalone scripts, schemas are MCP-compatible JSON, and a generic serve script bridges to MCP protocol on demand.
related:
  - "[[mcp-is-dead-long-live-the-cli]]"
---

## Seed

Can you check Slack from the terminal? What's the best approach — MCP server or CLI?

## Key Reasoning Chain

### MCP and CLI make identical API calls
If both a CLI and an MCP server call the same Slack API, the difference is purely invocation and context flow. A CLI via Bash tool returns stdout. An MCP tool returns structured JSON. For a CLI with JSON output, these are functionally equivalent.

### Persistent auth doesn't require a server
CLI tools handle auth via config files, keychain, or lazy OAuth refresh on invocation. No background daemon needed. Same pattern as `gh` (GitHub CLI).

### Tool discovery doesn't require MCP
CLI subcommands + `--help` are self-documenting. A `schema` subcommand outputting MCP-compatible JSON schema provides machine-readable discovery identical to MCP's `tools/list`.

### MCP's only real advantage is convention
MCP provides a shared schema format (JSON schema for tool names, parameters, descriptions) that any MCP-compatible client can auto-consume. But a CLI that adopts and promises the same JSON schema standard achieves the same interop.

### Context window cost
MCP servers register all tools at session start — every tool's schema sits in context whether used or not. A CLI has zero context cost until invoked. For the Gmail MCP: 7 tool schemas loaded in every conversation even when not doing email.

### CLI subsumes MCP
A CLI that: (1) works standalone, (2) exposes `schema` for discovery, (3) runs `serve` to speak MCP protocol — is strictly more flexible than a pure MCP server. It works in more contexts (any terminal, any agent, any automation) and degrades gracefully (no server needed for direct use).

### The gap: nobody has built this
As of March 2026, the discourse is CLI *vs* MCP. Nobody is building CLI *that subsumes* MCP. The opportunity is a convention (not a framework) — a spec + generic serve script that lets any CLI also speak MCP.

### Convention over framework
The spec is a markdown file. The implementation is shell scripts. Claude Code can generate a CLI-MCP from the spec + API docs in one session. The generic `serve.sh` (~80-100 lines of bash+jq) is written once and works for every CLI-MCP.

### Reverse-engineering existing MCPs
Most npm MCP servers are thin REST API wrappers. Conversion to CLI-MCP is mechanical: extract tool definitions → schemas/*.json, extract API calls → commands/*.sh (curl+jq), extract auth → lib/auth.sh.

## Sources Referenced

- [Eric Holmes, "MCP is dead. Long live the CLI"](https://ejholmes.github.io/2026/02/28/mcp-is-dead-long-live-the-cli.html) — same core argument, stops short of interop solution
- [HN: "When does MCP make sense vs CLI?"](https://news.ycombinator.com/item?id=47208398) — consensus: CLI + skills wins for developers
- ["This MCP Server Could Have Been a JSON File"](https://materializedview.io/p/mcp-server-could-have-been-json-file) — MCP is redundant over OpenAPI/CLI
- ["CLIs Are Still Beating MCP Servers"](https://dev.to/mechcloud_academy/the-uncomfortable-truth-why-clis-are-still-beating-mcp-servers-in-the-age-of-ai-agents-4n9f) — six friction points with MCP

## Outcome

Plan 004 written: CLI-MCP specification. Targets its own repo at itsjustshell.dev. Includes spec, generic serve.sh, template skeleton, and two reference implementations (Slack from scratch, Gmail reverse-engineered).
