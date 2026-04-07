#!/usr/bin/env python3

from __future__ import annotations

import argparse
from pathlib import Path


REQUIRED_EXACT = {
    "new-feature": [
        "manifest.json",
        "stage-status.json",
        "00-需求总览.md",
    ],
    "change-request": [
        "manifest.json",
        "stage-status.json",
        "00-需求总览.md",
    ],
    "bugfix": [
        "manifest.json",
        "stage-status.json",
        "00-需求总览.md",
    ],
    "ui-optimization": [
        "manifest.json",
        "stage-status.json",
        "00-需求总览.md",
    ],
}

REQUIRED_PATTERNS = {
    "new-feature": [
        "*-需求文档.md",
        "*-任务分解.md",
        "*-技术方案.md",
        "*-UI交互设计规范.md",
        "*-测试用例.md",
        "*-实现控制总表.md",
        "*-页面接口验收总表.md",
        "*-开发放行报告.md",
        "*-代码审查报告.md",
        "*-冒烟测试脚本.sh",
        "*-冒烟测试报告.md",
        "*-QA与产品验收报告.md",
    ],
    "change-request": [
        "*-需求文档.md",
        "*-任务分解.md",
        "*-技术方案.md",
        "*-测试用例.md",
        "*-实现控制总表.md",
        "*-页面接口验收总表.md",
    ],
    "bugfix": [
        "*-需求文档.md",
        "*-任务分解.md",
        "*-技术方案.md",
        "*-测试用例.md",
        "*-开发放行报告.md",
    ],
    "ui-optimization": [
        "*-需求文档.md",
        "*-UI交互设计规范.md",
        "*-页面接口验收总表.md",
    ],
}


def main() -> int:
    parser = argparse.ArgumentParser(description="校验 Picasso 需求产物")
    parser.add_argument("--request", required=True, help="需求目录路径")
    parser.add_argument("--type", required=True, choices=sorted(REQUIRED_EXACT))
    args = parser.parse_args()

    request_dir = Path(args.request).resolve()
    missing = []

    for rel in REQUIRED_EXACT[args.type]:
        if not (request_dir / rel).exists():
            missing.append(rel)

    for pattern in REQUIRED_PATTERNS[args.type]:
        if not list(request_dir.glob(pattern)):
            missing.append(pattern)

    if missing:
        print("[FAIL] 缺少以下产物：")
        for item in missing:
            print(f"- {item}")
        return 1

    print("[PASS] 产物校验通过")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
