#!/usr/bin/env bash
# Copy slides/YYYY → docs/slides/YYYY for GitHub Pages (Quarto cleans docs/).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${ROOT}/slides"
DST="${ROOT}/docs/slides"

if [[ ! -d "$SRC" ]]; then
  echo "OK: no slides/ directory; skip"
  exit 0
fi

mkdir -p "$DST"
rsync -a --delete --exclude '.DS_Store' "${SRC}/" "${DST}/"
echo "OK: synced slides/ → docs/slides/"
