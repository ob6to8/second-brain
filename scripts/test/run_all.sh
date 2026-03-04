#!/usr/bin/env bash
set -euo pipefail

# run_all.sh — Discover and run all test_*.sh scripts

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
total=0
passed=0
failed=0
failed_tests=()

for test_file in "$SCRIPT_DIR"/test_*.sh; do
  [[ -f "$test_file" ]] || continue
  name=$(basename "$test_file")
  total=$((total + 1))

  echo "=== $name ==="
  if bash "$test_file"; then
    passed=$((passed + 1))
  else
    failed=$((failed + 1))
    failed_tests+=("$name")
  fi
  echo ""
done

echo "=============================="
echo "Total: $total  Passed: $passed  Failed: $failed"
if [[ $failed -gt 0 ]]; then
  echo "Failed tests:"
  for t in "${failed_tests[@]}"; do
    echo "  - $t"
  done
  exit 1
fi
exit 0
