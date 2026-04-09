#!/usr/bin/env bash

set -euo pipefail

PICASSO_RUNTIME_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PICASSO_RUNTIME_ENV_LOADED="${PICASSO_RUNTIME_ENV_LOADED:-false}"

picasso_log() {
  echo "[RUNTIME] $*"
}

picasso_truthy() {
  case "${1:-}" in
    1|true|TRUE|yes|YES|on|ON)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

picasso_resolve_from_root() {
  local path="${1:-}"
  if [ -z "$path" ]; then
    echo ""
  elif [ "${path#/}" != "$path" ]; then
    echo "$path"
  else
    echo "${PICASSO_SKILL_ROOT}/${path#./}"
  fi
}

picasso_find_skill_root() {
  local current="${1:-$PICASSO_RUNTIME_LIB_DIR}"
  while [ "$current" != "/" ]; do
    if [ -f "$current/.env.example" ] && [ -d "$current/shared" ] && [ -d "$current/install" ]; then
      echo "$current"
      return 0
    fi
    current="$(dirname "$current")"
  done
  return 1
}

picasso_load_skill_env() {
  local runtime_override_vars=(
    PICASSO_RUNTIME_SESSION_NAME
    PICASSO_RUNTIME_READY_TIMEOUT_SEC
    PICASSO_AUTO_START_LOCAL_SERVICES
    PICASSO_AUTO_STOP_LOCAL_SERVICES
    PICASSO_AUTO_FETCH_ACCESS_TOKEN
    PICASSO_RUNTIME_DIR
    PICASSO_BACKEND_START_WORKDIR
    PICASSO_BACKEND_START_CMD
    PICASSO_BACKEND_BASE_URL
    PICASSO_BACKEND_HEALTH_URL
    PICASSO_BACKEND_EXPECT_TEXT
    PICASSO_FRONTEND_START_WORKDIR
    PICASSO_FRONTEND_START_CMD
    PICASSO_FRONTEND_READY_URL
    PICASSO_FRONTEND_EXPECT_TEXT
    PICASSO_API_PREFIX
    PICASSO_LOGIN_URL
    PICASSO_LOGIN_METHOD
    PICASSO_LOGIN_USERNAME
    PICASSO_LOGIN_PASSWORD
    PICASSO_LOGIN_TENANT_ID
    PICASSO_LOGIN_TENANT_HEADER
    PICASSO_LOGIN_REQUEST_BODY_TEMPLATE
    PICASSO_LOGIN_TOKEN_PATH
    TOKEN
    ACCESS_TOKEN
  )
  local var_name
  local preserve_slot
  local preserved_names=()

  if [ "$PICASSO_RUNTIME_ENV_LOADED" = "true" ]; then
    return 0
  fi

  PICASSO_SKILL_ROOT="${PICASSO_SKILL_ROOT:-$(picasso_find_skill_root "$PICASSO_RUNTIME_LIB_DIR")}"
  if [ -z "${PICASSO_SKILL_ROOT:-}" ] || [ ! -d "$PICASSO_SKILL_ROOT" ]; then
    echo "[RUNTIME][ERROR] 无法定位 picasso-dev-skill 根目录" >&2
    return 1
  fi

  export PICASSO_SKILL_ROOT
  if [ -f "$PICASSO_SKILL_ROOT/.env" ]; then
    for var_name in "${runtime_override_vars[@]}"; do
      if [ "${!var_name+x}" = "x" ]; then
        preserved_names+=("$var_name")
        preserve_slot="PICASSO_PRESERVE_${var_name}"
        printf -v "$preserve_slot" '%s' "${!var_name}"
      fi
    done
    # shellcheck disable=SC1091
    set -a && source "$PICASSO_SKILL_ROOT/.env" && set +a
    for var_name in "${preserved_names[@]}"; do
      preserve_slot="PICASSO_PRESERVE_${var_name}"
      export "$var_name=${!preserve_slot}"
      unset "$preserve_slot"
    done
  fi

  PICASSO_RUNTIME_ENV_LOADED="true"
  export PICASSO_RUNTIME_ENV_LOADED
}

