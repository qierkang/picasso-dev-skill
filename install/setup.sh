#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "[INFO] Picasso Dev Skill 初始化开始"

if [ ! -f "$ROOT_DIR/.env" ]; then
  cp "$ROOT_DIR/.env.example" "$ROOT_DIR/.env"
  echo "[INFO] 已创建 .env，请按实际环境调整配置"
fi

mkdir -p \
  "$ROOT_DIR/workspace/requests" \
  "$ROOT_DIR/workspace/archives" \
  "$ROOT_DIR/workspace/server-tasks/incoming" \
  "$ROOT_DIR/workspace/server-tasks/active" \
  "$ROOT_DIR/workspace/server-tasks/archived" \
  "$ROOT_DIR/workspace/cache" \
  "$ROOT_DIR/workspace/tmp" \
  "$ROOT_DIR/governance/updates" \
  "$ROOT_DIR/governance/decisions" \
  "$ROOT_DIR/examples/maintenance-plan/assets" \
  "$ROOT_DIR/examples/attendance-mobile" \
  "$ROOT_DIR/examples/recruitment-manage"

for keep_dir in \
  "$ROOT_DIR/workspace/requests" \
  "$ROOT_DIR/workspace/archives" \
  "$ROOT_DIR/workspace/server-tasks/incoming" \
  "$ROOT_DIR/workspace/server-tasks/active" \
  "$ROOT_DIR/workspace/server-tasks/archived" \
  "$ROOT_DIR/workspace/cache" \
  "$ROOT_DIR/workspace/tmp" \
  "$ROOT_DIR/governance/decisions"; do
  if [ ! -f "$keep_dir/.gitkeep" ]; then
    touch "$keep_dir/.gitkeep"
  fi
done

echo "[INFO] 目录初始化完成"
echo "[INFO] 下一步请执行: bash install/doctor.sh --capability dev"
