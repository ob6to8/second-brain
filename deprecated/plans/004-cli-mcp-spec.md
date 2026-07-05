# Plan 004: CLI-MCP Specification

## Context

MCP (Model Context Protocol) solves a real problem — tool discovery and interop across LLM clients — but wraps it in unnecessary infrastructure. An MCP server is a persistent process speaking JSON-RPC over stdio, registering all tools into context at startup whether used or not.

The insight: a well-structured CLI already does everything MCP does. Subcommands are tools. `--help` is discovery. JSON output is structured data. The only thing missing is a machine-readable schema convention and an optional transport bridge for clients that expect MCP.

This plan defines **CLI-MCP**: a convention for building CLI tools that are natively usable from the shell, expose MCP-compatible tool schemas on demand, and optionally speak MCP protocol when asked. No framework. No runtime. Just a spec and a generic serve script.

### Prior art and influences

- [Eric Holmes, "MCP is dead. Long live the CLI"](https://ejholmes.github.io/2026/02/28/mcp-is-dead-long-live-the-cli.html) — argues LLMs already know CLIs, MCP adds overhead with no benefit. Stops short of proposing interop solution.
- [HN thread: "When does MCP make sense vs CLI?"](https://news.ycombinator.com/item?id=47208398) — consensus: CLI + skills wins for developers, MCP retains niche for non-dev interfaces.
- ["This MCP Server Could Have Been a JSON File"](https://materializedview.io/p/mcp-server-could-have-been-json-file) — argues MCP is redundant over OpenAPI/CLI, recommends investing in existing standards.
- ["CLIs Are Still Beating MCP Servers"](https://dev.to/mechcloud_academy/the-uncomfortable-truth-why-clis-are-still-beating-mcp-servers-in-the-age-of-ai-agents-4n9f) — six friction points with MCP, recommends CLI-first.

All identify the same problem. None propose the synthesis: CLI that subsumes MCP.

### Design principles

- **Shell-first.** Every command is a standalone script. No compiled runtime.
- **Zero context cost.** Unlike MCP servers that register all tools at startup, a CLI-MCP has zero context footprint until invoked.
- **Human and agent identical.** A human runs `mytool search --query "foo"`. An agent runs the same command. Same input, same output, no mystery.
- **MCP as a flag, not an architecture.** `mytool serve` speaks MCP protocol. It's a thin transport wrapper, not a different paradigm.
- **Convention over framework.** The spec is a markdown file. The implementation is shell scripts. Claude Code (or any LLM) can generate a CLI-MCP from the spec + API docs in one session.

## The Spec

### Directory layout

```
mytool/
├── commands/           # One script per tool
│   ├── search.sh
│   ├── read.sh
│   └── post.sh
├── schemas/            # One JSON file per tool (MCP-compatible)
│   ├── search.json
│   ├── read.json
│   └── post.json
├── lib/                # Shared helpers (auth, config, output formatting)
│   ├── auth.sh
│   ├── config.sh
│   └── output.sh
├── serve.sh            # Generic MCP transport bridge (same for every CLI-MCP)
├── mytool              # Entrypoint script (router)
├── schema.json         # Generated: aggregated tool schemas
└── README.md
```

### Entrypoint (`mytool`)

The entrypoint is a shell script that routes subcommands to `commands/*.sh`.

```bash
#!/usr/bin/env bash
set -euo pipefail

TOOL_DIR="$(cd "$(dirname "$0")" && pwd)"
CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in
  schema)  cat "$TOOL_DIR/schema.json" ;;
  serve)   exec "$TOOL_DIR/serve.sh" "$@" ;;
  help)    # list available commands from schemas/
           for f in "$TOOL_DIR/schemas/"*.json; do
             name=$(jq -r '.name' "$f")
             desc=$(jq -r '.description' "$f")
             printf "  %-16s %s\n" "$name" "$desc"
           done ;;
  *)       exec "$TOOL_DIR/commands/$CMD.sh" "$@" ;;
esac
```

### Command scripts (`commands/*.sh`)

Each command is a standalone executable script. Requirements:

- Accepts arguments as flags (`--query "foo"` or `--channel general`)
- Outputs JSON to stdout by default
- Outputs human-readable text when `--format text` is passed (optional)
- Exits 0 on success, non-zero on failure
- Writes errors to stderr, never stdout
- Sources `lib/auth.sh` and `lib/config.sh` as needed
- No global state — all config via environment variables or `~/.config/mytool/`

Example (`commands/search.sh`):

```bash
#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib/auth.sh"
source "$(dirname "$0")/../lib/output.sh"

query="" limit=10
while [[ $# -gt 0 ]]; do
  case "$1" in
    --query)  query="$2"; shift 2 ;;
    --limit)  limit="$2"; shift 2 ;;
    --format) FORMAT="$2"; shift 2 ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

[[ -z "$query" ]] && echo "Error: --query required" >&2 && exit 1

result=$(curl -s -H "Authorization: Bearer $(get_token)" \
  "https://slack.com/api/search.messages?query=$(urlencode "$query")&count=$limit")

output "$result"
```

### Tool schemas (`schemas/*.json`)

Each tool has a companion JSON schema file following MCP's tool definition format:

```json
{
  "name": "search",
  "description": "Search messages across channels",
  "inputSchema": {
    "type": "object",
    "properties": {
      "query": {
        "type": "string",
        "description": "Search query string"
      },
      "limit": {
        "type": "number",
        "description": "Maximum results to return",
        "default": 10
      }
    },
    "required": ["query"]
  }
}
```

The `schema.json` in the root is the aggregated form — an array of all tool schemas. Generated by:

```bash
jq -s '.' schemas/*.json > schema.json
```

### The serve script (`serve.sh`)

This is the MCP transport bridge. It is **generic** — the same script works for every CLI-MCP. It:

1. Reads JSON-RPC requests from stdin (MCP protocol)
2. Handles `initialize`, `tools/list`, and `tools/call` methods
3. For `tools/list`: returns contents of `schema.json`
4. For `tools/call`: maps tool name to `commands/<name>.sh`, converts JSON params to CLI flags, executes, wraps stdout in JSON-RPC response
5. Writes JSON-RPC responses to stdout

This is the only non-trivial piece. It's ~80-100 lines of bash + jq. Written once, copied into every CLI-MCP unchanged.

### Shared libraries (`lib/`)

**`lib/auth.sh`** — provides `get_token` function. Reads from:
1. Environment variable (`MYTOOL_TOKEN`)
2. Config file (`~/.config/mytool/token`)
3. Keychain (macOS: `security find-generic-password`)

No OAuth server, no token refresh daemon. If the API uses OAuth, the CLI includes a one-time `mytool auth` command that does the browser flow and stores the refresh token. Token refresh happens lazily on 401 response.

**`lib/config.sh`** — reads `~/.config/mytool/config.json`. Provides `get_config <key>`.

**`lib/output.sh`** — provides `output` function. Passes JSON through by default. Formats as text when `FORMAT=text`.

### Auth convention

```
~/.config/mytool/
├── config.json      # workspace URL, default channel, preferences
└── credentials.json # tokens (gitignored, 600 permissions)
```

For tools that need OAuth:

```bash
mytool auth          # opens browser, stores tokens
mytool auth status   # shows current auth state
mytool auth revoke   # clears stored credentials
```

### How to build a new CLI-MCP

**From scratch (API docs available):**

Prompt Claude Code with:
> Here is the CLI-MCP spec: [this file]. Here are the API docs for [service]. Build me a CLI-MCP.

Claude Code generates: entrypoint, one command script per API endpoint, one schema per command, auth helper for the service's auth method, copies in the generic `serve.sh`.

**Reverse-engineering an existing MCP server:**

Prompt Claude Code with:
> Here is the CLI-MCP spec: [this file]. Here is an existing MCP server: [repo URL or local path]. Convert it to a CLI-MCP.

The conversion:
1. Extract tool definitions from the MCP server's tool registration code → `schemas/*.json`
2. Extract each tool handler's API calls → `commands/*.sh` (curl + jq)
3. Extract auth mechanism → `lib/auth.sh`
4. Wire up entrypoint
5. Drop in generic `serve.sh`

Most npm MCP servers are thin wrappers around REST APIs. The conversion is mechanical.

## Deliverables

This plan produces a **repo** (targeting `itsjustshell.dev` / associated GitHub) containing:

| File | Description |
|---|---|
| `spec.md` | The CLI-MCP specification (the spec section of this plan, refined) |
| `serve.sh` | Generic MCP transport bridge (works for any CLI-MCP) |
| `template/` | Skeleton directory structure for a new CLI-MCP |
| `examples/slack/` | Reference implementation: Slack CLI-MCP |
| `examples/gmail/` | Reference implementation: Gmail CLI-MCP (reverse-engineered from your existing MCP server) |

## Steps

### Step 1: Create the repo

Create `cli-mcp` repo with the spec as README/core doc. Include the directory layout convention, command format, schema format, auth convention.

### Step 2: Write the generic `serve.sh`

The reusable MCP transport bridge. Handles `initialize`, `tools/list`, `tools/call`. Maps tool calls to command scripts. This is the only piece of shared infrastructure.

Test it standalone with a trivial two-command CLI-MCP (e.g., `echo` and `date`).

### Step 3: Create the template skeleton

```
template/
├── commands/.gitkeep
├── schemas/.gitkeep
├── lib/auth.sh       # stub
├── lib/config.sh     # stub
├── lib/output.sh     # stub
├── serve.sh          # symlink or copy of generic serve.sh
├── mytool            # entrypoint template
└── schema.json       # empty array
```

### Step 4: Build reference implementation — Slack

Build a Slack CLI-MCP with commands: `search`, `read`, `post`, `channels`, `history`. Uses Slack Web API + bot token auth.

Verify:
- `slack-tool search --query "deploy"` works from terminal
- `slack-tool schema` outputs valid MCP tool array
- `slack-tool serve` works when registered as an MCP server in Claude Code
- Same tool, three interfaces, zero duplication

### Step 5: Build reference implementation — Gmail

Reverse-engineer the existing Gmail MCP server at `/Users/mark/dev/repos/others/Gmail-MCP-Server` into a CLI-MCP. Proves the reverse-engineering workflow.

### Step 6: Write the "how to build" and "how to convert" guides

Two short guides:
1. "Build a CLI-MCP from API docs" — prompt template + walkthrough
2. "Convert an existing MCP server to CLI-MCP" — prompt template + walkthrough

## Verification

1. `slack-tool search --query "test"` returns JSON results (CLI mode)
2. `slack-tool schema | jq '.[0].name'` returns `"search"` (schema discovery)
3. Register `slack-tool serve` as MCP server in Claude Code → tools appear, function calls work (MCP mode)
4. `gmail-tool` works identically via all three interfaces
5. `shellcheck` passes on all scripts
6. A new CLI-MCP can be generated from the spec + arbitrary API docs in a single Claude Code session

## Non-goals

- Package manager distribution (brew, npm) — future
- Windows support — future (WSL works)
- Streaming / SSE transport — future (stdio sufficient for now)
- GUI or web interface
- Rewriting existing MCP servers upstream

## Relationship to assertion-graph

This plan originated from an assertion-graph research conversation. The reasoning chain should be ingested as a source and assertions extracted. The plan itself graduates to its own repo — it does not modify assertion-graph.

## Status

**Pending approval.**