picasso_runtime_init() {
  picasso_load_skill_env

  export PICASSO_RUNTIME_SESSION_NAME="${PICASSO_RUNTIME_SESSION_NAME:-default}"
  export PICASSO_RUNTIME_READY_TIMEOUT_SEC="${PICASSO_RUNTIME_READY_TIMEOUT_SEC:-180}"
  export PICASSO_AUTO_START_LOCAL_SERVICES="${PICASSO_AUTO_START_LOCAL_SERVICES:-true}"
  export PICASSO_AUTO_STOP_LOCAL_SERVICES="${PICASSO_AUTO_STOP_LOCAL_SERVICES:-true}"
  export PICASSO_AUTO_FETCH_ACCESS_TOKEN="${PICASSO_AUTO_FETCH_ACCESS_TOKEN:-false}"
  export PICASSO_RUNTIME_DIR="${PICASSO_RUNTIME_DIR:-$PICASSO_SKILL_ROOT/workspace/tmp/runtime}"
  export PICASSO_RUNTIME_DIR="$(picasso_resolve_from_root "$PICASSO_RUNTIME_DIR")"
  export PICASSO_RUNTIME_SESSION_DIR="$PICASSO_RUNTIME_DIR/$PICASSO_RUNTIME_SESSION_NAME"
  mkdir -p "$PICASSO_RUNTIME_SESSION_DIR/logs" "$PICASSO_RUNTIME_SESSION_DIR/pids"
}

picasso_runtime_log_path() {
  local service_name="$1"
  echo "$PICASSO_RUNTIME_SESSION_DIR/logs/${service_name}.log"
}

picasso_runtime_pid_path() {
  local service_name="$1"
  echo "$PICASSO_RUNTIME_SESSION_DIR/pids/${service_name}.pid"
}

picasso_runtime_probe_http() {
  local url="$1"
  local expect_text="${2:-}"
  local body
  body="$(curl -fsS --max-time 3 "$url" 2>/dev/null || true)"
  if [ -z "$body" ]; then
    return 1
  fi
  if [ -n "$expect_text" ] && ! printf '%s' "$body" | grep -Fq "$expect_text"; then
    return 1
  fi
  return 0
}

picasso_runtime_wait_http() {
  local url="$1"
  local ready_name="$2"
  local expect_text="${3:-}"
  local timeout="${4:-$PICASSO_RUNTIME_READY_TIMEOUT_SEC}"
  local start_ts
  local current_ts
  start_ts="$(date +%s)"

  while :; do
    if picasso_runtime_probe_http "$url" "$expect_text"; then
      picasso_log "$ready_name 已就绪: $url"
      return 0
    fi

    current_ts="$(date +%s)"
    if [ $(( current_ts - start_ts )) -ge "$timeout" ]; then
      echo "[RUNTIME][ERROR] 等待 $ready_name 超时: $url" >&2
      return 1
    fi
    sleep 2
  done
}

picasso_runtime_start_service() {
  local service_name="$1"
  local workdir="$2"
  local start_cmd="$3"
  local ready_url="$4"
  local expect_text="${5:-}"
  local timeout="${6:-$PICASSO_RUNTIME_READY_TIMEOUT_SEC}"
  local pid_file
  local log_file
  local resolved_workdir
  local pid

  if [ -z "$start_cmd" ]; then
    picasso_log "$service_name 未配置启动命令，跳过自动拉起"
    return 0
  fi

  if [ -n "$ready_url" ] && picasso_runtime_probe_http "$ready_url" "$expect_text"; then
    picasso_log "$service_name 已在运行，直接复用现有服务"
    return 0
  fi

  resolved_workdir="$(picasso_resolve_from_root "$workdir")"
  if [ ! -d "$resolved_workdir" ]; then
    echo "[RUNTIME][ERROR] $service_name 启动目录不存在: $resolved_workdir" >&2
    return 1
  fi

  pid_file="$(picasso_runtime_pid_path "$service_name")"
  log_file="$(picasso_runtime_log_path "$service_name")"

  picasso_log "启动 $service_name"
  (
    cd "$resolved_workdir"
    nohup bash -lc "$start_cmd" > "$log_file" 2>&1 &
    echo $! > "$pid_file"
  )

  pid="$(cat "$pid_file")"
  picasso_log "${service_name} 已启动，PID=${pid}，日志=${log_file}"

  if [ -n "$ready_url" ] && ! picasso_runtime_wait_http "$ready_url" "$service_name" "$expect_text" "$timeout"; then
    echo "[RUNTIME][ERROR] $service_name 最近日志：" >&2
    tail -n 40 "$log_file" >&2 || true
    return 1
  fi
}

picasso_runtime_stop_service() {
  local service_name="$1"
  local pid_file
  local pid

  pid_file="$(picasso_runtime_pid_path "$service_name")"
  if [ ! -f "$pid_file" ]; then
    return 0
  fi

  pid="$(cat "$pid_file")"
  if [ -n "$pid" ] && kill -0 "$pid" >/dev/null 2>&1; then
    picasso_log "停止 $service_name (PID=$pid)"
    kill "$pid" >/dev/null 2>&1 || true
    sleep 1
    if kill -0 "$pid" >/dev/null 2>&1; then
      kill -9 "$pid" >/dev/null 2>&1 || true
    fi
  fi

  rm -f "$pid_file"
}

