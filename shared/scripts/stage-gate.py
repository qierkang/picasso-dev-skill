#!/usr/bin/env python3
"""Picasso 需求阶段放行校验脚本。"""

from __future__ import annotations

import argparse
import json
import re
import sys
import xml.etree.ElementTree as ET
import fcntl
from contextlib import contextmanager
from datetime import datetime
from pathlib import Path
from typing import Any


STAGE_STATUS_FILE = "stage-status.json"

REPORT_MARKERS = {
    "开发放行报告": ["## 元信息", "执行时间", "执行人", "## 4. 结论"],
    "覆盖率报告": ["## 元信息", "执行时间", "执行人", "## 4. Gate 结论"],
    "前端关键流程覆盖清单": ["## 元信息", "执行时间", "执行人", "## 4. Gate 结论"],
    "代码审查报告": ["## 元信息", "审查时间", "审查人", "## 1. 审查结论", "## 4. 结论"],
    "冒烟测试报告": [
        "## 元信息",
        "执行时间",
        "执行脚本",
        "## 2. 第1关：API 接口验证",
        "### 2.1 第1关汇总",
        "## 3. 第2关：页面集成验证",
        "### 3.1 第2关汇总",
        "## 4. 结论",
    ],
    "QA验收报告": ["## 元信息", "执行时间", "执行人", "## 3. 结论"],
    "UI验收报告": ["## 元信息", "执行时间", "执行人", "## 4. 结论"],
    "产品验收报告": ["## 元信息", "执行时间", "执行人", "## 3. 结论"],
    "发布记录": ["## 元信息", "目标环境", "## 1. 发布前确认", "## 3. 发布后验证", "## 5. 结论"],
}

DOC_ALIASES = {
    "dev_report": ["开发放行报告"],
    "coverage_report": ["覆盖率报告"],
    "fe_checklist": ["前端关键流程覆盖清单"],
    "review_report": ["代码审查报告"],
    "smoke_report": ["冒烟测试报告"],
    "smoke_script": ["冒烟测试脚本"],
    "qa_report": ["QA验收报告"],
    "ui_acceptance_report": ["UI验收报告"],
    "product_acceptance_report": ["产品验收报告"],
    "release_report": ["发布记录"],
}


def load_manifest(requirements_dir: Path) -> dict[str, Any]:
    manifest_path = requirements_dir / "manifest.json"
    if not manifest_path.exists():
        return {}
    return json.loads(manifest_path.read_text(encoding="utf-8"))


def find_first(requirements_dir: Path, suffixes: list[str], extension: str = "md") -> Path | None:
    for suffix in suffixes:
        matches = sorted(requirements_dir.glob(f"*-{suffix}.{extension}"))
        if matches:
            return matches[0]
    return None


def resolve_from_manifest(manifest: dict[str, Any], requirements_dir: Path, doc_key: str) -> Path | None:
    stage_docs = manifest.get("stage_docs", {})
    relative_path = stage_docs.get(doc_key)
    if not relative_path:
        return None
    candidate = (requirements_dir / relative_path).resolve()
    if candidate.exists() and candidate.is_file():
        return candidate
    return None


def resolve_doc(
    requirements_dir: Path, manifest: dict[str, Any], doc_key: str, extension: str = "md"
) -> Path | None:
    manifest_path = resolve_from_manifest(manifest, requirements_dir, doc_key)
    if manifest_path is not None:
        return manifest_path
    return find_first(requirements_dir, DOC_ALIASES[doc_key], extension=extension)


def load_status(path: Path) -> dict[str, Any]:
    default_status = {
        "current_stage": "需求分析",
        "current_task": "初始化需求目录",
        "current_cycle": "planning",
        "retry_count": 0,
        "max_retries": 3,
        "last_failed_by": None,
        "blocking_issues": [],
        "evidence_paths": [],
        "next_action": "补充需求文档",
        "release_decision": "NEEDS_WORK",
        "last_updated": None,
        "checks": {},
        "history": [],
    }
    if path.exists():
        loaded = json.loads(path.read_text(encoding="utf-8"))
        merged = {**default_status, **loaded}
        merged["checks"] = loaded.get("checks", {})
        merged["history"] = loaded.get("history", [])
        return merged
    return default_status


@contextmanager
def lock_status(path: Path):
    lock_path = path.with_suffix(f"{path.suffix}.lock")
    lock_path.parent.mkdir(parents=True, exist_ok=True)
    with lock_path.open("w", encoding="utf-8") as lock_file:
        fcntl.flock(lock_file.fileno(), fcntl.LOCK_EX)
        try:
            yield
        finally:
            fcntl.flock(lock_file.fileno(), fcntl.LOCK_UN)


