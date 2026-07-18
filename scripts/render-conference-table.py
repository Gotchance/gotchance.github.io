#!/usr/bin/env python3
"""Generate conferences/_list.qmd from conferences/data/conferences.yml."""

from __future__ import annotations

import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    sys.stderr.write(
        "PyYAML is required. Install with:\n"
        "  python3 -m pip install pyyaml\n"
        "or use the project venv:\n"
        "  .venv/bin/python scripts/render-conference-table.py\n"
    )
    sys.exit(1)

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "conferences" / "data" / "conferences.yml"
OUT = ROOT / "conferences" / "_list.qmd"

H5_ICON = (
    '<i class="bi bi-bar-chart-line" title="h5-index" aria-label="h5-index"></i>'
)


def fmt_conf(item: dict) -> str:
    name = item["name"]
    if item.get("tier") is not None:
        name = f"{name} (T{item['tier']})"
    if item.get("h5"):
        name = f"{name} [{H5_ICON}]({item['h5']})"
    return name


def fmt_edition(ed: dict | None) -> str:
    if not ed:
        return ""
    label = ed.get("label") or ""
    url = ed.get("url")
    dl = ed.get("dl")
    cell = f"[{label}]({url})" if url else label
    if dl:
        cell += f"<br>DL: {dl}"
    return cell


def render(data: dict) -> str:
    years = [int(y) for y in data["years"]]
    header = ["Conf", "Approx. DL", *[str(y) for y in years]]
    sep = [":-----", ":-----------", *[":-----" for _ in years]]

    lines = [
        "<!-- Generated from conferences/data/conferences.yml — edit the YAML, not this file. -->",
        "",
        "## Conference List (Computer Security)",
        "",
        "::: {.table-scroll .table-scroll-wide}",
        "|" + "|".join(header) + "|",
        "|" + "|".join(sep) + "|",
    ]

    for item in data["conferences"]:
        if item.get("type") == "section":
            cells = [f"**{item['label']}**", *([""] * (1 + len(years)))]
            lines.append("|" + "|".join(cells) + "|")
            continue

        editions = item.get("editions") or {}
        year_cells = []
        for y in years:
            ed = editions.get(y)
            if ed is None:
                ed = editions.get(str(y))
            year_cells.append(fmt_edition(ed))

        cells = [
            fmt_conf(item),
            item.get("approx_dl") or "",
            *year_cells,
        ]
        lines.append("|" + "|".join(cells) + "|")

    lines.append(":::")
    lines.append("")
    return "\n".join(lines)


def main() -> None:
    data = yaml.safe_load(DATA.read_text(encoding="utf-8"))
    if not data or "conferences" not in data:
        sys.stderr.write(f"Invalid data file: {DATA}\n")
        sys.exit(1)
    OUT.write_text(render(data), encoding="utf-8")
    print(f"OK: {OUT.relative_to(ROOT)} ({OUT.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
