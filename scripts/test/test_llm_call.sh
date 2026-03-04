#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
source "$REPO_ROOT/scripts/lib/test-harness.sh"
source "$REPO_ROOT/scripts/lib/llm-call.sh"

export SB_LLM_BACKEND=stub

setup_tmpdir

# --- Stub backend ---

llm_stub_reset

out=$(llm_call "hello")
check_output "$out" "stub response 1" "stub first call returns 1"

out=$(llm_call "hello again")
check_output "$out" "stub response 2" "stub increments counter"

llm_stub_reset
out=$(llm_call "after reset")
check_output "$out" "stub response 1" "stub reset works"

# --- Argument parsing ---

out=$(llm_call "msg" --system "you are helpful" 2>&1); rc=$?
check_exit "$rc" 0 "system prompt accepted"
check_output "$out" "stub response 2" "system prompt doesnt affect stub output"

out=$(llm_call "msg" --model "gpt-4" 2>&1); rc=$?
check_exit "$rc" 0 "model flag accepted"

out=$(llm_call "msg" --backend stub 2>&1); rc=$?
check_exit "$rc" 0 "explicit --backend stub accepted"

# --- Stdin mode ---

llm_stub_reset
out=$(echo "piped input" | llm_call - 2>&1); rc=$?
check_exit "$rc" 0 "stdin mode accepted"
check_output "$out" "stub response 1" "stdin mode returns stub response"

# --- Error cases ---

out=$(llm_call 2>&1) && rc=$? || rc=$?
check_exit "$rc" 1 "missing message fails"
check_contains "$out" "message required" "error message for missing message"

out=$(llm_call "msg" --system 2>&1) && rc=$? || rc=$?
check_exit "$rc" 1 "empty --system fails"

out=$(llm_call "msg" --bogus 2>&1) && rc=$? || rc=$?
check_exit "$rc" 1 "unknown flag fails"
check_contains "$out" "unknown flag" "error message for unknown flag"

out=$(SB_LLM_BACKEND=bogus llm_call "msg" 2>&1) && rc=$? || rc=$?
check_exit "$rc" 1 "unknown backend fails"

summary "llm-call"
