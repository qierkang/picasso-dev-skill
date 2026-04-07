#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

if [ ! -f "$ROOT_DIR/.env" ]; then
  echo "[FAIL] .env 不存在，请先执行 bash install/setup.sh"
  exit 1
fi

# shellcheck disable=SC1091
set -a && source "$ROOT_DIR/.env" && set +a

sync_target() {
  local label="$1"
  local target_dir="$2"

  if [ -z "$target_dir" ]; then
    echo "[WARN] $label 未配置，跳过"
    return
  fi

  mkdir -p "$target_dir"

  for skill_dir in "$ROOT_DIR"/skills/*; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"
    rm -rf "$target_dir/$skill_name"
    cp -R "$skill_dir" "$target_dir/$skill_name"
    echo "[PASS] 已同步 $skill_name -> $target_dir"
  done
}

sync_target "OpenClaw" "${OPENCLAW_SKILLS_DIR:-}"
sync_target "Claude" "${CLAUDE_SKILLS_DIR:-}"
sync_target "Codex" "${CODEX_SKILLS_DIR:-}"

echo "[INFO] 技能同步完成"
