#!/usr/bin/env bash

set -u

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
GUIDE_DOC="$ROOT_DIR/install/开发环境安装指引.md"
FAIL_COUNT=0
WARN_COUNT=0
CAPABILITY="dev"

usage() {
  cat <<'EOF'
用法：
  bash install/doctor.sh
  bash install/doctor.sh --capability docs
  bash install/doctor.sh --capability dev
  bash install/doctor.sh --capability db
  bash install/doctor.sh --capability deploy
  bash install/doctor.sh --capability all

说明：
  docs   仅文档/方案能力，不强依赖开发工具链
  dev    代码开发能力（默认）
  db     本地数据库查询 / SQL 校验能力
  deploy 本地 local/dev 启动、冒烟、发布准备能力
  all    执行全部校验
EOF
}

if [ "${1:-}" = "--capability" ]; then
  CAPABILITY="${2:-}"
elif [ -n "${1:-}" ]; then
  CAPABILITY="$1"
fi

case "$CAPABILITY" in
  docs|dev|db|deploy|all)
    ;;
  *)
    usage
    exit 2
    ;;
esac

pass() { echo "[PASS] $1"; }
warn() { echo "[WARN] $1"; WARN_COUNT=$((WARN_COUNT + 1)); }
fail() { echo "[FAIL] $1"; FAIL_COUNT=$((FAIL_COUNT + 1)); }
info() { echo "[INFO] $1"; }
guide() { echo "[GUIDE] $1"; }

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

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

strip_version_prefix() {
  printf '%s' "$1" | sed -E 's/^[^0-9]*//; s/[^0-9.].*$//'
}

version_ge() {
  python3 - "$1" "$2" <<'PY'
import sys


def normalize(value: str) -> list[int]:
    cleaned = "".join(ch for ch in value if ch.isdigit() or ch == ".").strip(".")
    if not cleaned:
        raise SystemExit(1)
    return [int(part) for part in cleaned.split(".") if part != ""]


current = normalize(sys.argv[1])
required = normalize(sys.argv[2])
length = max(len(current), len(required))
current.extend([0] * (length - len(current)))
required.extend([0] * (length - len(required)))
raise SystemExit(0 if current >= required else 1)
PY
}

read_package_engine_version() {
  local package_json="$1"
  local engine_key="$2"
  python3 - "$package_json" "$engine_key" <<'PY'
import json
import re
import sys
from pathlib import Path

package_json = Path(sys.argv[1])
engine_key = sys.argv[2]

if not package_json.exists():
    print("")
    raise SystemExit(0)

data = json.loads(package_json.read_text(encoding="utf-8"))
raw = str(data.get("engines", {}).get(engine_key, "")).strip()
match = re.search(r"(\d+(?:\.\d+){0,2})", raw)
print(match.group(1) if match else "")
PY
}

contains_csv_item() {
  local csv="$1"
  local item="$2"
  case ",$csv," in
    *",$item,"*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

is_local_host() {
  case "$1" in
    127.0.0.1|localhost|::1)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

os_name() {
  case "$(uname -s 2>/dev/null)" in
    Darwin) echo "macos" ;;
    Linux) echo "linux" ;;
    *) echo "other" ;;
  esac
}

install_hint() {
  local tool="$1"
  local os
  os="$(os_name)"

  case "$tool" in
    java)
      if [ "$os" = "macos" ]; then
        echo "安装 Java 21：brew install openjdk@21"
      elif [ "$os" = "linux" ]; then
        echo "安装 Java 21：sudo apt-get install openjdk-21-jdk"
      else
        echo "安装 Java 21，并确保 java 可执行命令在 PATH 中"
      fi
      ;;
    maven)
      if [ "$os" = "macos" ]; then
        echo "安装 Maven：brew install maven"
      elif [ "$os" = "linux" ]; then
        echo "安装 Maven：sudo apt-get install maven"
      else
        echo "安装 Maven，或在后端仓库中提供可执行的 ./mvnw"
      fi
      ;;
    node)
      if [ "$os" = "macos" ]; then
        echo "安装 Node.js 20+：brew install node"
      elif [ "$os" = "linux" ]; then
        echo "安装 Node.js 20+：sudo apt-get install nodejs npm"
      else
        echo "安装 Node.js 20+，并确保 node 可执行命令在 PATH 中"
      fi
      ;;
    pnpm)
      echo "安装 pnpm：npm install -g pnpm"
      ;;
    flutter)
      echo "安装 Flutter，并确保 flutter 可执行命令在 PATH 中；参考 Flutter 官方安装文档"
      ;;
    psql)
      if [ "$os" = "macos" ]; then
        echo "安装 PostgreSQL 客户端：brew install libpq，并把 /opt/homebrew/opt/libpq/bin 加入 PATH（建议写入 ~/.zprofile 或 ~/.zshrc）"
      elif [ "$os" = "linux" ]; then
        echo "安装 PostgreSQL 客户端：sudo apt-get install postgresql-client"
      else
        echo "安装 PostgreSQL 客户端，并确保 psql 可执行命令在 PATH 中"
      fi
      ;;
    *)
      echo "安装缺失工具，并确保命令在 PATH 中"
      ;;
  esac
}

