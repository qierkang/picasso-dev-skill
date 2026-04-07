#!/usr/bin/env python3

from __future__ import annotations

import argparse
from datetime import date
from pathlib import Path


def render(text: str, mapping: dict[str, str]) -> str:
    for key, value in mapping.items():
        text = text.replace(f"{{{{{key}}}}}", value)
    return text


def main() -> int:
    parser = argparse.ArgumentParser(description="初始化 Picasso 需求目录")
    parser.add_argument("--key", required=True, help="需求英文代号，例如 maintenance-plan")
    parser.add_argument("--title", required=True, help="需求中文标题")
    parser.add_argument("--type", required=True, choices=["new-feature", "change-request", "bugfix", "ui-optimization"])
    parser.add_argument("--owner", default="unknown")
    parser.add_argument("--workspace", default="workspace")
    args = parser.parse_args()

    root = Path(__file__).resolve().parents[2]
    workspace_dir = (root / args.workspace).resolve()
    request_dir = workspace_dir / "requests" / args.key
    assets_dir = request_dir / "assets"
    logs_dir = request_dir / "logs"
    templates_dir = root / "shared" / "templates"

    request_dir.mkdir(parents=True, exist_ok=True)
    assets_dir.mkdir(parents=True, exist_ok=True)
    logs_dir.mkdir(parents=True, exist_ok=True)

    mapping = {
        "REQUEST_KEY": args.key,
        "REQUEST_TITLE": args.title,
        "REQUEST_TYPE": args.type,
        "CURRENT_DATE": str(date.today()),
        "OWNER": args.owner,
    }

    file_map = {
        templates_dir / "manifest模板.json": request_dir / "manifest.json",
        templates_dir / "需求总览模板.md": request_dir / "00-需求总览.md",
        templates_dir / "需求文档模板.md": request_dir / f"{args.title}-需求文档.md",
        templates_dir / "任务分解模板.md": request_dir / f"{args.title}-任务分解.md",
        templates_dir / "技术方案模板.md": request_dir / f"{args.title}-技术方案.md",
        templates_dir / "UI交互设计模板.md": request_dir / f"{args.title}-UI交互设计规范.md",
        templates_dir / "测试用例模板.md": request_dir / f"{args.title}-测试用例.md",
        templates_dir / "实现控制总表模板.md": request_dir / f"{args.title}-实现控制总表.md",
        templates_dir / "页面接口验收总表模板.md": request_dir / f"{args.title}-页面接口验收总表.md",
        templates_dir / "开发放行报告模板.md": request_dir / f"{args.title}-开发放行报告.md",
        templates_dir / "代码审查报告模板.md": request_dir / f"{args.title}-代码审查报告.md",
        templates_dir / "冒烟测试脚本模板.sh": request_dir / f"{args.title}-冒烟测试脚本.sh",
        templates_dir / "冒烟测试报告模板.md": request_dir / f"{args.title}-冒烟测试报告.md",
        templates_dir / "QA与产品验收报告模板.md": request_dir / f"{args.title}-QA与产品验收报告.md",
        templates_dir / "stage-status模板.json": request_dir / "stage-status.json",
    }

    for src, dst in file_map.items():
        if not dst.exists():
            dst.write_text(render(src.read_text(), mapping), encoding="utf-8")

    print(f"[OK] 已初始化需求目录: {request_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
