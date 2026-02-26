#!/usr/bin/env bash
set -euo pipefail

# ingest.sh — Fetch raw content from a URL and print to stdout.
# Claude handles frontmatter generation, tagging, and file placement.
#
# Usage: ./scripts/ingest.sh <url>
#
# Detects content type:
#   - YouTube URLs → transcript via yt-dlp
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
elif is_arxiv "$url"; then
  echo "# Content-Type: paper" >&2
  fetch_arxiv "$url"
else
  echo "# Content-Type: article" >&2
  fetch_article "$url"
fi
