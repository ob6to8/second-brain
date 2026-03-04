#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "--describe" ]]; then
  cat <<'JSON'
{ "name": "query", "description": "Search the knowledge base by tag, claim, type, tier, confidence, or full-text", "parameters": { "tag": "string", "claim": "string", "type": "source|assertion", "tier": "primitive|compound", "text": "string", "confidence": "string" } }
JSON
  exit 0
fi

# query.sh — Search the knowledge base.
# Queries index.json via jq, falls back to rg for full-text search.
#
# Usage:
#   ./scripts/query.sh --tag <tag>                    # search by tag
#   ./scripts/query.sh --claim <text>                 # search assertion claims
#   ./scripts/query.sh --type <source|assertion>      # filter by type
#   ./scripts/query.sh --tier <primitive|compound>    # filter assertions by tier
#   ./scripts/query.sh --text <pattern>               # full-text search across all files
#   ./scripts/query.sh --confidence <level>           # filter by confidence
#
# Flags can be combined: --type assertion --tier compound --tag ai
#
# Requires: jq, rg (for --text)

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INDEX_FILE="$REPO_ROOT/index.json"

if [[ ! -f "$INDEX_FILE" ]]; then
  echo "Error: index.json not found. Run ./scripts/build-index.sh first." >&2
  exit 1
fi

# Parse arguments
tag="" claim="" type="" tier="" text="" confidence=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tag)        tag="$2"; shift 2 ;;
    --claim)      claim="$2"; shift 2 ;;
    --type)       type="$2"; shift 2 ;;
    --tier)       tier="$2"; shift 2 ;;
    --text)       text="$2"; shift 2 ;;
    --confidence) confidence="$2"; shift 2 ;;
    -h|--help)
      echo "Usage: $0 [--tag TAG] [--claim TEXT] [--type TYPE] [--tier TIER] [--text PATTERN] [--confidence LEVEL]"
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

# Full-text search via rg
if [[ -n "$text" ]]; then
  echo "Full-text search: \"$text\""
  echo "---"
  if command -v rg &>/dev/null; then
    rg -il "$text" "$REPO_ROOT/sources/" "$REPO_ROOT/assertions/" 2>/dev/null \
      | sed "s|$REPO_ROOT/||" \
      || echo "(no matches)"
  else
    grep -ril "$text" "$REPO_ROOT/sources/" "$REPO_ROOT/assertions/" 2>/dev/null \
      | sed "s|$REPO_ROOT/||" \
      || echo "(no matches)"
  fi
  exit 0
fi

# Build jq filter for index.json queries
# Merge sources and assertions into one stream, then filter
filter='[.sources[], .assertions[]]'
conditions=()

if [[ -n "$tag" ]]; then
  conditions+=("(.tags | map(ascii_downcase) | any(. == (\"$tag\" | ascii_downcase)))")
fi

if [[ -n "$claim" ]]; then
  conditions+=("(.claim // \"\" | ascii_downcase | contains(\"$claim\" | ascii_downcase))")
fi

if [[ -n "$type" ]]; then
  conditions+=("(.type == \"$type\")")
fi

if [[ -n "$tier" ]]; then
  conditions+=("(.tier == \"$tier\")")
fi

if [[ -n "$confidence" ]]; then
  conditions+=("(.confidence == \"$confidence\")")
fi

if [[ ${#conditions[@]} -eq 0 ]]; then
  echo "Error: at least one filter flag is required. Use --help for usage." >&2
  exit 1
fi

# Join conditions with "and"
combined=""
for cond in "${conditions[@]}"; do
  if [[ -z "$combined" ]]; then
    combined="$cond"
  else
    combined="$combined and $cond"
  fi
done

filter="$filter | map(select($combined))"

results=$(jq "$filter" "$INDEX_FILE")
count=$(echo "$results" | jq 'length')

if [[ "$count" -eq 0 ]]; then
  echo "(no matches)"
  exit 0
fi

# Display results
echo "$results" | jq -r '.[] | "\(.type) | \(.id) | \(.title // .claim)"'
echo "---"
echo "$count result(s)"
