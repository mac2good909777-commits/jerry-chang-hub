#!/bin/bash
# 一鍵推到 GitHub + 啟用 Pages

set -e

REPO_NAME="jerry-chang-hub"
OWNER="mac2good909777-commits"
GIT_NAME="Mac Chang"
GIT_EMAIL="mac2good909777-commits@users.noreply.github.com"
COMMIT_MSG_FILE="/tmp/jerry-hub-commit-msg.txt"

cd "$(dirname "$0")"

echo "━━━ 1/6 build 驗證 ━━━"
npm run build 2>&1 | tail -3
[ -d dist ] || { echo "✗ build 失敗"; exit 1; }

echo ""
echo "━━━ 2/6 git init + commit ━━━"
if [ ! -d .git ]; then
  git init -b main
fi
git config user.name "$GIT_NAME"
git config user.email "$GIT_EMAIL"

cat > "$COMMIT_MSG_FILE" <<'COMMIT_EOF'
Initial commit: 張現傑 × 睦聚地產 中間站 MVP

- 4 版型並存 (v1/v2/v3/v4), 預設推薦 v4
- 5 篇首批文章 (market-view 3 / insights 2)
- Astro 5 + Decap CMS + GitHub Pages 部署
- Sothebys 配色 x CBRE 版面骨架
- 全站 Noto Serif TC, 3 字級嚴控

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
COMMIT_EOF

git add -A
if git diff --cached --quiet; then
  echo "(無新變更，跳過 commit)"
else
  git commit -F "$COMMIT_MSG_FILE"
fi
rm -f "$COMMIT_MSG_FILE"

echo ""
echo "━━━ 3/6 建立 GitHub repo 並推送 ━━━"
if gh repo view "$OWNER/$REPO_NAME" >/dev/null 2>&1; then
  echo "Repo 已存在，直接 push"
  git remote remove origin 2>/dev/null || true
  git remote add origin "https://github.com/$OWNER/$REPO_NAME.git"
  git push -u origin main --force-with-lease
else
  gh repo create "$OWNER/$REPO_NAME" \
    --public \
    --source=. \
    --push \
    --description="張現傑 x 睦聚地產 - 工業不動產市場觀察、產業資訊分析、前期判讀整理"
fi

echo ""
echo "━━━ 4/6 啟用 GitHub Pages (workflow 模式) ━━━"
gh api --method POST "repos/$OWNER/$REPO_NAME/pages" \
  -f "build_type=workflow" 2>&1 | head -5 || true

echo ""
echo "━━━ 5/6 等 Actions 觸發 ━━━"
sleep 3
gh run list --repo "$OWNER/$REPO_NAME" --limit 1 2>&1 | head -3

echo ""
echo "━━━ 6/6 Done ━━━"
echo ""
echo "Repo:    https://github.com/$OWNER/$REPO_NAME"
echo "Actions: https://github.com/$OWNER/$REPO_NAME/actions"
echo "Pages:   https://$OWNER.github.io/$REPO_NAME/  (約 2-3 分鐘後上線)"
