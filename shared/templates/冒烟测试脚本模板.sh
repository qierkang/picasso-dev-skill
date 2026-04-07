#!/usr/bin/env bash

# {{REQUEST_TITLE}} 冒烟测试脚本模板
# 使用前请替换实际接口、页面路径、字典类型、路由名

set -euo pipefail

BASE_URL="${BASE_URL:-http://127.0.0.1:8080}"
API_PREFIX="${API_PREFIX:-/admin-api}"
TENANT_ID="${TENANT_ID:-1}"
TOKEN="${TOKEN:-}"

PASS_COUNT=0
FAIL_COUNT=0

pass() {
  echo "[PASS] $1"
  PASS_COUNT=$((PASS_COUNT + 1))
}

fail() {
  echo "[FAIL] $1"
  FAIL_COUNT=$((FAIL_COUNT + 1))
}

check_http() {
  local name="$1"
  local path="$2"
  local method="${3:-GET}"
  local code
  code=$(curl -s -o /dev/null -w "%{http_code}" \
    -X "$method" \
    "$BASE_URL$path" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Tenant-Id: $TENANT_ID" || echo "000")
  if [ "$code" = "200" ] || [ "$code" = "201" ]; then
    pass "$name"
  else
    fail "$name (HTTP $code)"
  fi
}

echo "== 第1关：接口健康检查 =="
check_http "健康检查" "/actuator/health"

echo "== 第2关：核心业务接口检查 =="
# TODO: 按需求替换实际接口
# check_http "列表接口" "$API_PREFIX/xxx/page" "GET"
# check_http "详情接口" "$API_PREFIX/xxx/get?id=1" "GET"
# check_http "创建接口" "$API_PREFIX/xxx/create" "POST"

echo "== 第3关：字典 / 菜单 / 路由检查 =="
# TODO: 按需求检查新增字典、菜单权限和页面路由

echo "== 第4关：前端 / 小程序 / App 文件存在性检查 =="
# TODO: 按需求检查页面文件、API 文件、路由注册

echo "== 汇总 =="
echo "PASS=$PASS_COUNT FAIL=$FAIL_COUNT"

if [ "$FAIL_COUNT" -gt 0 ]; then
  exit 1
fi
