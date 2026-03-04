#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "--describe" ]]; then
  cat <<'JSON'
{ "name": "build-index", "description": "Regenerate index.json from sources/ and assertions/ frontmatter", "parameters": {} }
JSON
  exit 0
fi

# build-index.sh — Regenerate index.json from sources/ and assertions/.
# Builds three arrays: sources, assertions, edges (the DAG).
# Edges derived from evidence[].source, deps[], and supersedes wikilinks.
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

sources="[]"
assertions="[]"
edges="[]"

# Collect all known IDs for broken-link detection
all_ids="[]"

# Extract wikilink ID from "[[some-id]]" format
extract_id() {
  echo "$1" | sed 's/^\[\[//; s/\]\]$//'
}

# --- Process sources ---
for mdfile in "$REPO_ROOT"/sources/*.md; do
  [[ -f "$mdfile" ]] || continue

  filename=$(basename "$mdfile" .md)
  relpath="sources/$(basename "$mdfile")"

  frontmatter=$(awk '/^---$/{if(n++)exit;next}n' "$mdfile")
  [[ -z "$frontmatter" ]] && continue

  fm_json=$(echo "$frontmatter" | yq -o=json '.' 2>/dev/null) || continue

  entry=$(echo "$fm_json" | jq --arg id "$filename" --arg file "$relpath" '{
    id: $id,
    type: "source",
    source_type: (.source_type // ""),
    title: (.title // ""),
    tags: (.tags // []),
    file: $file
  }')

  sources=$(echo "$sources" | jq --argjson entry "$entry" '. + [$entry]')
  all_ids=$(echo "$all_ids" | jq --arg id "$filename" '. + [$id]')
done

# --- Process assertions ---
for mdfile in "$REPO_ROOT"/assertions/*.md; do
  [[ -f "$mdfile" ]] || continue

  filename=$(basename "$mdfile" .md)
  relpath="assertions/$(basename "$mdfile")"

  frontmatter=$(awk '/^---$/{if(n++)exit;next}n' "$mdfile")
  [[ -z "$frontmatter" ]] && continue

  fm_json=$(echo "$frontmatter" | yq -o=json '.' 2>/dev/null) || continue

  entry=$(echo "$fm_json" | jq --arg id "$filename" --arg file "$relpath" '{
    id: $id,
    type: "assertion",
    tier: (.tier // "primitive"),
    claim: (.claim // ""),
    confidence: (.confidence // "high"),
    tags: (.tags // []),
    deps: (.deps // []),
    file: $file
  }')

  assertions=$(echo "$assertions" | jq --argjson entry "$entry" '. + [$entry]')
  all_ids=$(echo "$all_ids" | jq --arg id "$filename" '. + [$id]')

  # --- Extract edges from this assertion ---

  # Evidence edges: assertion -> source (only for wikilink sources, not inline strings)
  evidence_links=$(echo "$fm_json" | jq -r '(.evidence // [])[] | .source // empty')
  while IFS= read -r link; do
    [[ -z "$link" ]] && continue
    # Skip inline context strings — only process [[wikilink]] format
    [[ "$link" != "[["* ]] && continue
    target_id=$(extract_id "$link")
    edge=$(jq -n --arg from "$filename" --arg to "$target_id" \
      '{from: $from, to: $to, type: "evidence"}')
    edges=$(echo "$edges" | jq --argjson edge "$edge" '. + [$edge]')
  done <<< "$evidence_links"

  # Dependency edges: compound -> prerequisite assertion
  dep_links=$(echo "$fm_json" | jq -r '(.deps // [])[]')
  while IFS= read -r link; do
    [[ -z "$link" ]] && continue
    target_id=$(extract_id "$link")
    edge=$(jq -n --arg from "$filename" --arg to "$target_id" \
      '{from: $from, to: $to, type: "dependency"}')
    edges=$(echo "$edges" | jq --argjson edge "$edge" '. + [$edge]')
  done <<< "$dep_links"

  # Supersedes edge: new assertion -> old assertion
  supersedes=$(echo "$fm_json" | jq -r '.supersedes // empty')
  if [[ -n "$supersedes" ]]; then
    target_id=$(extract_id "$supersedes")
    edge=$(jq -n --arg from "$filename" --arg to "$target_id" \
      '{from: $from, to: $to, type: "supersedes"}')
    edges=$(echo "$edges" | jq --argjson edge "$edge" '. + [$edge]')
  fi
done

# --- Build final index ---
index=$(jq -n \
  --argjson sources "$sources" \
  --argjson assertions "$assertions" \
  --argjson edges "$edges" \
  '{sources: $sources, assertions: $assertions, edges: $edges}')

echo "$index" | jq '.' > "$INDEX_FILE"

# --- Stats ---
src_count=$(echo "$sources" | jq 'length')
ast_count=$(echo "$assertions" | jq 'length')
edge_count=$(echo "$edges" | jq 'length')
echo "index.json updated: $src_count sources, $ast_count assertions, $edge_count edges"

# --- Warn on broken wikilinks ---
edge_targets=$(echo "$edges" | jq -r '.[].to')
while IFS= read -r target; do
  [[ -z "$target" ]] && continue
  found=$(echo "$all_ids" | jq --arg id "$target" 'any(. == $id)')
  if [[ "$found" != "true" ]]; then
    echo "WARNING: broken wikilink -> [[$target]] (no matching file)" >&2
  fi
done <<< "$edge_targets"
