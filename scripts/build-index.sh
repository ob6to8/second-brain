#!/usr/bin/env bash
set -euo pipefail

# build-index.sh — Regenerate index.json from all note frontmatter.
# Scans .md files (excluding plans/, templates/), extracts YAML frontmatter
# via yq, and writes a JSON array to index.json.
#
# Usage: ./scripts/build-index.sh
#
# Requires: yq, jq

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INDEX_FILE="$REPO_ROOT/index.json"

for dep in yq jq; do
  if ! command -v "$dep" &>/dev/null; then
    echo "Error: '$dep' is required but not installed. Install with: brew install $dep" >&2
    exit 1
  fi
done

entries="[]"

while IFS= read -r -d '' mdfile; do
  # Get path relative to repo root
  relpath="${mdfile#"$REPO_ROOT"/}"

  # Extract frontmatter (between first --- pair) via yq
  frontmatter=$(awk '/^---$/{if(n++)exit;next}n' "$mdfile")

  if [[ -z "$frontmatter" ]]; then
    continue
  fi

  # Parse frontmatter to JSON, add the file path
  entry=$(echo "$frontmatter" | yq -o=json '.' 2>/dev/null) || continue
  entry=$(echo "$entry" | jq --arg file "$relpath" '. + {file: $file}')

  entries=$(echo "$entries" | jq --argjson entry "$entry" '. + [$entry]')
done < <(find "$REPO_ROOT" \
  -name "*.md" \
  -not -path "*/plans/*" \
  -not -path "*/templates/*" \
  -not -path "*/.obsidian/*" \
  -not -name "CLAUDE.md" \
  -not -name "README.md" \
  -print0)

echo "$entries" | jq '.' > "$INDEX_FILE"

count=$(echo "$entries" | jq 'length')
echo "index.json updated: $count entries"
