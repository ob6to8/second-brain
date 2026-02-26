#!/usr/bin/env bash
set -euo pipefail

# ingest.sh — Fetch raw content from a URL and print to stdout.
# Claude handles frontmatter generation, tagging, and file placement.
#
# Usage: ./scripts/ingest.sh <url>
#
# Detects content type:
#   - YouTube URLs → transcript via yt-dlp
#   - Reddit URLs  → post + comments via JSON API
#   - arxiv URLs   → PDF abstract page (text extraction)
#   - Everything else → article text via curl

usage() {
  echo "Usage: $0 <url>" >&2
  exit 1
}

check_dep() {
  if ! command -v "$1" &>/dev/null; then
    echo "Error: '$1' is required but not installed. Install with: brew install $1" >&2
    exit 1
  fi
}

is_youtube() {
  local url="$1"
  [[ "$url" =~ (youtube\.com|youtu\.be) ]]
}

is_reddit() {
  local url="$1"
  [[ "$url" =~ (reddit\.com|redd\.it) ]]
}

is_arxiv() {
  local url="$1"
  [[ "$url" =~ arxiv\.org ]]
}

fetch_youtube() {
  local url="$1"
  check_dep yt-dlp

  # Extract transcript (auto-generated or manual) as plain text
  local tmpdir
  tmpdir=$(mktemp -d)
  trap 'rm -rf "$tmpdir"' EXIT

  yt-dlp \
    --write-auto-sub \
    --sub-lang en \
    --skip-download \
    --sub-format vtt \
    -o "$tmpdir/transcript" \
    "$url" 2>/dev/null

  local vtt_file
  vtt_file=$(find "$tmpdir" -name "*.vtt" | head -1)

  if [[ -z "$vtt_file" ]]; then
    echo "Error: No English transcript found for this video." >&2
    exit 1
  fi

  # Strip VTT formatting: remove headers, timestamps, duplicates
  awk '
    /^[0-9]{2}:[0-9]{2}/ { next }
    /^$/ { next }
    /^WEBVTT/ { next }
    /^Kind:/ { next }
    /^Language:/ { next }
    /^NOTE/ { next }
    !seen[$0]++ { print }
  ' "$vtt_file"
}

fetch_reddit() {
  local url="$1"
  check_dep jq

  # Strip trailing slash, append .json
  local json_url
  json_url="${url%/}.json"

  local raw
  raw=$(curl -sL --max-time 30 -A "Mozilla/5.0 (compatible; SecondBrain/1.0)" "$json_url")

  # Extract post title and body
  local title selftext author
  title=$(echo "$raw" | jq -r '.[0].data.children[0].data.title // empty')
  selftext=$(echo "$raw" | jq -r '.[0].data.children[0].data.selftext // empty')
  author=$(echo "$raw" | jq -r '.[0].data.children[0].data.author // empty')

  echo "# $title"
  echo ""
  echo "**Author:** u/$author"
  echo ""
  echo "$selftext"
  echo ""

  # Extract top-level comments (skip AutoModerator, limit to top 15)
  local comments
  comments=$(echo "$raw" | jq -r '
    [.[1].data.children[]
     | select(.kind == "t1")
     | .data
     | select(.author != "AutoModerator")
    ] | sort_by(-.score) | .[:15][] |
    "---\n**\(.author)** (score: \(.score)):\n\(.body)\n"
  ' 2>/dev/null)

  if [[ -n "$comments" ]]; then
    echo "## Comments"
    echo ""
    echo "$comments"
  fi
}

fetch_article() {
  local url="$1"

  # Fetch HTML and convert to readable text
  # Falls back to raw HTML dump if pandoc unavailable
  local html
  html=$(curl -sL --max-time 30 -A "Mozilla/5.0 (compatible; SecondBrain/1.0)" "$url")

  if command -v pandoc &>/dev/null; then
    echo "$html" | pandoc -f html -t plain --wrap=none 2>/dev/null
  else
    # Rough text extraction: strip tags, decode entities
    echo "$html" | sed 's/<[^>]*>//g' | sed 's/&amp;/\&/g; s/&lt;/</g; s/&gt;/>/g; s/&quot;/"/g; s/&#39;/'"'"'/g'
  fi
}

fetch_arxiv() {
  local url="$1"

  # Convert arxiv abstract URL to abs page if given a PDF link
  local abs_url
  abs_url="${url//\/pdf\///abs/}"

  fetch_article "$abs_url"
}

# --- Main ---

[[ $# -lt 1 ]] && usage

url="$1"

if is_youtube "$url"; then
  echo "# Content-Type: video" >&2
  fetch_youtube "$url"
elif is_reddit "$url"; then
  echo "# Content-Type: article" >&2
  fetch_reddit "$url"
elif is_arxiv "$url"; then
  echo "# Content-Type: paper" >&2
  fetch_arxiv "$url"
else
  echo "# Content-Type: article" >&2
  fetch_article "$url"
fi
