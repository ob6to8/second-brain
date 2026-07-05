#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "--describe" ]]; then
  cat <<'JSON'
{ "name": "context-load", "description": "Assemble knowledge base context for LLM calls by topic, assertion, or thread", "parameters": { "topic": "string", "assertion-id": "string", "thread-id": "string" } }
JSON
  exit 0
fi

# context-load.sh — Context assembler for knowledge-base-aware LLM calls.
# Gathers relevant assertions, sources, and conversation history.
#
# Usage:
#   ./scripts/context-load.sh --topic "agent memory"
#   ./scripts/context-load.sh --assertion-id "some-assertion"
#   ./scripts/context-load.sh --thread-id "abc123"
#
# Requires: jq, scripts/query.sh, scripts/deps.sh

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INDEX_FILE="$REPO_ROOT/index.json"
SB_CONTEXT_LIMIT="${SB_CONTEXT_LIMIT:-5}"
SB_THREAD_WINDOW="${SB_THREAD_WINDOW:-10}"

usage() {
  echo "Usage: $0 --topic <text> | --assertion-id <id> | --thread-id <id>" >&2
  exit 1
}

# Read a markdown file's content (after frontmatter)
read_body() {
  local file="$1"
  [[ -f "$file" ]] || return 0
  # Skip YAML frontmatter (between --- delimiters)
  awk 'BEGIN{skip=0} /^---$/{skip++; next} skip>=2{print}' "$file"
}

# Read a markdown file's frontmatter as YAML
read_frontmatter() {
  local file="$1"
  [[ -f "$file" ]] || return 0
  awk '/^---$/{n++; next} n==1{print} n>=2{exit}' "$file"
}

# Gather context by topic: search tags and claims, read top N files
context_topic() {
  local topic="$1"
  local files_shown=0

  echo "## Relevant Assertions"
  echo ""

  # Search by tag (use topic words as tags)
  for word in $topic; do
    tag=$(echo "$word" | tr '[:upper:]' '[:lower:]')
    results=$("$REPO_ROOT/scripts/query.sh" --tag "$tag" 2>/dev/null || true)
    if [[ -n "$results" && "$results" != "(no matches)" ]]; then
      while IFS='|' read -r type id _title; do
        id=$(echo "$id" | xargs)
        type=$(echo "$type" | xargs)
        if [[ "$type" == "assertion" && $files_shown -lt $SB_CONTEXT_LIMIT ]]; then
          local file="$REPO_ROOT/assertions/${id}.md"
          if [[ -f "$file" ]]; then
            echo "### $id"
            read_frontmatter "$file"
            echo ""
            read_body "$file"
            echo ""
            files_shown=$((files_shown + 1))
          fi
        fi
      done <<< "$results"
    fi
  done

  # Search by claim text
  results=$("$REPO_ROOT/scripts/query.sh" --claim "$topic" 2>/dev/null || true)
  if [[ -n "$results" && "$results" != "(no matches)" ]]; then
    while IFS='|' read -r type id _title; do
      id=$(echo "$id" | xargs)
      type=$(echo "$type" | xargs)
      if [[ "$type" == "assertion" && $files_shown -lt $SB_CONTEXT_LIMIT ]]; then
        local file="$REPO_ROOT/assertions/${id}.md"
        if [[ -f "$file" ]]; then
          echo "### $id"
          read_frontmatter "$file"
          echo ""
          read_body "$file"
          echo ""
          files_shown=$((files_shown + 1))
        fi
      fi
    done <<< "$results"
  fi

  echo "## Evidence Sources"
  echo ""
  files_shown=0

  for word in $topic; do
    tag=$(echo "$word" | tr '[:upper:]' '[:lower:]')
    results=$("$REPO_ROOT/scripts/query.sh" --tag "$tag" 2>/dev/null || true)
    if [[ -n "$results" && "$results" != "(no matches)" ]]; then
      while IFS='|' read -r type id _title; do
        id=$(echo "$id" | xargs)
        type=$(echo "$type" | xargs)
        if [[ "$type" == "source" && $files_shown -lt $SB_CONTEXT_LIMIT ]]; then
          local file="$REPO_ROOT/sources/${id}.md"
          if [[ -f "$file" ]]; then
            echo "### $id"
            read_frontmatter "$file"
            echo ""
            files_shown=$((files_shown + 1))
          fi
        fi
      done <<< "$results"
    fi
  done
}

