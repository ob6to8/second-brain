#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
source "$REPO_ROOT/scripts/lib/test-harness.sh"

scripts=(
  "$REPO_ROOT/scripts/query.sh"
  "$REPO_ROOT/scripts/deps.sh"
  "$REPO_ROOT/scripts/orphans.sh"
  "$REPO_ROOT/scripts/contested.sh"
  "$REPO_ROOT/scripts/build-index.sh"
  "$REPO_ROOT/scripts/ingest.sh"
  "$REPO_ROOT/scripts/context-load.sh"
  "$REPO_ROOT/scripts/thread.sh"
  "$REPO_ROOT/scripts/export-conversation.sh"
  "$REPO_ROOT/scripts/publish-post.sh"
  "$REPO_ROOT/scripts/publish-research.sh"
)

for script in "${scripts[@]}"; do
  name=$(basename "$script" .sh)

  out=$("$script" --describe 2>&1); rc=$?
  check_exit "$rc" 0 "$name --describe exits 0"

  echo "$out" | jq . >/dev/null 2>&1; rc=$?
  check_exit "$rc" 0 "$name --describe outputs valid JSON"

  json_name=$(echo "$out" | jq -r '.name')
  check_output "$json_name" "$name" "$name --describe has correct name"
done

summary "--describe"
