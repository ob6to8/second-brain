#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "--describe" ]]; then
  cat <<'JSON'
{ "name": "orphans", "description": "Find unconnected nodes: assertions with no dependents, sources with no evidence links", "parameters": {} }
JSON
  exit 0
fi

# orphans.sh — Find unconnected nodes in the knowledge DAG.
# Lists assertions with no dependents and sources with no evidence links.
#
# Usage: ./scripts/orphans.sh
#
# Requires: jq

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INDEX_FILE="$REPO_ROOT/index.json"

if [[ ! -f "$INDEX_FILE" ]]; then
  echo "Error: index.json not found. Run ./scripts/build-index.sh first." >&2
  exit 1
fi

# Orphan assertions: no other assertion depends on them (not in any deps[] or edge target)
echo "=== Orphan Assertions ==="
echo "(assertions nothing depends on)"
echo ""

orphan_assertions=$(jq -r '
  .assertions as $all |
  .edges as $edges |
  $all[] |
  select(
    .id as $id |
    ($edges | map(select(.to == $id and .type == "dependency")) | length) == 0
  ) |
  "\(.tier) | \(.id) | \(.claim)"
' "$INDEX_FILE")

if [[ -z "$orphan_assertions" ]]; then
  echo "(none)"
else
  echo "$orphan_assertions"
fi

echo ""
echo "=== Orphan Sources ==="
echo "(sources no assertion cites as evidence)"
echo ""

orphan_sources=$(jq -r '
  .sources as $all |
  .edges as $edges |
  $all[] |
  select(
    .id as $id |
    ($edges | map(select(.to == $id and .type == "evidence")) | length) == 0
  ) |
  "\(.source_type) | \(.id) | \(.title)"
' "$INDEX_FILE")

if [[ -z "$orphan_sources" ]]; then
  echo "(none)"
else
  echo "$orphan_sources"
fi