def save_status(path: Path, status: dict[str, Any]) -> None:
    status["last_updated"] = datetime.now().isoformat(timespec="seconds")
    temp_path = path.with_suffix(f"{path.suffix}.tmp")
    temp_path.write_text(json.dumps(status, ensure_ascii=False, indent=2), encoding="utf-8")
    temp_path.replace(path)


def next_action(stage: str, passed: bool) -> str:
    if not passed:
        return f"修复 {stage} 阶段阻塞项并重新执行 stage-gate.py {stage}"
    if stage == "dev":
        return "开发阶段通过，进入代码审查阶段"
    if stage == "review":
        return "代码审查通过，进入冒烟测试阶段"
    if stage == "smoke":
        return "冒烟通过，进入 QA 阶段"
    if stage == "qa":
        return "QA 通过，进入 UI 验收阶段"
    if stage == "ui_acceptance":
        return "UI 验收通过，进入产品验收阶段"
    if stage == "product_acceptance":
        return "产品验收通过，可准备发布"
    return "发布通过，可归档并关闭需求"


def record(status: dict[str, Any], stage: str, passed: bool, details: list[str]) -> None:
    checked_at = datetime.now().isoformat(timespec="seconds")
    status["checks"][stage] = {
        "passed": passed,
        "details": details,
        "checked_at": checked_at,
    }
    status["history"].append(
        {
            "stage": stage,
            "passed": passed,
            "details": details,
            "checked_at": checked_at,
        }
    )
    if passed:
        status["current_stage"] = stage
        status["last_failed_by"] = None
        status["blocking_issues"] = []
        status["current_cycle"] = "handoff"
        status["next_action"] = next_action(stage, passed=True)
        if stage == "release":
            status["release_decision"] = "READY"
    else:
        status["retry_count"] = int(status.get("retry_count", 0)) + 1
        status["last_failed_by"] = stage
        status["blocking_issues"] = details
        status["current_cycle"] = (
            "dev-qa-loop" if stage in {"dev", "review", "smoke", "qa", "ui_acceptance", "product_acceptance"} else "planning"
        )
        status["next_action"] = next_action(stage, passed=False)
        status["release_decision"] = "NEEDS_WORK"


def extract_percent_from_text(path: Path | None) -> float | None:
    if path is None or not path.exists():
        return None
    content = path.read_text(encoding="utf-8")
    match = re.search(r"(\d+(?:\.\d+)?)\s*%", content)
    return float(match.group(1)) if match else None


def extract_jacoco_coverage(project_dir: Path) -> float | None:
    jacoco = project_dir / "target" / "site" / "jacoco" / "jacoco.xml"
    if not jacoco.exists():
        return None
    root = ET.parse(jacoco).getroot()
    for counter in root.findall("counter"):
        if counter.attrib.get("type") == "LINE":
            missed = int(counter.attrib.get("missed", "0"))
            covered = int(counter.attrib.get("covered", "0"))
            total = missed + covered
            if total == 0:
                return 0.0
            return covered * 100.0 / total
    return None


def validate_markers(path: Path | None, doc_type: str) -> list[str]:
    if path is None or not path.exists():
        return []
    issues: list[str] = []
    content = path.read_text(encoding="utf-8")
    for marker in REPORT_MARKERS.get(doc_type, []):
        if marker not in content:
            issues.append(f"{path.name} 缺少必要内容标记: {marker}")
    return issues


def check_dev(requirements_dir: Path, backend_project: Path | None, manifest: dict[str, Any]) -> tuple[bool, list[str]]:
    issues: list[str] = []
    dev_report = resolve_doc(requirements_dir, manifest, "dev_report")
    coverage_report = resolve_doc(requirements_dir, manifest, "coverage_report")
    fe_checklist = resolve_doc(requirements_dir, manifest, "fe_checklist")

    if dev_report is None:
        issues.append("缺少开发放行报告")
    if coverage_report is None:
        issues.append("缺少覆盖率报告")
    if fe_checklist is None:
        issues.append("缺少前端关键流程覆盖清单")

    issues.extend(validate_markers(dev_report, "开发放行报告"))
    issues.extend(validate_markers(coverage_report, "覆盖率报告"))
    issues.extend(validate_markers(fe_checklist, "前端关键流程覆盖清单"))

    coverage = None
    if backend_project is not None:
        coverage = extract_jacoco_coverage(backend_project)
    if coverage is None:
        coverage = extract_percent_from_text(coverage_report)

    if coverage is None:
        issues.append("无法识别后端覆盖率数值")
    elif coverage < 90.0:
        issues.append(f"后端覆盖率不足 90%，当前为 {coverage:.2f}%")

    if fe_checklist is not None:
        content = fe_checklist.read_text(encoding="utf-8")
        required_keywords = ["列表加载", "查询", "新增", "编辑", "查看", "删除", "权限"]
        missing_keywords = [keyword for keyword in required_keywords if keyword not in content]
        if missing_keywords:
            issues.append(f"前端关键流程覆盖清单缺少项: {', '.join(missing_keywords)}")

    if dev_report is not None:
        content = dev_report.read_text(encoding="utf-8")
        if "NEEDS_WORK" not in content and "待放行" not in content:
            issues.append("开发放行报告未体现默认 NEEDS_WORK 立场")

    details = [f"后端覆盖率: {coverage:.2f}%" if coverage is not None else "后端覆盖率: 未识别"]
    details.extend(issues or ["开发阶段卡点通过"])
    return (not issues, details)


