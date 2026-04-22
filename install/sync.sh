#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TRASH_DIR="${HOME}/.Trash"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
LEGACY_SKILLS=(
  "picasso-dev-skill"
  "picasso-dev"
  "picasso-dev-config"
  "picasso-dev-maintainer"
  "picasso-dev-task"
  "picasso-dev-ui"
  "zzpms-dev-ui"
)

if [ ! -f "$ROOT_DIR/.env" ]; then
  echo "[FAIL] .env 不存在，请先执行 bash install/setup.sh"
  exit 1
fi

# shellcheck disable=SC1091
set -a && source "$ROOT_DIR/.env" && set +a

archive_duplicate_dir() {
  local target_dir="$1"
  local label="$2"
  local skill_name="$3"
  local duplicate_dir="$target_dir/$skill_name"

  if [ ! -d "$duplicate_dir" ]; then
    return
  fi

  if [ "$(cd "$duplicate_dir" 2>/dev/null && pwd -P)" = "$(cd "$ROOT_DIR" && pwd -P)" ]; then
    return
  fi

  mkdir -p "$TRASH_DIR"
  local trash_path="$TRASH_DIR/${skill_name}.${label}.${TIMESTAMP}"
  mv "$duplicate_dir" "$trash_path"
  echo "[PASS] 已归档外部副本 -> $trash_path"
}

cleanup_target() {
  local label="$1"
  local target_dir="$2"

  if [ -z "$target_dir" ]; then
    echo "[WARN] $label 未配置，跳过"
    return
  fi

  for skill_name in "${LEGACY_SKILLS[@]}"; do
    archive_duplicate_dir "$target_dir" "$label" "$skill_name"
  done
}

cleanup_target "OpenClaw" "${OPENCLAW_SKILLS_DIR:-$HOME/.openclaw/skills}"
cleanup_target "Claude" "${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
cleanup_target "Codex" "${CODEX_SKILLS_DIR:-$HOME/.codex/skills}"
cleanup_target "OpenCode" "${OPENCODE_SKILLS_DIR:-$HOME/.opencode/skills}"

echo "[INFO] 已完成外部副本清理；当前唯一 canonical skill 源目录: $ROOT_DIR"