check_required_cmd() {
  local label="$1"
  local cmd="$2"
  local hint_key="${3:-$2}"
  if has_cmd "$cmd"; then
    pass "$label 可用"
  else
    fail "$label 不可用"
    guide "$(install_hint "$hint_key")"
  fi
}

check_required_value() {
  local label="$1"
  local value="$2"
  if is_placeholder "$value"; then
    fail "$label 仍是占位值，请先修改 .env"
  elif [ -n "$value" ]; then
    pass "$label 已配置"
  else
    fail "$label 未配置"
  fi
}

check_optional_path_value() {
  local label="$1"
  local value="$2"
  local resolved
  if is_placeholder "$value"; then
    fail "$label 仍是占位值，请先修改 .env"
    return
  fi
  resolved="$(resolve_path "$value")"
  if [ -d "$resolved" ]; then
    pass "$label 存在"
  else
    fail "$label 不存在: $resolved"
  fi
}

check_version_at_least() {
  local label="$1"
  local current_version="$2"
  local required_version="$3"
  if [ -z "$required_version" ]; then
    return
  fi
  if [ -z "$current_version" ]; then
    fail "$label 未识别到版本号"
    return
  fi
  if version_ge "$current_version" "$required_version"; then
    pass "$label 版本满足要求（当前 ${current_version}，要求 >= ${required_version}）"
  else
    fail "$label 版本过低（当前 ${current_version}，要求 >= ${required_version}）"
  fi
}