def check_review(status: dict[str, Any], requirements_dir: Path, manifest: dict[str, Any]) -> tuple[bool, list[str]]:
    issues: list[str] = []
    dev_check = status.get("checks", {}).get("dev")
    review_report = resolve_doc(requirements_dir, manifest, "review_report")
    if not dev_check or not dev_check.get("passed"):
        issues.append("开发阶段卡点未通过，禁止进入代码审查")
    if review_report is None:
        issues.append("缺少代码审查报告")
    issues.extend(validate_markers(review_report, "代码审查报告"))
    if review_report is not None:
        content = review_report.read_text(encoding="utf-8")
        if "P0" in content or "阻塞" in content:
            issues.append("代码审查报告仍存在 P0 / 阻塞项")
    return (not issues, issues or ["代码审查阶段卡点通过"])


def check_smoke(status: dict[str, Any], requirements_dir: Path, manifest: dict[str, Any]) -> tuple[bool, list[str]]:
    issues: list[str] = []
    review_check = status.get("checks", {}).get("review")
    smoke_report = resolve_doc(requirements_dir, manifest, "smoke_report")
    smoke_script = resolve_doc(requirements_dir, manifest, "smoke_script", extension="sh")
    if not review_check or not review_check.get("passed"):
        issues.append("代码审查阶段卡点未通过，禁止进入冒烟测试")
    if smoke_report is None:
        issues.append("缺少冒烟测试报告")
    if smoke_script is None:
        issues.append("缺少冒烟测试脚本")
    issues.extend(validate_markers(smoke_report, "冒烟测试报告"))
    if smoke_report is not None:
        content = smoke_report.read_text(encoding="utf-8")
        if "100%通过" not in content and "100% 通过" not in content and "未执行" in content:
            issues.append("冒烟测试报告尚未形成真实通过结论")
    if smoke_script is not None:
        script_content = smoke_script.read_text(encoding="utf-8")
        if "TODO" in script_content:
            issues.append("冒烟测试脚本仍包含 TODO，占位脚本未替换为真实检查项")
        if "第1关" not in script_content or "第2关" not in script_content:
            issues.append("冒烟测试脚本未按两关制结构组织")
    return (not issues, issues or ["冒烟测试阶段卡点通过"])


def check_qa(status: dict[str, Any], requirements_dir: Path, manifest: dict[str, Any]) -> tuple[bool, list[str]]:
    issues: list[str] = []
    smoke_check = status.get("checks", {}).get("smoke")
    qa_report = resolve_doc(requirements_dir, manifest, "qa_report")
    if not smoke_check or not smoke_check.get("passed"):
        issues.append("冒烟测试阶段卡点未通过，禁止进入 QA")
    if qa_report is None:
        issues.append("缺少 QA验收报告")
    issues.extend(validate_markers(qa_report, "QA验收报告"))
    if qa_report is not None:
        content = qa_report.read_text(encoding="utf-8")
        if "是否QA通过：`否`" in content:
            issues.append("QA验收报告仍为未通过状态")
        if "是否回流开发：`是`" in content:
            issues.append("QA验收报告要求回流开发，禁止继续推进")
        if "P0 / 阻塞项是否清零：`否`" in content:
            issues.append("QA 阻塞项未清零，禁止进入 UI 验收")
    return (not issues, issues or ["QA 阶段卡点通过"])


