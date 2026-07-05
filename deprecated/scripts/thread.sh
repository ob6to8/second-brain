#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "--describe" ]]; then
  cat <<'JSON'
{ "name": "thread", "description": "Manage persistent LLM conversations with knowledge base context", "parameters": { "command": "new|continue|list|export|conclude", "args": "varies by command" } }
JSON
  exit 0
fi

# thread.sh — Conversation threading with knowledge base context.
#
# Usage:
#   ./scripts/thread.sh new "Why is the context window the unit of work?"
#   ./scripts/thread.sh continue <conversation-id> "Follow up question"
#   ./scripts/thread.sh list
#   ./scripts/thread.sh export <conversation-id>
#   ./scripts/thread.sh conclude <conversation-id>
#
# Requires: scripts/lib/llm-call.sh, scripts/context-load.sh

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$REPO_ROOT/scripts/lib/llm-call.sh"

SYSTEM_PROMPT="You are a research assistant for a knowledge base. You help explore ideas, challenge assumptions, and develop assertions backed by evidence. Be concise and specific. When making claims, distinguish between what the evidence supports and what is speculation."

usage() {
  cat >&2 <<'EOF'
Usage:
  thread.sh new <message> [--topic <topic>]
  thread.sh continue <conversation-id> <message>
  thread.sh list
  thread.sh export <conversation-id>
  thread.sh conclude <conversation-id>
EOF
  exit 1
}

cmd_new() {
  local message=""
  local topic=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --topic) topic="$2"; shift 2 ;;
      *)
        if [[ -z "$message" ]]; then
          message="$1"
        fi
        shift ;;
    esac
  done

  [[ -z "$message" ]] && { echo "Error: message required" >&2; usage; }

  # Generate conversation ID
  local cid
  cid="sb-$(date +%Y%m%d-%H%M%S)"

  # Load context if topic provided
  local context=""
  if [[ -n "$topic" ]]; then
    context=$("$REPO_ROOT/scripts/context-load.sh" --topic "$topic" 2>/dev/null || true)
  fi

  # Build full message with context
  local full_message="$message"
  if [[ -n "$context" ]]; then
    full_message="# Knowledge Base Context

$context

# Question

$message"
  fi

  echo "Conversation: $cid" >&2
  llm_call "$full_message" --system "$SYSTEM_PROMPT" --conversation-id "$cid"
}

cmd_continue() {
  local cid="${1:-}"
  shift || true
  local message="${1:-}"

  [[ -z "$cid" ]] && { echo "Error: conversation-id required" >&2; usage; }
  [[ -z "$message" ]] && { echo "Error: message required" >&2; usage; }

  # Load thread context
  local context=""
  context=$("$REPO_ROOT/scripts/context-load.sh" --thread-id "$cid" 2>/dev/null || true)

  local full_message="$message"
  if [[ -n "$context" ]]; then
    full_message="# Updated Context

$context

# Follow-up

$message"
  fi

  llm_call "$full_message" --continue --conversation-id "$cid"
}

cmd_list() {
  if ! command -v llm &>/dev/null; then
    echo "Error: llm CLI required" >&2
    exit 1
  fi
  llm logs list --json 2>/dev/null | jq -r '.[] | select(.conversation_id | startswith("sb-")) | "\(.conversation_id)\t\(.datetime)\t\(.prompt[:80])"' 2>/dev/null || echo "(no conversations found)"
}

cmd_export() {
  local cid="${1:-}"
  [[ -z "$cid" ]] && { echo "Error: conversation-id required" >&2; usage; }
  "$REPO_ROOT/scripts/export-conversation.sh" "$cid"
}

cmd_conclude() {
  local cid="${1:-}"
  [[ -z "$cid" ]] && { echo "Error: conversation-id required" >&2; usage; }
  "$REPO_ROOT/scripts/export-conversation.sh" --conclude "$cid"
}

# --- Main ---

[[ $# -lt 1 ]] && usage

command="$1"
shift

case "$command" in
  new)      cmd_new "$@" ;;
  continue) cmd_continue "$@" ;;
  list)     cmd_list ;;
  export)   cmd_export "$@" ;;
  conclude) cmd_conclude "$@" ;;
  -h|--help) usage ;;
  *)        echo "Unknown command: $command" >&2; usage ;;
esac
