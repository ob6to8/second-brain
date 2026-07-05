#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
source "$REPO_ROOT/scripts/lib/test-harness.sh"
source "$REPO_ROOT/scripts/lib/log.sh"

setup_tmpdir

# --- Basic logging ---

export LOG_FILE="$TEST_TMPDIR/test.jsonl"

log_event "ingest" "Fetched source: https://example.com"
check_file_exists "$LOG_FILE" "log file created"

line=$(head -1 "$LOG_FILE")
check_json_field "$line" "event" "ingest" "event field correct"
check_json_field "$line" "agent" "assertion-graph" "default agent id"
check_contains "$line" "Fetched source" "message preserved"

# Validate JSON
jq . "$LOG_FILE" >/dev/null 2>&1; rc=$?
check_exit "$rc" 0 "output is valid JSON"

# --- Custom agent ---

SB_AGENT_ID="test-agent" log_event "test" "custom agent"
line=$(tail -1 "$LOG_FILE")
check_json_field "$line" "agent" "test-agent" "custom agent id"

# --- Special characters ---

log_event "test" 'quotes "and" newlines
and tabs	here'
line=$(tail -1 "$LOG_FILE")
jq . <<< "$line" >/dev/null 2>&1; rc=$?
check_exit "$rc" 0 "special chars produce valid JSON"

# --- Error cases ---

LOG_FILE="" log_event "test" "msg" >/dev/null 2>&1 && rc=$? || rc=$?
check_exit "$rc" 1 "empty LOG_FILE fails"

log_event "" "msg" >/dev/null 2>&1 && rc=$? || rc=$?
check_exit "$rc" 1 "empty event_type fails"

summary "log"
