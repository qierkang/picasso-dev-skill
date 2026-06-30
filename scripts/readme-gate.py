#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path


SECTION_GROUPS = [
    ("why", ["为什么需要", "Why "]),
    ("overview", ["项目概述", "Project Overview"]),
    ("features", ["核心特色", "Core Features"]),
    ("comparison", ["与同类方案对比", "Comparison"]),
    ("workflow", ["工作流总览", "Workflow Overview"]),
    ("quick_start", ["快速开始", "Quick Start"]),
    ("modules", ["功能模块", "Modules"]),
    ("stack", ["技术栈", "Technology Stack"]),
    ("architecture", ["系统架构", "System Architecture"]),
    ("directory", ["目录结构", "Directory Structure"]),
    ("commands", ["命令参考", "Command Reference"]),
    ("development", ["开发指南", "Development Guide"]),
    ("validation", ["开发与验证", "Development and Validation"]),
    ("status", ["项目状态", "Project Status"]),
    ("faq", ["常见问题", "FAQ"]),
    ("contributing", ["参与贡献", "Contributing"]),
    ("versions", ["版本说明", "Version History"]),
    ("acknowledgements", ["致谢", "Acknowledgements"]),
    ("stars", ["Star History"]),
    ("license", ["许可证", "License"]),
    ("author", ["作者", "Author"]),
]

HEADING_RE = re.compile(r"^(#{1,6})\s+(.*\S)\s*$")
IMAGE_RE = re.compile(r"!\[[^\]]*\]\(([^)]+)\)")
PLACEHOLDERS = ("{{", "}}", "TODO", "待补充", "<repository-url>")


def normalize(text: str) -> str:
    return re.sub(r"[^0-9a-z\u4e00-\u9fff]+", "", text.lower())


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--readme", required=True)
    args = parser.parse_args()

    readme = Path(args.readme).resolve()
    content = readme.read_text(encoding="utf-8")
    headings = [
        match.group(2).strip()
        for line in content.splitlines()
        if (match := HEADING_RE.match(line.strip()))
    ]
    normalized = [normalize(item) for item in headings]
    missing = [
        key
        for key, aliases in SECTION_GROUPS
        if not any(normalize(alias) in heading for alias in aliases for heading in normalized)
    ]
    placeholders = [token for token in PLACEHOLDERS if token in content]
    social_preview = "assets/social-preview.png" in content
    image_paths = []
    missing_images = []
    for raw in IMAGE_RE.findall(content):
        path_text = raw.split("?", 1)[0]
        if path_text.startswith(("http://", "https://")):
            continue
        image_paths.append(path_text)
        candidate = (readme.parent / path_text).resolve()
        if not candidate.exists():
            missing_images.append(path_text)

    result = {
        "readme": str(readme),
        "pass": not missing and not placeholders and social_preview and not missing_images,
        "missing_sections": missing,
        "placeholder_hits": placeholders,
        "social_preview": social_preview,
        "image_count": len(image_paths),
        "missing_images": missing_images,
        "heading_count": len(headings),
        "bytes": len(content.encode("utf-8")),
    }
    print(json.dumps(result, ensure_ascii=False))
    if not result["pass"]:
        raise SystemExit(2)


if __name__ == "__main__":
    main()
