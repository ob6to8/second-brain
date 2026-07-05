#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "--describe" ]]; then
  cat <<'JSON'
{ "name": "export-conversation", "description": "Export an LLM conversation thread as a source file", "parameters": { "conversation-id": "string (required)", "--conclude": "flag, print message to run /conclude" } }
JSON
  exit 0
fi

# export-conversation.sh — Export a thread as a source file.
#
# Usage:
#   ./scripts/export-conversation.sh <conversation-id>
#   ./scripts/export-conversation.sh --conclude <conversation-id>
#
# Requires: llm CLI, scripts/lib/llm-call.sh, jq

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$REPO_ROOT/scripts/lib/llm-call.sh"

conclude_mode=false
cid=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --conclude) conclude_mode=true; shift ;;
    -*) echo "Unknown flag: $1" >&2; exit 1 ;;
    *)
      if [[ -z "$cid" ]]; then
        cid="$1"
      fi
      shift ;;
  esac
done

if [[ -z "$cid" ]]; then
  echo "Usage: $0 [--conclude] <conversation-id>" >&2
  exit 1
fi

if ! command -v llm &>/dev/null; then
  echo "Error: llm CLI required" >&2
  exit 1
fi

# Get conversation content
conversation=$(llm logs -c "$cid" --json 2>/dev/null || true)

if [[ -z "$conversation" || "$conversation" == "[]" ]]; then
  echo "Error: no conversation found for: $cid" >&2
  exit 1
fi

# Extract metadata via LLM
metadata_prompt="Given this conversation JSON, extract:
1. A short title (5-8 words)
2. 3-5 lowercase hyphenated tags
3. A one-paragraph summary

Output as JSON: {\"title\": \"...\", \"tags\": [\"...\"], \"summary\": \"...\"}

Conversation:
$conversation"

metadata=$(llm_call "$metadata_prompt" --system "You extract metadata from conversations. Output only valid JSON, no markdown fences.")

# Parse metadata
title=$(echo "$metadata" | jq -r '.title // "Untitled Conversation"')
tags_json=$(echo "$metadata" | jq -c '.tags // []')
summary=$(echo "$metadata" | jq -r '.summary // ""')

# Generate filename
slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')
filename="$slug.md"
filepath="$REPO_ROOT/sources/$filename"

# Format conversation body
body=$(echo "$conversation" | jq -r '.[] | "**\(.role):** \(.content)\n"' 2>/dev/null || echo "$conversation")

# Build tags array for YAML
tags_yaml=$(echo "$tags_json" | jq -r '.[] | "  - " + .')

# Write source file
cat > "$filepath" <<EOF
---
type: source
source_type: conversation
title: "$title"
url: ""
aliases: []
tags:
$tags_yaml
authors: []
date_published: ""
date_captured: "$(date +%Y-%m-%d)"
summary: >
  $summary
related: []
---

$body
EOF

echo "Exported: sources/$filename" >&2

# Rebuild index
"$REPO_ROOT/scripts/build-index.sh" >/dev/null 2>&1 || true

if [[ "$conclude_mode" == "true" ]]; then
  echo "" >&2
  echo "Run /conclude to extract assertions from this conversation." >&2
fi

echo "$filepath"
