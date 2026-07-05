#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "--describe" ]]; then
  cat <<'JSON'
{ "name": "publish-research", "description": "Generate a research item from a source with three thesis-grounded bullets", "parameters": { "source-id": "string (required)" } }
JSON
  exit 0
fi

# publish-research.sh — Generate a research item from a source.
#
# Usage:
#   ./scripts/publish-research.sh <source-id>
#
# Requires: scripts/lib/llm-call.sh, yq, jq

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$REPO_ROOT/scripts/lib/llm-call.sh"

source_id=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --describe) ;; # already handled above
    -*) echo "Unknown flag: $1" >&2; exit 1 ;;
    *)
      if [[ -z "$source_id" ]]; then
        source_id="$1"
      fi
      shift ;;
  esac
done

if [[ -z "$source_id" ]]; then
  echo "Usage: $0 <source-id>" >&2
  exit 1
fi

source_file="$REPO_ROOT/sources/${source_id}.md"
if [[ ! -f "$source_file" ]]; then
  echo "Error: source not found: $source_id" >&2
  exit 1
fi

# Read source frontmatter
title=$(yq -r '.title // ""' "$source_file" 2>/dev/null || true)
url=$(yq -r '.url // ""' "$source_file" 2>/dev/null || true)
source_type=$(yq -r '.source_type // "post"' "$source_file" 2>/dev/null || true)
date_published=$(yq -r '.date_published // ""' "$source_file" 2>/dev/null || true)
authors_json=$(yq -c '.authors // []' "$source_file" 2>/dev/null || echo '[]')
summary=$(yq -r '.summary // ""' "$source_file" 2>/dev/null || true)

# Read body content
body=$(awk 'BEGIN{skip=0} /^---$/{skip++; next} skip>=2{print}' "$source_file")

# Derive source name from authors or title
source_name=$(echo "$authors_json" | jq -r '.[0] // ""' 2>/dev/null || true)
if [[ -z "$source_name" ]]; then
  source_name="$title"
fi

# Format published date
published_display="$date_published"
if [[ -n "$date_published" ]]; then
  # Try to format as "Month YYYY"
  published_display=$(date -j -f "%Y-%m-%d" "$date_published" "+%B %Y" 2>/dev/null || echo "$date_published")
fi

# Generate bullets via LLM
bullet_prompt="Given this source content, write exactly 3 concise bullet points that connect this resource to the thesis: shell-first approaches are undervalued, and most AI/MCP tooling over-engineers what shell scripts already solve.

Each bullet should:
- Be 1-2 sentences
- Connect the source content to the shell-first thesis
- Be specific, not generic

Source title: $title
Source summary: $summary
Source content (excerpt):
$(echo "$body" | head -100)

Output as JSON: {\"source_name\": \"$source_name\", \"type\": \"$source_type\", \"bullets\": [\"...\", \"...\", \"...\"]}"

response=$(llm_call "$bullet_prompt" --backend claude --system "You generate research annotations for itsjustshell.com. Output only valid JSON, no markdown fences.")

# Parse response
bullets=$(echo "$response" | jq -r '.bullets[]' 2>/dev/null || true)
resp_source=$(echo "$response" | jq -r '.source_name // ""' 2>/dev/null || true)
resp_type=$(echo "$response" | jq -r '.type // "post"' 2>/dev/null || true)

[[ -n "$resp_source" ]] && source_name="$resp_source"
[[ -n "$resp_type" ]] && source_type="$resp_type"

# Generate slug
slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')

# Create output path
year=$(date +%Y)
date_slug=$(date +%m-%d)
outdir="$REPO_ROOT/publish/research/its-just-shell/$year"
mkdir -p "$outdir"
outfile="$outdir/${date_slug}-${slug}.md"

# Format bullets as markdown list
bullet_md=""
if [[ -n "$bullets" ]]; then
  while IFS= read -r bullet; do
    bullet_md="$bullet_md- $bullet
"
  done <<< "$bullets"
else
  bullet_md="- (bullets not generated — review source manually)
"
fi

cat > "$outfile" <<EOF
%{
  title: "$title",
  url: "$url",
  source: "$source_name",
  published: "$published_display",
  type: "$source_type"
}
---
$bullet_md
EOF

echo "Published: publish/research/its-just-shell/$year/${date_slug}-${slug}.md" >&2
echo "$outfile"
