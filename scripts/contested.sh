#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "--describe" ]]; then
  cat <<'JSON'
{ "name": "contested", "description": "Find contested and low-confidence assertions needing attention", "parameters": {} }
JSON
  exit 0
fi

# contested.sh — Find assertions needing attention.
# Lists contested and low-confidence assertions.
#
# Usage: ./scripts/contested.sh
#
# Requires: jq

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INDEX_FILE="$REPO_ROOT/index.json"

if [[ ! -f "$INDEX_FILE" ]]; then
  echo "Error: index.json not found. Run ./scripts/build-index.sh first." >&2
  exit 1
fi

echo "=== Contested Assertions ==="
echo ""

contested=$(jq -r '
  .assertions[] | select(.confidence == "contested") |
  "\(.id) | \(.claim)"
' "$INDEX_FILE")

if [[ -z "$contested" ]]; then
  echo "(none)"
else
  echo "$contested"
fi

echo ""
echo "=== Low-Confidence Assertions ==="
echo ""

low=$(jq -r '
  .assertions[] | select(.confidence == "low") |
  "\(.id) | \(.claim)"
' "$INDEX_FILE")

if [[ -z "$low" ]]; then
  echo "(none)"
else
  echo "$low"
fi

echo ""
echo "=== Potential Contradictions ==="
echo "(assertions with overlapping tags and opposing confidence levels)"
echo ""

# Find pairs where one is high-confidence and another is contested on the same tags
contradictions=$(jq -r '
  [.assertions[] | select(.confidence == "high" or .confidence == "contested")] |
  . as $all |
  [range(length)] | .[] as $i |
  [range($i+1; ($all | length))] | .[] as $j |
  $all[$i] as $a | $all[$j] as $b |
  select(
    $a.confidence != $b.confidence and
    ([$a.tags[], $b.tags[]] | group_by(.) | map(select(length > 1)) | length > 0)
  ) |
  "\($a.id) [\($a.confidence)] vs \($b.id) [\($b.confidence)]"
' "$INDEX_FILE" 2>/dev/null)

if [[ -z "$contradictions" ]]; then
  echo "(none found)"
else
  echo "$contradictions"
fi
