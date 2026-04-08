#!/usr/bin/env bash

# {{REQUEST_TITLE}} 冒烟测试脚本模板
# 使用前必须把下列占位变量替换为真实值：
# - 第1关：健康检查、登录、核心 CRUD、字典/菜单依赖
# - 第2关：PC / 小程序 / App 路由注册、Controller 路径、编译验证

set -euo pipefail

BASE_URL="${BASE_URL:-http://127.0.0.1:8080}"
API_PREFIX="${API_PREFIX:-/admin-api}"
TENANT_ID="${TENANT_ID:-1}"
TOKEN="${TOKEN:-}"

FRONT_REPO_DIR="${FRONT_REPO_DIR:-}"
MINIAPP_REPO_DIR="${MINIAPP_REPO_DIR:-}"
MOBILE_APP_REPO_DIR="${MOBILE_APP_REPO_DIR:-}"

PC_PAGE_FILE="${PC_PAGE_FILE:-}"
PC_API_FILE="${PC_API_FILE:-}"
PC_ROUTE_FILE="${PC_ROUTE_FILE:-}"
PC_ROUTE_KEYWORD="${PC_ROUTE_KEYWORD:-}"

MINIAPP_ROUTE_FILE="${MINIAPP_ROUTE_FILE:-}"
MINIAPP_ROUTE_KEYWORD="${MINIAPP_ROUTE_KEYWORD:-}"

MOBILE_NAMES_FILE="${MOBILE_NAMES_FILE:-}"
MOBILE_PAGES_FILE="${MOBILE_PAGES_FILE:-}"
MOBILE_NAVIGATION_FILE="${MOBILE_NAVIGATION_FILE:-}"
MOBILE_ROUTE_KEYWORD="${MOBILE_ROUTE_KEYWORD:-}"

CONTROLLER_FILE="${CONTROLLER_FILE:-}"
CONTROLLER_ROUTE_KEYWORD="${CONTROLLER_ROUTE_KEYWORD:-}"

PASS_COUNT=0
FAIL_COUNT=0
GATE1_PASS=0
GATE1_FAIL=0
GATE2_PASS=0
GATE2_FAIL=0

pass() {
  local gate="$1"
  local name="$2"
  echo "[PASS] $name"
  PASS_COUNT=$((PASS_COUNT + 1))
  if [ "$gate" = "gate1" ]; then
    GATE1_PASS=$((GATE1_PASS + 1))
  else
    GATE2_PASS=$((GATE2_PASS + 1))
  fi
}

fail() {
  local gate="$1"
  local name="$2"
  echo "[FAIL] $name"
  FAIL_COUNT=$((FAIL_COUNT + 1))
  if [ "$gate" = "gate1" ]; then
    GATE1_FAIL=$((GATE1_FAIL + 1))
  else
    GATE2_FAIL=$((GATE2_FAIL + 1))
  fi
}

skip() {
  local gate="$1"
  local name="$2"
  echo "[SKIP] $name"
  if [ "$gate" = "gate1" ]; then
    GATE1_PASS=$((GATE1_PASS + 1))
  else
    GATE2_PASS=$((GATE2_PASS + 1))
  fi
}

check_http() {
  local gate="$1"
  local name="$2"
  local path="$3"
  local method="${4:-GET}"
  local code
  code=$(curl -s -o /dev/null -w "%{http_code}" \
    -X "$method" \
    "$BASE_URL$path" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Tenant-Id: $TENANT_ID" || echo "000")
  if [ "$code" = "200" ] || [ "$code" = "201" ]; then
    pass "$gate" "$name"
  else
    fail "$gate" "$name (HTTP $code)"
  fi
}

check_file() {
  local gate="$1"
  local name="$2"
  local path="$3"
  if [ -z "$path" ]; then
    skip "$gate" "$name（未配置）"
    return
  fi
  if [ -f "$path" ]; then
    pass "$gate" "$name"
  else
    fail "$gate" "$name（文件不存在: $path）"
  fi
}

check_contains() {
  local gate="$1"
  local name="$2"
  local path="$3"
  local keyword="$4"
  if [ -z "$path" ] || [ -z "$keyword" ]; then
    skip "$gate" "$name（未配置）"
    return
  fi
  if [ ! -f "$path" ]; then
    fail "$gate" "$name（文件不存在: $path）"
    return
  fi
  if grep -q "$keyword" "$path"; then
    pass "$gate" "$name"
  else
    fail "$gate" "$name（未找到关键字: $keyword）"
  fi
}

echo "[SMOKE] 冒烟测试 - {{REQUEST_TITLE}}"
echo
echo "--- 第1关：API 接口验证 ---"
check_http "gate1" "1.1 健康检查" "/actuator/health"

if [ -z "$TOKEN" ]; then
  fail "gate1" "1.2 登录获取 Token（TOKEN 未配置）"
else
  pass "gate1" "1.2 登录获取 Token"
fi

# 使用前请替换为真实接口
# check_http "gate1" "1.3 列表接口" "$API_PREFIX/xxx/page?pageNo=1&pageSize=10"
# check_http "gate1" "1.4 详情接口" "$API_PREFIX/xxx/get?id=1"
# check_http "gate1" "1.5 新增接口" "$API_PREFIX/xxx/create" "POST"
# check_http "gate1" "1.6 字典 / 菜单 / 权限依赖接口" "$API_PREFIX/system/dict-data/page?dictType=xxx"

echo "--- 第1关结果: ✅ $GATE1_PASS 通过, ❌ $GATE1_FAIL 失败 ---"
echo

echo "--- 第2关：页面集成验证 ---"
check_file "gate2" "2.1 PC 页面文件存在" "$PC_PAGE_FILE"
check_file "gate2" "2.2 PC API 文件存在" "$PC_API_FILE"
check_contains "gate2" "2.3 PC 路由已注册" "$PC_ROUTE_FILE" "$PC_ROUTE_KEYWORD"
check_contains "gate2" "2.4 小程序路由已注册" "$MINIAPP_ROUTE_FILE" "$MINIAPP_ROUTE_KEYWORD"
check_contains "gate2" "2.5 Flutter names.dart 已注册" "$MOBILE_NAMES_FILE" "$MOBILE_ROUTE_KEYWORD"
check_contains "gate2" "2.6 Flutter pages.dart 已注册" "$MOBILE_PAGES_FILE" "$MOBILE_ROUTE_KEYWORD"
check_contains "gate2" "2.7 Flutter Navigation.to 已映射" "$MOBILE_NAVIGATION_FILE" "$MOBILE_ROUTE_KEYWORD"
check_contains "gate2" "2.8 Controller 路径 / 前缀正确" "$CONTROLLER_FILE" "$CONTROLLER_ROUTE_KEYWORD"

if [ -n "$FRONT_REPO_DIR" ] && [ -d "$FRONT_REPO_DIR" ]; then
  pass "gate2" "2.9 前端仓库路径可访问"
else
  skip "gate2" "2.9 前端仓库路径可访问（未配置）"
fi

echo "--- 第2关结果: ✅ $GATE2_PASS 通过, ❌ $GATE2_FAIL 失败 ---"
echo

echo "--- 汇总 ---"
echo "[SMOKE] 总计: ✅ $PASS_COUNT 通过, ❌ $FAIL_COUNT 失败"

if [ "$FAIL_COUNT" -gt 0 ]; then
  echo "[SMOKE] ❌ 存在失败项，请修复后重新运行"
  exit 1
fi

echo "[SMOKE] ✅ 两关全部通过"
