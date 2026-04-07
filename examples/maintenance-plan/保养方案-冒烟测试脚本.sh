#!/usr/bin/env bash

set -euo pipefail

# 保养方案冒烟测试脚本模板
# 使用方式：
# BASE_URL=http://127.0.0.1:48080 \
# TOKEN=your_token \
# bash 保养方案-冒烟测试脚本.sh

BASE_URL="${BASE_URL:-http://127.0.0.1:48080}"
TOKEN="${TOKEN:-}"

if [ -z "${TOKEN}" ]; then
  echo "[FAIL] TOKEN 为空，请先导出 TOKEN"
  exit 1
fi

echo "[STEP] 1. 列表分页查询"
curl -sS -H "Authorization: Bearer ${TOKEN}" \
  "${BASE_URL}/maintenance/plan/page?pageNo=1&pageSize=10" >/tmp/maintenance-plan-page.json
echo "[PASS] 列表查询完成"

echo "[STEP] 2. 删除前校验（示例 id=1，实际执行前替换）"
curl -sS -H "Authorization: Bearer ${TOKEN}" \
  "${BASE_URL}/maintenance/plan/check-delete?id=1" >/tmp/maintenance-plan-check-delete.json || true
echo "[PASS] 删除校验接口已触达"

echo "[STEP] 3. 设备类型简单列表"
curl -sS -H "Authorization: Bearer ${TOKEN}" \
  "${BASE_URL}/equipment/type/simple-list" >/tmp/maintenance-plan-device-type.json
echo "[PASS] 设备类型接口已触达"

echo "[STEP] 4. 保养项简单列表（示例 companyCode=COMP001，实际执行前替换）"
curl -sS -H "Authorization: Bearer ${TOKEN}" \
  "${BASE_URL}/maintenance/item/simple-list?companyCode=COMP001" >/tmp/maintenance-plan-item.json
echo "[PASS] 保养项接口已触达"

echo "[DONE] 冒烟脚本执行完成，请人工检查 /tmp/maintenance-plan-*.json 输出"
