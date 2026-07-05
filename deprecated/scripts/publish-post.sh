#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "--describe" ]]; then
  cat <<'JSON'
{ "name": "publish-post", "description": "Generate a blog post from a compound assertion and its dependency tree", "parameters": { "assertion-id": "string (required)", "--slug": "string (optional custom slug)" } }
JSON
  exit 0
fi

# publish-post.sh — Generate a blog post from a compound assertion.
#
# Usage:
#   ./scripts/publish-post.sh <assertion-id> [--slug "custom-slug"]
#
# Requires: scripts/lib/llm-call.sh, scripts/deps.sh, jq, yq

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$REPO_ROOT/scripts/lib/llm-call.sh"

assertion_id=""
custom_slug=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --slug) custom_slug="$2"; shift 2 ;;
    --describe) ;; # already handled above
    -*) echo "Unknown flag: $1" >&2; exit 1 ;;
    *)
      if [[ -z "$assertion_id" ]]; then
        assertion_id="$1"
      fi
      shift ;;
  esac
done

if [[ -z "$assertion_id" ]]; then
  echo "Usage: $0 <assertion-id> [--slug <slug>]" >&2
  exit 1
fi

assertion_file="$REPO_ROOT/assertions/${assertion_id}.md"
if [[ ! -f "$assertion_file" ]]; then
  echo "Error: assertion not found: $assertion_id" >&2
  exit 1
fi

# Verify it's a compound assertion
tier=$(yq -r '.tier // ""' "$assertion_file" 2>/dev/null || true)
if [[ "$tier" != "compound" ]]; then
  echo "Error: $assertion_id is not a compound assertion (tier: ${tier:-unknown})" >&2
  exit 1
fi

# Gather context
context=$("$REPO_ROOT/scripts/context-load.sh" --assertion-id "$assertion_id" 2>/dev/null)

# Build the editorial prompt
claim=$(yq -r '.claim // ""' "$assertion_file" 2>/dev/null || true)
implication=$(yq -r '.implication // ""' "$assertion_file" 2>/dev/null || true)

editorial_system="You are a technical writer for itsjustshell.com, a site that advocates shell-first approaches over over-engineered AI tooling. Your voice is opinionated, concise, and grounded in evidence. No padding, no hedging, no corporate tone.

Write a blog post that argues the thesis expressed in the assertion. Use the evidence from the knowledge base context. Every claim must trace back to the provided evidence.

Output format (exactly):
TITLE: <title>
DESCRIPTION: <one sentence>
TAGS: <comma-separated>
---
<markdown body>"

message="Write a blog post based on this compound assertion.

Claim: $claim
Implication: $implication

$context"

response=$(llm_call "$message" --backend claude --system "$editorial_system")

# Parse the response
post_title=$(echo "$response" | grep '^TITLE:' | sed 's/^TITLE: *//')
post_desc=$(echo "$response" | grep '^DESCRIPTION:' | sed 's/^DESCRIPTION: *//')
post_tags=$(echo "$response" | grep '^TAGS:' | sed 's/^TAGS: *//')
post_body=$(echo "$response" | sed '1,/^---$/d')

# Generate slug
if [[ -n "$custom_slug" ]]; then
  slug="$custom_slug"
else
  slug=$(echo "$post_title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')
fi

# Format tags as Elixir list
tags_elixir=$(echo "$post_tags" | tr ',' '\n' | sed 's/^ *//;s/ *$//' | awk '{printf "\"%s\", ", $0}' | sed 's/, $//')

# Create output path
year=$(date +%Y)
date_slug=$(date +%m-%d)
outdir="$REPO_ROOT/publish/posts/its-just-shell/$year"
mkdir -p "$outdir"
outfile="$outdir/${date_slug}-${slug}.md"

cat > "$outfile" <<EOF
%{
  title: "$post_title",
  description: "$post_desc",
  tags: [$tags_elixir]
}
---
$post_body
EOF

echo "Published: publish/posts/its-just-shell/$year/${date_slug}-${slug}.md" >&2
echo "$outfile"