picasso_runtime_cleanup() {
  if ! picasso_truthy "${PICASSO_AUTO_STOP_LOCAL_SERVICES:-true}"; then
    return 0
  fi
  picasso_runtime_stop_service "frontend"
  picasso_runtime_stop_service "backend"
}

picasso_runtime_register_cleanup() {
  trap picasso_runtime_cleanup EXIT INT TERM
}

picasso_render_login_body() {
  local template="$1"
  template="${template//\{\{username\}\}/${PICASSO_LOGIN_USERNAME:-}}"
  template="${template//\{\{password\}\}/${PICASSO_LOGIN_PASSWORD:-}}"
  template="${template//\{\{tenant_id\}\}/${PICASSO_LOGIN_TENANT_ID:-}}"
  printf '%s' "$template"
}

picasso_extract_json_path() {
  local json_path="$1"
  python3 -c '
import json
import sys

path = [segment for segment in sys.argv[1].split(".") if segment]
payload = json.load(sys.stdin)

current = payload
for segment in path:
    if isinstance(current, dict):
        current = current.get(segment)
    else:
        current = None
        break

if current in (None, ""):
    raise SystemExit(1)

if isinstance(current, str):
    print(current)
else:
    print(json.dumps(current, ensure_ascii=False))
' "$json_path"
}

picasso_fetch_access_token() {
  local login_body
  local response
  local token_path
  local token

  if [ -n "${TOKEN:-}" ]; then
    picasso_log "TOKEN 已存在，跳过自动登录"
    return 0
  fi

  if ! picasso_truthy "${PICASSO_AUTO_FETCH_ACCESS_TOKEN:-false}"; then
    return 0
  fi

  if [ -z "${PICASSO_LOGIN_URL:-}" ] || [ -z "${PICASSO_LOGIN_USERNAME:-}" ] || [ -z "${PICASSO_LOGIN_PASSWORD:-}" ]; then
    echo "[RUNTIME][ERROR] 已开启自动获取 Token，但登录配置未完整填写" >&2
    return 1
  fi

  local default_login_body
  default_login_body='{"username":"{{username}}","password":"{{password}}","tenantId":"{{tenant_id}}"}'
  login_body="$(picasso_render_login_body "${PICASSO_LOGIN_REQUEST_BODY_TEMPLATE:-$default_login_body}")"
  token_path="${PICASSO_LOGIN_TOKEN_PATH:-data.accessToken}"

  if [ -n "${PICASSO_LOGIN_TENANT_ID:-}" ]; then
    response="$(
      curl -fsS \
        -X "${PICASSO_LOGIN_METHOD:-POST}" \
        "${PICASSO_LOGIN_URL}" \
        -H "Content-Type: application/json" \
        -H "${PICASSO_LOGIN_TENANT_HEADER:-Tenant-Id}: ${PICASSO_LOGIN_TENANT_ID}" \
        -d "$login_body"
    )"
  else
    response="$(
      curl -fsS \
        -X "${PICASSO_LOGIN_METHOD:-POST}" \
        "${PICASSO_LOGIN_URL}" \
        -H "Content-Type: application/json" \
        -d "$login_body"
    )"
  fi

  token="$(printf '%s' "$response" | picasso_extract_json_path "$token_path" || true)"
  if [ -z "$token" ]; then
    echo "[RUNTIME][ERROR] 登录响应中未找到 access token，响应内容如下：" >&2
    echo "$response" >&2
    return 1
  fi

  export TOKEN="$token"
  export ACCESS_TOKEN="$token"
  picasso_log "已自动获取 access token"
}

picasso_runtime_bootstrap() {
  picasso_runtime_init
  picasso_runtime_register_cleanup

  if picasso_truthy "${PICASSO_AUTO_START_LOCAL_SERVICES:-true}"; then
    picasso_runtime_start_service \
      "backend" \
      "${PICASSO_BACKEND_START_WORKDIR:-}" \
      "${PICASSO_BACKEND_START_CMD:-}" \
      "${PICASSO_BACKEND_HEALTH_URL:-}" \
      "${PICASSO_BACKEND_EXPECT_TEXT:-}" \
      "${PICASSO_RUNTIME_READY_TIMEOUT_SEC}"

    picasso_runtime_start_service \
      "frontend" \
      "${PICASSO_FRONTEND_START_WORKDIR:-}" \
      "${PICASSO_FRONTEND_START_CMD:-}" \
      "${PICASSO_FRONTEND_READY_URL:-}" \
      "${PICASSO_FRONTEND_EXPECT_TEXT:-}" \
      "${PICASSO_RUNTIME_READY_TIMEOUT_SEC}"
  fi

  picasso_fetch_access_token
}
