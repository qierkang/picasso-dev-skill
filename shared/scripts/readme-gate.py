#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path


SECTION_GROUPS = [
    ("项目概述", ["项目概述"]),
    ("核心特色", ["核心特色"]),
    ("在线演示 / 效果预览", ["在线演示 / 效果预览", "在线演示", "效果预览"]),
    ("项目状态", ["项目状态"]),
    ("功能模块", ["功能模块"]),
    ("技术栈", ["技术栈"]),
    ("系统架构", ["系统架构"]),
    ("目录结构", ["目录结构"]),
    ("快速开始", ["快速开始"]),
    ("开发指南", ["开发指南"]),
    ("测试与构建", ["测试与构建"]),
    ("部署说明", ["部署说明"]),
    ("Roadmap", ["Roadmap", "路线图"]),
    ("常见问题", ["常见问题", "FAQ"]),
    ("贡献与协作", ["贡献与协作", "贡献指南", "Contributing"]),
    ("安全说明", ["安全说明", "Security"]),
    ("许可证", ["许可证", "License"]),
    ("维护者", ["维护者"]),
]

HEADING_RE = re.compile(r"^(#{1,6})\s+(.*\S)\s*$")
PLACEHOLDERS = ("{{", "}}", "TODO", "待补充", "占位")


def normalize(text: str) -> str:
    return re.sub(r"\s+", "", text).lower()


def extract_headings(content: str) -> list[str]:
    headings: list[str] = []
    for line in content.splitlines():
        match = HEADING_RE.match(line.strip())
        if match:
            headings.append(match.group(2).strip())
    return headings


def has_heading(headings: list[str], aliases: list[str]) -> bool:
    normalized = {normalize(item) for item in headings}
    return any(normalize(alias) in normalized for alias in aliases)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--readme", required=True)
    args = parser.parse_args()

    readme_path = Path(args.readme).resolve()
    content = readme_path.read_text(encoding="utf-8")
    headings = extract_headings(content)

    missing_sections = [
        name for name, aliases in SECTION_GROUPS if not has_heading(headings, aliases)
    ]
    placeholder_hits = [token for token in PLACEHOLDERS if token in content]
    result = {
        "readme": str(readme_path),
        "pass": not missing_sections and not placeholder_hits,
        "missing_sections": missing_sections,
        "placeholder_hits": placeholder_hits,
    }
    print(json.dumps(result, ensure_ascii=False))
    if missing_sections or placeholder_hits:
        raise SystemExit(2)


if __name__ == "__main__":
    main()
