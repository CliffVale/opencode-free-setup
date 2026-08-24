#!/usr/bin/env python3
"""pdf-to-markdown.py — extract text/tables from academic PDFs to Markdown.

Uses PyMuPDF (lightweight, ~60MB, no ML deps) to convert a PDF into clean
Markdown: heading hierarchy (by font size), paragraphs, tables (find_tables),
and inline image markers. This is the ingestion helper for ai-engineer Mode A:
PDFs fetched during research become readable Markdown the agent actually reads.

(Original plan used `unstructured`, but its PDF partition hard-requires the
unstructured-inference ML stack — torch + CUDA, multi-GB. PyMuPDF does the same
job at ~1/10 the footprint. ponytail: simplest thing that works.)

Usage:
  ~/.local/share/ai-engineer/.venv-pdf/bin/python pdf-to-markdown.py <input.pdf> [output.md]

Output (default): <input>.md next to the PDF, or the path given as second arg.
Exit codes: 0 ok, 1 missing input, 2 parse error.
"""

import argparse
import sys
from pathlib import Path


def heading_level(size: float, base: float) -> int:
    """Map a font size to a markdown heading level relative to body text."""
    ratio = size / base
    if ratio >= 1.6:
        return 1
    if ratio >= 1.3:
        return 2
    if ratio >= 1.12:
        return 3
    return 0  # body


def extract(input_pdf: Path, output_md: Path) -> list[str]:
    import fitz  # PyMuPDF

    doc = fitz.open(str(input_pdf))

    # Determine body font size from the most common size on page 1
    sizes: dict[float, int] = {}
    for block in doc[0].get_text("dict")["blocks"]:
        for line in block.get("lines", []):
            for span in line.get("spans", []):
                sizes[round(span["size"], 1)] = sizes.get(round(span["size"], 1), 0) + len(span["text"])
    body_size = max(sizes, key=sizes.get) if sizes else 10.0

    lines: list[str] = []
    titles: list[str] = []
    for page_no, page in enumerate(doc, 1):
        # tables first (they'd otherwise mangle the text flow)
        for tab in page.find_tables().tables:
            rows = tab.extract()
            if not rows:
                continue
            lines.append("| " + " | ".join(str(c or "").replace("|", "\\|") for c in rows[0]) + " |")
            lines.append("|" + "---|" * len(rows[0]))
            for row in rows[1:]:
                lines.append("| " + " | ".join(str(c or "").replace("|", "\\|") for c in row) + " |")
            lines.append("")

        blocks = page.get_text("dict")["blocks"]
        for block in blocks:
            if block.get("type") == 1:  # image block
                lines.append(f"*[image on page {page_no}]*\n")
                continue
            for line in block.get("lines", []):
                spans = line.get("spans", [])
                if not spans:
                    continue
                text = "".join(s["text"] for s in spans).strip()
                if not text:
                    continue
                size = max(s["size"] for s in spans)
                lvl = heading_level(size, body_size)
                if lvl:
                    title = text.strip()
                    titles.append(title)
                    lines.append(f"\n{'#' * lvl} {title}\n")
                else:
                    lines.append(text)

    output_md.parent.mkdir(parents=True, exist_ok=True)
    # errors="replace": never let a stray non-UTF8 byte from a PDF kill the write
    output_md.write_text("\n\n".join(lines) + "\n", encoding="utf-8", errors="replace")
    doc.close()
    return titles


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("input", help="path to input PDF")
    ap.add_argument("output", nargs="?", default=None, help="output .md path (default: <input>.md)")
    args = ap.parse_args()

    src = Path(args.input)
    if not src.exists():
        print(f"ERROR: input not found: {src}", file=sys.stderr)
        return 1
    if src.suffix.lower() != ".pdf":
        print(f"ERROR: not a PDF: {src}", file=sys.stderr)
        return 1

    out = Path(args.output) if args.output else src.with_suffix(".md")
    try:
        titles = extract(src, out)
    except Exception as e:  # noqa: BLE001 — surface any parse failure
        print(f"ERROR: extraction failed: {e}", file=sys.stderr)
        return 2

    print(f"OK: {len(titles)} headings → {out}")
    for t in titles[:20]:
        print(f"  - {t}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
