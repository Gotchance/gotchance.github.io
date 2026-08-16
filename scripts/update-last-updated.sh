#!/usr/bin/env bash
# Update "Last updated" date (Asia/Tokyo) before Quarto render.
# Targets: website footer (_quarto.yml) and CV PDF footer (cv/cv-pdf.qmd).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TODAY="$(TZ=Asia/Tokyo date +%Y-%m-%d)"

update_file() {
  local file="$1"
  local pattern="$2"
  if [[ ! -f "$file" ]]; then
    echo "ERROR: $file not found" >&2
    exit 1
  fi
  local tmp
  tmp="$(mktemp)"
  sed -E "$pattern" "$file" > "$tmp"
  mv "$tmp" "$file"
}

update_file "$ROOT/_quarto.yml" \
  "s/(center: \"Last updated: )[0-9]{4}-[0-9]{2}-[0-9]{2}(\")/\1${TODAY}\2/"

update_file "$ROOT/cv/cv-pdf.qmd" \
  "s/(Last updated: )[0-9]{4}-[0-9]{2}-[0-9]{2}/\1${TODAY}/"

echo "OK: Last updated → ${TODAY} (website + CV PDF)"
