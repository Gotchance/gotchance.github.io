#!/usr/bin/env bash
# Render CV PDF and copy into docs/ for GitHub Pages.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "Rendering CV PDF..."
quarto render cv/cv-pdf.qmd --to pdf

mkdir -p docs/cv

# Quarto typically writes cv/cv-pdf.pdf
if [[ -f cv/cv-pdf.pdf ]]; then
  cp -f cv/cv-pdf.pdf docs/cv/Chansu_Han_CV.pdf
elif [[ -f cv/Chansu_Han_CV.pdf ]]; then
  cp -f cv/Chansu_Han_CV.pdf docs/cv/Chansu_Han_CV.pdf
else
  PDF="$(ls -t cv/*.pdf 2>/dev/null | head -1 || true)"
  if [[ -z "${PDF}" ]]; then
    echo "ERROR: No PDF found under cv/" >&2
    exit 1
  fi
  cp -f "${PDF}" docs/cv/Chansu_Han_CV.pdf
fi

echo "OK: docs/cv/Chansu_Han_CV.pdf ($(wc -c < docs/cv/Chansu_Han_CV.pdf) bytes)"