def check_ui_acceptance(status: dict[str, Any], requirements_dir: Path, manifest: dict[str, Any]) -> tuple[bool, list[str]]:
    issues: list[str] = []
    qa_check = status.get("checks", {}).get("qa")
    ui_report = resolve_doc(requirements_dir, manifest, "ui_acceptance_report")
    if not qa_check or not qa_check.get("passed"):
        issues.append("QA 阶段卡点未通过，禁止进入 UI 验收")
    if ui_report is None:
        issues.append("缺少 UI验收报告")
    issues.extend(validate_markers(ui_report, "UI验收报告"))
    if ui_report is not None:
        content = ui_report.read_text(encoding="utf-8")
        if "是否UI验收通过：`否`" in content:
            issues.append("UI验收报告仍为未通过状态")
        if "是否回流UI/前端：`是`" in content:
            issues.append("UI验收报告要求回流 UI / 前端，禁止进入产品验收")
        if "页面差异是否清零：`否`" in content:
            issues.append("页面差异未清零，禁止进入产品验收")
    return (not issues, issues or ["UI 验收阶段卡点通过"])


def check_product_acceptance(
    status: dict[str, Any], requirements_dir: Path, manifest: dict[str, Any]
) -> tuple[bool, list[str]]:
    issues: list[str] = []
    ui_check = status.get("checks", {}).get("ui_acceptance")
    product_report = resolve_doc(requirements_dir, manifest, "product_acceptance_report")
    if not ui_check or not ui_check.get("passed"):
        issues.append("UI 验收阶段卡点未通过，禁止进入产品验收")
    if product_report is None:
        issues.append("缺少 产品验收报告")
    issues.extend(validate_markers(product_report, "产品验收报告"))
    if product_report is not None:
        content = product_report.read_text(encoding="utf-8")
        if "是否产品验收通过：`否`" in content:
            issues.append("产品验收报告仍为未通过状态")
        if "是否允许进入发布准备：`否`" in content:
            issues.append("产品验收未允许进入发布准备")
        if "是否回流需求/开发：`是`" in content:
            issues.append("产品验收要求回流需求 / 开发，禁止进入发布")
    return (not issues, issues or ["产品验收阶段卡点通过"])


def check_release(status: dict[str, Any], requirements_dir: Path, manifest: dict[str, Any]) -> tuple[bool, list[str]]:
    issues: list[str] = []
    acceptance_check = status.get("checks", {}).get("product_acceptance")
    release_report = resolve_doc(requirements_dir, manifest, "release_report")
    if not acceptance_check or not acceptance_check.get("passed"):
        issues.append("产品验收阶段卡点未通过，禁止进入发布")
    if release_report is None:
        issues.append("缺少发布记录")
    issues.extend(validate_markers(release_report, "发布记录"))
    if release_report is not None:
        content = release_report.read_text(encoding="utf-8")
        if "是否发布成功：`否`" in content or "默认结论：`未完成发布验证前保持 NEEDS_WORK`" in content:
            issues.append("发布记录仍为未完成或未通过状态")
    return (not issues, issues or ["发布阶段卡点通过"])


def main() -> int:
    parser = argparse.ArgumentParser(description="Picasso 阶段放行校验")
    parser.add_argument(
        "stage",
        choices=["dev", "review", "smoke", "qa", "ui_acceptance", "product_acceptance", "release"],
        help="要校验的阶段",
    )
    parser.add_argument("requirements_dir", help="需求目录路径")
    parser.add_argument("--backend-project", help="后端项目路径", default=None)
    args = parser.parse_args()

    requirements_dir = Path(args.requirements_dir).expanduser().resolve()
    if not requirements_dir.is_dir():
        print(f"❌ 目录不存在: {requirements_dir}", file=sys.stderr)
        return 2

    status_path = requirements_dir / STAGE_STATUS_FILE
    backend_project = Path(args.backend_project).expanduser().resolve() if args.backend_project else None
    manifest = load_manifest(requirements_dir)

    with lock_status(status_path):
        status = load_status(status_path)

        if args.stage == "dev":
            passed, details = check_dev(requirements_dir, backend_project, manifest)
        elif args.stage == "review":
            passed, details = check_review(status, requirements_dir, manifest)
        elif args.stage == "smoke":
            passed, details = check_smoke(status, requirements_dir, manifest)
        elif args.stage == "qa":
            passed, details = check_qa(status, requirements_dir, manifest)
        elif args.stage == "ui_acceptance":
            passed, details = check_ui_acceptance(status, requirements_dir, manifest)
        elif args.stage == "product_acceptance":
            passed, details = check_product_acceptance(status, requirements_dir, manifest)
        else:
            passed, details = check_release(status, requirements_dir, manifest)

        record(status, args.stage, passed, details)
        save_status(status_path, status)

    print(
        json.dumps(
            {
                "requirements_dir": str(requirements_dir),
                "stage": args.stage,
                "passed": passed,
                "details": details,
                "status_file": str(status_path),
            },
            ensure_ascii=False,
            indent=2,
        )
    )
    return 0 if passed else 1


if __name__ == "__main__":
    sys.exit(main())
