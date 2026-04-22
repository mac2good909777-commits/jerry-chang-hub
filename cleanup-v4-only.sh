#!/bin/bash
# 清除 V1/V2/V3，將 V4 搬到根路徑 /，然後 push
set -e

cd "$(dirname "$0")"

echo "━━━ 1. 刪除 V1 pages + V1 components + V1 layouts ━━━"
rm -f src/pages/index.astro src/pages/about.astro src/pages/contact.astro
rm -rf src/pages/industry-data src/pages/market-view src/pages/insights
rm -rf src/pages/v2 src/pages/v3
rm -f src/components/Footer.astro src/components/Nav.astro
rm -f src/components/ArticleCard.astro src/components/AuthorBio.astro
rm -f src/components/CategoryIndex.astro src/components/PartnerNote.astro
rm -rf src/components/v2 src/components/v3
rm -f src/components/VersionSwitch.astro
rm -f src/layouts/Base.astro src/layouts/Article.astro
rm -f src/layouts/V2Base.astro src/layouts/V2Article.astro
rm -f src/layouts/V3Base.astro src/layouts/V3Article.astro
rm -f src/styles/global.css
echo "   done."

echo ""
echo "━━━ 2. 將 V4 pages 搬到根 (去除 /v4 前綴) ━━━"
mv src/pages/v4/index.astro src/pages/index.astro
mv src/pages/v4/about.astro src/pages/about.astro
mv src/pages/v4/contact.astro src/pages/contact.astro
mv src/pages/v4/industry-data src/pages/industry-data
mv src/pages/v4/market-view src/pages/market-view
mv src/pages/v4/insights src/pages/insights
rmdir src/pages/v4
echo "   done."

echo ""
echo "━━━ 3. 用 Python 修正 import 路徑 + 改 href /v4/ → / ━━━"
python3 << 'PY_EOF'
import os, re

# fix 頂層 pages (深度減 1)
top = ['src/pages/index.astro', 'src/pages/about.astro', 'src/pages/contact.astro']
for f in top:
    s = open(f).read()
    # import ../../layouts → ../layouts
    s = s.replace("../../layouts/", "../layouts/")
    s = s.replace("../../components/", "../components/")
    # href /v4/ → /
    s = s.replace('"/v4/"', '"/"').replace('"/v4/', '"/')
    s = s.replace("'/v4/'", "'/'").replace("'/v4/", "'/")
    open(f, 'w').write(s)
    print("   fixed", f)

# fix 深一層 pages (depth 維持; 原 /v4/X/[slug].astro 是 3 層，現 /X/[slug].astro 是 2 層)
nested = []
for root, _, files in os.walk('src/pages'):
    for fn in files:
        if fn.endswith('.astro') and root != 'src/pages':
            nested.append(os.path.join(root, fn))

for f in nested:
    s = open(f).read()
    # ../../../ → ../../
    s = s.replace("../../../layouts/", "../../layouts/")
    s = s.replace("../../../components/", "../../components/")
    # href /v4/ → /
    s = s.replace('"/v4/"', '"/"').replace('"/v4/', '"/')
    s = s.replace("'/v4/'", "'/'").replace("'/v4/", "'/")
    open(f, 'w').write(s)
    print("   fixed", f)

# fix V4Base、V4Footer、V4Nav、V4Article、V4CategoryIndex、V4Insight 裡的 /v4/ 路徑
base_files = [
    'src/layouts/V4Base.astro',
    'src/layouts/V4Article.astro',
    'src/components/v4/V4Nav.astro',
    'src/components/v4/V4Footer.astro',
    'src/components/v4/V4CategoryIndex.astro',
    'src/components/v4/V4Insight.astro',
]
for f in base_files:
    if not os.path.exists(f):
        continue
    s = open(f).read()
    s = s.replace('"/v4/"', '"/"').replace('"/v4/', '"/')
    s = s.replace("'/v4/'", "'/'").replace("'/v4/", "'/")
    # 移除 VersionSwitch import + 使用
    s = re.sub(r"import VersionSwitch from [^\n]+\n", "", s)
    s = re.sub(r"<VersionSwitch[^/]*/>\s*\n?", "", s)
    open(f, 'w').write(s)
    print("   fixed", f)
PY_EOF
echo "   done."

echo ""
echo "━━━ 4. build 驗證 ━━━"
npm run build 2>&1 | tail -4

echo ""
echo "━━━ 5. git commit + push ━━━"
git add -A
git commit -m "Simplify to V4 only: remove V1/V2/V3, V4 moves to root

- 刪除 v1/v2/v3 所有頁面、元件、layout、樣式
- V4 從 /v4/... 搬到 /...（根路徑）
- 統一入口：/ 即 V4 首頁
- 移除版本切換器（只剩單一版本）

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>"
git push origin main
echo ""
echo "━━━ Done ━━━"
echo "等 Actions 部署（~1 分鐘）後可看："
echo "  https://mac2good909777-commits.github.io/jerry-chang-hub/"
