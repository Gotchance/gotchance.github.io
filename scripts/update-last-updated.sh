#!/usr/bin/env bash
# Update website page-footer "Last updated" date before Quarto render.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
YML="$ROOT/_quarto.yml"
TODAY="$(TZ=Asia/Tokyo date +%Y-%m-%d)"

if [[ ! -f "$YML" ]]; then
  echo "ERROR: $YML not found" >&2
  exit 1
fi

# macOS and GNU sed compatible in-place edit
tmp="$(mktemp)"
sed -E "s/(center: \"Last updated: )[0-9]{4}-[0-9]{2}-[0-9]{2}(\")/\1${TODAY}\2/" "$YML" > "$tmp"
mv "$tmp" "$YML"

echo "OK: Last updated → ${TODAY}"
