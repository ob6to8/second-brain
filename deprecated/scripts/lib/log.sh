#!/usr/bin/env bash
# scripts/lib/log.sh — Structured JSONL logging
#
# Ported from shellclaw lib/log.sh. Appends one JSON object per line.
#
# Environment:
#   LOG_FILE     — Path to append log entries to (required)
#   SB_AGENT_ID  — Agent identifier in each entry (default: "assertion-graph")
#
# Usage:
#   source scripts/lib/log.sh
#   LOG_FILE="$REPO_ROOT/logs/events.jsonl"
#   log_event "ingest" "Fetched source: $url"

log_event() {
    local event_type="${1:-}"
    local message="${2:-}"
    local agent="${SB_AGENT_ID:-assertion-graph}"

    if [[ -z "${LOG_FILE:-}" ]]; then
        echo "log_event: LOG_FILE not set" >&2
        return 1
    fi

    if [[ -z "$event_type" ]]; then
        echo "log_event: event_type required" >&2
        return 1
    fi

    local ts
    ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    jq -n -c \
        --arg ts "$ts" \
        --arg agent "$agent" \
        --arg event "$event_type" \
        --arg message "$message" \
        '{ts: $ts, agent: $agent, event: $event, message: $message}' \
        >> "$LOG_FILE"
}
