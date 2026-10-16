#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""scan_oral.py — flag banned jargon + long Chinese sentences in oral drafts.

Dependency-free. Usage:
  python3 scripts/scan_oral.py path/to/oral.md
  cat oral.md | python3 scripts/scan_oral.py
  python3 scripts/scan_oral.py -   # stdin (cwd irrelevant; jargon path is next to script)

Exit 0 always (report-only). Prints hits; "OK" if none.
Word list: ../references/banned-corp-jargon.md (core line + variant left column).
Long sentence: >20 Chinese chars between punctuation (，。！？； and newlines).
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
JARGON_PATH = ROOT / "references" / "banned-corp-jargon.md"
DEFAULT_MAX_CN = 20
SPLIT_RE = re.compile(r"[，。！？；\n]+")
CN_RE = re.compile(r"[\u4e00-\u9fff]")


def load_jargon(path: Path) -> list[str]:
    if not path.is_file():
        print(f"WARN: jargon file missing: {path}", file=sys.stderr)
        return []
    text = path.read_text(encoding="utf-8")
    terms: list[str] = []
    core_m = re.search(r"## 核心禁写[^\n]*\n+([^\n#]+)", text)
    if core_m:
        for t in re.split(r"[、，,\s]+", core_m.group(1).strip()):
            t = t.strip()
            t = re.sub(r"[（(][^）)]*[）)]", "", t).strip()
            if t:
                terms.append(t)
    for line in text.splitlines():
        if not line.startswith("|"):
            continue
        if "变体" in line or "---" in line or "近义" in line:
            continue
        cells = [c.strip() for c in line.strip("|").split("|")]
        if not cells or not cells[0]:
            continue
        for t in re.split(r"\s*/\s*", cells[0]):
            t = t.strip()
            if t:
                terms.append(t)
    return sorted(set(terms), key=lambda x: (-len(x), x))


def cn_len(s: str) -> int:
    return len(CN_RE.findall(s))


def scan(text: str, terms: list[str], max_cn: int) -> list[str]:
    hits: list[str] = []
    lines = text.splitlines() or [text]
    for i, line in enumerate(lines, 1):
        for term in terms:
            if term and term in line:
                hits.append(f"L{i} JARGON {term!r}: {line.strip()[:80]}")
        for part in SPLIT_RE.split(line):
            part = part.strip()
            if not part:
                continue
            n = cn_len(part)
            if n > max_cn:
                preview = part[:60] + ("…" if len(part) > 60 else "")
                hits.append(f"L{i} LONG {n}cn>{max_cn}: {preview}")
    return hits


def main() -> int:
    ap = argparse.ArgumentParser(description="Scan oral text for jargon + long sentences")
    ap.add_argument("path", nargs="?", default="-", help="file path or - for stdin")
    ap.add_argument("--max-cn", type=int, default=DEFAULT_MAX_CN)
    args = ap.parse_args()

    if args.path == "-":
        text = sys.stdin.read()
        label = "stdin"
    else:
        p = Path(args.path)
        text = p.read_text(encoding="utf-8")
        label = str(p)

    terms = load_jargon(JARGON_PATH)
    hits = scan(text, terms, args.max_cn)
    print(f"# scan_oral: {label} (terms={len(terms)}, max_cn={args.max_cn})")
    if not hits:
        print("OK")
        return 0
    for h in hits:
        print(h)
    print(f"# {len(hits)} hit(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