# Gather context by assertion: walk deps, read assertion + deps + evidence
context_assertion() {
  local assertion_id="$1"
  local assertion_file="$REPO_ROOT/assertions/${assertion_id}.md"

  if [[ ! -f "$assertion_file" ]]; then
    echo "Error: assertion not found: $assertion_id" >&2
    exit 1
  fi

  echo "## Target Assertion"
  echo ""
  echo "### $assertion_id"
  read_frontmatter "$assertion_file"
  echo ""
  read_body "$assertion_file"
  echo ""

  # Get dependency tree
  local dep_output
  dep_output=$("$REPO_ROOT/scripts/deps.sh" "$assertion_id" 2>/dev/null || true)

  if [[ -n "$dep_output" ]]; then
    echo "## Dependency Tree"
    echo ""
    echo '```'
    echo "$dep_output"
    echo '```'
    echo ""
  fi

  # Extract dep IDs from index and read their files
  echo "## Dependencies"
  echo ""
  local deps
  deps=$(jq -r --arg id "$assertion_id" \
    '.edges[] | select(.from == $id and .type == "dependency") | .to' \
    "$INDEX_FILE" 2>/dev/null || true)

  if [[ -n "$deps" ]]; then
    while IFS= read -r dep_id; do
      local dep_file="$REPO_ROOT/assertions/${dep_id}.md"
      if [[ -f "$dep_file" ]]; then
        echo "### $dep_id"
        read_frontmatter "$dep_file"
        echo ""
      fi
    done <<< "$deps"
  fi

  # Read evidence sources
  echo "## Evidence Sources"
  echo ""
  local evidence_sources
  evidence_sources=$(jq -r --arg id "$assertion_id" \
    '.edges[] | select(.from == $id and .type == "evidence") | .to' \
    "$INDEX_FILE" 2>/dev/null || true)

  if [[ -n "$evidence_sources" ]]; then
    while IFS= read -r src_id; do
      local src_file="$REPO_ROOT/sources/${src_id}.md"
      if [[ -f "$src_file" ]]; then
        echo "### $src_id"
        read_frontmatter "$src_file"
        echo ""
      fi
    done <<< "$evidence_sources"
  fi
}

# Gather context by thread: get recent conversation + related knowledge
context_thread() {
  local thread_id="$1"

  if ! command -v llm &>/dev/null; then
    echo "Error: llm CLI required for thread context" >&2
    exit 1
  fi

  echo "## Prior Conversation"
  echo ""

  # Get recent messages from the thread
  local messages
  messages=$(llm logs -c "$thread_id" --json 2>/dev/null | tail -"$SB_THREAD_WINDOW" || true)

  if [[ -n "$messages" ]]; then
    echo "$messages" | jq -r '.[] | "**\(.role):** \(.content)"' 2>/dev/null || echo "$messages"
    echo ""

    # Extract keywords from conversation for topic search
    local keywords
    keywords=$(echo "$messages" | jq -r '.[].content' 2>/dev/null | \
      tr '[:upper:]' '[:lower:]' | tr -cs '[:alpha:]' '\n' | \
      sort | uniq -c | sort -rn | head -5 | awk '{print $2}' | \
      grep -v -E '^(the|and|for|that|this|with|are|was|have|from)$' | \
      head -3 | tr '\n' ' ' || true)

    if [[ -n "$keywords" ]]; then
      echo "## Related Knowledge"
      echo ""
      context_topic "$keywords"
    fi
  else
    echo "(no conversation found for thread: $thread_id)"
    echo ""
  fi
}

# --- Main ---

[[ $# -lt 2 ]] && usage

mode=""
value=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --topic)        mode="topic"; value="$2"; shift 2 ;;
    --assertion-id) mode="assertion"; value="$2"; shift 2 ;;
    --thread-id)    mode="thread"; value="$2"; shift 2 ;;
    -h|--help)      usage ;;
    *)              echo "Unknown option: $1" >&2; usage ;;
  esac
done

case "$mode" in
  topic)     context_topic "$value" ;;
  assertion) context_assertion "$value" ;;
  thread)    context_thread "$value" ;;
  *)         usage ;;
esac
