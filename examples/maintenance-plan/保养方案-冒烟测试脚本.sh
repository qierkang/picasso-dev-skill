#!/usr/bin/env bash

set -euo pipefail

# 保养方案冒烟测试脚本
# 使用方式：
# BASE_URL=http://127.0.0.1:48080 \
# TOKEN=your_token \
# PC_PAGE_FILE=/path/to/index.vue \
# PC_API_FILE=/path/to/api.ts \
# CONTROLLER_FILE=/path/to/controller.java \
# bash 保养方案-冒烟测试脚本.sh

BASE_URL="${BASE_URL:-http://127.0.0.1:48080}"
TOKEN="${TOKEN:-}"
PC_PAGE_FILE="${PC_PAGE_FILE:-}"
PC_API_FILE="${PC_API_FILE:-}"
CONTROLLER_FILE="${CONTROLLER_FILE:-}"

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

check_http() {
  local gate="$1"
  local name="$2"
  local path="$3"
  local code
  code=$(curl -s -o /dev/null -w "%{http_code}" \
    "$BASE_URL$path" \
    -H "Authorization: Bearer $TOKEN" || echo "000")
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
    echo "[SKIP] $name（未配置）"
    return
  fi
  if [ -f "$path" ]; then
    pass "$gate" "$name"
  else
    fail "$gate" "$name（文件不存在: $path）"
  fi
}

echo "--- 第1关：API 接口验证 ---"
if [ -z "$TOKEN" ]; then
  fail "gate1" "登录获取 Token（TOKEN 未配置）"
else
  pass "gate1" "登录获取 Token"
fi
check_http "gate1" "列表分页查询" "/maintenance/plan/page?pageNo=1&pageSize=10"
check_http "gate1" "删除前校验接口" "/maintenance/plan/check-delete?id=1"
check_http "gate1" "设备类型简单列表" "/equipment/type/simple-list"
check_http "gate1" "保养项简单列表" "/maintenance/item/simple-list?companyCode=COMP001"
echo "--- 第1关结果: ✅ $GATE1_PASS 通过, ❌ $GATE1_FAIL 失败 ---"

echo
echo "--- 第2关：页面集成验证 ---"
check_file "gate2" "PC 页面文件存在" "$PC_PAGE_FILE"
check_file "gate2" "PC API 文件存在" "$PC_API_FILE"
check_file "gate2" "后端 Controller 文件存在" "$CONTROLLER_FILE"
echo "--- 第2关结果: ✅ $GATE2_PASS 通过, ❌ $GATE2_FAIL 失败 ---"

echo
echo "[SMOKE] 总计: ✅ $PASS_COUNT 通过, ❌ $FAIL_COUNT 失败"
if [ "$FAIL_COUNT" -gt 0 ]; then
  exit 1
fi
