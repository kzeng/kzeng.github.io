#!/usr/bin/env bash
# 新建一篇内容：自动按 pYYYY-MM-DD-NNN.md 编号，并生成 front matter
# 用法： ./scripts/new.sh [可选标题]
set -euo pipefail

DIR="content/posts"
mkdir -p "$DIR"

TITLE="${1:-未命名}"
TODAY="$(date +%F)"

# 找到当天已有的最大编号
LAST="$(ls "$DIR" 2>/dev/null | grep -E "^p${TODAY}-[0-9]{3}\.md$" | tail -1 || true)"
if [ -z "$LAST" ]; then
  N=1
else
  N=$(printf '%s' "$LAST" | sed -E 's/.*-([0-9]{3})\.md/\1/')
  N=$((10#$N + 1))
fi

FILE="$DIR/p${TODAY}-$(printf '%03d' "$N").md"

# 提取所有文章中已有的 tags（去重排序）
TAGS="$(grep -hoE 'tags: *\[.*\]' "$DIR"/*.md 2>/dev/null \
  | sed -E 's/tags: *\[//; s/\]//' \
  | tr ',' '\n' \
  | tr -d '" ' \
  | grep -v '^$' \
  | sort -u \
  | paste -sd '、' - || true)"

cat > "$FILE" <<EOF
---
title: "${TITLE}"
date: ${TODAY}
draft: false
tags: []
# 已有 tags：${TAGS}
---

EOF

echo "已创建：$FILE"
