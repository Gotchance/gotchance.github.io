#!/usr/bin/env bash
# Prefer project venv when present (has PyYAML).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
if [[ -x "$ROOT/.venv/bin/python" ]]; then
  exec "$ROOT/.venv/bin/python" "$ROOT/scripts/render-conference-table.py"
fi
exec python3 "$ROOT/scripts/render-conference-table.py"