check_java_version() {
  local java_version
  if ! has_cmd "java"; then
    return
  fi
  java_version="$(java -version 2>&1 | head -n 1 | sed -E 's/.*version "([^"]+)".*/\1/')"
  check_version_at_least "Java" "$java_version" "21"
}

check_node_and_pnpm_versions_for_repo() {
  local repo_label="$1"
  local repo_dir="$2"
  local package_json="$repo_dir/package.json"
  local required_node
  local required_pnpm
  local current_node
  local current_pnpm

  if [ ! -f "$package_json" ]; then
    warn "$repo_label 未找到 package.json，跳过 Node.js / pnpm 版本校验"
    return
  fi

  required_node="$(read_package_engine_version "$package_json" "node")"
  required_pnpm="$(read_package_engine_version "$package_json" "pnpm")"

  if [ -n "$required_node" ] && has_cmd "node"; then
    current_node="$(strip_version_prefix "$(node -v 2>/dev/null || true)")"
    check_version_at_least "$repo_label Node.js" "$current_node" "$required_node"
  fi
  if [ -n "$required_pnpm" ] && has_cmd "pnpm"; then
    current_pnpm="$(strip_version_prefix "$(pnpm -v 2>/dev/null || true)")"
    check_version_at_least "$repo_label pnpm" "$current_pnpm" "$required_pnpm"
  fi
}

detect_server_resources_dir() {
  local server_dir="$1"
  local candidate
  for candidate in \
    "$server_dir/picasso-server/src/main/resources" \
    "$server_dir/src/main/resources"; do
    if [ -d "$candidate" ]; then
      echo "$candidate"
      return
    fi
  done
  echo ""
}

check_boundary_rules() {
  local boundary_mode="${PICASSO_ENV_BOUNDARY_MODE:-local-only}"
  local allowed_profiles="${PICASSO_ALLOWED_RUNTIME_PROFILES:-local,dev}"
  local forbidden_profiles="${PICASSO_FORBIDDEN_RUNTIME_PROFILES:-test,uat,prod}"
  local legacy_var

  if [ "$boundary_mode" = "local-only" ]; then
    pass "当前边界模式为 local-only"
  else
    fail "当前边界模式不是 local-only：$boundary_mode"
  fi

  if contains_csv_item "$allowed_profiles" "local" && contains_csv_item "$allowed_profiles" "dev"; then
    pass "允许环境包含 local/dev"
  else
    fail "允许环境未正确包含 local/dev：$allowed_profiles"
  fi

  if contains_csv_item "$forbidden_profiles" "test" \
    && contains_csv_item "$forbidden_profiles" "uat" \
    && contains_csv_item "$forbidden_profiles" "prod"; then
    pass "已明确禁用 test/uat/prod"
  else
    fail "禁用环境未完整覆盖 test/uat/prod：$forbidden_profiles"
  fi

  for legacy_var in \
    PICASSO_TEST_DB_HOST \
    PICASSO_TEST_DB_PORT \
    PICASSO_TEST_DB_NAME \
    PICASSO_TEST_DB_USER \
    PICASSO_TEST_DB_PASSWORD \
    PICASSO_TEST_SSH_ALIAS \
    PICASSO_TEST_DEPLOY_PATH; do
    if [ -n "${!legacy_var:-}" ]; then
      fail "local-only 模式下禁止继续配置 $legacy_var"
    fi
  done
}

check_repo_path() {
  local label="$1"
  local path="$2"
  if is_placeholder "$path"; then
    fail "$label 仍是占位值，请先修改 .env"
  elif [ -n "$path" ] && [ -e "$path" ]; then
    pass "$label 存在"
  else
    fail "$label 缺失"
  fi
}

check_workspace_ready() {
  check_repo_path "运行目录" "$WORKSPACE_DIR"
  if [ -d "$WORKSPACE_DIR" ] && [ -w "$WORKSPACE_DIR" ]; then
    pass "workspace 可写"
  elif [ -d "$WORKSPACE_DIR" ]; then
    fail "workspace 不可写"
  fi
}

check_runtime_repo_paths() {
  check_repo_path "服务端源码" "$SERVER_DIR"
  check_repo_path "PC 前端源码" "$FRONT_DIR"
  check_repo_path "服务端任务目录" "$TASK_DIR"

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
}

check_runtime_toolchain() {
  check_required_cmd "Java" "java" "java"
  check_java_version
  if has_cmd "mvn" || [ -x "$SERVER_DIR/mvnw" ] || [ -x "$SERVER_DIR/picasso-server/mvnw" ]; then
    pass "Maven / Maven Wrapper 可用"
  else
    fail "Maven / Maven Wrapper 不可用"
    guide "$(install_hint "maven")"
  fi

  check_required_cmd "Node.js" "node" "node"
  check_required_cmd "pnpm" "pnpm" "pnpm"
  check_node_and_pnpm_versions_for_repo "PC 前端" "$FRONT_DIR"

  if [ -n "$MINIAPP_DIR" ] && [ -d "$MINIAPP_DIR" ]; then
    check_node_and_pnpm_versions_for_repo "小程序" "$MINIAPP_DIR"
  fi

  if [ -n "$MOBILE_DIR" ] && [ -d "$MOBILE_DIR" ]; then
    check_required_cmd "Flutter" "flutter" "flutter"
  fi
}

check_runtime_profiles() {
  RESOURCES_DIR="$(detect_server_resources_dir "$SERVER_DIR")"
  if [ -n "$RESOURCES_DIR" ]; then
    if [ -f "$RESOURCES_DIR/application-local.yaml" ] && [ -f "$RESOURCES_DIR/application-dev.yaml" ]; then
      pass "已识别 application-local.yaml / application-dev.yaml，本地开发边界明确"
    else
      fail "未完整识别 application-local.yaml / application-dev.yaml"
    fi
    for forbidden_profile in test uat prod; do
      if [ -f "$RESOURCES_DIR/application-$forbidden_profile.yaml" ]; then
        pass "已识别受限环境 application-$forbidden_profile.yaml，按规则禁止连接和部署"
      else
        warn "未找到 application-$forbidden_profile.yaml，无法辅助识别受限环境"
      fi
    done
  else
    warn "未识别 Spring resources 目录，无法辅助检查 application-local/dev/test/uat/prod.yaml"
  fi
}

check_runtime_orchestration() {
  if [ "${PICASSO_AUTO_START_LOCAL_SERVICES:-true}" = "true" ]; then
    pass "已开启自动拉起本地服务"
    check_optional_path_value "后端启动目录" "${PICASSO_BACKEND_START_WORKDIR:-}"
    check_required_value "后端启动命令" "${PICASSO_BACKEND_START_CMD:-}"
    check_required_value "后端基础地址" "${PICASSO_BACKEND_BASE_URL:-}"
    check_required_value "后端健康检查地址" "${PICASSO_BACKEND_HEALTH_URL:-}"

    check_optional_path_value "前端启动目录" "${PICASSO_FRONTEND_START_WORKDIR:-}"
    check_required_value "前端启动命令" "${PICASSO_FRONTEND_START_CMD:-}"
    check_required_value "前端就绪地址" "${PICASSO_FRONTEND_READY_URL:-}"
  else
    warn "已关闭自动拉起本地服务；无法保证启动、联调、冒烟全自动闭环"
  fi

  if [ -n "${PICASSO_RUNTIME_READY_TIMEOUT_SEC:-}" ]; then
    if [[ "${PICASSO_RUNTIME_READY_TIMEOUT_SEC:-}" =~ ^[0-9]+$ ]]; then
      pass "运行时等待超时秒数格式正确"
    else
      fail "PICASSO_RUNTIME_READY_TIMEOUT_SEC 必须是整数秒"
    fi
  else
    warn "未配置 PICASSO_RUNTIME_READY_TIMEOUT_SEC，将使用默认值"
  fi

  if [ "${PICASSO_AUTO_FETCH_ACCESS_TOKEN:-false}" = "true" ]; then
    pass "已开启自动获取 Token"
    check_required_value "登录接口地址" "${PICASSO_LOGIN_URL:-}"
    check_required_value "登录用户名" "${PICASSO_LOGIN_USERNAME:-}"
    check_required_value "登录密码" "${PICASSO_LOGIN_PASSWORD:-}"
    check_required_value "登录请求体模板" "${PICASSO_LOGIN_REQUEST_BODY_TEMPLATE:-}"
    check_required_value "登录 token 路径" "${PICASSO_LOGIN_TOKEN_PATH:-}"
  else
    warn "已关闭自动获取 Token；需要鉴权的冒烟脚本必须手动传入 TOKEN"
  fi

  if [ "${PICASSO_AUTO_STOP_LOCAL_SERVICES:-true}" = "true" ]; then
    pass "已开启自动收尾"
  else
    warn "已关闭自动收尾；脚本结束后需要人工停止本地服务"
  fi
}

if [ ! -f "$ROOT_DIR/.env" ]; then
  fail ".env 不存在，请先执行 bash install/setup.sh"
  info "doctor 检查完成: FAIL=$FAIL_COUNT WARN=$WARN_COUNT"
  exit 1
else
  # shellcheck disable=SC1091
  set -a && source "$ROOT_DIR/.env" && set +a
  pass ".env 已加载"
fi

info "当前 doctor 能力模式: $CAPABILITY"

check_required_cmd "git" "git"
check_required_cmd "python3" "python3"

if [ -n "${CLAUDE_BIN:-}" ] && has_cmd "$CLAUDE_BIN"; then
  pass "Claude CLI 可用"
else
  warn "Claude CLI 不可用，可改为单模型或其他 CLI 模式"
fi

if [ -n "${CODEX_BIN:-}" ] && has_cmd "$CODEX_BIN"; then
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

check_workspace_ready

if [ "$CAPABILITY" != "docs" ]; then
  check_boundary_rules

  case "$CAPABILITY" in
    dev)
      check_runtime_repo_paths
      check_runtime_toolchain
      check_runtime_profiles
      ;;
    db)
      check_repo_path "服务端源码" "$SERVER_DIR"
      check_runtime_profiles
      ;;
    deploy)
      check_runtime_repo_paths
      check_runtime_toolchain
      check_runtime_profiles
      ;;
    all)
      check_runtime_repo_paths
      check_runtime_toolchain
      check_runtime_profiles
      ;;
  esac

  if [ "$CAPABILITY" = "db" ] || [ "$CAPABILITY" = "all" ]; then
    if is_placeholder "${PICASSO_LOCAL_DB_HOST:-}" || is_placeholder "${PICASSO_LOCAL_DB_PORT:-}" || is_placeholder "${PICASSO_LOCAL_DB_NAME:-}"; then
      fail "本地数据库配置未完成，请先修改 .env"
    else
      pass "本地数据库配置已填写"
    fi

    if is_local_host "${PICASSO_LOCAL_DB_HOST:-}"; then
      pass "本地数据库 Host 属于本机地址"
    else
      fail "本地数据库 Host 必须是 127.0.0.1 / localhost / ::1，当前为 ${PICASSO_LOCAL_DB_HOST:-未配置}"
    fi

    if [ "${PICASSO_REQUIRE_LOCAL_DB_CLI:-true}" = "true" ]; then
      check_required_cmd "psql" "psql" "psql"
    else
      warn "已关闭 psql 强校验；如需执行本地 SQL / 数据查询，请自行确认客户端可用"
    fi
  fi

  if [ "$CAPABILITY" = "deploy" ] || [ "$CAPABILITY" = "all" ]; then
    pass "当前部署边界仅允许 local/dev，不允许 test/uat/prod"
    if [ -n "${PICASSO_REMOTE_SSH_ALIAS:-}" ] || [ -n "${PICASSO_REMOTE_DEPLOY_PATH:-}" ]; then
      fail "local-only 模式下不应配置远程部署入口"
    fi
    check_runtime_orchestration
  fi
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

info "doctor 检查完成: FAIL=$FAIL_COUNT WARN=$WARN_COUNT"

if [ "$FAIL_COUNT" -gt 0 ]; then
  guide "先按能力补齐环境，再继续开发；安装参考：$GUIDE_DOC"
  exit 1
fi
