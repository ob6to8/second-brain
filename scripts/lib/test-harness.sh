#!/usr/bin/env bash
# scripts/lib/test-harness.sh — Test framework
#
# Ported from shellclaw test/test_harness.sh.
# Provides assertion functions and summary reporter.
#
# Usage:
#   source scripts/lib/test-harness.sh
#   setup_tmpdir
#   check_output "$(echo hi)" "hi" "echo works"
#   summary "my tests"

_TESTS_RUN=0
_TESTS_PASSED=0
_TESTS_FAILED=0
_CURRENT_TEST=""

if [[ -t 1 ]]; then
    _RED='\033[0;31m'
    _GREEN='\033[0;32m'
    _BOLD='\033[1m'
    _NC='\033[0m'
else
    _RED='' _GREEN='' _BOLD='' _NC=''
fi

_test_start() { _CURRENT_TEST="$1"; _TESTS_RUN=$(( _TESTS_RUN + 1 )); }

_test_pass() {
    _TESTS_PASSED=$(( _TESTS_PASSED + 1 ))
    printf "  ${_GREEN}PASS${_NC} %s\n" "$_CURRENT_TEST"
}

_test_fail() {
    local detail="$1"
    _TESTS_FAILED=$(( _TESTS_FAILED + 1 ))
    printf "  ${_RED}FAIL${_NC} %s" "$_CURRENT_TEST"
    [[ -n "$detail" ]] && printf ": %s" "$detail"
    printf "\n"
}

# --- Assertions ---

check_exit() {
    local actual="$1"
    local expected="$2"
    local label="${3:-exit code $expected}"
    _test_start "$label"
    if [[ "$actual" -eq "$expected" ]]; then _test_pass; else _test_fail "expected exit $expected, got $actual"; fi
}

check_output() {
    local actual="$1"
    local expected="$2"
    local label="${3:-output match}"
    _test_start "$label"
    if [[ "$actual" == "$expected" ]]; then _test_pass; else _test_fail "expected '$expected', got '$actual'"; fi
}

check_contains() {
    local haystack="$1"
    local needle="$2"
    local label="${3:-contains \"$needle\"}"
    _test_start "$label"
    if [[ "$haystack" == *"$needle"* ]]; then _test_pass; else _test_fail "output does not contain '$needle'"; fi
}

check_not_contains() {
    local haystack="$1"
    local needle="$2"
    local label="${3:-not contains \"$needle\"}"
    _test_start "$label"
    if [[ "$haystack" != *"$needle"* ]]; then _test_pass; else _test_fail "output should not contain '$needle'"; fi
}

check_file_exists() {
    local path="$1"
    local label="${2:-file exists: $path}"
    _test_start "$label"
    if [[ -f "$path" ]]; then _test_pass; else _test_fail "file not found: $path"; fi
}

check_json_field() {
    local json="$1"
    local field="$2"
    local expected="$3"
    local label="${4:-json .$field == $expected}"
    _test_start "$label"
    local actual
    actual=$(printf '%s' "$json" | jq -r ".$field")
    if [[ "$actual" == "$expected" ]]; then _test_pass; else _test_fail ".$field: expected '$expected', got '$actual'"; fi
}

# --- Setup / Teardown ---

setup_tmpdir() {
    TEST_TMPDIR=$(mktemp -d)
    trap 'rm -rf "$TEST_TMPDIR"' EXIT
}

# --- Reporter ---

summary() {
    local label="${1:-Tests}"
    echo ""
    printf -- "${_BOLD}--- %s ---${_NC}\n" "$label"
    printf "  Run:    %d\n" "$_TESTS_RUN"
    printf "  ${_GREEN}Passed: %d${_NC}\n" "$_TESTS_PASSED"
    if [[ "$_TESTS_FAILED" -gt 0 ]]; then
        printf "  ${_RED}Failed: %d${_NC}\n" "$_TESTS_FAILED"
        exit 1
    else
        printf "  Failed: 0\n"
        exit 0
    fi
}
