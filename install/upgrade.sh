#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "[INFO] 重新执行初始化、体检和同步"
bash "$ROOT_DIR/install/setup.sh"
bash "$ROOT_DIR/install/doctor.sh"
bash "$ROOT_DIR/install/sync.sh"
