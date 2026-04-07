#!/usr/bin/env bash

set -u

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
FAIL_COUNT=0
WARN_COUNT=0

pass() { echo "[PASS] $1"; }
warn() { echo "[WARN] $1"; WARN_COUNT=$((WARN_COUNT + 1)); }
fail() { echo "[FAIL] $1"; FAIL_COUNT=$((FAIL_COUNT + 1)); }

resolve_path() {
  local path="$1"
  if [ -z "$path" ]; then
    echo ""
  elif [ "${path#/}" != "$path" ]; then
    echo "$path"
  else
    echo "$ROOT_DIR/${path#./}"
  fi
}

is_placeholder() {
  case "$1" in
    ""|"/path/to/"*|*"/path/to/"*|"CHANGE_ME"*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

if [ ! -f "$ROOT_DIR/.env" ]; then
  fail ".env 不存在，请先执行 bash install/setup.sh"
  echo "[INFO] doctor 检查完成: FAIL=$FAIL_COUNT WARN=$WARN_COUNT"
  exit 1
else
  # shellcheck disable=SC1091
  set -a && source "$ROOT_DIR/.env" && set +a
  pass ".env 已加载"
fi

for cmd in git python3; do
  if command -v "$cmd" >/dev/null 2>&1; then
    pass "$cmd 可用"
  else
    fail "$cmd 不可用"
  fi
done

if [ -n "${CLAUDE_BIN:-}" ] && command -v "$CLAUDE_BIN" >/dev/null 2>&1; then
  pass "Claude CLI 可用"
else
  warn "Claude CLI 不可用，可改为单模型或其他 CLI 模式"
fi

if [ -n "${CODEX_BIN:-}" ] && command -v "$CODEX_BIN" >/dev/null 2>&1; then
  pass "Codex CLI 可用"
else
  warn "Codex CLI 不可用，仍可使用单模型模式"
fi

WORKSPACE_DIR="$(resolve_path "${PICASSO_WORKSPACE_DIR:-./workspace}")"
SERVER_DIR="$(resolve_path "${PICASSO_SERVER_CODE_DIR:-}")"
FRONT_DIR="$(resolve_path "${PICASSO_FRONT_CODE_DIR:-}")"
MINIAPP_DIR="$(resolve_path "${PICASSO_MINIAPP_CODE_DIR:-}")"
MOBILE_DIR="$(resolve_path "${PICASSO_MOBILE_APP_CODE_DIR:-}")"
TASK_DIR="$(resolve_path "${PICASSO_SERVER_TASK_DIR:-}")"

for pair in \
  "运行目录:$WORKSPACE_DIR" \
  "服务端源码:$SERVER_DIR" \
  "PC 前端源码:$FRONT_DIR" \
  "服务端任务目录:$TASK_DIR"; do
  label="${pair%%:*}"
  path="${pair#*:}"
  if is_placeholder "$path"; then
    fail "$label 仍是占位值，请先修改 .env"
  elif [ -n "$path" ] && [ -e "$path" ]; then
    pass "$label 存在"
  else
    fail "$label 缺失"
  fi
done

for pair in \
  "小程序源码:$MINIAPP_DIR" \
  "移动端源码:$MOBILE_DIR"; do
  label="${pair%%:*}"
  path="${pair#*:}"
  if is_placeholder "$path"; then
    warn "$label 仍是占位值，可按需修改 .env"
  elif [ -n "$path" ] && [ -e "$path" ]; then
    pass "$label 存在"
  else
    warn "$label 未配置或不存在"
  fi
done

if [ -w "$WORKSPACE_DIR" ]; then
  pass "workspace 可写"
else
  fail "workspace 不可写"
fi

for pair in \
  "OpenClaw:${OPENCLAW_SKILLS_DIR:-}" \
  "Claude:${CLAUDE_SKILLS_DIR:-}" \
  "Codex:${CODEX_SKILLS_DIR:-}"; do
  label="${pair%%:*}"
  path="${pair#*:}"
  if [ -n "${path:-}" ]; then
    if [ -d "$path" ]; then
      pass "$label 技能目录存在"
    else
      warn "$label 技能目录不存在，sync.sh 执行时会尝试创建"
    fi
  else
    warn "$label 技能目录未配置"
  fi
done

echo "[INFO] doctor 检查完成: FAIL=$FAIL_COUNT WARN=$WARN_COUNT"

if [ "$FAIL_COUNT" -gt 0 ]; then
  exit 1
fi
