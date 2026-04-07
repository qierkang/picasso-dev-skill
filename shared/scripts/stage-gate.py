#!/usr/bin/env python3

from __future__ import annotations

import argparse
from pathlib import Path


GATES = {
    "analysis": ["00-需求总览.md", "*-需求文档.md"],
    "design": ["*-技术方案.md", "*-任务分解.md", "*-实现控制总表.md"],
    "ui": ["*-UI交互设计规范.md", "*-页面接口验收总表.md"],
    "qa": ["*-测试用例.md", "*-开发放行报告.md", "*-代码审查报告.md"],
    "release": ["*-冒烟测试报告.md", "*-QA与产品验收报告.md"],
}


def main() -> int:
    parser = argparse.ArgumentParser(description="检查阶段卡点资料是否齐全")
    parser.add_argument("--request", required=True)
    parser.add_argument("--gate", required=True, choices=sorted(GATES))
    args = parser.parse_args()

    request_dir = Path(args.request).resolve()
    missing = []
    for rel in GATES[args.gate]:
        if "*" in rel:
            if not list(request_dir.glob(rel)):
                missing.append(rel)
        elif not (request_dir / rel).exists():
            missing.append(rel)

    if missing:
        print(f"[FAIL] 阶段 {args.gate} 缺少资料：")
        for item in missing:
            print(f"- {item}")
        return 1

    print(f"[PASS] 阶段 {args.gate} 资料齐全")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
