#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
source "$REPO_ROOT/scripts/lib/test-harness.sh"

setup_tmpdir

# --- --describe ---

out=$("$REPO_ROOT/scripts/context-load.sh" --describe 2>&1)
echo "$out" | jq . >/dev/null 2>&1; rc=$?
check_exit "$rc" 0 "context-load --describe outputs valid JSON"

out=$("$REPO_ROOT/scripts/thread.sh" --describe 2>&1)
echo "$out" | jq . >/dev/null 2>&1; rc=$?
check_exit "$rc" 0 "thread --describe outputs valid JSON"

out=$("$REPO_ROOT/scripts/export-conversation.sh" --describe 2>&1)
echo "$out" | jq . >/dev/null 2>&1; rc=$?
check_exit "$rc" 0 "export-conversation --describe outputs valid JSON"

# --- context-load error cases ---

"$REPO_ROOT/scripts/context-load.sh" 2>/dev/null && rc=$? || rc=$?
check_exit "$rc" 1 "context-load with no args fails"

# --- context-load --topic with no matching content ---

out=$("$REPO_ROOT/scripts/context-load.sh" --topic "nonexistent-xyzzy-topic" 2>&1) && rc=$? || rc=$?
check_exit "$rc" 0 "context-load --topic with no matches exits 0"
check_contains "$out" "## Relevant Assertions" "topic mode has assertions header"
check_contains "$out" "## Evidence Sources" "topic mode has evidence header"

# --- thread error cases ---

"$REPO_ROOT/scripts/thread.sh" 2>/dev/null && rc=$? || rc=$?
check_exit "$rc" 1 "thread with no args fails"

"$REPO_ROOT/scripts/thread.sh" new 2>/dev/null && rc=$? || rc=$?
check_exit "$rc" 1 "thread new with no message fails"

summary "context-load + thread"
