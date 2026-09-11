#!/usr/bin/env bash
# ctool 静态站点发布：本地构建 → rsync 到服务器 Caddy 站点目录
# 用法: deploy/deploy.sh [服务器别名] [远端目录]
#   默认: deploy/deploy.sh cnife.ali-hz-1 /srv/ctool
set -euo pipefail

HOST="${1:-cnife.ali-hz-1}"
SITE_DIR="${2:-/srv/ctool}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST="$ROOT/packages/ctool-site/dist"

cd "$ROOT"

echo "==> 构建 (pnpm run vercel-build)"
pnpm run vercel-build

echo "==> 发布 $DIST/ → $HOST:$SITE_DIR/"
rsync -az --delete --chmod=D755,F644 "$DIST/" "$HOST:$SITE_DIR/"

echo "==> 完成: https://ctool.cnife.cn  ($(date '+%Y-%m-%d %H:%M:%S'))"
